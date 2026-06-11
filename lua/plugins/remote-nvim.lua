-- lua/plugins/remote-nvim.lua
-- remote-nvim.nvim = "VS Code Remote SSH"-nya Neovim.
-- Saat connect ke server, dia otomatis install Neovim + copy config
-- lokal kamu ke server, lalu Neovim lokal jadi UI client-nya.
-- Hasilnya: LSP, treesitter, formatter, dll jalan DI SERVER,
-- jadi path/dependency proyek remote ke-resolve dengan benar.
--
-- Syarat:
--   - lokal : ssh + scp (bawaan macOS, host bisa pakai ~/.ssh/config)
--   - remote: bash + curl/wget (buat download binary Neovim)
--
-- Cara pakai:
--   :RemoteStart  → pilih host SSH, tunggu setup, workspace kebuka
--   :RemoteStop   → putuskan sesi remote
--   :RemoteInfo   → lihat status sesi yang lagi jalan

return {
  "amitds1997/remote-nvim.nvim",

  -- Pin ke release GitHub biar nggak ketarik breaking change dari main.
  version = "*",

  dependencies = {
    "nvim-lua/plenary.nvim",            -- fungsi util standar
    "MunifTanjim/nui.nvim",             -- komponen UI (popup setup)
    "nvim-telescope/telescope.nvim",    -- picker buat milih host/aksi
  },

  -- Lazy-load: baru ke-load saat salah satu perintah ini dipakai.
  cmd = {
    "RemoteStart",
    "RemoteStop",
    "RemoteInfo",
    "RemoteCleanup",                    -- hapus instalasi nvim di server
    "RemoteConfigDel",                  -- lupakan konfigurasi host tersimpan
    "RemoteLog",
  },

  -- config = true → panggil setup() dengan default. Default-nya sudah
  -- pas: copy config lokal ke remote + pakai ~/.ssh/config buat host.
  config = true,
}
