-- lua/plugins/completion.lua
-- blink.cmp = mesin autocomplete (nampilin menu saran pas ngetik).

return {
  "saghen/blink.cmp",

  -- `version = "1.*"` → ambil rilis stabil yang BINARY-nya udah jadi.
  -- Jadi nggak perlu compile (nggak butuh cargo/rust dipasang manual).
  version = "1.*",

  dependencies = {
    "rafamadriz/friendly-snippets", -- kumpulan snippet siap pakai (opsional)
  },

  -- `opts` → lazy.nvim auto-panggil require("blink.cmp").setup(opts)
  opts = {
    -- ----- Preset keymap: nentuin tombol buat accept/navigasi -----
    -- "default"  → C-y accept, C-n/C-p navigasi (mirip completion bawaan)
    -- "super-tab"→ Tab buat accept (mirip VSCode)
    -- "enter"    → Enter buat accept
    keymap = { preset = "default" },

    -- ----- Tampilan -----
    completion = {
      -- auto_show = true → dokumentasi tiap saran muncul OTOMATIS di samping
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },

    -- ----- Sumber saran: dari mana datanya diambil -----
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      -- lsp      → saran dari language server (paling pinter)
      -- path     → autocomplete path file/folder
      -- snippets → template kode
      -- buffer   → kata-kata yang udah ada di file (fallback)
    },

    -- ----- Mesin fuzzy matching (tahan typo, super cepat) -----
    fuzzy = { implementation = "rust" }, -- pakai binary Rust bawaan rilis
  },
}
