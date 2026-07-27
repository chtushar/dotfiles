vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local map = vim.keymap.set

-- fzf-lua
map("n", "<C-p>", "<cmd>FzfLua files<cr>", { desc = "Find files" })
map("n", "<C-q>", "<cmd>FzfLua buffers<cr>", { desc = "Find buffers" })

-- neo-tree
map("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle file tree" })

-- gitsigns
map("n", "<leader>gd", "<cmd>Gitsigns preview_hunk<cr>", { desc = "Preview git hunk diff" })
map("n", "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Full blame for current line" })

-- split resizing
map("n", "<C-,>", "<cmd>vertical resize -1<cr>", { desc = "Decrease split width" })
map("n", "<C-.>", "<cmd>vertical resize +1<cr>", { desc = "Increase split width" })

-- terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
