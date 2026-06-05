-- lua/plugins/lazydev.lua
-- lazydev = bikin lua_ls paham API Neovim (vim.*) + tipe plugin-mu.
-- Hasilnya: autocomplete `vim.opt`, `vim.keymap`, dll JALAN.

return {
  "folke/lazydev.nvim",
  ft = "lua", -- cuma di-load pas buka file Lua (lazy loading by filetype)

  opts = {
    library = {
      -- Muat tipe luvit (buat vim.uv) kalau kata "vim.uv" ketemu di file.
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
