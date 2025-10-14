return {
	"echasnovski/mini.nvim",
	version = false,
	opts = {
		icons = {},
		surround = {
			mappings = {
				add = "gsa",
				delete = "gsd",
				find = "gsf",
				find_left = "gsF",
				highlight = "gsh",
				replace = "gsr",
			},
		},
	},
	config = function(_, _opts)
		require("mini.icons").setup(_opts.icons)
		require("mini.surround").setup(_opts.surround)
		require("mini.ai").setup()
	end,
}

