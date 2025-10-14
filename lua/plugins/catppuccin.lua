return {
	"catppuccin/nvim",
	name = "catppuccin",
	opts = {
		auto_integrations = true,
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd.colorscheme("catppuccin")
	end,
}

