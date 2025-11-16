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
				"markdownlint-cli2",
				"markdown-toc",

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
				filetypes = { "tex", "plaintex", "bib" },
				root_markers = { ".git" },
				capabilities = capabilities,
				settings = {
					ltex = {
						language = "en-US",
					},
				},
			}

			vim.lsp.config.cspell_ls = {
				cmd = { "cspell-lsp", "--stdio" },
				filetypes = {
					"lua",
					"python",
					"javascript",
					"typescript",
					"html",
					"css",
					"json",
					"yaml",
					"markdown",
					"gitcommit",
				},
				root_markers = { ".git" },
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

			-- Markdown
			vim.lsp.config.marksman = {}

			-- bashls (Bash)
			vim.lsp.config.bashls = {
				cmd = { "bash-language-server", "start" },
				filetypes = { "sh", "bash" },
				root_markers = { ".git" },
				capabilities = capabilities,
			}
			-- ✅ CRITICAL: Enable all LSP servers
			vim.lsp.enable({
				"clangd",
				"texlab",
				-- "ltex",
				"lua_ls",
				"pyright",
				"bashls",
				"marksman",
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local bufnr = args.buf
					-- If you prefer to keep LSP mappings out of tex buffers, skip here:
					local ft = vim.bo[bufnr].filetype
					if ft == "tex" then
						return
					end

					local opts = { buffer = bufnr }

					-- clangd-specific mapping (keep if clangd)
					if client and client.name == "clangd" then
						vim.keymap.set(
							"n",
							"<leader>cR",
							"<cmd>ClangdSwitchSourceHeader<cr>",
							vim.tbl_extend("force", opts, { desc = "Switch Source/Header (C/C++)" })
						)
					end

					-- General LSP navigation & actions (buffer-local)
					vim.keymap.set(
						"n",
						"gd",
						vim.lsp.buf.definition,
						vim.tbl_extend("force", opts, { desc = "Goto Definition" })
					)
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "Goto Declaration" })
					)
					vim.keymap.set(
						"n",
						"gr",
						vim.lsp.buf.references,
						vim.tbl_extend("force", opts, { desc = "References", nowait = true })
					)
					vim.keymap.set(
						"n",
						"gI",
						vim.lsp.buf.implementation,
						vim.tbl_extend("force", opts, { desc = "Goto Implementation" })
					)
					vim.keymap.set(
						"n",
						"gy",
						vim.lsp.buf.type_definition,
						vim.tbl_extend("force", opts, { desc = "Goto Type Definition" })
					)

					-- LSP pickers (if you want to keep these tied to LSP attach)
					local picker = require("snacks").picker
					vim.keymap.set(
						"n",
						"<leader>ls",
						picker.lsp_definitions,
						vim.tbl_extend("force", opts, { desc = "Buffer Symbols" })
					)
					vim.keymap.set(
						"n",
						"<leader>lS",
						picker.lsp_workspace_symbols,
						vim.tbl_extend("force", opts, { desc = "Workspace Symbols" })
					)
				end,
			})
		end,
	},
}
