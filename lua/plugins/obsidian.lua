-- lua/plugins/obsidian.lua
return {
  "epwalsh/obsidian.nvim",
  version = "*",  -- recommended, use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the workspace path with the actual path to your notes directory
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    workspaces = {
      {
        name = "aws_study",
        path = "~/Documents/aws_study", -- YOU MUST CREATE THIS DIRECTORY
      },
    },
    
    -- Optional: Configure note frontmatter
    note_frontmatter_func = function(note)
      -- This ensures notes have a standard metadata block
      local out = { id = note.id, aliases = note.aliases, tags = note.tags }
      if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
        for k, v in pairs(note.metadata) do
          out[k] = v
        end
      end
      return out
    end,

    -- Use Telescope for finding notes
    finder = "telescope.nvim",
    
    -- Optional: UI configurations for checkboxes
    ui = {
      enable = true, 
      update_debounce = 200, 
    },
  },
  keys = {
    { "<leader>on", "<cmd>ObsidianNew<CR>", desc = "New Obsidian Note" },
    { "<leader>os", "<cmd>ObsidianSearch<CR>", desc = "Search Obsidian Notes" },
    { "<leader>oq", "<cmd>ObsidianQuickSwitch<CR>", desc = "Quick Switch Obsidian Note" },
  }
}
