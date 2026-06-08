-- lua/plugins/todo-comments.lua
-- todo-comments = highlight kata kunci komentar (TODO, FIXME, NOTE, dll)
-- dengan warna berbeda biar gampang dicari. Plus bisa cari semua TODO
-- di seluruh proyek lewat Telescope.

return {
  "folke/todo-comments.nvim",

  -- Telescope harus sudah load dulu sebelum TodoTelescope bisa jalan,
  -- karena todo-comments daftar dirinya sebagai Telescope extension.
  dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },

  -- Nyala pas buka file
  event = { "BufReadPre", "BufNewFile" },

  keys = {
    -- Lompat antar TODO di file aktif
    {
      "]t",
      function() require("todo-comments").jump_next() end,
      desc = "Todo: berikutnya",
    },
    {
      "[t",
      function() require("todo-comments").jump_prev() end,
      desc = "Todo: sebelumnya",
    },
    -- Cari semua TODO di seluruh proyek lewat Telescope
    {
      "<leader>ft",
      "<cmd>TodoTelescope<cr>",
      desc = "Todo: cari semua (Telescope)",
    },
  },

  -- opts = {} → pakai default semua. Keyword bawaan sudah lengkap:
  --   TODO  → biru   (hal yang mau dikerjain)
  --   FIXME → merah  (bug yang harus dibenerin)
  --   HACK  → oranye (solusi sementara / workaround)
  --   WARN  → kuning (perhatian, hati-hati)
  --   PERF  → ungu   (potensi masalah performa)
  --   NOTE  → hijau  (info penting buat pembaca)
  --   TEST  → merah muda (kode testing sementara)
  opts = {},
}
