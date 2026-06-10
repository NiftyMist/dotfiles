#!/usr/bin/env bash
# Build a tarball of dotfile configs + plugins for transfer to an offline host.
# Bundles: shell functions, neovim (config+plugins), tmux (config+plugins), ghostty config.
#
# Usage: ./scripts/build-offline-bundle.sh
# Output: ~/dotfiles-offline-<timestamp>.tar.gz

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DATE="$(date +%Y%m%d_%H%M%S)"
BUNDLE_NAME="dotfiles-offline"
PARENT="$(mktemp -d)"
STAGING="$PARENT/$BUNDLE_NAME"
OUTPUT="${HOME}/${BUNDLE_NAME}-${BUILD_DATE}.tar.gz"

# Neovim binary to bundle. Override NVIM_ARCH=arm64 for ARM Ubuntu.
NVIM_VERSION="${NVIM_VERSION:-v0.12.2}"
NVIM_ARCH="${NVIM_ARCH:-x86_64}"
NVIM_TARBALL="nvim-linux-${NVIM_ARCH}.tar.gz"
NVIM_URL="https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/${NVIM_TARBALL}"

trap 'rm -rf "$PARENT"' EXIT

mkdir -p "$STAGING"

# 1. Shell functions library
echo "==> Functions library"
mkdir -p "$STAGING/functions"
cp "$DOTFILES_DIR/lib/functions.sh" "$STAGING/functions/functions.sh"

# 2. Neovim config (with offline-safe patch)
echo "==> Neovim config"
mkdir -p "$STAGING/nvim/config"
rsync -a --exclude='.DS_Store' "$DOTFILES_DIR/.config/nvim/" "$STAGING/nvim/config/"

# Patch init.lua: treesitter parsers can't be cross-compiled cleanly, and the
# nvim-treesitter `main` branch fetches parser sources from GitHub + compiles
# them with the `tree-sitter` CLI at startup. Neutralize the install() call so
# nvim doesn't try to reach the network (or fail for a missing CLI) on first
# offline launch. Highlighting falls back to vim's built-in regex syntax; the
# register() + FileType autocmd below it stay and degrade gracefully (pcall).
perl -i -0pe "s/require\('nvim-treesitter'\)\.install\(\{[^}]*\}\)/-- offline: parsers not pre-built; install() skipped (no network \/ no tree-sitter CLI)/s" \
  "$STAGING/nvim/config/init.lua"

# Download Neovim binary
echo "==> Downloading Neovim $NVIM_VERSION ($NVIM_ARCH)"
mkdir -p "$STAGING/nvim/binary"
curl -fsSL "$NVIM_URL" -o "$STAGING/nvim/binary/$NVIM_TARBALL"

# 3. Neovim plugins from nvim-pack-lock.json
echo "==> Neovim plugins"
mkdir -p "$STAGING/nvim/plugins"
PACK_LOCK="$DOTFILES_DIR/.config/nvim/nvim-pack-lock.json"
while IFS=$'\t' read -r name src rev; do
  echo "    - $name @ ${rev:0:7}"
  git clone --quiet "$src" "$STAGING/nvim/plugins/$name"
  git -C "$STAGING/nvim/plugins/$name" checkout --quiet "$rev"
  rm -rf "$STAGING/nvim/plugins/$name/.git"
done < <(jq -r '.plugins | to_entries[] | "\(.key)\t\(.value.src)\t\(.value.rev)"' "$PACK_LOCK")

# 4. Tmux config
echo "==> Tmux config"
mkdir -p "$STAGING/tmux/config"
cp "$DOTFILES_DIR/.tmux.conf" "$STAGING/tmux/tmux.conf"
rsync -a --exclude='plugins/' --exclude='.DS_Store' \
  "$DOTFILES_DIR/.config/tmux/" "$STAGING/tmux/config/"

# Disable `run 'tpack init'` — tpack is a Go binary not bundled. The @plugin
# declarations stay (they're just option-sets) but won't be sourced; for this
# config the manual keybinds in tmux.conf cover what those plugins would do.
perl -i -pe "s|^run 'tpack init'|# offline: tpack binary not bundled\n# run 'tpack init'|" \
  "$STAGING/tmux/tmux.conf"

# 5. Tmux plugins
echo "==> Tmux plugins"
mkdir -p "$STAGING/tmux/plugins"
for spec in \
  "tpack=https://github.com/tmuxpack/tpack" \
  "tmux-sensible=https://github.com/tmux-plugins/tmux-sensible" \
  "vim-tmux-navigator=https://github.com/christoomey/vim-tmux-navigator"; do
  name="${spec%%=*}"
  url="${spec#*=}"
  echo "    - $name"
  git clone --depth 1 --quiet "$url" "$STAGING/tmux/plugins/$name"
  rm -rf "$STAGING/tmux/plugins/$name/.git"
done

# Catppuccin: tmux.conf references it as catppuccin/tmux/catppuccin.tmux
# (the repo is nested one level deep). Match that layout.
echo "    - catppuccin (nested)"
mkdir -p "$STAGING/tmux/plugins/catppuccin"
git clone --depth 1 --quiet https://github.com/catppuccin/tmux \
  "$STAGING/tmux/plugins/catppuccin/tmux"
