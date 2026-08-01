-- lua/plugins/lint.lua
-- nvim-lint = jalanin linter EKSTERNAL (di luar LSP) lalu tampilkan hasilnya
-- sebagai diagnostic inline. Buat Go kita pakai golangci-lint: kumpulan
-- banyak linter sekaligus, lebih ketat dari analisis bawaan gopls.

return {
  "mfussenegger/nvim-lint",

  -- Lazy load: cukup pas buka/baca/simpan file.
  event = { "BufReadPre", "BufNewFile" },

  config = function()
    local lint = require("lint")
    local oxutil = require("util.oxlint") -- helper bersama (lihat lua/util/oxlint.lua)

    -- "filetype mana → linter apa".
    -- - golangcilint = pemanggil golangci-lint (install: :MasonInstall golangci-lint)
    -- - oxlint = linter JS/TS super cepat (ditulis pakai Rust), bisa 50-100x lebih
    --   ngebut dari ESLint. (install: :MasonInstall oxlint).
    --
    -- CATATAN: oxlint cuma dipakai kalau proyek BELUM punya config eslint.
    -- Kalau ada config eslint, oxlint di-skip → biar eslint (LSP) yang nge-lint,
    -- jadi gak dobel. Logikanya ada di run_lint() di bawah.
    lint.linters_by_ft = {
      go = { "golangcilint" },
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
    }

    -- Tentukan binary oxlint mana yang dipakai (monorepo-aware).
    -- Detail logikanya di util.oxlint.find_bin (dipakai juga oleh conform).
    lint.linters.oxlint.cmd = function()
      return oxutil.find_bin()
    end

    -- Jalankan lint dengan aturan: skip oxlint kalau proyek pakai eslint.
    local function run_lint()
      local ft_linters = lint.linters_by_ft[vim.bo.filetype]

      -- Default: nil → nvim-lint pakai linters_by_ft seperti biasa.
      local names = nil
      if ft_linters and vim.tbl_contains(ft_linters, "oxlint") and oxutil.has_eslint_config() then
        -- Buang oxlint dari daftar. Kalau jadi kosong, try_lint({}) = gak ngapa2in
        -- (eslint LSP yang ambil alih).
        names = vim.tbl_filter(function(l)
          return l ~= "oxlint"
        end, ft_linters)
      end

      lint.try_lint(names)
    end

    -- Kapan lint dijalankan. golangci-lint agak berat, jadi cukup pas
    -- buka file & SETELAH save — bukan tiap ketik (biar nggak lemot).
    local grp = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      group = grp,
      callback = run_lint,
    })

    -- Lint manual kapan pun (mis. abis pull dependency baru).
    vim.keymap.set("n", "<leader>cl", run_lint, { desc = "Lint: jalankan linter manual" })
  end,
}
