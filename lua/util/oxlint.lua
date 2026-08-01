-- lua/util/oxlint.lua
-- Helper bersama soal JS/TS linting yang dipakai DUA tempat:
--   - lua/plugins/lint.lua   → nvim-lint (tampilkan diagnostic oxlint)
--   - lua/plugins/conform.lua → oxlint --fix saat save
-- Ditaruh di sini biar logikanya satu sumber, nggak gampang beda perilaku.

local M = {}

-- Tentukan binary oxlint mana yang dipakai.
-- Di monorepo (bun/pnpm workspace) binary-nya ada PER-PACKAGE di
-- node_modules/.bin, bukan di root. Jadi kita cari dengan NAIK dari direktori
-- `from` (idealnya direktori file yang dibuka) → file apps/frontend pakai oxlint
-- frontend, apps/backend pakai oxlint backend, terlepas dari mana Neovim
-- dijalankan. Kalau gak ketemu, fallback ke oxlint global (mis. dari Mason).
function M.find_bin(from)
  if not from or from == "" then
    local fname = vim.api.nvim_buf_get_name(0)
    from = fname ~= "" and vim.fs.dirname(fname) or vim.fn.getcwd()
  end
  local found = vim.fs.find("node_modules/.bin/oxlint", {
    upward = true, path = from, type = "file", limit = 1,
  })[1]
  return found or "oxlint"
end

-- Daftar nama file config eslint (sama persis kayak yang dideteksi eslint LSP
-- di nvim-lspconfig). Kalau salah satunya ketemu naik ke atas dari file yang
-- dibuka, berarti proyek ini "pakai eslint".
local eslint_config_files = {
  ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.yaml",
  ".eslintrc.yml", ".eslintrc.json",
  "eslint.config.js", "eslint.config.mjs", "eslint.config.cjs",
  "eslint.config.ts", "eslint.config.mts", "eslint.config.cts",
}

-- Cek: apakah proyek file ini punya config eslint?
-- Dipakai buat NGE-SKIP oxlint (baik lint maupun fix) kalau eslint yang ambil
-- alih → biar gak dobel kerja sama eslint LSP.
function M.has_eslint_config(bufnr)
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

return M
