return {
	-- Mason core
	{
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
	},

	-- Mason tool installer (uses Mason package names)
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- LSP Servers
				"texlab",
				"ltex-ls",
				"clangd",
				"lua-language-server",
				"pyright",
				"bash-language-server",
				"marksman",

				-- Linters
				"shellcheck",
				"ruff",
				"markdownlint",

				-- Formatters
				"bibtex-tidy",
				"latexindent",
				"tex-fmt",
				"stylua",
				"black",
				"isort",
				"prettier",
				"shfmt",

				-- Debuggers
				"cpptools",
			},
			auto_update = true,
			run_on_start = true,
		},
	},

	-- LSP configurations (Neovim 0.11+ native API)
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"mason-org/mason.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			-- Get capabilities from blink.cmp
			local capabilities = require("blink.cmp").get_lsp_capabilities()

			-- Set default root markers for all LSP servers
			vim.lsp.config("*", {
				root_markers = { ".git" },
			})

			-- clangd (C/C++)
			vim.lsp.config.clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--header-insertion=iwyu",
					"--completion-style=detailed",
					"--function-arg-placeholders",
					"--fallback-style=llvm",
				},
				filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
				root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git" },
				capabilities = vim.tbl_deep_extend("force", capabilities, {
					offsetEncoding = { "utf-16" },
				}),
			}

			-- texlab (LaTeX)
			vim.lsp.config.texlab = {
				cmd = { "texlab" },
				filetypes = { "tex", "plaintex", "bib" },
				root_markers = { ".latexmkrc", ".git" },
				capabilities = capabilities,
				settings = {
					texlab = {
						build = {
							executable = "latexmk",
							args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
							onSave = true,
						},
						chktex = {
							onEdit = true,
							onOpenAndSave = true,
						},
						diagnosticsDelay = 300,
					},
				},
			}

			-- ltex (grammar/spell check)
			vim.lsp.config.ltex = {
				cmd = { "ltex-ls" },
				filetypes = { "tex", "plaintex", "bib", "markdown" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					ltex = {
						language = "en-US",
					},
				},
			}

			-- lua_ls (Lua)
			vim.lsp.config.lua_ls = {
				cmd = { "lua-language-server" },
				filetypes = { "lua" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = vim.api.nvim_get_runtime_file("", true),
							checkThirdParty = false,
						},
						telemetry = {
							enable = false,
						},
					},
				},
			}

			-- pyright (Python)
			vim.lsp.config.pyright = {
				cmd = { "pyright-langserver", "--stdio" },
				filetypes = { "python" },
				root_markers = { "pyproject.toml", "setup.py", ".git" },
				capabilities = capabilities,
			}

			-- bashls (Bash)
			vim.lsp.config.bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}

			-- marksman (Markdown)
			vim.lsp.config.marksman = {
				cmd = { "marksman", "server" },
				filetypes = { "markdown", "markdown.mdx" },
				root_markers = { ".git", ".marksman.toml" },
				capabilities = capabilities,
			}

			-- ✅ CRITICAL: Enable all LSP servers
			vim.lsp.enable({ "clangd", "texlab", "ltex", "lua_ls", "pyright", "bashls", "marksman" })

			-- Keymaps for clangd source/header switching
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "clangd" then
						vim.keymap.set("n", "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", {
							buffer = args.buf,
							desc = "Switch Source/Header (C/C++)",
						})
					end
				end,
			})
		end,
	},
}
