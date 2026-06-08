-- lua/plugins/gitsigns.lua
-- gitsigns = "git diff yang hidup di dalam editor".
-- Tampilin tanda +/~/- di gutter (kolom kiri) tiap baris berubah,
-- plus blame inline biar tau siapa nulis baris ini & kapan.

return {
  "lewis6991/gitsigns.nvim",

  -- Nyala pas buka file (bukan startup) — plugin ini butuh buffer dulu.
  event = { "BufReadPre", "BufNewFile" },

  opts = {
    -- =========================================================
    -- TANDA DI GUTTER
    -- Ini yang muncul di kolom kiri (sebelah nomor baris).
    -- =========================================================
    signs = {
      add          = { text = "▎" }, -- baris baru
      change       = { text = "▎" }, -- baris diubah
      delete       = { text = "" }, -- baris dihapus (tanda di bawah)
      topdelete    = { text = "" }, -- baris dihapus di atas
      changedelete = { text = "▎" }, -- diubah sekaligus dihapus
    },

    -- =========================================================
    -- BLAME INLINE
    -- Tampilkan "siapa nulis + kapan" di ujung kanan setiap baris
    -- saat kursor diam sebentar. Warnanya redup biar nggak ganggu.
    -- =========================================================
    current_line_blame = true, -- nyala by default
    current_line_blame_opts = {
      delay = 500,             -- tunggu 500ms setelah kursor diam
      virt_text_pos = "eol",   -- posisi: End Of Line (ujung kanan)
    },

    -- =========================================================
    -- KEYMAP — on_attach dipanggil tiap gitsigns nempel ke buffer.
    -- Semua keymap di sini LOKAL (cuma aktif di buffer yang ada git-nya).
    -- =========================================================
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- -------------------------------------------------------
      -- NAVIGASI HUNK
      -- Hunk = satu blok perubahan (bisa beberapa baris sekaligus).
      -- ]c / [c = lompat ke hunk berikutnya / sebelumnya.
      -- Cek vim.wo.diff dulu: kalau lagi di mode diff bawaan vim
      -- (mis. vimdiff), pakai perintah vim biasa bukan gitsigns.
      -- -------------------------------------------------------
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, "Git: hunk berikutnya")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, "Git: hunk sebelumnya")

      -- -------------------------------------------------------
      -- AKSI HUNK — <leader>h_ (h = hunk)
      -- -------------------------------------------------------

      -- Stage = "siapkan hunk ini untuk commit" (kayak git add per-blok)
      map("n", "<leader>hs", gs.stage_hunk, "Git: Stage hunk")
      -- Stage cuma baris yang diseleksi di visual mode
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Git: Stage baris terpilih")

      -- Reset = batalin perubahan di hunk ini (balik ke versi git)
      map("n", "<leader>hr", gs.reset_hunk, "Git: Reset hunk")
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, "Git: Reset baris terpilih")

      -- Stage / reset SELURUH file sekaligus
      map("n", "<leader>hS", gs.stage_buffer, "Git: Stage seluruh file")
      map("n", "<leader>hR", gs.reset_buffer, "Git: Reset seluruh file")

      -- Preview hunk dalam popup kecil (lihat diff sebelum commit)
      map("n", "<leader>hp", gs.preview_hunk, "Git: Preview hunk")

      -- Blame popup FULL (author, tanggal, pesan commit) buat baris ini
      -- Beda dari blame inline: ini muncul pas dipanggil, bukan otomatis.
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, "Git: Blame baris (popup)")

      -- -------------------------------------------------------
      -- TOGGLE — <leader>t_ (t = toggle)
      -- -------------------------------------------------------

      -- Nyala/matiin blame inline (kalau mau fokus tanpa distraksi)
      map("n", "<leader>tb", gs.toggle_current_line_blame, "Git: Toggle blame inline")

      -- -------------------------------------------------------
      -- TEXT OBJECT: ih = "inner hunk"
      -- Contoh: dih = hapus isi hunk, vih = seleksi hunk
      -- -------------------------------------------------------
      map({ "o", "x" }, "ih", gs.select_hunk, "Git: pilih isi hunk")
    end,
  },
}
