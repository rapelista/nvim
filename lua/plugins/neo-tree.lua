return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-tree/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').set_icon({
          tsx = {
            color = '#20c2e3',
            cterm_color = '45',
            icon = '',
            name = 'Tsx',
          },
        })
      end,
    },
    'MunifTanjim/nui.nvim',
    '3rd/image.nvim',
  },
  config = function()
    local neotree = require('neo-tree')

    neotree.setup({
      enable_git_status = true,
      enable_diagnostics = true,
      popup_border_style = 'single',
      default_component_configs = {
        indent = {
          with_markers = false,
          indent_size = 1,
        },
        icon = {
          folder_closed = '',
          folder_open = '',
          folder_empty = '󰜌',
          provider = function(icon, node) -- default icon provider utilizes nvim-web-devicons if available
            if node.type == 'file' or node.type == 'terminal' then
              local success, web_devicons = pcall(require, 'nvim-web-devicons')
              local name = node.type == 'terminal' and 'terminal' or node.name
              if success then
                local devicon, hl = web_devicons.get_icon(name)
                icon.text = devicon or icon.text
                icon.highlight = hl or icon.highlight
              end
            end
          end,
          -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
          -- then these will never be used.
          default = '*',
          highlight = 'NeoTreeFileIcon',
        },
        modified = {
          symbol = '[+]',
          highlight = 'NeoTreeModified',
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = 'NeoTreeFileName',
        },
        git_status = {
          symbols = {
            -- Change type
            added = '✚', -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified = '', -- or "", but this is redundant info if you use git_status_colors on the name
            deleted = '✖', -- this can only be used in the git_status source
            renamed = '󰁕', -- this can only be used in the git_status source
            -- Status type
            untracked = '',
            ignored = '',
            unstaged = '󰄱',
            staged = '',
            conflict = '',
          },
        },
      },
      event_handlers = {
        {
          event = 'file_open_requested',
          handler = function() require('neo-tree.command').execute({ action = 'close' }) end,
        },
      },
      window = {
        position = 'left',
        width = 40,
        mappings = {
          ['P'] = { 'toggle_preview', config = { use_float = true, use_image_nvim = true } },
        },
      },
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
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
      git_status = {
        window = {
          position = 'float',
        },
      },
      hijack_netrw_behavior = 'open_default',
    })

    -- vim.cmd([[nnoremap \ :Neotree toggle<CR>]])
    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', '\\', ':Neotree toggle<CR>', opts)
    vim.keymap.set('n', '<leader>G', ':Neotree git_status<CR>', opts)
  end,
}
