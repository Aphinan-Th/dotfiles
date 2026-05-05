return {
	-- tools
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
				"prettier",
				"pyright",
				"ruff", -- native ruff (no ruff-lsp)
			})
		end,
	},

	-- lsp servers
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = false },
			---@type lspconfig.options
			servers = {
				cssls = {},
				tailwindcss = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
				},
				tsserver = {
					root_dir = function(...)
						return require("lspconfig.util").root_pattern(".git")(...)
					end,
					single_file_support = false,
					settings = {
						typescript = {
							inlayHints = {
								includeInlayParameterNameHints = "literal",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = false,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
						javascript = {
							inlayHints = {
								includeInlayParameterNameHints = "all",
								includeInlayParameterNameHintsWhenArgumentMatchesName = false,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayVariableTypeHints = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayEnumMemberValueHints = true,
							},
						},
					},
				},
				html = {},
				yamlls = {
					settings = {
						yaml = {
							keyOrdering = false,
						},
					},
				},
				lua_ls = {
					-- enabled = false,
					single_file_support = true,
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							completion = {
								workspaceWord = true,
								callSnippet = "Both",
							},
							misc = {
								parameters = {
									-- "--log-level=trace",
								},
							},
							hint = {
								enable = true,
								setType = false,
								paramType = true,
								paramName = "Disable",
								semicolon = "Disable",
								arrayIndex = "Disable",
							},
							doc = {
								privateName = { "^_" },
							},
							type = {
								castNumberToInteger = true,
							},
							diagnostics = {
								disable = { "incomplete-signature-doc", "trailing-space" },
								-- enable = false,
								groupSeverity = {
									strong = "Warning",
									strict = "Warning",
								},
								groupFileStatus = {
									["ambiguity"] = "Opened",
									["await"] = "Opened",
									["codestyle"] = "None",
									["duplicate"] = "Opened",
									["global"] = "Opened",
									["luadoc"] = "Opened",
									["redefined"] = "Opened",
									["strict"] = "Opened",
									["strong"] = "Opened",
									["type-check"] = "Opened",
									["unbalanced"] = "Opened",
									["unused"] = "Opened",
								},
								unusedLocalExclude = { "_*" },
							},
							format = {
								enable = false,
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
									continuation_indent_size = "2",
								},
							},
						},
					},
				},
				-- Pyright for type checking
				pyright = {
					settings = {
						python = {
							analysis = { typeCheckingMode = "basic" },
						},
					},
				},

				-- Ruff native server
				ruff = {
					cmd = { "ruff", "server" },
					init_options = {
						settings = { args = { "--line-length", "120" } },
					},
					on_attach = function(client, bufnr)
						if vim.bo[bufnr].filetype == "python" then
							-- Auto format, fix, and organize imports on save
							vim.api.nvim_create_autocmd("BufWritePre", {
								buffer = bufnr,
								callback = function()
									-- Black-compatible format
									vim.lsp.buf.format({ async = false })
									-- Fix all auto-fixable issues + organize imports
									vim.lsp.buf.code_action({
										context = {
											only = { "source.fixAll", "source.organizeImports" },
											diagnostics = {},
										},
										apply = true,
									})
								end,
							})
						end
					end,
				},
			},
			setup = {},
		},
	},
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			vim.list_extend(keys, {
				{
					"gd",
					function()
						-- DO NOT RESUSE WINDOW
						require("telescope.builtin").lsp_definitions({ reuse_win = false })
					end,
					desc = "Goto Definition",
					has = "definition",
				},
			})
		end,
	},
	-- Formatter: Conform uses Ruff
	{
		"stevearc/conform.nvim",
		opts = {
			formatters_by_ft = {
				-- Prettier
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				vue = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				less = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				jsonc = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },

				-- Other formatters
				lua = { "stylua" },
				sh = { "shfmt" },

				-- For python, run ruff to fix issues, then format.
				python = { "ruff_fix", "ruff_format" },
			},
		},
	},
}
