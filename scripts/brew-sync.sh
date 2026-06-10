#!/usr/bin/env bash
# Sync installed Homebrew packages to the committed Brewfile.
#
# The Brewfile (repo root) is the source of truth. This script makes the
# machine match it: installs anything missing and (optionally) removes
# anything not listed.
#
# Usage:
#   ./scripts/brew-sync.sh            Install everything in the Brewfile (safe; adds only)
#   ./scripts/brew-sync.sh --check    Report what is missing/extra; change nothing
#   ./scripts/brew-sync.sh --cleanup  Install, then uninstall anything NOT in the Brewfile
#   ./scripts/brew-sync.sh --dump     Regenerate the Brewfile from what's currently installed
#   ./scripts/brew-sync.sh --force    With --cleanup: skip the confirmation prompt
#
# Typical flow on a new machine:   ./scripts/brew-sync.sh
# After manually adding a package: ./scripts/brew-sync.sh --dump  (then commit the Brewfile)
# To prune the machine to match:   ./scripts/brew-sync.sh --cleanup

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"

DO_CHECK=false
DO_CLEANUP=false
DO_DUMP=false
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --check)   DO_CHECK=true ;;
    --cleanup) DO_CLEANUP=true ;;
    --dump)    DO_DUMP=true ;;
    --force)   FORCE=true ;;
    -h|--help) sed -n '2,18p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Unknown option: $arg (try --help)" >&2; exit 2 ;;
  esac
done

if ! command -v brew >/dev/null 2>&1; then
  echo "ERROR: Homebrew is not installed or not on PATH." >&2
  echo "Install it from https://brew.sh, then re-run this script." >&2
  exit 1
fi

# Regenerate the Brewfile from the current system, curated to top-level
# packages (dependencies are pulled in automatically on install). Keeps the
# same layout as the committed file so diffs stay readable.
dump_brewfile() {
  local out="$1"
  {
    echo "# Brewfile -- declarative list of Homebrew packages for this machine."
    echo "# Managed by scripts/brew-sync.sh. Edit this file, then run the script."
    echo "#"
    echo "# Docs: https://github.com/Homebrew/homebrew-bundle"
    echo
    echo "# ---- Taps ----"
    brew tap | sed 's/^/tap "/; s/$/"/'
    echo
    echo "# ---- Formulae (top-level; dependencies are installed automatically) ----"
    brew leaves --installed-on-request | sed 's/^/brew "/; s/$/"/'
    echo
    echo "# ---- Casks ----"
    brew list --cask 2>/dev/null | sed 's/^/cask "/; s/$/"/'
  } > "$out"
}

if $DO_DUMP; then
  if [[ -f "$BREWFILE" ]]; then
    cp "$BREWFILE" "$BREWFILE.bak"
    echo "==> Backed up existing Brewfile to Brewfile.bak"
  fi
  echo "==> Regenerating Brewfile from installed packages"
  dump_brewfile "$BREWFILE"
  echo "==> Wrote $BREWFILE ($(grep -cE '^(tap|brew|cask) ' "$BREWFILE") entries)"
  echo "    Review the diff and commit it:  git -C \"$DOTFILES_DIR\" diff Brewfile"
  exit 0
fi

if [[ ! -f "$BREWFILE" ]]; then
  echo "ERROR: No Brewfile at $BREWFILE" >&2
  echo "Generate one from the current machine with:  $0 --dump" >&2
  exit 1
fi

if $DO_CHECK; then
  echo "==> Checking Brewfile against installed packages"
  if brew bundle check --file="$BREWFILE" --verbose; then
    echo "==> All Brewfile dependencies are satisfied."
  fi
  echo
  echo "==> Installed packages NOT in the Brewfile (would be removed by --cleanup):"
  # stdout = real removal candidates; stderr = "not latest version" noise we drop.
  extras="$(brew bundle cleanup --file="$BREWFILE" 2>/dev/null || true)"
  if [[ -z "$extras" ]]; then
    echo "    (none -- machine matches the Brewfile)"
  else
    echo "$extras"
  fi
  exit 0
fi

echo "==> Installing everything listed in the Brewfile"
brew bundle install --file="$BREWFILE"

if $DO_CLEANUP; then
  echo
  echo "==> The following installed packages are NOT in the Brewfile:"
  # Dry run (no --force) prints removal candidates on stdout; stderr is just
  # "not latest version" noise, so drop it.
  extras="$(brew bundle cleanup --file="$BREWFILE" 2>/dev/null || true)"
  if [[ -z "$extras" ]]; then
    echo "    (nothing to remove -- machine already matches the Brewfile)"
  else
    echo "$extras"
    if ! $FORCE; then
      read -r -p "Uninstall the above packages? [y/N] " reply
      case "$reply" in
        [yY]|[yY][eE][sS]) ;;
        *) echo "Aborted. Nothing removed."; exit 0 ;;
      esac
    fi
    echo "==> Removing packages not in the Brewfile"
    brew bundle cleanup --file="$BREWFILE" --force
  fi
fi

echo "==> Done."
