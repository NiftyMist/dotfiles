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
  - `Hack Nerd Font` (ghostty) and `JetBrainsMonoNL Nerd Font` (alacritty)
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
  - ghostty: Catppuccin Frappe (`Hack Nerd Font Propo`, size 17)
  - alacritty: default colors (`JetBrainsMonoNL Nerd Font`)
  - nvim: `catppuccin/nvim` (`catppuccin-macchiato`)
  - tmux: `catppuccin/tmux` (frappe)
  - starship: `catppuccin_frappe` palette
  - bat: Catppuccin Macchiato
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

