-- lua/plugins/lsp.lua
-- LSP = bikin Neovim jadi "ngerti" bahasa: error inline, go-to-definition, dll.

return {
  "mason-org/mason-lspconfig.nvim",

  -- plugin yang harus ada DULUAN (urutan diurus lazy.nvim otomatis):
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- opts = {} → auto-panggil mason.setup()
    "neovim/nvim-lspconfig",               -- definisi config server
  },

  -- `opts` = cara singkat lazy.nvim: dia auto-panggil
  -- require("mason-lspconfig").setup(opts) buat kita.
  opts = {
    -- Server yang mau diinstall otomatis. Nama-nama ini dari mason.
    -- (lua_ls = server buat bahasa Lua)
    ensure_installed = { "lua_ls" },

    -- automatic_enable = true (default) → server yang keinstall
    -- langsung dinyalain pakai vim.lsp.enable() bawaan Neovim 0.11+.
    -- Jadi nggak perlu setup manual per-server. 🎉
  },

  config = function(_, opts)
    -- =====================================================
    -- KONFIG PER-SERVER (API baru Neovim 0.11+: vim.lsp.config)
    -- Ini diset SEBELUM server dinyalain mason-lspconfig.
    -- =====================================================
    -- lua_ls: kasih tau `vim` itu global sah → warning "Undefined global" hilang.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" }, -- daftar global yang dianggap "udah ada"
          },
        },
      },
    })

    require("mason-lspconfig").setup(opts)

    -- =====================================================
    -- KEYMAP LSP — cuma aktif di buffer yang ada LSP-nya.
    -- Caranya: pasang lewat event "LspAttach" (jalan tiap
    -- LSP nempel ke sebuah buffer). Pola standar Neovim.
    -- =====================================================
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        -- `buffer = event.buf` → keymap ini lokal buffer ini aja
        local opt = function(desc)
          return { buffer = event.buf, desc = "LSP: " .. desc }
        end

        local map = vim.keymap.set
        map("n", "gd", vim.lsp.buf.definition, opt("Go to Definition"))
        map("n", "K", vim.lsp.buf.hover, opt("Hover docs"))
        map("n", "gr", vim.lsp.buf.references, opt("Cari semua Reference"))
        map("n", "<leader>rn", vim.lsp.buf.rename, opt("Rename symbol"))
        map("n", "<leader>ca", vim.lsp.buf.code_action, opt("Code Action / fix"))
        map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, opt("Error sebelumnya"))
        map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, opt("Error berikutnya"))
        map("n", "<leader>d", vim.diagnostic.open_float, opt("Lihat detail error"))
      end,
    })
  end,
}
