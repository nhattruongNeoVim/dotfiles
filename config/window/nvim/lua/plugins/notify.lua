local status, notify = pcall(require, "notify")
if not status then
    return
end

notify.setup({
    background_colour = "NotifyBackground",
    fps = 90, -- số khung hình mỗi giây khi hiển thị thông báo, càng cao càng mượt, cần thận mượt quá đi luôn á
    icons = {
        DEBUG = "",
        ERROR = "",
        INFO = "",
        TRACE = "✎",
        WARN = ""
    },
    level = 2,
    -- level
    -- 0: Tắt thông báo hoàn toàn. Không có thông báo nào sẽ hiển thị.
    -- 1: Hiển thị thông báo lỗi (ERROR) và cảnh báo (WARN) chỉ.
    -- 2: Hiển thị thông báo lỗi (ERROR), cảnh báo (WARN) và thông tin (INFO).
    -- 3: Hiển thị tất cả các mức độ thông báo, bao gồm cả DEBUG và TRACE (có nghĩa là tất cả các thông báo).
    minimum_width = 50,           -- độ rộng tối thiểu của notify
    render = "default",           -- gồm: "default", "minimal", "simple", "compact"
    stages = "fade_in_slide_out", -- gồm: "fade_in_slide_out", "fade", "slide", "static"
    timeout = 1000,               -- thời gian notify kết thúc, mặc định 5000(5s)
    top_down = true               -- vị trí notify, trên hoạc dưới
})

-- Cấu hình màu sắc tùy chỉnh theo sở thích

-- vim.cmd("highlight NotifyERRORBorder guifg=#8A1F1F")
-- vim.cmd("highlight NotifyWARNBorder guifg=#79491D")
-- vim.cmd("highlight NotifyINFOBorder guifg=#2cccff")
-- vim.cmd("highlight NotifyDEBUGBorder guifg=#8B8B8B")
-- vim.cmd("highlight NotifyTRACEBorder guifg=#4F3552")
-- vim.cmd("highlight NotifyERRORIcon guifg=#F70067")
-- vim.cmd("highlight NotifyWARNIcon guifg=#F79000")
-- vim.cmd("highlight NotifyINFOIcon guifg=#2cccff")
-- vim.cmd("highlight NotifyDEBUGIcon guifg=#8B8B8B")
-- vim.cmd("highlight NotifyTRACEIcon guifg=#D484FF")
-- vim.cmd("highlight NotifyERRORTitle guifg=#F70067")
-- vim.cmd("highlight NotifyWARNTitle guifg=#F79000")
-- vim.cmd("highlight NotifyINFOTitle guifg=#2cccff")
-- vim.cmd("highlight NotifyDEBUGTitle guifg=#8B8B8B")
-- vim.cmd("highlight NotifyTRACETitle guifg=#D484FF")
-- vim.cmd("highlight link NotifyERRORBody Normal")
-- vim.cmd("highlight link NotifyWARNBody Normal")
-- vim.cmd("highlight link NotifyINFOBody Normal")
-- vim.cmd("highlight link NotifyDEBUGBody Normal")
-- vim.cmd("highlight link NotifyTRACEBody Normal")
