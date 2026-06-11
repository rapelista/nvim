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

    -- "filetype mana → linter apa". golangcilint = pemanggil golangci-lint.
    -- (install binary-nya via :MasonInstall golangci-lint)
    lint.linters_by_ft = {
      go = { "golangcilint" },
    }

    -- Kapan lint dijalankan. golangci-lint agak berat, jadi cukup pas
    -- buka file & SETELAH save — bukan tiap ketik (biar nggak lemot).
    local grp = vim.api.nvim_create_augroup("nvim_lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
      group = grp,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Lint manual kapan pun (mis. abis pull dependency baru).
    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Lint: jalankan golangci-lint manual" })
  end,
}
