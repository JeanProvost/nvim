return {
	'nvim-treesitter/nvim-treesitter',
	build = ':TSUpdate',
	config = function()
		require('nvim-treesitter.configs').setup({
			-- A list of parser names, or all

			ensure_installed = {
				'c',
				'lua',
				'vim',
				'vimdoc',
				'c_sharp',
				'python',
				'go',
				'sql',
				'json',
				'yaml',
				'javascript',
				'typescript',
				'html',
        'markdown',
        'markdown_inline'
			},

			-- Install parsers synchronously (blocks UI on first install)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			auto_install = true,

			-- Enable syntax highlighting
			highlight = {
				enable = true,
			},

			-- Enable indentation based on nvim-treesitter
			indent = {
				enable = true,
			},
		})
	end,
}
