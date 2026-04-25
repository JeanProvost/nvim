-- lua/plugins/lsp.lua

return {
  -- ## Mason: for installing LSPs ##
  {
    'williamboman/mason.nvim',
    opts = {},
  },

  -- ## Mason-LSPConfig: bridge between Mason and lspconfig ##
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    -- lazy.nvim will automatically call `.setup(opts)` with the table below
    opts = {
      -- A list of servers to automatically install
      ensure_installed = { "lua_ls", "gopls", "csharp_ls", "pyright", "sqlls", "marksman" },
      -- The setup for each server
      handlers = {
        -- This is the default handler. It is called for every server that is not explicitly handled below.
        function(server_name)
          require('lspconfig')[server_name].setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
          })
        end,
        -- The next handler is for a server that needs custom settings.
        ["lua_ls"] = function()
          require('lspconfig').lua_ls.setup({
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
      }
    }
  },

  -- ## nvim-navic: For breadcrumbs ##
  {
    'SmiteshP/nvim-navic',
    opts = { lsp = { auto_attach = true } },
  },

  -- ## LSPConfig: This now ONLY handles keymaps and autocommands ##
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'SmiteshP/nvim-navic',
    },
    config = function()
      local navic = require('nvim-navic')
      -- The setup loops have been moved to mason-lspconfig.
      -- This section now only contains your personal settings, like keymaps.
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.documentSymbolProvider then
            navic.attach(client, ev.buf)
          end

          -- Keymaps for LSP
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'LSP: Hover' })
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'LSP: Go to Definition' })
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'LSP: Go to References' })
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'LSP: Go to Implementation' })
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'LSP: Code Action' })
          vim.keymap.set('n', '<leader>cr', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'LSP: Rename' })
          vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float,
            { buffer = ev.buf, desc = 'LSP: Show Diagnostics' })
        end,
      })
    end,
  },

  -- ## LuaSnip ##
  {
    'L3MON4D3/LuaSnip',
    build = 'make install_jsregexp',
  },

  -- ## Autocompletion Engine (nvim-cmp) ##
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
      'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        sources = {
          { name = 'nvim_lsp' }, { name = 'luasnip' },
          { name = 'buffer' }, { name = 'path' },
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
      })
    end,
  },
}
