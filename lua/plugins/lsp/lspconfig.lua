return {
	'neovim/nvim-lspconfig',
	event = { 'BufReadPre', 'BufNewFile' },
	dependencies = {
		'hrsh7th/cmp-nvim-lsp',
		{ 'antosha417/nvim-lsp-file-operations', config = true },
	},
	config = function()
		local mason_lspconfig = require('mason-lspconfig')
		local cmp_nvim_lsp = require('cmp_nvim_lsp')

		local lspconfig = require('lspconfig')
		local lsp_defaults = require('lspconfig').util.default_config

		lsp_defaults.capabilities =
			vim.tbl_deep_extend('force', lsp_defaults.capabilities, cmp_nvim_lsp.default_capabilities())

		vim.api.nvim_create_autocmd('LspAttach', {
			desc = 'LSP actions',
			callback = function(event)
				local opts = { buffer = event.buf }
				vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
				vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
				vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
				vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
				vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
				vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
				vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
				vim.keymap.set('n', 'gc', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
				vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
			end,
		})

		mason_lspconfig.setup({
			ensure_installed = {
				'lua_ls',
			},
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
			},
		})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = { 'vim' },
					},
					workspace = {
						-- library = {
						--   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
						--   [vim.fn.stdpath("config") .. "/lua"] = true
						-- },
						library = vim.api.nvim_get_runtime_file('', true),
						checkThirdParty = false,
					},
					codeLens = {
						enable = true,
					},
					completion = {
						callSnippet = 'Replace',
					},
					doc = {
						privateName = { '^_' },
					},
					hint = {
						enable = true,
						setType = false,
						paramType = true,
						paramName = 'Disable',
						semicolon = 'Disable',
						arrayIndex = 'Disable',
					},
				},
			},
		})
	end,
}
