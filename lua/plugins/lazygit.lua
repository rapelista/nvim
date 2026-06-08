-- lua/plugins/lazygit.lua
-- lazygit.nvim = jembatan antara Neovim dan binary lazygit.
-- Plugin ini BUKAN lazygit itu sendiri — dia cuma buka lazygit
-- dalam popup floating terminal di dalam Neovim, jadi kamu nggak
-- perlu keluar dari editor buat commit/branch/rebase/dll.
--
-- Syarat: binary lazygit harus sudah terinstall (brew install lazygit).

return {
  "kdheepak/lazygit.nvim",

  -- plenary udah keinstall lewat telescope, jadi nggak ada overhead baru.
  dependencies = { "nvim-lua/plenary.nvim" },

  -- Lazy-load: plugin baru ke-load saat perintah / keymap dipakai.
  cmd = {
    "LazyGit",                  -- buka lazygit dari root proyek
    "LazyGitCurrentFile",       -- buka lazygit, langsung fokus ke file aktif
  },

  keys = {
    {
      "<leader>lg",
      "<cmd>LazyGit<cr>",
      desc = "Lazygit: buka UI git",
    },
  },

  -- Plugin ini nggak butuh setup() — langsung jalan dari cmd/keymap.
}
