local present, nvterm = pcall(require, "nvterm")
if not present then
    return
end

nvterm.setup({
    terminals = {
        list = {},
        type_opts = {
            float = {
                relative = "editor",
                row = 0.3,  -- 30% chiều cao của trình soạn thảo (tính từ phía trên xuống)
                col = 0.20, -- 20% chiều rộng của trình soạn thảo (tính từ bên trái sang)
                width = 0.6, -- 50% chiều rộng của trình soạn thảo
                height = 0.4, -- 40% chiều cao của trình soạn thảo
                border = "rounded", -- viền gồm: none, single, double, rounded, solid
            },
            horizontal = { location = "rightbelow", split_ratio = 0.3 },
            vertical = { location = "rightbelow", split_ratio = 0.5 },
        },
        -- shell = "wsl.exe ",
        -- shell = "powershell.exe -NoExit ",
    },
    behavior = {
        close_on_exit = true,
        auto_insert = true,
    },
    enable_new_mappings = true,
})

local terminal = require("nvterm.terminal")
local toggle_modes = { 'n', 't' }
local mappings = {
    { 'n',          '<C-l>', function() require("nvterm.terminal").send(ft_cmds[vim.bo.filetype]) end },
    { toggle_modes, '<A-h>', function() require("nvterm.terminal").toggle('horizontal') end },
    { toggle_modes, '<A-v>', function() require("nvterm.terminal").toggle('vertical') end },
    -- { toggle_modes, '<A-i>', function() require("nvterm.terminal").toggle('float') end },
}
local opts = { noremap = true, silent = true }
for _, mapping in ipairs(mappings) do
    vim.keymap.set(mapping[1], mapping[2], mapping[3], opts)
end
