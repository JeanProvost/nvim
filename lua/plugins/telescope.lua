return {
  'nvim-telescope/telescope.nvim',
  branch = '0.1.x',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-project.nvim' },
  config = function()
    local telescope = require('telescope')

    -- Telescope configuration
    telescope.setup({
      defaults = {
        path_display = { 'truncate' },
      },
      extensions = {
        project = {
          base_dirs = {
            '/Users/jeanprovost/Repositories',
          },
          hidden_files = true,
        },
      },
    })

    -- Load the project extension
    telescope.load_extension('project')

    local project_actions = require('telescope._extensions.project.actions')
    telescope.extensions.project.mappings = {
      i = {
        ['<C-d>'] = project_actions.delete_project,
        ['<C-f>'] = project_actions.find_project_files,
        ['<C-g>'] = project_actions.search_in_project_files,
        ['<C-a>'] = project_actions.add_project,
      },
      n = {
        ['d'] = project_actions.delete_project,
        ['f'] = project_actions.find_project_files,
        ['g'] = project_actions.search_in_project_files,
      },
    }

    -- Define keymaps
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = '[F]ind [B]uffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
    vim.keymap.set('n', '<leader>fp', '<cmd>Telescope project<cr>', { desc = '[F]ind [P]roject' })
  end,
}
