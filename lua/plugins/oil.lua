-- lua/plugins/oil.lua
-- oil.nvim = file explorer yang bikin FOLDER jadi BUFFER teks biasa.
-- Ngatur file = ngedit teks pakai motion vim. Rename = edit baris + :w.

return {
  "stevearc/oil.nvim",

  -- mini.icons = penyedia ikon (folder/file). Butuh Nerd Font di terminal.
  -- opts = {} → mini.icons auto-setup. Kalau ikon keliatan kotak kosong,
  -- terminalmu belum pake Nerd Font (oil tetap jalan normal kok).
  dependencies = { { "nvim-mini/mini.icons", opts = {} } },

  -- oil SENGAJA nggak di-lazy-load. Soalnya dia harus siap NGEGANTIIN netrw
  -- dari awal — kalau lazy, buka folder pas startup malah keburu netrw duluan.
  lazy = false,

  -- ===================================================================
  -- KEYMAP: "-" buka folder INDUK dari file sekarang (gaya vim-vinegar).
  -- Pencet "-" lagi di dalam oil → naik satu folder lagi.
  -- Ini ngegantiin <leader>e → :Ex yang lama (netrw jadul).
  -- ===================================================================
  keys = {
    { "-", "<CMD>Oil<CR>", desc = "Oil: buka folder induk" },
  },

  -- `opts` → lazy.nvim auto-panggil require("oil").setup(opts).
  opts = {
    -- oil ngambil-alih buffer folder (gantiin netrw bawaan).
    default_file_explorer = true,

    -- kolom yang ditampilin di kiri tiap nama file. "icon" aja biar bersih.
    -- (bisa tambah "permissions", "size", "mtime" kalau mau detail)
    columns = { "icon" },

    -- file yang dihapus MASUK ke Trash (bisa di-restore), bukan lenyap permanen.
    -- macOS punya Trash, jadi ini aman & disaranin. 🗑️
    delete_to_trash = true,

    -- pantau filesystem; kalau ada perubahan dari luar, oil auto-refresh.
    watch_for_changes = true,

    view_options = {
      -- file tersembunyi (diawali ".") DISEMBUNYIIN secara default.
      -- Toggle keliatan/nggak pakai "g." di dalam oil.
      show_hidden = false,
    },
  },
}
