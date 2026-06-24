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

    -- Tentukan binary oxlint mana yang dipakai.
    -- Bawaan nvim-lint cuma cek ./node_modules/.bin relatif ke CWD Neovim — di
    -- monorepo (bun/pnpm workspace) binary-nya ada PER-PACKAGE, bukan di root.
    -- Jadi kita cari node_modules/.bin/oxlint dengan naik dari direktori FILE
    -- yang dibuka → file apps/frontend pakai oxlint frontend, apps/backend pakai
    -- oxlint backend, terlepas dari mana Neovim dijalankan. Selalu konsisten sama
    -- versi yang dipin tiap package. Kalau gak ketemu, fallback ke oxlint global
    -- (mis. yang diinstall Mason). (Resolusi config .oxlintrc.json diurus oxlint
    -- sendiri lewat "nested config" berdasar lokasi file — bukan urusan kita.)
    lint.linters.oxlint.cmd = function()
      local fname = vim.api.nvim_buf_get_name(0)
      local from = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
      local found = vim.fs.find("node_modules/.bin/oxlint", {
        upward = true, path = from, type = "file", limit = 1,
      })[1]
      return found or "oxlint"
    end

    -- Daftar nama file config eslint (sama persis kayak yang dideteksi
    -- eslint LSP di nvim-lspconfig). Kalau salah satunya ketemu naik ke atas
    -- dari file yang dibuka, berarti proyek ini "pakai eslint".
    local eslint_config_files = {
      ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
      ".eslintrc.yml", ".eslintrc.json",
      "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
      "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
    }

    -- Cek: apakah proyek file ini punya config eslint?
    local function has_eslint_config(bufnr)
      local fname = vim.api.nvim_buf_get_name(bufnr or 0)
      if fname == "" then
        return false
      end
      local from = vim.fs.dirname(fname)

      -- 1) cari file config eslint ke ATAS dari lokasi file.
      if vim.fs.find(eslint_config_files, { upward = true, path = from, type = "file", limit = 1 })[1] then
        return true
      end

      -- 2) cara lama: field "eslintConfig" di dalam package.json juga sah.
      local pkg = vim.fs.find("package.json", { upward = true, path = from, type = "file", limit = 1 })[1]
      if pkg then
        local ok, lines = pcall(vim.fn.readfile, pkg)
        if ok and table.concat(lines, "\n"):match('"eslintConfig"%s*:') then
          return true
        end
      end

      return false
    end

    -- Jalankan lint dengan aturan: skip oxlint kalau proyek pakai eslint.
    local function run_lint()
      local ft_linters = lint.linters_by_ft[vim.bo.filetype]

      -- Default: nil → nvim-lint pakai linters_by_ft seperti biasa.
      local names = nil
      if ft_linters and vim.tbl_contains(ft_linters, "oxlint") and has_eslint_config() then
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
