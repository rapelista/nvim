local function file_exists(name)
  local f = io.open(name, 'r')
  return f ~= nil and io.close(f)
end

vim.api.nvim_create_autocmd('DirChangedPre', {
  desc = 'Change colorscheme based on package.json',
  callback = function(event)
    local isPackageJsonExists = file_exists(event.file .. '/package.json')
    local currentColorscheme = vim.g.colors_name

    if isPackageJsonExists then
      if currentColorscheme ~= 'rapelista' then vim.cmd('colorscheme rapelista') end
    else
      if currentColorscheme ~= 'cyberdream' then vim.cmd('colorscheme cyberdream') end
    end
  end,
})
