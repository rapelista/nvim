return {
  "scottmckendry/cyberdream.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("cyberdream").setup({
      transparent = true,
      terminal_colors = true,
      theme = {
        saturation = 1,
      },
      extensions = {
        telescope = false,
      },
    })

    vim.cmd("colorscheme cyberdream")
  end,
}
