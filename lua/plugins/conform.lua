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
				markdown = { "prettier", "markdownlint-cli2", "markdown-toc" },
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
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			format_on_save = {
				timeout_ms = 3000,
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
