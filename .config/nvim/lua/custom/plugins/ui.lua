return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local nvimtree = require 'nvim-tree'

      -- recommended settings from nvim-tree documentation
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- change color for arrows in tree to light blue
      vim.cmd [[ highlight NvimTreeFolderArrowClosed guifg=#3FC5FF ]]
      vim.cmd [[ highlight NvimTreeFolderArrowOpen guifg=#3FC5FF ]]

      -- configure nvim-tree
      nvimtree.setup {
        view = {
          width = 65,
          relativenumber = true,
        },
        -- change folder arrow icons
        renderer = {
          indent_markers = {
            enable = true,
          },
        },
        -- disable window_picker for
        -- explorer to work well with
        -- window splits
        actions = {
          open_file = {
            quit_on_open = true,
            window_picker = {
              enable = false,
            },
          },
        },
        filters = {
          custom = { '.DS_Store' },
        },
        git = {
          ignore = false,
        },
      }

      -- set keymaps
      local keymap = vim.keymap -- for conciseness

      keymap.set('n', '<leader>ef', '<cmd>NvimTreeFocus<CR>', { desc = 'Focus file explorer' }) -- toggle file explorer
      keymap.set('n', '<leader>ee', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' }) -- toggle file explorer
      keymap.set('n', '<leader>es', '<cmd>NvimTreeFindFileToggle<CR>', { desc = 'Toggle file explorer on current file' }) -- toggle file explorer on current file
      keymap.set('n', '<leader>ec', '<cmd>NvimTreeCollapse<CR>', { desc = 'Collapse file explorer' }) -- collapse file explorer
      keymap.set('n', '<leader>er', '<cmd>NvimTreeRefresh<CR>', { desc = 'Refresh file explorer' }) -- refresh file explorer
    end,
  },
  {
    'harrisoncramer/gitlab.nvim',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'nvim-lua/plenary.nvim',
      'sindrets/diffview.nvim',
      'stevearc/dressing.nvim', -- Recommended but not required. Better UI for pickers.
      'nvim-tree/nvim-web-devicons', -- Recommended but not required. Icons in discussion tree.
    },
    enabled = true,
    build = function()
      require('gitlab.server').build(true)
    end, -- Builds the Go binary
    config = function()
      local gitlab = require 'gitlab'
      local keymap = vim.keymap -- for conciseness

      keymap.set('n', 'glb', gitlab.choose_merge_request, { desc = 'Choose merge request' })
      keymap.set('n', 'glr', gitlab.review, { desc = 'Review' })
      keymap.set('n', 'gls', gitlab.summary, { desc = 'Summary' })
      keymap.set('n', 'glA', gitlab.approve, { desc = 'Approve' })
      keymap.set('n', 'glR', gitlab.revoke, { desc = 'Revoke' })
      keymap.set('n', 'glc', gitlab.create_comment, { desc = 'Create comment' })
      keymap.set('v', 'glc', gitlab.create_multiline_comment, { desc = 'Create multine comment' })
      keymap.set('v', 'glC', gitlab.create_comment_suggestion, { desc = 'Create comment suggestion' })
      keymap.set('n', 'glO', gitlab.create_mr, { desc = 'Create Merge Request' })
      keymap.set('n', 'glm', gitlab.move_to_discussion_tree_from_diagnostic, { desc = 'Move to discussion tree from diagnostic' })
      keymap.set('n', 'gln', gitlab.create_note, { desc = 'Create Note' })
      keymap.set('n', 'gld', gitlab.toggle_discussions, { desc = 'Toggle Discussion' })
      keymap.set('n', 'glaa', gitlab.add_assignee, { desc = 'Add Assignee' })
      keymap.set('n', 'glad', gitlab.delete_assignee, { desc = 'Delete assignee' })
      keymap.set('n', 'glla', gitlab.add_label, { desc = 'Add label' })
      keymap.set('n', 'glld', gitlab.delete_label, { desc = 'Delete label' })
      keymap.set('n', 'glra', gitlab.add_reviewer, { desc = 'Add reviewer' })
      keymap.set('n', 'glrd', gitlab.delete_reviewer, { desc = 'Delete reviewer' })
      keymap.set('n', 'glp', gitlab.pipeline, { desc = 'Pipeline' })
      keymap.set('n', 'glo', gitlab.open_in_browser, { desc = 'Open in browser' })
      keymap.set('n', 'glM', gitlab.merge, { desc = 'Merge' })
      keymap.set('n', 'glu', gitlab.copy_mr_url, { desc = 'Copy Merge request URL' })
      keymap.set('n', 'glP', gitlab.publish_all_drafts, { desc = 'Publish all drafts' })
      gitlab.setup()
    end,
  },

  {
    'kdheepak/lazygit.nvim',
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>', { desc = 'Lazygit' })
    end,
  },
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup {
        default_mappings = {
          ours = 'co',
          theirs = 'ct',
          none = 'c0',
          both = 'cb',
          next = 'cn',
          prev = 'cp',
        },
      }

      vim.api.nvim_create_autocmd('User', {
        pattern = 'GitConflictDetected',
        callback = function()
          vim.notify('Conflict detected in ' .. vim.fn.expand '<afile>')
          vim.keymap.set('n', 'cww', function()
            engage.conflict_buster()
            create_buffer_local_mappings()
          end)
        end,
      })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
    config = function()
      require('ibl').setup()
    end,
  },
  {
    'FabianWirth/search.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    config = function()
      local builtin = require 'telescope.builtin'
      local search = require 'search'
      local harpoon = require 'harpoon'
      search.setup {
        append_tabs = { -- append_tabs will add the provided tabs to the default ones
          {
            'Commits', -- or name = "Commits"
            builtin.git_commits, -- or tele_func = require('telescope.builtin').git_commits
            available = function() -- optional
              return vim.fn.isdirectory '.git' == 1
            end,
          },
          {
            'Harpoon',
            tele_func = function()
              local file_path = {}
              local tab = harpoon:list()
              local conf = require('telescope.config').values
              for _, item in ipairs(tab.items) do
                table.insert(file_path, item.value)
              end
              require('telescope.pickers')
                .new({}, {
                  prompt_title = 'Harpoon',
                  finder = require('telescope.finders').new_table {
                    results = file_path,
                  },
                  previewer = conf.file_previewer {},
                  sortter = conf.generic_sorter {},
                })
                :find()
            end,
            available = function()
              local table = harpoon:list()
              return #table.items > 0
            end,
          },
        },
      }
      vim.keymap.set('n', '<leader><leader>', search.open, { desc = 'Open search' })
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'
      harpoon:setup()
      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local file_path = {}
        for _, item in ipairs(harpoon_files.items) do
          table.insert(file_path, item.value)
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = require('telescope.finders').new_table {
              results = file_path,
            },
            previewer = conf.file_previewer {},
            sortter = conf.generic_sorter {},
          })
          :find()
      end

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end)
      vim.keymap.set('n', '<leader>m', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon window' })
    end,
  },
}
