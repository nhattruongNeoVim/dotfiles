local status, bufferline = pcall(require, "bufferline")
if not status then
    return
end

bufferline.setup({
    options = {
        hover = {
            enabled = true,
            delay = 200,
            reveal = { 'close' }
        },

        -- Cấu hình độ lệch bên trái
        offsets = {
            {
                filetype = "NvimTree",
                text = "nhật trường",
                highlight = "Directory",
                text_align = "center",
            }
        },
        always_show_bufferline = false,

        -- Cấu hình độ lệch bên phải
        tabpage_offset = 2,             -- Độ lệch giữa các tab
        buffer_close_icon = "",        -- Biểu tượng đóng buffer
        modified_icon = "",            -- Biểu tượng cho các buffer đã thay đổi
        close_icon = "",               -- Biểu tượng đóng tab
        left_trunc_marker = "",        -- Biểu tượng hiển thị khi tên buffer quá dài bên trái
        right_trunc_marker = "",       -- Biểu tượng hiển thị khi tên buffer quá dài bên phải
    }
})
