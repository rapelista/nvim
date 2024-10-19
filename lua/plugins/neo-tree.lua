return {
	'nvim-neo-tree/neo-tree.nvim',
	branch = 'v3.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'MunifTanjim/nui.nvim',
	},
	config = function()
		local neotree = require('neo-tree')

		neotree.setup({
			event_handlers = {
				{
					event = 'file_open_requested',
					handler = function()
						require('neo-tree.command').execute({ action = 'close' })
					end,
				},
			},
			filesystem = {
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					never_show = {
						'.DS_Store',
						'thumbs.db',
						'.git',
					},
				},
			},
		})
		vim.cmd([[nnoremap \ :Neotree toggle<CR>]])
	end,
}
