-- lua/plugins/conform.lua
-- conform.nvim = "manajer formatter". Dia manggil Prettier buat ngerapiin
-- kode, dan bisa auto-format tiap kali kamu :w (save).

return {
  "stevearc/conform.nvim",

  -- LAZY LOAD: cuma di-load pas MAU save (BufWritePre) atau panggil :ConformInfo.
  -- Startup tetap kenceng. (Pola event lagi, kayak autopairs.)
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },

  -- Keymap format MANUAL (kalau mau rapiin tanpa harus save).
  -- mode {n,v}: jalan di normal (seluruh file) & visual (seleksi aja).
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "v" },
      desc = "Conform: Format file/seleksi",
    },
  },

  opts = {
    -- "filetype mana → pakai formatter apa". Prettier handle semua web.
    formatters_by_ft = {
      javascript = { "prettier" },
      javascriptreact = { "prettier" },
      typescript = { "prettier" },
      typescriptreact = { "prettier" }, -- ini file .tsx React kamu
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      python = { "ruff_format" },
      sh = { "shfmt" }, -- shell script (.sh) → shfmt (install via :MasonInstall shfmt)
    },

    -- AUTO-FORMAT tiap save (:w).
    format_on_save = {
      -- batas waktu; formatter lemot → nyerah biar nggak ngegantung.
      timeout_ms = 1000,
      -- kalau nggak ada prettier buat filetype itu (mis. .lua),
      -- coba formatter bawaan LSP sebagai cadangan.
      lsp_format = "fallback",
    },
  },
}
