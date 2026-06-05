-- lua/plugins/autopairs.lua
-- nvim-autopairs = otomatis nutup kurung/quote pas ngetik.
-- Ketik "(" → dapet "()", kursor di tengah. Backspace hapus dua-duanya.

return {
  "windwp/nvim-autopairs",

  -- LAZY LOAD lewat `event`: plugin baru di-load pas PERTAMA kali masuk
  -- insert mode (pencet i/a/o/dll). Soalnya autopairs cuma guna pas ngetik.
  -- Startup tetap kenceng. (Pola lazy-load ke-3: keys / lazy=false / event)
  event = "InsertEnter",

  -- `opts` → lazy.nvim auto-panggil require("nvim-autopairs").setup(opts).
  opts = {
    -- check_ts = pakai TREESITTER buat ngerti konteks. Jadi autopairs
    -- lebih pinter soal kapan nutup kurung (mis. di dalam string/komentar).
    check_ts = true,

    -- CATATAN: kita NGGAK nyambungin ke autocomplete manual di sini.
    -- blink.cmp kamu udah otomatis nambahin "()" pas milih fungsi dari
    -- menu (fitur auto_brackets, nyala default). Jadi nggak perlu.
  },
}
