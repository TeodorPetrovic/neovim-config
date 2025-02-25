local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "masofino.plugins" }, { import = "masofino.plugins.lsp" } }, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})

vim.opt.clipboard:append("unnamedplus")
vim.g.clipboard = {
	name = "xsel",
	copy = {
		["+"] = "xsel --clipboard --input",
		["*"] = "xsel --input",
	},
	paste = {
		["+"] = "xsel --clipboard --output",
		["*"] = "xsel --output",
	},
	cache_enabled = 1,
}
