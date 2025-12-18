return {
	"rest-nvim/rest.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			opts.ensure_installed = opts.ensure_installed or {}
			table.insert(opts.ensure_installed, "http")
		end,
	},
	config = function()
		-- Set formatprg for JSON using jq
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "json",
			callback = function()
				vim.opt_local.formatprg = "jq"
			end,
		})

		-- Set formatprg for HTML using tidy
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "html",
			callback = function()
				vim.opt_local.formatprg = "tidy -i -q"
			end,
		})

		vim.g.rest_nvim = {
			result = {
				formatters = {
					json = "jq",
					html = "tidy",
				},
			},
		}
	end,
}
