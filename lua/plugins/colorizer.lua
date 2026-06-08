-- lua/plugins/colorizer.lua
-- nvim-colorizer = preview warna CSS langsung di kode.
-- Contoh: "#ff6b6b" tampil dengan background merah, rgb(0,255,0) jadi hijau.
-- Nggak butuh dependency eksternal — murni Lua, ngebut.

return {
  "catgoose/nvim-colorizer.lua",

  -- Nyala pas buka file — biar langsung aktif tanpa harus manggil command.
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    -- Daftar filetype yang dikasih preview warna.
    -- Formatnya: { "filetype" } atau { "filetype", options = {...} }
    filetypes = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
      "lua",
    },

    -- Opsi default yang berlaku ke semua filetype di atas.
    user_default_options = {
      -- `css = true` = aktifkan SEMUA parser CSS sekaligus:
      -- hex (#fff, #ff6b6b), rgb(), hsl(), oklch(), nama warna (red, blue...).
      css = true,

      -- Tailwind: kenali kelas seperti `bg-red-500`, `text-blue-300`, dll.
      -- Enak kalau kamu pakai Tailwind di proyek React.
      tailwind = true,

      -- Mode tampilan: "background" = warna muncul sebagai background teks.
      -- Pilihan lain: "foreground" (warna teks), "virtualtext" (kotak kecil).
      mode = "background",
    },
  },
}
