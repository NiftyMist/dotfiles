-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

local opts = {
  ensure_installed = { "ansible-lint", "markdownlint-cli2", "markdown-toc" }
}

require("vim-options")
require("lazy").setup("plugins", opts)
require("gitsigns").setup()
require('lualine').setup {
    options = {
        theme = "catppuccin"
        -- ... the rest of your lualine config
    }
}
-- set color scheme
-- vim.o.background = "dark" -- or "light" for light mode
vim.cmd([[colorscheme catppuccin]])
-- vim.cmd.colorscheme "gruvbox"
-- vim.cmd

-- telescope config
local builtin = require('telescope.builtin')
-- telescope
vim.keymap.set('n', '<C-p>', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
