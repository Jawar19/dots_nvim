return {
	{
		"mason-org/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ensure_installed = {
						"bibtex-tidy",
						"texlab",
						"tex-fmt",
						"ltex",
						"clangd",
						"cpptools",
						"clangd-format",
					},
				},
			},
			{ "neovim/nvim-lspconfig", dependencies = { "saghen/blink.cmp" } },
		},
	},
}

