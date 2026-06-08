-- ~/.config/nvim/init.lua
-- =========================================================
-- LEADER KEY — WAJIB paling atas, sebelum keymap & plugin apapun
-- =========================================================
vim.g.mapleader = " "      -- leader utama = Spasi
vim.g.maplocalleader = " " -- localleader (buat filetype tertentu) = Spasi juga

-- =========================================================
-- LESSON 1: OPTIONS
-- `vim.opt` itu cara Lua buat ngatur setting (di VimScript dulu `set ...`)
-- =========================================================

-- ----- Tampilan nomor baris -----
vim.opt.number = true         -- tampilkan nomor baris
vim.opt.relativenumber = true -- nomor relatif (baris lain dihitung dari kursor)
-- → bikin lompat gampang: 5j / 12k langsung kebaca

-- ----- Indentasi -----
vim.opt.tabstop = 2        -- 1 tab tampil selebar 2 spasi
vim.opt.shiftwidth = 2     -- 1 level indent (>> atau <<) = 2 spasi
vim.opt.expandtab = true   -- tekan Tab → keluar spasi, bukan karakter tab
vim.opt.smartindent = true -- auto-indent pintar saat bikin baris baru

-- ----- Pencarian -----
vim.opt.ignorecase = true -- /cari → nggak peduli huruf besar/kecil
vim.opt.smartcase = true  -- TAPI kalau kamu ketik huruf besar, jadi case-sensitive
vim.opt.hlsearch = true   -- highlight semua hasil pencarian

-- ----- Quality of life -----
vim.opt.wrap = false         -- baris panjang nggak dibungkus ke bawah
vim.opt.scrolloff = 8        -- selalu sisakan 8 baris di atas/bawah kursor
vim.opt.signcolumn = "yes"   -- kolom kiri buat ikon (error LSP, git) selalu ada
vim.opt.termguicolors = true -- warna 24-bit (warna theme jadi akurat)
vim.opt.cursorline = true    -- highlight baris tempat kursor berada
vim.opt.mouse = "a"          -- mouse aktif (boleh dimatiin nanti kalau mau purist)

-- ----- Clipboard -----
vim.opt.clipboard = "unnamedplus" -- yank (y) langsung nyambung ke clipboard sistem
-- → bisa copy-paste antar app

-- =========================================================
-- LESSON 2: KEYMAPS
-- vim.keymap.set(mode, "tombol", aksi, opsi)
-- `desc` = deskripsi (kepake nanti pas pakai which-key / :map)
-- =========================================================

-- biar nggak capek ngetik, bikin alias pendek
local map = vim.keymap.set

-- ----- Hidup lebih enak -----
map("n", "<leader>nh", ":noh<CR>", { desc = "Matiin highlight pencarian" })
-- ^ Spasi n h → matiin highlight sisa /search (janji dari Lesson 1!)
-- <CR> = tombol Enter. ":noh<CR>" = ketik :noh lalu otomatis Enter.

map("n", "<leader>w", ":w<CR>", { desc = "Simpan file" })  -- Spasi w → save
map("n", "<leader>q", ":q<CR>", { desc = "Tutup window" }) -- Spasi q → quit

-- ----- Pindah antar window (split) tanpa Ctrl-w dulu -----
map("n", "<C-h>", "<C-w>h", { desc = "Pindah ke window kiri" })
map("n", "<C-j>", "<C-w>j", { desc = "Pindah ke window bawah" })
map("n", "<C-k>", "<C-w>k", { desc = "Pindah ke window atas" })
map("n", "<C-l>", "<C-w>l", { desc = "Pindah ke window kanan" })
-- <C-h> artinya Ctrl+h

-- ----- Geser baris naik/turun (di Visual mode) -----
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Geser blok ke bawah" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Geser blok ke atas" })
-- seleksi beberapa baris di Visual, tekan J/K → pindahin blok-nya, indent auto-fix

-- ----- Tetap di tengah saat scroll setengah halaman -----
map("n", "<C-d>", "<C-d>zz", { desc = "Turun setengah layar (kursor center)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Naik setengah layar (kursor center)" })
-- `zz` = pusatkan kursor. Mata nggak capek nyari kursor lagi.

-- ----- Buka file explorer -----
-- Buka oil di FLOATING window (melayang di tengah). Beda sama "-" yang
-- buka oil di window biasa. Definisi plugin oil ada di lua/plugins/oil.lua.
-- map("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Buka file explorer (oil float)" })

-- =========================================================
-- LESSON 3: BOOTSTRAP lazy.nvim (plugin manager)
-- Blok ini: "kalau lazy.nvim belum ada, git clone sendiri".
-- Jalan SEKALI pas pertama buka, abis itu di-skip.
-- =========================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- stdpath("data") = ~/.local/share/nvim  → tempat data plugin disimpan
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- fs_stat = cek folder ada/nggak. Kalau nggak ada → clone:
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    -- kalau git gagal (mis. nggak ada internet), kasih pesan jelas
    vim.api.nvim_echo({
      { "Gagal clone lazy.nvim:\n",             "ErrorMsg" },
      { out,                                    "WarningMsg" },
      { "\nTekan tombol apa aja buat keluar..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath) -- daftarin lazy.nvim ke "runtime path" Neovim

-- =========================================================
-- Jalankan lazy.nvim
-- `import = "plugins"` → auto-baca SEMUA file di lua/plugins/
-- jadi tiap plugin = satu file rapi, nggak numpuk di sini.
-- =========================================================
require("lazy").setup({
  spec = {
    { import = "plugins" },     -- baca lua/plugins/*.lua
  },
  checker = { enabled = true }, -- auto-cek update plugin di background
  rocks = {
    enabled = false,            -- disable luarocks
  },
})
