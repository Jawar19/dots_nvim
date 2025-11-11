return {
	"stevearc/conform.nvim",
	tag = "v9.1.0",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				json = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				bash = { "beautysh" },
				yaml = { "yamlfix" },
				toml = { "taplo" },
				latex = { "tex-fmt" },
				bib = { "bibtex-tidy" },
				cmake = { "cmake_format" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				objc = { "clang-format" },
				objcpp = { "clang-format" },
				cuda = { "clang-format" },
				proto = { "clang-format" },
			},
			formatters = {
				["clang-format"] = {
					command = "/usr/bin/clang-format",
				},
			},
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
		})

		vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
			pattern = { "*.h", "*.hpp", "*.hh", "*.hxx", "*.H" },
			callback = function()
				vim.bo.filetype = "cpp"
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>lf", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
