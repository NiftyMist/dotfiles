require("vim-options")

-- Plugins
vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/catppuccin/nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-telescope/telescope.nvim",
  "https://github.com/nvim-telescope/telescope-file-browser.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/tpope/vim-surround",
  "https://github.com/tpope/vim-fugitive",
  "https://github.com/shumphrey/fugitive-gitlab.vim",
  "https://github.com/christoomey/vim-tmux-navigator",
  "https://github.com/pearofducks/ansible-vim",
  "https://github.com/mfussenegger/nvim-ansible",
  "https://github.com/williamboman/mason.nvim",
  "https://github.com/startup-nvim/startup.nvim",
  "https://github.com/greggh/claude-code.nvim"
})
-- Colorscheme
vim.cmd.colorscheme("catppuccin-macchiato")

-- Plugin configs
require("gitsigns").setup()

require("lualine").setup({
  options = { theme = "auto" },
})

require("mason").setup()
require("startup").setup()

require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg", "--color=never", "--no-heading", "--with-filename",
      "--line-number", "--column", "--smart-case", "--hidden", "--glob", "!.git/*",
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
    },
  },
})

-- The module is now just 'nvim-treesitter' not 'nvim-treesitter.configs'
require('nvim-treesitter').setup({
  ensure_installed = {
    "lua",
    "bash",
    "python",
    "yaml",
    "hcl",
    "jinja",
    "nginx",
    "tmux",
    "markdown",
  },
})

require("claude-code").setup({
  window = {
    split_ratio = 0.3,
    position = "float",
    enter_insert = true,
    hide_numbers = true,
    hide_signcolumn = true,
    float = {
      width = "80%",
      height = "80%",
      row = "center",
      col = "center",
      relative = "editor",
      border = "rounded",
    },
  },
  refresh = {
    enable = true,
    updatetime = 100,
    timer_interval = 1000,
    show_notifications = true,
  },
  git = { use_git_root = true },
  command = "claude",
  keymaps = {
    toggle = {
      normal = "<leader>cc",
      terminal = "<leader>cc",
      variants = {
        continue = "<leader>cC",
        verbose = "<leader>cV",
      },
    },
    window_navigation = true,
    scrolling = true,
  },
})

-- Telescope keymaps
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
