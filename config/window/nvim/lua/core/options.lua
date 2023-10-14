local opt = vim.opt

-- số hàng
opt.relativenumber = true -- số hàng lưu động
opt.number = true         -- số hàng

-- tab & thụt lề
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- ngắt dòng văn bản (sẽ không tự động xuống dòng khi ghi hết hàng)
opt.wrap = false

-- cài đặt tìm kiếm
opt.ignorecase = true
opt.smartcase = true

-- cursor line (đánh dấu dòng kẻ tại vị trí con trỏ)
opt.cursorline = true

-- giao diện
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"

-- bảng nhớ tạm (cho phép sử dụng bảng nhớ tạm của window)
opt.clipboard:append("unnamedplus")

-- chia cửa sổ
opt.splitright = true
opt.splitbelow = true

-- xóa dấu ~ ở những hàng trống
opt.fillchars = { eob = " " }

-- font với neovim-qt
opt.guifont = "MesloLGS NF:h10"


opt.iskeyword:append("-")

opt.cmdheight = 1
opt.showtabline = 2
opt.showmode = false

opt.sidescrolloff = 8

-- Tự động cập nhật nội dung file khi bị thay đổi từ bên ngoài
vim.cmd[[au FocusGained,BufEnter,BufRead * checktime]]
