---@diagnostic disable: unused-local
local use_noice = true
local is_neovide = false

if vim.g.neovide then
    is_neovide = true
    use_noice = false

    -- vim.o.guifont = "Source Code Pro:h12"
    -- vim.o.guifont = "MesloLGS NF:h10"
    -- vim.o.guifont = "JetBrainsMono_Nerd_Font:h14,MesloLGS NF:h10"
    vim.o.guifont = "MesloLGS NF:h10,JetBrainsMono_Nerd_Font:h10"

    vim.g.neovide_padding_top = 0
    vim.g.neovide_padding_bottom = 0
    vim.g.neovide_padding_right = 0
    vim.g.neovide_padding_left = 0

    vim.g.neovide_transparency = 0.9
    vim.g.transparency = 0.8

    vim.opt.linespace = 0
    -- vim.g.neovide_fullscreen = true
    -- vim.g.neovide_profiler = true
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.g.neovide_input_use_logo = 1

    vim.keymap.set("v", "<c-c>", '"+y')             -- Copy
    vim.keymap.set("n", "<c-v>", '"+P')             -- Paste normal mode
    vim.keymap.set("v", "<c-v>", '"+P')             -- Paste visual mode
    vim.keymap.set("c", "<c-v>", "<C-R>+")          -- Paste command mode
    vim.keymap.set("i", "<c-v>", '<C-R>+')          -- Paste insert mode
    vim.keymap.set("t", "<c-v>", '<c-\\><c-n>"+Pa') -- Paste terminal mode

    vim.opt.cmdheight = 0
end

-- vim.opt.lazyredraw = is_neovide
-- return {
--     {"folke/noice.nvim", enabled = use_noice }
-- }
