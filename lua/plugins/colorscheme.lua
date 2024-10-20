return {
  -- Cyberdream
  {
    'scottmckendry/cyberdream.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('cyberdream').setup({
        transparent = true,
        terminal_colors = true,
        theme = {
          saturation = 1,
        },
        extensions = {
          telescope = false,
        },
      })

      vim.cmd('colorscheme cyberdream')
    end,
  },
  -- Github
  -- {
  -- 	'projekt0n/github-nvim-theme',
  -- 	name = 'github-theme',
  -- 	lazy = false,
  -- 	priority = 1000,
  -- 	config = function()
  -- 		require('github-theme').setup({
  -- 			options = {
  -- 				compile_path = vim.fn.stdpath('cache') .. '/github-theme',
  -- 				compile_file_suffix = '_compiled',
  -- 				hide_end_of_buffer = true,
  -- 				hide_nc_statusline = true,
  -- 				transparent = true,
  -- 				terminal_colors = true,
  -- 				dim_inactive = false,
  -- 				module_default = true,
  -- 				styles = {
  -- 					comments = 'italic',
  -- 					functions = 'NONE',
  -- 					keywords = 'NONE',
  -- 					variables = 'bold',
  -- 					conditionals = 'NONE',
  -- 					constants = 'underline',
  -- 					numbers = 'bold',
  -- 					operators = 'bold',
  -- 					strings = 'bold',
  -- 					types = 'NONE',
  -- 				},
  -- 				inverse = {
  -- 					match_paren = false,
  -- 					visual = false,
  -- 					search = false,
  -- 				},
  -- 				darken = {
  -- 					floats = true,
  -- 					sidebars = {
  -- 						enable = true,
  -- 						list = {},
  -- 					},
  -- 				},
  -- 				modules = {},
  -- 			},
  -- 			palettes = {},
  -- 			specs = {},
  -- 			groups = {},
  -- 		})
  --
  -- 		vim.cmd('colorscheme github_dark_high_contrast')
  -- 	end,
  -- },
}
