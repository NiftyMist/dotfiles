# dotfiles

Configuration files 

# Installation

Clone into home directory.

# Requirements

- `zsh` with [oh-my-zsh](https://ohmyz.sh/)
  - oh-my-zsh plugins: `git`, `zsh-autosuggestions`, `zsh-kubectl-prompt`
  - `zsh-syntax-highlighting` with the Catppuccin Mocha theme
    (`~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh`)
  - [`starship`](https://starship.rs/) prompt
- nerd fonts (installed via the `Brewfile`)
  - `Hack Nerd Font` (ghostty)
- `stow`
- homebrew — all packages are declared in the [`Brewfile`](Brewfile) and
  managed by [`scripts/brew-sync.sh`](scripts/brew-sync.sh):

  ```sh
  ./scripts/brew-sync.sh            # install everything in the Brewfile (new machine)
  ./scripts/brew-sync.sh --check    # report missing/extra packages, change nothing
  ./scripts/brew-sync.sh --dump     # regenerate the Brewfile after installing something new
  ./scripts/brew-sync.sh --cleanup  # uninstall anything NOT in the Brewfile
  ```

  Edit the `Brewfile` to add/remove packages, run the script, and commit the
  `Brewfile` so the package set stays tracked in git.

# My settings
- themes (mostly Catppuccin):
  - ghostty: Catppuccin Mocha (`Hack Nerd Font Propo`, size 17)
  - nvim: `catppuccin/nvim` (`catppuccin-macchiato`)
  - tmux: `catppuccin/tmux` (mocha)
  - starship: `catppuccin_mocha` palette
  - bat: Catppuccin Mocha
  - zsh-syntax-highlighting: Catppuccin Mocha
  - yazi: gruvbox-dark `ya pack -a bennyyip/gruvbox-dark`
- nvim plugins (see `.config/nvim/init.lua`):
  - catppuccin/nvim (colorscheme)
  - plenary.nvim
  - nvim-web-devicons
  - lualine.nvim
  - gitsigns.nvim
  - telescope.nvim + telescope-file-browser.nvim
  - nvim-treesitter
  - vim-surround
  - vim-fugitive + fugitive-gitlab.vim
  - vim-tmux-navigator
  - pearofducks/ansible-vim
  - nvim-ansible
  - mason.nvim
  - startup.nvim
  - claude-code.nvim
- tmux plugins (see `.tmux.conf`):
  - 'tmuxpack/tpack' (plugin manager)
  - 'tmux-plugins/tmux-sensible'
  - 'christoomey/vim-tmux-navigator'
  - 'catppuccin/tmux' (theme)

# Using stow  

From the root of the repo, execute `stow .` and restart my terminal and/or programs.

# Offline install (air-gapped hosts)

For hosts with no Internet, [`scripts/build-offline-bundle.sh`](scripts/build-offline-bundle.sh)
builds a self-contained tarball of the shell functions, neovim (Linux binary +
config + plugins), tmux (config + plugins), and ghostty config.

```sh
# On an online machine (macOS):
./scripts/build-offline-bundle.sh                 # -> ~/dotfiles-offline-<timestamp>.tar.gz
NVIM_ARCH=arm64 ./scripts/build-offline-bundle.sh # for ARM Linux targets (default: x86_64)

# Copy the tarball to the offline host, then:
tar -xzf dotfiles-offline-*.tar.gz
./dotfiles-offline/install.sh
```

Notes:
- Plugins are pinned to `.config/nvim/nvim-pack-lock.json` and pre-cloned, so
  neovim never fetches on first launch.
- Treesitter parsers are arch-specific and **not** bundled; the startup
  `install()` is stripped and highlighting falls back to vim's regex syntax.
  To enable treesitter later you need one-shot Internet **and** the
  `tree-sitter` CLI on PATH, then `:TSInstall <lang>`.
- `claude-code.nvim` is bundled but needs the `claude` CLI installed separately.

