-- lua/core/options.lua

-- Set highlight on search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.conceallevel = 1 -- For obsidian clearer UI

-- Make line numbers default
-- vim.opt.number = true
-- vim.opt.relativenumber = true

-- Enable mouse mode
vim.opt.mouse = 'a'

-- Other core settings
vim.opt.clipboard = 'unnamedplus'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.signcolumn = 'yes'
vim.opt.termguicolors = true
vim.opt.completeopt = 'menuone,noselect'
vim.opt.cursorline = true

-- ===================================================================
-- THE FIX: Set splitting behavior
-- ===================================================================
vim.opt.splitright = true -- Force new vertical splits to the right
vim.opt.splitbelow = true -- Force new horizontal splits to the bottom
-- ===================================================================
