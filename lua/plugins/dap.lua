-- lua/plugins/dap.lua

return {
  -- Main DAP plugin
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg", -- Corrected spelling
    request = "launch",
    program = function()
      return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
    end,
  },
  {
    type = "coreclr",
    name = "attach - container",
    request = "attach",
    processId = 1,
    justMyCode = false, -- Corrected from 'justCode'
    connect = {
      hostName = "127.0.0.1",
      port = 4711,
    },
    sourceFileMap = {
      ["/workspaces"] = "${workspaceFolder}",
      ["/source"] = "${workspaceFolder}",
    },
  },
}

      -- Debugger cleanup
      -- local function cleanup_delve_binary()
        -- local binary_name = "__debug_bin.exe"
        -- local cwd = vim.fn.getcwd()
        -- local binary_path = cwd .. "/" .. binary_name

        -- if vim.fn.filereadable(binary_path) == 1 then
          -- vim.fn.delete(binary_path)
          -- vim.notify("Cleaned up Delve debug binary.", vim.log.levels.INFO)
        -- end 
      -- end

      -- dap.listeners.after.event_terminated["cleanup"] = cleanup_delve_binary
      -- dap.listeners.after.event_exited["cleanup"] = cleanup_delve_binary

      -- Keymap for toggling the UI
      vim.keymap.set("n", "<leader>uu", function() require("dapui").toggle() end, { desc = "Debug: Toggle UI" })
    end,
  },

  -- DAP UI
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup() -- Setup the UI itself

      -- Automatically open/close the UI when a debug session starts/stops
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- Mason Bridge for DAP
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    config = function()
      require("mason-nvim-dap").setup({
        ensure_installed = { "coreclr", "python", "go" },
        handlers = {}, -- Let the plugin handle the setup
      })
    end,
  },

  -- Go Debugger Support
  {
    "leoluz/nvim-dap-go",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-go").setup()
    end,
  },

  -- DAP Keymaps (Centralized for clarity)
  {
    "mfussenegger/nvim-dap", -- We add a separate entry to define keymaps
    keys = {
      { "<space>b", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<space>?", function() require("dapui").eval(nil, { enter = true }) end, desc = "Evaluate Expression" },
      { "<F1>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F2>", function() require("dap").step_over() end, desc = "Debug: Step Over (j)" },
      { "<F3>", function() require("dap").step_into() end, desc = "Debug: Step Into (k)" },
      { "<F4>", function() require("dap").step_out() end, desc = "Debug: Step Out (K)" },
      { "<F5>", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
      { "<F6>", function() require("dap").run_last() end, desc = "Debug: Run Last" },
      { "<F9>", function() require("dap").terminate() end, desc = "Debug: Quit/Terminate" },
    }
  },

  -- Optional: Virtual Text
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
}
