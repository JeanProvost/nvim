
return {
  {
    "folke/sidekick.nvim",
    opts = {
      -- add any options here
      cli = {
        mux = {
          enabled = false,
        },
        layout = {
          width = 0.2,
        },
      },
    },
    keys = {
      {
        "<tab>",
        function()
          -- if there is a next edit, jump to it, otherwise apply it if any
          if not require("sidekick").nes_jump_or_apply() then
            return "<Tab>" -- fallback to normal tab
          end
        end,
        expr = true,
        desc = "Goto/Apply Next Edit Suggestion",
      },
      {
        "<c-.>",
        function()
          require("sidekick.cli").focus()
        end,
        desc = "Sidekick Switch Focus",
        mode = { "n", "v" },
      },
      {
        "<leader>aa",
        function()
          require("sidekick.cli").toggle({ focus = true })
        end,
        desc = "Sidekick Toggle CLI",
        mode = { "n", "v" },
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Claude Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>ag",
        function()
          require("sidekick.cli").toggle({ name = "grok", focus = true })
        end,
        desc = "Sidekick Grok Toggle",
        mode = { "n", "v" },
      },
      {
        "<leader>ap",
        function()
          require("sidekick.cli").select_prompt()
        end,
        desc = "Sidekick Ask Prompt",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local sidekick = require("sidekick")
      local cli = require("sidekick.cli")

      sidekick.setup(opts)

      local last_win = nil
      local function toggle_sidekick_focus()
        local win = vim.api.nvim_get_current_win()
        local bufname = vim.api.nvim_buf_get_name(0)

        if bufname:match("sidekick://") then
          -- Currently in sidekick input -> go back to last normal window
          if last_win and vim.api.nvim_win_is_valid(last_win) then
            vim.api.nvim_set_current_win(last_win)
          else
            vim.cmd("wincmd p")
          end
        else
          -- Currently in editor -> focus sidekick CLI
          last_win = win
          cli.focus()
        end
      end

      -- Bind toggle globally
      vim.keymap.set({ "n", "i", "t", "x" }, "<C-.>", toggle_sidekick_focus, {
        noremap = true,
        silent = true,
        desc = "Toggle focus between Sidekick and editor",
      })

      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*sidekick*",
        callback = function()
          local map_opts = { noremap = true, silent = true, buffer = true }
          vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w>h]], map_opts)
          vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w>j]], map_opts)
          vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w>k]], map_opts)
          vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w>l]], map_opts)
        end,
      })

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "sidekick://*",
        callback = function(args)
          local buf = args.buf
          local map_opts = { noremap = true, silent = true, buffer = buf }

          vim.keymap.set("i", "<C-h>", function()
            vim.cmd("stopinsert | wincmd h")
          end, map_opts)
          vim.keymap.set("i", "<C-j>", function()
            vim.cmd("stopinsert | wincmd j")
          end, map_opts)
          vim.keymap.set("i", "<C-k>", function()
            vim.cmd("stopinsert | wincmd k")
          end, map_opts)
          vim.keymap.set("i", "<C-l>", function()
            vim.cmd("stopinsert | wincmd l")
          end, map_opts)
        end,
      })
    end,
  },
}
