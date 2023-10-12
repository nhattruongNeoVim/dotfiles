---@diagnostic disable: param-type-mismatch
local status, _ = pcall(vim.cmd, "colorscheme tokyonight-night")
if not status then
    print("Không tìm thấy bảng màu")
    return
end
