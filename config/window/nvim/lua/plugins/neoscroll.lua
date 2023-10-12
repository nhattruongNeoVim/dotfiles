local status, scroll = pcall(require, "neoscroll")
if not status then
    return
end

scroll.setup({
    mappings = {
        '<C-u>',                -- cuộn lên
        '<C-d>',                -- cuộn xuống
        '<C-y>',                -- kéo màn hình xuống
        '<C-e>',                -- kéo màn hình lên
        'zt',                   -- đưa con trỏ lên trên cùng màn hình
        'zb',                   -- đưa con trỏ xuốn dưới cùng màn hình
        'zz',                   -- đưa con trỏ về giữa màn hình
    },
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    pre_hook = nil,              -- Function to run before the scrolling animation starts
    post_hook = nil,             -- Function to run after the scrolling animation ends
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
})

