return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('telescope').setup({
        defaults = {
          vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
            '--glob', '!.git/*',
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--hidden', '--glob', '!.git/*' },
          },
        },
      })
    end,
  }
}
