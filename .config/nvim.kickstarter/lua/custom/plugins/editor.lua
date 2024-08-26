return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  {
    'NvChad/nvim-colorizer.lua',
    config = true,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  },
  {
    'jinh0/eyeliner.nvim',
    config = function()
      require('eyeliner').setup {
        -- show highlights only after keypress
        highlight_on_key = true,

        -- dim all other characters if set to true (recommended!)
        dim = true,
        -- set the maximum number of characters eyeliner.nvim will check from
        -- your current cursor position; this is useful if you are dealing with
        -- large files: see https://github.com/jinh0/eyeliner.nvim/issues/41
        max_length = 9999,

        -- filetypes for which eyeliner should be disabled;
        -- e.g., to disable on help files:
        -- disable_filetypes = {"help"}
        disable_filetypes = {},

        -- buftypes for which eyeliner should be disabled
        -- e.g., disable_buftypes = {"nofile"}
        disable_buftypes = {},

        -- add eyeliner to f/F/t/T keymaps;
        -- see section on advanced configuration for more information
        default_keymaps = true,
      }
    end,
  },
  {
    'm4xshen/hardtime.nvim',
    dependencies = { 'MunifTanjim/nui.nvim', 'nvim-lua/plenary.nvim' },
    opts = {
      max_count = 8,
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
  },
  {
    'RRethy/vim-illuminate',
  },
  {
    'feline-nvim/feline.nvim',
    config = function()
      local present, feline = pcall(require, 'feline')
      if not present then
        return
      end

      -- Customizations {{{
      local theme = {
        aqua = '#7AB0DF',
        bg = '#1C212A',
        blue = '#5FB0FC',
        cyan = '#70C0BA',
        darkred = '#FB7373',
        fg = '#C7C7CA',
        gray = '#222730',
        green = '#79DCAA',
        lime = '#54CED6',
        orange = '#FFD064',
        pink = '#D997C8',
        purple = '#C397D8',
        red = '#F87070',
        yellow = '#FFE59E',
      }

      local mode_theme = {
        ['NORMAL'] = theme.green,
        ['OP'] = theme.cyan,
        ['INSERT'] = theme.aqua,
        ['VISUAL'] = theme.yellow,
        ['LINES'] = theme.darkred,
        ['BLOCK'] = theme.orange,
        ['REPLACE'] = theme.purple,
        ['V-REPLACE'] = theme.pink,
        ['ENTER'] = theme.pink,
        ['MORE'] = theme.pink,
        ['SELECT'] = theme.darkred,
        ['SHELL'] = theme.cyan,
        ['TERM'] = theme.lime,
        ['NONE'] = theme.gray,
        ['COMMAND'] = theme.blue,
      }

      local modes = setmetatable({
        ['n'] = 'N',
        ['no'] = 'N',
        ['v'] = 'V',
        ['V'] = 'VL',
        [''] = 'VB',
        ['s'] = 'S',
        ['S'] = 'SL',
        [''] = 'SB',
        ['i'] = 'I',
        ['ic'] = 'I',
        ['R'] = 'R',
        ['Rv'] = 'VR',
        ['c'] = 'C',
        ['cv'] = 'EX',
        ['ce'] = 'X',
        ['r'] = 'P',
        ['rm'] = 'M',
        ['r?'] = 'C',
        ['!'] = 'SH',
        ['t'] = 'T',
      }, {
        __index = function()
          return '-'
        end,
      })
      -- }}}

      -- Components {{{
      local component = {}

      component.vim_mode = {
        provider = function()
          return modes[vim.api.nvim_get_mode().mode]
        end,
        hl = function()
          return {
            fg = 'bg',
            bg = require('feline.providers.vi_mode').get_mode_color(),
            style = 'bold',
            name = 'NeovimModeHLColor',
          }
        end,
        left_sep = 'block',
        right_sep = 'block',
      }

      component.git_branch = {
        provider = 'git_branch',
        hl = {
          fg = 'fg',
          bg = 'bg',
          style = 'bold',
        },
        left_sep = 'block',
        right_sep = '',
      }

      component.git_add = {
        provider = 'git_diff_added',
        hl = {
          fg = 'green',
          bg = 'bg',
        },
        left_sep = '',
        right_sep = '',
      }

      component.git_delete = {
        provider = 'git_diff_removed',
        hl = {
          fg = 'red',
          bg = 'bg',
        },
        left_sep = '',
        right_sep = '',
      }

      component.git_change = {
        provider = 'git_diff_changed',
        hl = {
          fg = 'purple',
          bg = 'bg',
        },
        left_sep = '',
        right_sep = '',
      }

      component.separator = {
        provider = '',
        hl = {
          fg = 'bg',
          bg = 'bg',
        },
      }

      component.diagnostic_errors = {
        provider = 'diagnostic_errors',
        hl = {
          fg = 'red',
        },
      }

      component.diagnostic_warnings = {
        provider = 'diagnostic_warnings',
        hl = {
          fg = 'yellow',
        },
      }

      component.diagnostic_hints = {
        provider = 'diagnostic_hints',
        hl = {
          fg = 'aqua',
        },
      }

      component.diagnostic_info = {
        provider = 'diagnostic_info',
      }

      component.lsp = {
        provider = function()
          if not rawget(vim, 'lsp') then
            return ''
          end

          local progress = vim.lsp.status()[1]
          if vim.o.columns < 120 then
            return ''
          end

          local clients = vim.lsp.get_clients { bufnr = 0 }
          if #clients ~= 0 then
            if progress then
              local spinners = {
                '◜ ',
                '◠ ',
                '◝ ',
                '◞ ',
                '◡ ',
                '◟ ',
              }
              local ms = vim.loop.hrtime() / 1000000
              local frame = math.floor(ms / 120) % #spinners
              local content = string.format('%%<%s', spinners[frame + 1])
              return content or ''
            else
              return 'לּ LSP'
            end
          end
          return ''
        end,
        hl = function()
          local progress = vim.lsp.status()[1]
          return {
            fg = progress and 'yellow' or 'green',
            bg = 'gray',
            style = 'bold',
          }
        end,
        left_sep = '',
        right_sep = 'block',
      }

      component.file_type = {
        provider = {
          name = 'file_type',
          opts = {
            filetype_icon = true,
          },
        },
        hl = {
          fg = 'fg',
          bg = 'gray',
        },
        left_sep = 'block',
        right_sep = 'block',
      }

      component.scroll_bar = {
        provider = function()
          local chars = setmetatable({
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
            ' ',
          }, {
            __index = function()
              return ' '
            end,
          })
          local line_ratio = vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0)
          local position = math.floor(line_ratio * 100)

          local icon = chars[math.floor(line_ratio * #chars)] .. position
          if position <= 5 then
            icon = ' TOP'
          elseif position >= 95 then
            icon = ' BOT'
          end
          return icon
        end,
        hl = function()
          local position = math.floor(vim.api.nvim_win_get_cursor(0)[1] / vim.api.nvim_buf_line_count(0) * 100)
          local fg
          local style

          if position <= 5 then
            fg = 'aqua'
            style = 'bold'
          elseif position >= 95 then
            fg = 'red'
            style = 'bold'
          else
            fg = 'purple'
            style = nil
          end
          return {
            fg = fg,
            style = style,
            bg = 'bg',
          }
        end,
        left_sep = 'block',
        right_sep = 'block',
      }
      -- }}}

      -- Arrangements -- {{{
      vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#101317', fg = '#7AB0DF' })
      feline.setup {
        components = {
          active = {
            {}, -- left
            {}, -- middle
            { -- right
              component.vim_mode,
              component.file_type,
              component.lsp,
              component.git_branch,
              component.git_add,
              component.git_delete,
              component.git_change,
              component.separator,
              component.diagnostic_errors,
              component.diagnostic_warnings,
              component.diagnostic_info,
              component.diagnostic_hints,
              component.scroll_bar,
            },
          },
        },
        theme = theme,
        vi_mode_colors = mode_theme,
      }
      -- }}}
    end,
  },
}
