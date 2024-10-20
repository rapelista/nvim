return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		local builtin = require('telescope.builtin')
		local config = require('telescope.config')

		---@diagnostic disable-next-line: deprecated
		local vimgrep_arguments = { unpack(config.values.vimgrep_arguments) }

		table.insert(vimgrep_arguments, '--hidden')
		table.insert(vimgrep_arguments, '--glob')
		table.insert(vimgrep_arguments, '!**/.git/*')

		require('telescope').load_extension('notify')

		vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
		vim.keymap.set('n', '<leader>pg', builtin.live_grep, { desc = 'Telescope live grep' })
		vim.keymap.set('n', '<leader>pb', builtin.buffers, { desc = 'Telescope buffers' })
		vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = 'Telescope help tags' })
		vim.keymap.set(
			'n',
			'<leader>pn',
			function() vim.cmd('Telescope notify') end,
			{ desc = 'Telescope notifications' }
		)

		require('telescope').setup({
			defaults = {
				-- border = false,
				borderchars = {
					prompt = { ' ', ' ', '─', '│', '│', ' ', '─', '└' },
					results = { '─', ' ', ' ', '│', '┌', '─', ' ', '│' },
					preview = { '─', '│', '─', '│', '┬', '┐', '┘', '┴' },
				},
				vimgrep_arguments = vimgrep_arguments,
			},
			pickers = {
				find_files = {
					find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
				},
			},
		})
	end,
}
