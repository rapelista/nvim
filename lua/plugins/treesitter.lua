-- lua/plugins/treesitter.lua
-- Treesitter = parser kode → highlight & indent yang "paham struktur".
-- Pakai branch "main" (rewrite baru) karena cocok buat Neovim 0.11+/0.12.

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",      -- WAJIB main buat Neovim 0.12 (master udah beku & error)
  lazy = false,         -- treesitter nggak boleh di-lazy-load
  build = ":TSUpdate",  -- abis install/update → update semua parser

  config = function()
    -- 1) Install parser bahasa (pakai NAMA BAHASA, bukan filetype).
    --    Jalan di background, idempotent (yang udah ada di-skip).
    require("nvim-treesitter").install({
      "lua", "vim", "vimdoc",
      "javascript", "typescript", "tsx",
      "html", "css", "json",
      "markdown", "markdown_inline",
      "bash",
    })

    -- 2) Nyalain highlight + indent tiap buka file yang ADA parser-nya.
    --    Di branch main kita kudu start manual lewat autocmd FileType.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        -- Ubah filetype (mis. "sh") → nama bahasa parser (mis. "bash").
        local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)

        -- Start cuma kalau parser-nya beneran ada.
        -- pcall = "coba jalanin, kalau gagal jangan bikin error" (aman).
        if lang and pcall(vim.treesitter.start, args.buf, lang) then
          -- indent berbasis struktur kode (opsional tapi enak)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
