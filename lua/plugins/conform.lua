return {
	'stevearc/conform.nvim',
	lazy = false,
	event = { 'BufWritePre' },
	cmd = { 'ConformInfo' },
	keys = {
		{
			'<leader>f',
			function() require('conform').format({ async = true }) end,
			mode = { 'n', 'v' },
			desc = 'Format buffer',
		},
	},
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			lua = { 'stylua' },
		},
		default_format_opts = {
			lsp_format = 'fallback',
		},
		format_on_save = { timeout_ms = 500 },
		formatters = {},
	},
	init = function() vim.o.formatexpr = "v:lua.require'conform'.formatexpr()" end,
}
