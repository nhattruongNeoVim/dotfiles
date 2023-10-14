vim.g.mapleader = " "           -- set leader

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

--------------------------------------------- phím tắt tổng quan------------------------------------------------

-- thoát nhanh khỏi chế độ insert bằng hj, ngoài ra cũng có thể thoát nhanh bằng Alt + h,j,k,l
keymap.set("i", "hj", "<ESC>")

-- buffer
keymap.set("n", "<C-s>", ":w<CR>",              {silent = true})    -- lưu buffer trong normal mode
keymap.set("i", "<C-s>", "<ESC>:w<CR>a",        {silent = true})    -- lưu buffer trong insert mode

-- tăng giảm số hạng 
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x")

-- tab 
keymap.set("n", "<leader>to", ":tabnew<CR>",    {silent = true})    -- mở tab mới
keymap.set("n", "<leader>tx", ":tabclose<CR>",  {silent = true})    -- đóng tab hiện tại

-- thao tác với hàng như Visual Studio Code
keymap.set("n", "<S-j>", ":t +0<CR>",           {silent = true})    -- Shift + j để coppy hàng và tạo hàng bên dưới
keymap.set("n", "<M-j>", ":m+<CR>",             {silent = true})    -- Alt + j để di chuyển hàng xuống
keymap.set("n", "<M-k>", ":m -2<CR>",           {silent = true})    -- Alt + k để di chuyển hàng lên

-- giữ ctrl + h,j,k,l để di chuyển trong insert mode
keymap.set("i", "<C-h>", "<left>",              {silent = true})
keymap.set("i", "<C-j>", "<down>",              {silent = true})
keymap.set("i", "<C-k>", "<up>",                {silent = true})
keymap.set("i", "<C-l>", "<right>",             {silent = true})

-- ngắt dòng văn bản trong neovim
keymap.set("n", "<M-z>", ":set wrap<CR>",       {silent = true})
keymap.set("n", "<M-x>", ":set nowrap<CR>",     {silent = true})

-- format code Ctrl + f
keymap.set("n", "<C-f>", ":lua vim.lsp.buf.format{async=true}<CR>",             {silent = true})

-- open terminal
keymap.set("n", "<M-i>", ":ToggleTerm direction=float<CR>",                     {silent = true})
keymap.set("n", "<M-v>", ":ToggleTerm direction=vertical<CR>",          {silent = true})
keymap.set("n", "<M-h>", ":ToggleTerm direction=horizontal<CR>",        {silent = true})

---------------------------------------------- keymap cho plugin ------------------------------------------------

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>",               {silent = true})

-- nvim-tree
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>",                 {silent = true})

-- bufferline
keymap.set("n", "<tab>", ":BufferLineCycleNext<CR>",                {silent = true})
keymap.set("n", "<S-tab>", ":BufferLineCyclePrev<CR>",              {silent = true})

-- bật live-server
keymap.set("n", "<C-k>l", ":LiveServer start<CR>",                  {silent = true})

-- smart-split
keymap.set("n", "<M-a>", ":SmartResizeLeft<CR>",                    {silent = true})
keymap.set("n", "<M-s>", ":SmartResizeDown<CR>",                    {silent = true})
keymap.set("n", "<M-w>", ":SmartResizeUp<CR>",                      {silent = true})
keymap.set("n", "<M-d>", ":SmartResizeRight<CR>",                   {silent = true})

-- keymap.set("n", "<C-A-h>", ":SmartResizeLeft<CR>",                 {noremap = false, silent = true})
-- keymap.set("n", "<C-M-j>", ":SmartResizeDown<CR>",                 {silent = true})
-- keymap.set("n", "<C-M-k>", ":SmartResizeUp<CR>",                     {silent = true})
-- keymap.set("n", "<C-M-l>", ":SmartResizeRight<CR>",               {silent = true})
