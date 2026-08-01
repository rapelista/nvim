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
    -- Formatter custom: oxlint --fix.
    -- oxlint cuma bisa fix file di tempat (bukan via stdin), jadi:
    --   stdin = false  → conform nulis buffer ke tempfile, ganti $FILENAME,
    --                    oxlint fix tempfile itu, lalu conform baca balik.
    --   exit_codes {0,1} → "--fix" keluar exit 1 kalau MASIH ada lint error yang
    --                    gak bisa di-autofix; itu normal, bukan kegagalan.
    -- `command` pakai binary monorepo-aware yang sama kayak nvim-lint.
    -- ctx.dirname = direktori file asli → resolusi config .oxlintrc.json bener.
    formatters = {
      oxlint = {
        command = function(_, ctx)
          return require("util.oxlint").find_bin(ctx.dirname)
        end,
        args = { "--fix", "$FILENAME" },
        stdin = false,
        exit_codes = { 0, 1 },
      },
    },

    -- "filetype mana → pakai formatter apa". Prettier handle semua web.
    --
    -- Buat JS/TS: jalankan oxlint --fix DULU (buang/atur sesuai rule yang bisa
    -- di-autofix), BARU prettier rapiin formatnya. TAPI sama kayak nvim-lint,
    -- oxlint di-SKIP kalau proyek pakai eslint (biar eslint --fix lewat code
    -- action di lsp.lua yang ambil alih, gak dobel). Makanya nilainya function.
    formatters_by_ft = {
      javascript = function(bufnr)
        return require("util.oxlint").has_eslint_config(bufnr) and { "prettier" } or { "oxlint", "prettier" }
      end,
      javascriptreact = function(bufnr)
        return require("util.oxlint").has_eslint_config(bufnr) and { "prettier" } or { "oxlint", "prettier" }
      end,
      typescript = function(bufnr)
        return require("util.oxlint").has_eslint_config(bufnr) and { "prettier" } or { "oxlint", "prettier" }
      end,
      typescriptreact = function(bufnr) -- ini file .tsx React kamu
        return require("util.oxlint").has_eslint_config(bufnr) and { "prettier" } or { "oxlint", "prettier" }
      end,
      css = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      python = { "ruff_format" },
      sh = { "shfmt" }, -- shell script (.sh) → shfmt (install via :MasonInstall shfmt)
      -- Go: goimports rapiin + auto-atur import, lalu gofumpt (format lebih ketat).
      go = { "goimports", "gofumpt" },
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
