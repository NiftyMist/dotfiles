vim.g.mapleader = " "
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.cursorline = true
vim.opt.clipboard = "unnamedplus"

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

-- gitsigns
vim.keymap.set('n', '<leader>gb', '::Gitsigns toggle_current_line_blame<CR>')
vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk_inline<CR>')

-- Custom filetype associations
-- Example:
--   vim.filetype.add({
--     extension = {
--       tfvars = "terraform",
--       hcl = "terraform",
--     },
--     filename = {
--       ["Jenkinsfile"] = "groovy",
--       [".env.local"] = "sh",
--     },
--     pattern = {
--       [".*%.conf%.d/.*"] = "conf",
--     },
--   })
vim.filetype.add({
  extension = {
    tfvars = "terraform",
  },
})

-- fugitive-gitlab
vim.g.fugitive_gitlab_domains = { 'https://git.rinet.io' }

