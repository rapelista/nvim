-- lua/plugins/treesitter-textobjects.lua
-- Nambah text object SEMANTIK: af/if (fungsi), ac/ic (class), aa/ia (argumen).
-- Nyatu sama operator vim → daf hapus fungsi, cif ganti isi, dst.

return {
  "nvim-treesitter/nvim-treesitter-textobjects",

  -- WAJIB "main" biar seirama sama treesitter kamu yang juga "main".
  -- (master = API lama yang naruh keymap di dalam configs.setup — beda total.)
  branch = "main",
  dependencies = { "nvim-treesitter/nvim-treesitter" },

  -- treesitter kamu udah lazy=false (load di awal), jadi cukup VeryLazy:
  -- load pas Neovim udah santai abis startup. Nggak ngerem buka file.
  event = "VeryLazy",

  config = function()
    -- Beda sama master: di main kita setup() DULU, lalu pasang keymap MANUAL.
    require("nvim-treesitter-textobjects").setup({
      -- lookahead: kalau kursor lagi DI LUAR objek, lompat maju ke objek
      -- terdekat. Jadi cif tetap jalan walau kursor belum pas di fungsi.
      select = { lookahead = true },
      -- set_jumps: tiap lompat ([f/]f) kecatat di jumplist → Ctrl-o balik.
      move = { set_jumps = true },
    })

    local map = vim.keymap.set

    -- ===== SELECT: cuma di Visual ("x") & Operator-pending ("o") =====
    -- "o" = mode setelah ngetik operator (d/c/y). Itu yang bikin "daf" jalan.
    -- (Nggak dipasang di Normal mode — text object emang cuma guna di sini.)
    local sel = require("nvim-treesitter-textobjects.select").select_textobject
    map({ "x", "o" }, "af", function() sel("@function.outer", "textobjects") end, { desc = "TS: A Function" })
    map({ "x", "o" }, "if", function() sel("@function.inner", "textobjects") end, { desc = "TS: Inner Function" })
    map({ "x", "o" }, "ac", function() sel("@class.outer", "textobjects") end, { desc = "TS: A Class" })
    map({ "x", "o" }, "ic", function() sel("@class.inner", "textobjects") end, { desc = "TS: Inner Class" })
    map({ "x", "o" }, "aa", function() sel("@parameter.outer", "textobjects") end, { desc = "TS: A Argument" })
    map({ "x", "o" }, "ia", function() sel("@parameter.inner", "textobjects") end, { desc = "TS: Inner Argument" })

    -- ===== MOVE: Normal/Visual/Operator — lompat antar objek =====
    local move = require("nvim-treesitter-textobjects.move")
    map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
      { desc = "TS: fungsi berikutnya" })
    map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
      { desc = "TS: fungsi sebelumnya" })
    map({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end,
      { desc = "TS: argumen berikutnya" })
    map({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end,
      { desc = "TS: argumen sebelumnya" })

    -- ===== SWAP: tuker argumen tanpa cut-paste manual =====
    local swap = require("nvim-treesitter-textobjects.swap")
    map("n", "<leader>na", function() swap.swap_next("@parameter.inner") end, { desc = "TS: tuker argumen dgn Next" })
    map("n", "<leader>pa", function() swap.swap_previous("@parameter.inner") end, { desc = "TS: tuker argumen dgn Prev" })
  end,
}
