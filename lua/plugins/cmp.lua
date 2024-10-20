return {
	'hrsh7th/nvim-cmp',
	event = 'InsertEnter',
	lazy = false,
	dependencies = {
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'rafamadriz/friendly-snippets',
		'onsails/lspkind.nvim',
	},
	config = function()
		local cmp = require('cmp')
		local luasnip = require('luasnip')
		local lspkind = require('lspkind')

		require('luasnip.loaders.from_vscode').lazy_load()

		local bordered = cmp.config.window.bordered()
		bordered.border = 'single'

		cmp.setup({
			completion = {
				completeopt = 'menu,menuone,noinsert,preview',
			},
			snippet = {
				expand = function(args) luasnip.lsp_expand(args.body) end,
			},
			mapping = {
				['<Esc>'] = cmp.mapping({
					i = cmp.mapping.abort(),
				}),

				['<C-n>'] = cmp.mapping({
					i = function()
						if cmp.visible() then
							cmp.abort()
						else
							cmp.complete()
						end
					end,
				}),

				['<CR>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						if luasnip.expandable() then
							luasnip.expand()
						else
							cmp.confirm({
								select = true,
							})
						end
					else
						fallback()
					end
				end),

				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.locally_jumpable(1) then
						luasnip.jump(1)
					else
						fallback()
					end
				end, { 'i', 's' }),

				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'buffer' },
				{ name = 'path' },
			},
			---@type cmp.WindowConfig
			window = {
				completion = bordered,
				documentation = bordered,
			},
			formatting = {
				fields = { 'kind', 'abbr', 'menu' },
				format = function(entry, vim_item)
					local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, vim_item)
					local strings = vim.split(kind.kind, '%s', { trimempty = true })
					kind.kind = ' ' .. (strings[1] or '') .. ' '
					kind.menu = '    [' .. (strings[2] or '') .. ']'

					return kind
				end,
			},
		})
	end,
}
