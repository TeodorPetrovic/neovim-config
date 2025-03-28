return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
			{ "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		config = function()
			-- Try to require config.utils and config.icons; use fallbacks if not available.
			local ok_utils, utils = pcall(require, "config.utils")
			if not ok_utils then
				utils = {}
				-- Fallback for setting key mapping descriptions (no-op)
				utils.desc = function(lhs, desc)
					-- Optionally, you can print a message or simply do nothing.
				end
				-- Fallback for creating autocommands using Neovim API
				utils.au = function(event, opts)
					vim.api.nvim_create_autocmd(event, opts)
				end
			end

			local ok_icons, icons = pcall(require, "config.icons")
			if not ok_icons then
				icons = {
					ui = { User = "U", Bot = "B" },
					diagnostics = { Warn = "W" },
				}
			end

			utils.desc("<leader>a", "AI")

			-- Copilot autosuggestions
			vim.g.copilot_no_tab_map = false
			vim.g.copilot_hide_during_completion = false
			vim.g.copilot_proxy_strict_ssl = false
			vim.g.copilot_integration_id = "vscode-chat"
			vim.g.copilot_settings = { selectedCompletionModel = "gpt-4o-copilot" }
			vim.keymap.set("i", "<S-Tab>", 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

			-- Copilot chat
			local chat = require("CopilotChat")
			local prompts = require("CopilotChat.config.prompts")
			local select = require("CopilotChat.select")
			local cutils = require("CopilotChat.utils")

			local COPILOT_PLAN = [[
You are a software architect and technical planner focused on clear, actionable development plans.
]] .. prompts.COPILOT_BASE.system_prompt .. [[

When creating development plans:
- Start with a high-level overview
- Break down into concrete implementation steps
- Identify potential challenges and their solutions
- Consider architectural impacts
- Note required dependencies or prerequisites
- Estimate complexity and effort levels
- Track confidence percentage (0-100%)
- Format in markdown with clear sections

Always end with:
"Current Confidence Level: X%"
"Would you like to proceed with implementation?" (only if confidence >= 90%)
]]

			chat.setup({
				model = "claude-3.7-sonnet",
				references_display = "write",
				debug = true,
				question_header = " " .. icons.ui.User .. " ",
				answer_header = " " .. icons.ui.Bot .. " ",
				error_header = "> " .. icons.diagnostics.Warn .. " ",
				selection = select.visual,
				context = "buffers",
				mappings = {
					reset = false,
					show_diff = {
						full_diff = true,
					},
				},
				prompts = {
					Explain = {
						mapping = "<leader>ae",
						description = "AI Explain",
					},
					Review = {
						mapping = "<leader>ar",
						description = "AI Review",
					},
					Tests = {
						mapping = "<leader>at",
						description = "AI Tests",
					},
					Fix = {
						mapping = "<leader>af",
						description = "AI Fix",
					},
					Optimize = {
						mapping = "<leader>ao",
						description = "AI Optimize",
					},
					Docs = {
						mapping = "<leader>ad",
						description = "AI Documentation",
					},
					Commit = {
						mapping = "<leader>ac",
						description = "AI Generate Commit",
						selection = select.buffer,
					},
					Plan = {
						prompt = "Create or update the development plan for the selected code. Focus on architecture, implementation steps, and potential challenges.",
						system_prompt = COPILOT_PLAN,
						context = "file:.copilot/plan.md",
						progress = function()
							return false
						end,
						callback = function(response, source)
							chat.chat:append("Plan updated successfully!", source.winnr)
							local plan_file = source.cwd() .. "/.copilot/plan.md"
							local dir = vim.fn.fnamemodify(plan_file, ":h")
							vim.fn.mkdir(dir, "p")
							local file = io.open(plan_file, "w")
							if file then
								file:write(response)
								file:close()
							end
						end,
					},
				},
				contexts = {
					vectorspace = {
						description = "Semantic search through workspace using vector embeddings. Find relevant code with natural language queries.",
						schema = {
							type = "object",
							required = { "query" },
							properties = {
								query = {
									type = "string",
									description = "Natural language query to find relevant code.",
								},
								max = {
									type = "integer",
									description = "Maximum number of results to return.",
									default = 10,
								},
							},
						},
						resolve = function(input, source, prompt)
							local embeddings = cutils.curl_post("http://localhost:8000/query", {
								json_request = true,
								json_response = true,
								body = {
									dir = source.cwd(),
									text = input.query or prompt,
									max = input.max,
								},
							}).body

							cutils.schedule_main()
							return vim.iter(embeddings)
								:map(function(embedding)
									embedding.filetype = cutils.filetype(embedding.filename)
									return embedding
								end)
								:filter(function(embedding)
									return embedding.filetype
								end)
								:totable()
						end,
					},
				},
				providers = {
					github_models = {
						disabled = true,
					},
				},
			})

			utils.au("BufEnter", {
				pattern = "copilot-*",
				callback = function()
					vim.opt_local.relativenumber = false
					vim.opt_local.number = false
				end,
			})

			vim.keymap.set({ "n" }, "<leader>aa", chat.toggle, { desc = "AI Toggle" })
			vim.keymap.set({ "v" }, "<leader>aa", chat.open, { desc = "AI Open" })
			vim.keymap.set({ "n" }, "<leader>ax", chat.reset, { desc = "AI Reset" })
			vim.keymap.set({ "n" }, "<leader>as", chat.stop, { desc = "AI Stop" })
			vim.keymap.set({ "n" }, "<leader>am", chat.select_model, { desc = "AI Models" })
			vim.keymap.set({ "n" }, "<leader>ag", chat.select_agent, { desc = "AI Agents" })
			vim.keymap.set({ "n", "v" }, "<leader>ap", chat.select_prompt, { desc = "AI Prompts" })
			vim.keymap.set({ "n", "v" }, "<leader>aq", function()
				vim.ui.input({
					prompt = "AI Question> ",
				}, function(input)
					if input ~= "" then
						chat.ask(input)
					end
				end)
			end, { desc = "AI Question" })
		end,
	},
}
