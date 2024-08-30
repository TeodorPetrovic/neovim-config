vim.g.mapleader = " "

local keymap = vim.keymap -- for concise

--Clearing word highlight after search
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" }) -- TODO//Does not work

-- Managing windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Managing Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- Terminal
keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>A", { desc = "Run terminal in new tab" }) --  move current buffer to new tab
keymap.set("n", "<leader>tv", ":vsplit | terminal<CR>A", { desc = "Run terminal in vertical split" }) --  move current buffer to new tab
keymap.set("n", "<leader>ts", ":split | terminal<CR>A", { desc = "Run terminal in horizontal split" }) --  move current buffer to new tab
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Escape terminal mode" })

-- Rest
keymap.set("n", "<leader>rr", "<cmd>lua require('rest-nvim').run()<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>rp", "<cmd>lua require('rest-nvim').run(true)<CR>", { noremap = true, silent = true })
keymap.set("n", "<leader>rl", "<cmd>lua require('rest-nvim').last()<CR>", { noremap = true, silent = true })

-- Moving text
keymap.set("v", "J", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
keymap.set("v", "K", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
