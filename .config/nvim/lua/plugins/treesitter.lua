return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_install = false,
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
        highlight = { enable = true },
        indent = { enable = false },
      })
    end
  }
}
