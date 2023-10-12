local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    return
end

toggleterm.setup {
    size = 20,
    open_mapping = [[<a-i>]],
    hide_numbers = true,
    shade_filetypes = { "none" },
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "float",
    close_on_exit = true,
    -- shell = "powershell.exe -NoExit",
    -- shell = "wsl.exe",
    float_opts = {
        -- border = "single",
        -- border = "double",
        -- border = "shadow",
        border = "curved",
        winblend = 0,
        highlights = {
            border = "Normal",
            background = "Normal",
        },
    },
}
