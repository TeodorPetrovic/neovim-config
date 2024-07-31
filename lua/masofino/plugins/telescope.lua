return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{
			"nvim-telescope/telescope-fzf-native.nvim",
			build = function()
				-- Detect operating system
				local os = vim.loop.os_uname().sysname

				-- Function to execute commands
				local function execute_cmd(cmd)
					local result = vim.fn.system(cmd)
					if vim.v.shell_error ~= 0 then
						error("Command failed: " .. cmd .. "\nError: " .. result)
					end
				end

				-- Windows specific setup
				if os == "Windows_NT" then
					local cmake_cmd = 'cmake -S . -B build -DCMAKE_BUILD_TYPE=Release -G "Visual Studio 16 2019" -A x64'
					local build_cmd = "cmake --build build --config Release"
					local install_cmd = "cmake --install build --prefix build"

					execute_cmd(cmake_cmd)
					execute_cmd(build_cmd)
					execute_cmd(install_cmd)
				else
					-- Linux or macOS specific setup
					execute_cmd("cmake -S . -B build -DCMAKE_BUILD_TYPE=Release")
					execute_cmd("cmake --build build --config Release")
					execute_cmd("cmake --install build --prefix build")
				end
			end,
		},
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
						["<C-t>"] = trouble_telescope.open,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
	end,
}
