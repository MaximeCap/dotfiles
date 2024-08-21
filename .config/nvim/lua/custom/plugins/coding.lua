return {
  {
    'windwp/nvim-autopairs',
    event = { 'InsertEnter' },
    dependencies = {
      'hrsh7th/nvim-cmp',
    },
    config = function()
      -- import nvim-autopairs
      local autopairs = require 'nvim-autopairs'

      -- configure autopairs
      autopairs.setup {
        check_ts = true, -- enable treesitter
        ts_config = {
          lua = { 'string' }, -- don't add pairs in lua string treesitter nodes
          javascript = { 'template_string' }, -- don't add pairs in javscript template_string treesitter nodes
          java = false, -- don't check treesitter on java
        },
      }

      -- import nvim-autopairs completion functionality
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'

      -- import nvim-cmp plugin (completions plugin)
      local cmp = require 'cmp'

      -- make autopairs and completion work together
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },
  {
    'ray-x/lsp_signature.nvim',
    opts = {},
    config = function(_, opts)
      require('lsp_signature').setup(opts)
    end,
  },
  {
    'wuelnerdotexe/vim-astro',
    ft = 'astro',
    init = function()
      -- Astro configuration variables.
      vim.g.astro_typescript = 'enable'
      vim.g.astro_stylus = 'disable'
    end,
  },
  {
    'barrett-ruth/live-server.nvim',
    build = 'pnpm add -g live-server',
    cmd = { 'LiveServerStart', 'LiveServerStop' },
    config = true,
  },
  {
    'github/copilot.vim',
  },
  {
    {
      'CopilotC-Nvim/CopilotChat.nvim',
      branch = 'canary',
      dependencies = {
        { 'zbirenbaum/copilot.lua' }, -- or github/copilot.vim
        { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
      },
      opts = {
        debug = true, -- Enable debugging
        -- See Configuration section for rest
      },
      -- See Commands section for default commands if you want to lazy load on them
    },
  },
}
