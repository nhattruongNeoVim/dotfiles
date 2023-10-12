local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
    return
end

vim.g.loaded_netrw = 1
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

nvimtree.setup({
    update_focused_file = {
        enable = true,
        update_cwd = true,
        update_root = false,
    },
    view = {
        width = 25,
        preserve_window_proportions = true,
        signcolumn = "no",
        float = {
            enable = false,
            quit_on_focus_loss = true,
            open_win_config = {
                relative = "editor",
                border = "rounded",
                width = 30,
                height = 30,
                row = 2,
                col = 1,
            },
        },
    },
    filesystem_watchers = {
        enable = true,
    },
    renderer = {
        root_folder_label = false,
        root_folder_modifier = ":t",
        indent_markers = {
            enable = false,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            glyphs = {
                folder = {
                    -- thay đổi icon khi mở tệp
                    arrow_closed = "", -- icon mũi tên khi tệp đóng
                    arrow_open = "",   -- icon mũi tên khi tệp mở
                },
            },
        },
    },
    actions = {
        open_file = {
            resize_window = true,
            window_picker = {
                enable = false,
            },
        },
    },
    disable_netrw = true,
    hijack_netrw = true,
    hijack_cursor = true,
    auto_reload_on_write = true,
    hijack_unnamed_buffer_when_opening = false,
    sync_root_with_cwd = true,
})
