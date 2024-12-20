return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function () 
      local configs = require("nvim-treesitter.configs")

      configs.setup({
          ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "java", "heex", "javascript", "html", "python", "go", "bash", "rego", "sql"},
          sync_install = false,
          highlight = { enable = true },
          indent = { enable = true },  
        })
    end
  },
}
