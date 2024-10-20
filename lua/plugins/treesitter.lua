return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    local configs = require('nvim-treesitter.configs')

    ---@diagnostic disable-next-line: missing-fields
    configs.setup({
      ensure_installed = { 'c', 'lua', 'vim', 'vimdoc', 'query', 'typescript', 'html' },
      sync_install = true,
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      ignore_install = { 'javascript' },
    })
  end,
}
