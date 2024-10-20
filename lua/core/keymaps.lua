vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')

vim.keymap.set('n', 'N', 'nzzzv')

vim.keymap.set('x', '<leader>p', '"_dP')

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

vim.keymap.set('v', '~', '~gv')
vim.keymap.set('v', 'U', 'Ugv')
vim.keymap.set('v', 'u', 'ugv')

vim.keymap.set('n', '<Up>', ':resize -2<CR>')
vim.keymap.set('n', '<Down>', ':resize +2<CR>')
vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>')
vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>')

vim.keymap.set('n', '<leader>|', '<C-w>v')
vim.keymap.set('n', '<leader>-', '<C-w>s')
vim.keymap.set('n', '<leader>se', '<C-w>=')
vim.keymap.set('n', '<leader>xs', ':close<CR>')

vim.keymap.set('n', '<C-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<C-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<C-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<C-l>', ':wincmd l<CR>')

vim.keymap.set('n', '<S-w>', ':bd!<CR>')
vim.keymap.set('n', '<leader>kw', ':%bd!<CR><CR>')

vim.keymap.set('n', '<leader>kz', function()
  vim.cmd('set nowrap!')
  vim.notify('Toggle Wrap')
end)

vim.keymap.set('n', 'Q', '<nop>')

vim.keymap.set('n', '<leader>so', function()
  vim.cmd('source $MYVIMRC')
  vim.notify('Config reloaded...', vim.diagnostic.severity.INFO, {
    title = 'OK!',
  })
end)
