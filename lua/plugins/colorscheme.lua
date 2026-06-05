-- lua/plugins/colorscheme.lua
-- File ini HARUS `return` sebuah tabel berisi plugin-spec.
-- lazy.nvim baca return-nya, terus install plugin-nya.

return {
  "folke/tokyonight.nvim", -- repo: github.com/folke/tokyonight.nvim

  lazy = false,    -- colorscheme jangan di-lazy-load → harus siap saat startup
  priority = 1000, -- load PALING awal (theme harus duluan sebelum plugin lain)

  config = function()
    -- `config` jalan SETELAH plugin ke-install & ke-load.
    require("tokyonight").setup({
      style = "night", -- pilihan: "night" | "storm" | "moon" | "day"
    })

    -- aktifkan theme-nya
    vim.cmd.colorscheme("tokyonight")
  end,
}
