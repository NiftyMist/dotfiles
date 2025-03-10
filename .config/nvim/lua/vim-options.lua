vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.cursorline = true

-- relative line numbers enable
vim.wo.relativenumber = true
vim.wo.number = true

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- split buffers easier
vim.keymap.set('n', '<leader>w', ':vsplit<CR>')
vim.keymap.set('n', '<leader>ww', ':sp<CR>')
