return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		preset = "helix",
		spec = {
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>q", group = "quit/close" },
			{ "<leader>s", group = "search" },
			{ "<leader>u", group = "ui" },
			{ "<leader>a", group = "+File switch" },
			{ "<leader>b", group = "+buffer" },
			{ "<leader>i", group = "+lsp" },
			{ "<leader>x", group = "Todo" },
			{ "<localleader>l", group = "Vimtex" },
			{ "<leader>l", group = "LSP" },
			{ "<leader>w", group = "Wiki" },
		},
	},
	keys = {
		{
			"<leader>?",
			function()
				require("which-key").show({ global = false })
			end,
			desc = "Buffer Local Keymaps (which-key)",
		},
	},
}
