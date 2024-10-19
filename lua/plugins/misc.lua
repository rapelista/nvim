return {
	{
		'kylechui/nvim-surround',
		version = '*',
		event = 'VeryLazy',
		config = function()
			require('nvim-surround').setup({})
		end,
	},
	{
		'windwp/nvim-autopairs',
		event = 'InsertEnter',
		config = true,
	},
	{
		'windwp/nvim-ts-autotag',
		config = function()
			require('nvim-ts-autotag').setup({
				opts = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = false,
				},
			})
		end,
	},
}
