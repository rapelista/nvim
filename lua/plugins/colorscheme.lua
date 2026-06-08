-- lua/plugins/colorscheme.lua
-- File ini HARUS `return` sebuah tabel berisi plugin-spec.
-- lazy.nvim baca return-nya, terus install plugin-nya.

-- CATATAN: link yang kamu mau (primer/github-vscode-theme) itu tema buat
-- VSCODE — Neovim nggak bisa baca itu. Yang dipasang di sini adalah PORT-nya
-- buat Neovim: projekt0n/github-nvim-theme. Warnanya niru tema GitHub VSCode,
-- termasuk varian "github_dark_default" yang kamu pilih.

return {
  "projekt0n/github-nvim-theme", -- repo: github.com/projekt0n/github-nvim-theme

  lazy = false,    -- colorscheme jangan di-lazy-load → harus siap saat startup
  priority = 1000, -- load PALING awal (theme harus duluan sebelum plugin lain)

  config = function()
    -- `config` jalan SETELAH plugin ke-install & ke-load.
    -- Nama plugin-nya "github-theme" (beda dikit dari nama repo).
    require("github-theme").setup({
      -- `groups.all` = override warna grup highlight di SEMUA varian tema.
      groups = {
        all = {
          -- Komponen React (huruf besar, mis. <Head>) ditandai Treesitter
          -- sebagai `@tag.tsx`, yang DEFAULT-nya github-theme link ke `@type`
          -- (oranye). VSCode bikin komponen sehijau tag biasa → kita link
          -- balik ke `@tag` biar warnanya samaan.
          ["@tag.tsx"] = { link = "@tag" },
        },
      },
    })

    -- aktifkan theme-nya. Perhatiin: pakai UNDERSCORE (github_dark_default),
    -- bukan spasi. Varian lain misalnya:
    --   github_dark, github_dark_dimmed, github_dark_high_contrast,
    --   github_light, github_light_default, dll.
    vim.cmd.colorscheme("github_dark_default")
  end,
}
