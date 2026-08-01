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
    ensure_installed = {
      "lua_ls", "vtsls", "eslint", "emmet_language_server", "pyright",
      "dockerls",                        -- Dockerfile (completion + hover instruksi)
      "docker_compose_language_service", -- compose.yml / docker-compose.yml
      "bashls",                          -- shell script: completion, hover man-page, dll.
      "gopls",                           -- Go: completion, go-to-def, hover, diagnostics
      "tailwindcss",                     -- Tailwind: autocomplete class + preview warna + hover
    },

    -- automatic_enable = true (default) → server yang keinstall
    -- langsung dinyalain pakai vim.lsp.enable() bawaan Neovim 0.11+.
    -- Jadi nggak perlu setup manual per-server. 🎉
    --
    -- TAPI kita exclude "oxlint": paket Mason "oxlint" itu masang CLI binary
    -- SEKALIGUS oxc language server. Kalau LSP-nya ikut nyala, oxlint nge-lint
    -- DOBEL (LSP + nvim-lint) → diagnostic kembar. Kita pilih jalur nvim-lint
    -- aja (lihat lua/plugins/lint.lua), jadi LSP oxlint dimatiin di sini.
    automatic_enable = {
      exclude = { "oxlint" },
    },
  },

  config = function(_, opts)
    -- =====================================================
    -- FILETYPE TAMBAHAN
    -- docker_compose_language_service cuma nempel ke filetype
    -- "yaml.docker-compose" — padahal Neovim default-nya cuma kasih "yaml".
    -- Jadi kita daftarin nama-nama file compose biar dikenali.
    -- =====================================================
    vim.filetype.add({
      filename = {
        ["compose.yml"] = "yaml.docker-compose",
        ["compose.yaml"] = "yaml.docker-compose",
        ["docker-compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
      },
    })

    -- =====================================================
    -- TAMPILAN DIAGNOSTIC
    -- severity_sort = true → kalau di SATU baris ada beberapa diagnostic dari
    -- sumber berbeda (mis. oxlint=ERROR + TypeScript unused=HINT), gutter cuma
    -- muat satu sign. Tanpa ini (default false) prioritasnya seri → kadang yang
    -- muncul malah "H" (hint), bukan "E" (error). Dengan true, yang PALING parah
    -- selalu menang → "E" yang tampil. Juga ngurutin virtual text dari parah→ringan.
    -- =====================================================
    vim.diagnostic.config({ severity_sort = true })

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

    -- gopls: language server resmi Go. Setting ini bikin pengalaman ngoding
    -- Go jauh lebih enak (saran pintar, lint ringan, inlay hint).
    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,            -- format ala gofumpt (lebih ketat dari gofmt)
          completeUnimported = true, -- saran fungsi dari paket yang BELUM di-import
          usePlaceholders = true,    -- isi argumen jadi placeholder yang bisa di-Tab
          staticcheck = true,        -- analisis bug/anti-pattern bawaan staticcheck
          analyses = {
            unusedparams = true,     -- parameter fungsi yang nggak kepake
            unusedwrite = true,      -- nulis ke variabel tapi nggak pernah dibaca
            nilness = true,          -- deteksi potensi nil dereference
            shadow = true,           -- variabel yang "ketutup" (shadowed)
          },
          -- inlay hint = teks abu-abu di sebelah kode (tipe, nama param, dll).
          -- Aktifkan/matiin pakai keymap <leader>th (lihat LspAttach di bawah).
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
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
    -- =====================================================
    -- AUTO CODE ACTION SAAT SAVE
    -- Jalanin code action tertentu (mis. "organize/remove unused imports"
    -- dari vtsls, dan "fix all" dari eslint) SEBELUM file ditulis.
    --
    -- Kenapa nggak pakai vim.lsp.buf.code_action biasa? Karena itu ASYNC —
    -- requestnya dikirim, lalu hasilnya baru di-apply nanti (kadang SETELAH
    -- file kadung ke-save). Di sini kita pakai request SINKRON (request_sync)
    -- per-client biar editnya pasti diterapkan dulu, baru file disimpan.
    --
    -- Daftar "kind" code action yang kita minta:
    --   source.organizeImports → urutin import + buang yang nggak kepake (vtsls)
    --   source.fixAll.eslint   → auto-fix semua yang bisa diperbaiki eslint
    -- Tiap server cuma balas kind yang dia dukung, jadi aman dikirim ke semua.
    -- =====================================================
    local CODE_ACTIONS_ON_SAVE = {
      "source.organizeImports",
      "source.fixAll.eslint",
    }

    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.ts", "*.tsx", "*.js", "*.jsx", "*.cjs", "*.mjs" },
      callback = function(event)
        local bufnr = event.buf
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
          -- skip client yang nggak dukung code action sama sekali
          if client:supports_method("textDocument/codeAction") then
            for _, kind in ipairs(CODE_ACTIONS_ON_SAVE) do
              local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
              params.context = { only = { kind }, diagnostics = vim.diagnostic.get(bufnr) }

              -- timeout 1500ms; kalau server lemot, nyerah biar save nggak ngegantung
              local res = client:request_sync("textDocument/codeAction", params, 1500, bufnr)
              for _, action in ipairs((res or {}).result or {}) do
                if action.edit then
                  vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
                -- sebagian action dikirim sebagai "command" (bukan edit langsung)
                if action.command then
                  local cmd = type(action.command) == "table" and action.command or action
                  client:exec_cmd(cmd, { bufnr = bufnr })
                end
              end
            end
          end
        end
      end,
    })

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

        -- Toggle inlay hint (teks tipe/param abu-abu). Hidup-matiin per buffer.
        if vim.lsp.inlay_hint then
          map("n", "<leader>th", function()
            local on = vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf })
            vim.lsp.inlay_hint.enable(not on, { bufnr = event.buf })
          end, opt("Toggle inlay hint"))
        end
      end,
    })
  end,
}
