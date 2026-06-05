-- lua/plugins/telescope.lua
-- Telescope = jendela pencari serba-bisa (fuzzy finder).
-- Cari file, cari teks di semua file, pindah buffer, cari help — semua UI sama.

return {
  "nvim-telescope/telescope.nvim",
  -- CATATAN: tag "0.1.8" (rilis lama) manggil vim.treesitter.language.ft_to_lang()
  -- yang UDAH DIHAPUS di Neovim 0.12 → bikin preview error.
  -- Branch master udah benerin (ganti ke get_lang). Sama persis kayak
  -- kasus treesitter master vs main dulu: versi lama, API Neovim baru.
  branch = "master",

  -- plugin yang harus ada DULUAN (lazy.nvim urus urutannya):
  dependencies = {
    -- plenary = library helper (fungsi async/util). Telescope mati tanpa ini.
    "nvim-lua/plenary.nvim",

    -- fzf-native = matcher fuzzy versi C (ngebut + lebih pinter).
    -- `build = "make"` → habis download, lazy.nvim COMPILE kode C-nya
    -- jadi binary pakai compiler (clang). Mirip build = ":TSUpdate".
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },

  -- ===================================================================
  -- LAZY LOADING lewat `keys`:
  -- Plugin BARU di-load pas salah satu tombol di bawah dipencet.
  -- Jadi startup Neovim tetap kilat — Telescope nganggur sampai dibutuhkan.
  -- Tiap entry: { "tombol", fungsi/cmd, desc = "..." }
  -- ===================================================================
  keys = {
    {
      "<leader>ff",
      function() require("telescope.builtin").find_files() end,
      desc = "Telescope: cari File by nama",
    },
    {
      "<leader>fg",
      function() require("telescope.builtin").live_grep() end,
      desc = "Telescope: Grep teks di semua file",
    },
    {
      "<leader>fb",
      function() require("telescope.builtin").buffers() end,
      desc = "Telescope: pindah Buffer (file yg kebuka)",
    },
    {
      "<leader>fh",
      function() require("telescope.builtin").help_tags() end,
      desc = "Telescope: cari Help docs",
    },
    {
      "<leader>fo",
      function() require("telescope.builtin").oldfiles() end,
      desc = "Telescope: file yg baru dibuka (Old)",
    },
    {
      "<leader>fk",
      function() require("telescope.builtin").keymaps() end,
      desc = "Telescope: cari Keymap sendiri",
    },
  },

  -- Kita pakai `config` (bukan `opts`) karena butuh ATUR URUTAN:
  -- setup() dulu, BARU nyalain extension fzf. opts nggak bisa atur ini.
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      -- defaults = berlaku ke SEMUA picker
      defaults = {
        -- ↓ hasil terbaik muncul di BAWAH (deket kotak ketik).
        --   Nyaman karena matamu udah di bawah pas ngetik.
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top", -- kotak ketik di ATAS
        },
        -- folder/file yang DIABAIKAN pas nyari (biar nggak berisik)
        file_ignore_patterns = { "node_modules", "%.git/" },
      },

      -- konfigurasi khusus extension
      extensions = {
        fzf = {}, -- pakai default fzf-native, udah bagus
      },
    })

    -- WAJIB di-load SETELAH setup biar fzf-native override sorter default.
    telescope.load_extension("fzf")
  end,
}
