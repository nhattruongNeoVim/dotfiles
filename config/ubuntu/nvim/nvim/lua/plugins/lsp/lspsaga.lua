local saga_status, saga = pcall(require, "lspsaga")
if not saga_status then
    return
end

saga.setup({
    use_saga_diagnostic_sign = false,
    error_sign = false,
    scroll_preview = { scroll_down = "<C-f>", scroll_up = "<C-b>" },
    definition = {
        edit = "<CR>",
    },
    ui = {
        title = true,
        border = "rounded",
        -- border = "single",
        winblend = 0,
        expand = "",
        collapse = "",
        code_action = "💡",
        incoming = " ",
        outgoing = " ",
        hover = ' ',
        kind = {},
    },
    lightbulb = {
        enable = false,
        enable_in_insert = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    symbol_in_winbar = {
        enable = false, -- bật tắt thanh breadcrumb
        separator = " ",
        ignore_patterns = {},
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        respect_root = false,
        color_mode = true,
    },
})
