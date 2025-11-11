return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			animate = { enabled = false },
			bigfile = { enabled = true },
			bufdelete = { enabled = true },
			dashboard = {
				preset = {
					pick = nil,
					---@type snacks.dashboard.Item[]
					keys = {
						{
							icon = " ",
							key = "f",
							desc = "Find File",
							action = ":lua Snacks.dashboard.pick('files')",
						},
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{
							icon = " ",
							key = "g",
							desc = "Find Text",
							action = ":lua Snacks.dashboard.pick('live_grep')",
						},
						{
							icon = " ",
							key = "r",
							desc = "Recent Files",
							action = ":lua Snacks.dashboard.pick('oldfiles')",
						},
						{
							icon = " ",
							key = "c",
							desc = "Config",
							action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
						},
						{ icon = " ", key = "s", desc = "Restore Session", section = "session" },
						{
							icon = "󰒲 ",
							key = "l",
							desc = "Lazy",
							action = ":Lazy",
							enabled = package.loaded.lazy ~= nil,
						},
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
					header = [[
                                                        
                 ████ ██████           █████      ██
                ███████████             █████ 
                █████████ ███████████████████ ███   ███████████
               █████████  ███    █████████████ █████ ██████████████
              █████████ ██████████ █████████ █████ █████ ████ █████
            ███████████ ███    ███ █████████ █████ █████ ████ █████
          ██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
				},
				sections = {
					{ section = "header" },
					{
						section = "keys",
						indent = 1,
						padding = 1,
					},
					{ section = "recent_files", icon = " ", title = "Recent Files", indent = 3, padding = 2 },
					{ section = "startup" },
				},
			},
			debug = {
				enabled = false,
				wrap = true,
			},
			dim = { enabled = false },
			explorer = { enabled = true },
			git = {
				enabled = false,
				width = 0.6,
				height = 0.6,
				border = "rounded",
				title = " Git Blame ",
				title_pos = "center",
				ft = "git",
			},
			gitbrowse = { enabled = false },
			image = { enabled = true },
			indent = { enabled = true },
			input = { enabled = true },
			lazygit = { enabled = true },
			notifier = {
				timeout = 3000,
				style = "compact",
			},
			statuscolumn = { enabled = true },
			terminal = { enabled = true },
			toggle = { enabled = true },
			picker = {
				enabled = true,
				sources = {
					-- Only diagnostics picker has wrapping enabled
					diagnostics = {
						win = {
							list = {
								wo = {
									wrap = true,
									linebreak = true,
								},
							},
						},
					},
					diagnostics_buffer = {
						win = {
							list = {
								wo = {
									wrap = true,
									linebreak = true,
								},
							},
						},
					},
				},
			},
			words = { enabled = true },
			zen = { enabled = true },
		},
		init = function()
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "snacks_diagnostics",
				callback = function()
					vim.wo.wrap = true
					vim.wo.linebreak = true
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Setup some globals for debugging (lazy-loaded)
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd -- Override print to use snacks for `:=` command
					-- Create some toggle mappings
					Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
					Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
					Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
					Snacks.toggle.diagnostics():map("<leader>ud")
					Snacks.toggle.line_number():map("<leader>ul")
					Snacks.toggle
						.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
						:map("<leader>uc")
					Snacks.toggle.treesitter():map("<leader>uT")
					Snacks.toggle
						.option("background", { off = "light", on = "dark", name = "Dark Background" })
						:map("<leader>ub")
					Snacks.toggle.inlay_hints():map("<leader>uh")
					Snacks.toggle.indent():map("<leader>ug")
					Snacks.toggle.dim():map("<leader>uD")
				end,
			})
		end,
	},
}