rm -rf "$STAGING/tmux/plugins/catppuccin/tmux/.git"

# 6. Ghostty config
echo "==> Ghostty config"
mkdir -p "$STAGING/ghostty"
cp "$DOTFILES_DIR/.config/ghostty/config" "$STAGING/ghostty/config"

# 7. Install script for the offline side
cat > "$STAGING/install.sh" <<'INSTALL'
#!/usr/bin/env bash
# Installs dotfile configs and plugins on an offline host.
set -euo pipefail
BUNDLE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

backup_or_remove() {
  local dst="$1"
  if [[ -L "$dst" ]]; then
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mv "$dst" "${dst}.bak.$(date +%s)"
    echo "    backed up existing $dst"
  fi
}

echo "==> Functions library"
TARGET_FN="$HOME_DIR/.local/share/dotfiles-functions.sh"
mkdir -p "$(dirname "$TARGET_FN")"
cp "$BUNDLE_DIR/functions/functions.sh" "$TARGET_FN"

echo "==> Neovim binary"
NVIM_DIR="$HOME_DIR/.local/nvim"
mkdir -p "$HOME_DIR/.local/bin"
TMPEXTRACT=$(mktemp -d)
tar -xzf "$BUNDLE_DIR"/nvim/binary/nvim-linux-*.tar.gz -C "$TMPEXTRACT"
EXTRACTED=$(find "$TMPEXTRACT" -maxdepth 1 -mindepth 1 -type d | head -1)
rm -rf "$NVIM_DIR"
mv "$EXTRACTED" "$NVIM_DIR"
rm -rf "$TMPEXTRACT"
ln -sf "$NVIM_DIR/bin/nvim" "$HOME_DIR/.local/bin/nvim"

echo "==> Neovim config"
backup_or_remove "$HOME_DIR/.config/nvim"
mkdir -p "$HOME_DIR/.config"
cp -r "$BUNDLE_DIR/nvim/config" "$HOME_DIR/.config/nvim"

echo "==> Neovim plugins"
NVIM_PACK="$HOME_DIR/.local/share/nvim/site/pack/core/opt"
mkdir -p "$NVIM_PACK"
for plug in "$BUNDLE_DIR/nvim/plugins"/*; do
  [ -d "$plug" ] || continue
  name=$(basename "$plug")
  if [ -d "$NVIM_PACK/$name" ]; then
    echo "    skipping existing $name"
  else
    cp -r "$plug" "$NVIM_PACK/$name"
  fi
done

echo "==> Tmux config"
backup_or_remove "$HOME_DIR/.tmux.conf"
cp "$BUNDLE_DIR/tmux/tmux.conf" "$HOME_DIR/.tmux.conf"
mkdir -p "$HOME_DIR/.config/tmux"
rsync -a "$BUNDLE_DIR/tmux/config/" "$HOME_DIR/.config/tmux/"

echo "==> Tmux plugins"
TMUX_PLUG="$HOME_DIR/.config/tmux/plugins"
mkdir -p "$TMUX_PLUG"
for plug in "$BUNDLE_DIR/tmux/plugins"/*; do
  [ -d "$plug" ] || continue
  name=$(basename "$plug")
  if [ -d "$TMUX_PLUG/$name" ]; then
    echo "    skipping existing $name"
  else
    cp -r "$plug" "$TMUX_PLUG/$name"
  fi
done

echo "==> Ghostty config"
mkdir -p "$HOME_DIR/.config/ghostty"
cp "$BUNDLE_DIR/ghostty/config" "$HOME_DIR/.config/ghostty/config"

cat <<DONE

Install complete. Final steps:

  1. Add to ~/.bashrc:
        export PATH="\$HOME/.local/bin:\$PATH"
        source "$TARGET_FN"
     Then start a new shell. Verify with: which nvim ; nvim --version

  2. Open tmux. Plugins are pre-installed; no Internet needed.

  3. Open nvim. Plugins load from pack/core/opt; no fetch happens.
     - Treesitter parsers are NOT pre-built (arch-specific) and the startup
       install() call is stripped, so syntax falls back to vim's regex
       highlighting. To get treesitter later (needs one-shot Internet AND the
       'tree-sitter' CLI on PATH): run :TSInstall <lang>.
     - claude-code.nvim is bundled but needs the 'claude' CLI installed
       separately to actually work.

  4. For Nerd Font icons (lualine, catppuccin), install a Nerd Font on this
     host. JetBrainsMono Nerd Font or Hack Nerd Font recommended.

DONE
INSTALL
chmod +x "$STAGING/install.sh"

# 8. Tarball — suppress macOS xattrs so GNU tar on Linux doesn't complain
COPYFILE_DISABLE=1 tar --no-xattrs --no-mac-metadata \
  -czf "$OUTPUT" -C "$PARENT" "$BUNDLE_NAME"

echo
echo "Built: $OUTPUT"
ls -lh "$OUTPUT"
