-- lua/plugins/mini-surround.lua
-- mini.surround = tambah/ganti/hapus "pembungkus" (kurung, kutip, tag) di
-- sekitar teks, nyatu sama motion vim. Bagian dari keluarga mini.nvim —
-- sama kayak mini.icons yang udah kepasang lewat oil.

return {
  "nvim-mini/mini.surround",

  -- LAZY LOAD lewat keys: plugin baru bangun pas salah satu prefix dipencet.
  -- WAJIB didaftarin di sini, kalau nggak mapping-nya nggak ada sampai
  -- plugin ke-load. `mode {n,v}` buat sa karena jalan di normal & visual.
  keys = {
    { "sa", mode = { "n", "v" },                          desc = "Surround: Add (bungkus)" },
    { "sd", desc = "Surround: Delete (hapus pembungkus)" },
    { "sr", desc = "Surround: Replace (ganti pembungkus)" },
  },

  -- opts = {} → lazy auto-panggil require("mini.surround").setup({}).
  -- Default mapping (sa/sd/sr/sf/sh) udah enak, jadi kosongin aja.
  opts = {},
}
