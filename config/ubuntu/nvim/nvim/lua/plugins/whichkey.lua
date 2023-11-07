local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
    plugins = {
        marks = true,         -- shows a list of your marks on ' and `
        registers = true,     -- shows your registers on " in NORMAL or <C-r> in INSERT mode
        spelling = {
            enabled = true,   -- enabling this will show WhichKey when pressing z= to select spelling suggestions
            suggestions = 20, -- how many suggestions should be shown in the list?
        },
        -- the presets plugin, adds help for a bunch of default keybindings in Neovim
        -- No actual key bindings are created
        presets = {
            operators = false,   -- adds help for operators like d, y, ... and registers them for motion / text object completion
            motions = true,      -- adds help for motions
            text_objects = true, -- help for text objects triggered after entering an operator
            windows = true,      -- default bindings on <c-w>
            nav = true,          -- misc bindings to work with windows
            z = true,            -- bindings for folds, spelling and others prefixed with z
            g = true,            -- bindings for prefixed with g
        },
    },
    -- add operators that will trigger motion and text object completion
    -- to enable all native operators, set the preset / operators plugin above
    -- operators = { gc = "Comments" },
    key_labels = {
        -- override the label used to display some keys. It doesn't effect WK in any other way.
        -- For example:
        -- ["<space>"] = "SPC",
        -- ["<cr>"] = "RET",
        -- ["<tab>"] = "TAB",
    },
    icons = {
        breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
        separator = "➜", -- symbol used between a key and it's label
        group = "+",      -- symbol prepended to a group
    },
    popup_mappings = {
        scroll_down = "<c-d>", -- binding to scroll down inside the popup
        scroll_up = "<c-u>",   -- binding to scroll up inside the popup
    },
    window = {
        border = "rounded",       -- none, single, double, shadow
        position = "bottom",      -- bottom, top
        margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]
        padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
        winblend = 0,
    },
    layout = {
        height = { min = 4, max = 25 },                                           -- min and max height of the columns
        width = { min = 20, max = 50 },                                           -- min and max width of the columns
        spacing = 3,                                                              -- spacing between columns
        align = "left",                                                           -- align columns left, center or right
    },
    ignore_missing = true,                                                        -- enable this to hide mappings for which you didn't specify a label
    hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true,                                                             -- show help message on the command line when the popup is visible
    triggers = "auto",                                                            -- automatically setup triggers
    -- triggers = {"<leader>"} -- or specify a list manually
    triggers_blacklist = {
        -- list of mode / prefixes that should never be hooked by WhichKey
        -- this is mostly relevant for key maps that start with a native binding
        -- most people should not need to change this
        i = { "j", "k" },
        v = { "j", "k" },
    },
}
local is_dap = pcall(require, "dap")
local opts = {
    mode = "n",     -- NORMAL mode
    prefix = "<leader>",
    buffer = nil,   -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true,  -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = true,  -- use `nowait` when creating keymaps
}
local mappings = {
    ["A"] = { "<cmd>Alpha<cr>", "Alpha" },
    ["b"] = {
        "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
        "Buffers",
    },
    ["x"] = { "<cmd>bd!<CR>", "Close Buffer" },
    ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
    ["w"] = { "<cmd>w!<CR>", "Save" },
    ["q"] = { "<cmd>q!<CR>", "Quit" },
    ["h"] = { "<cmd>nohlsearch<CR>", "No highlight" },
    ["/"] = {
        function()
            require("Comment.api").toggle.linewise.current()
        end,
        "Comment line",
    },
    f = {
        name = "Find",
        f = { "<cmd>Telescope find_files<CR>", "Find files" },
        o = { "<cmd>Telescope oldfiles<cr>", "Find oldfiles" },
        b = { "<cmd>Telescope marks<cr>", "Find bookmarks"},
    },
    p = {
        name = "Packer",
        c = { "<cmd>PackerCompile<cr>", "Compile" },
        i = { "<cmd>PackerInstall<cr>", "Install" },
        s = { "<cmd>PackerSync<cr>", "Sync" },
        S = { "<cmd>PackerStatus<cr>", "Status" },
        u = { "<cmd>PackerUpdate<cr>", "Update" },
    },

    l = {
        name = "LSP",
        a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
        d = {
            "<cmd>Telescope diagnostics bufnr=0<cr>",
            "Document Diagnostics",
        },
        W = {"<cmd>Telescope diagnostics<cr>", "Workspace Diagnostics",},
        f = { "<cmd>lua vim.lsp.buf.format{async=true}<cr>", "Format" },
        i = { "<cmd>LspInfo<cr>", "Info" },
        I = { ":Mason<CR>", "Installer Info" },
        j = {
            "<cmd>Lspsaga diagnostic_jump_next<CR>",
            "Next Diagnostic",
        },
        k = {
            "<cmd>Lspsaga diagnostic_jump_prev<cr>",
            "Prev Diagnostic",
        },
        l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
        q = { "<cmd>lua vim.diagnostic.setloclist()<cr>", "Quickfix" },
        r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
        p = { "<cmd>Lspsaga peek_definition<cr>", "Peek definition" },
        w = { "<cmd>Lspsaga winbar_toggle<cr>", "Winbar toggle" },
        g = { "<cmd>Lspsaga goto_definition<cr>", "Go to definition" },
        s = { "<cmd>Lspsaga show_line_diagnostics<cr>", "Show diagnostics"}
    },
    g = {
        name = "Help",
        t = { "<cmd>Telescope colorscheme theme=dropdown<cr>", "Themes" },
        g = { "<cmd>Telescope help_tags<cr>", "Find Help" },
        k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
        c = { "<cmd>Telescope commands<cr>", "Commands" },
    },
    -- Code runner
    r = {
        name = "Run",
        s = {
            '<cmd>autocmd bufwritepost [^_]*.sass,[^_]*.scss  silent exec "!sass %:p %:r.css"<CR>',
            "Auto Compile Sass",
        },
        r = { "<cmd>RunCode<CR>", "Run Code" },
        f = { "<cmd>RunFile<CR>", "Run File" },
        p = { "<cmd>RunProject<CR>", "Run Project" },
    },
    -- AutoRunner
    a = {
        name = "AutoRunner",
        r = { "<cmd>AutoRunnerRun<cr>", "Run the command" },
        t = { "<cmd>AutoRunnerToggle<cr>", "Toggle output window" },
        e = { "<cmd>AutoRunnerEditFile<cr>", "Edit build file (if available in runtime directory)" },
        a = { "<cmd>AutoRunnerAddCommand<cr>", "Add/change command" },
        c = { "<cmd>AutoRunnerClearBuffer<cr>", "Clear buffer" },
        C = { "<cmd>AutoRunnerClearAll<cr>", "Clear all (command and buffers)" },
        p = { "<cmd>AutoRunnerPrintCommand<cr>", "Print command" },
    },
    s = {
        name = "Split window",
        v = {"<C-w>v", "Vertical"},
        h = {"<C-w>s", "Horizontal"},
        e = {"<C-w>=", "Default size"},
        x = {"<cmd>close<CR>", "Close window"},
        m = {"<cmd>MaximizerToggle<CR>", "Maximum window size"},
    },
    t = {
        name = "Treesitter",
        e = {"<cmd>TSBufEnable highlight<CR>", "Enable highlight"},
        d = {"<cmd>TSBufDisable highlight<CR>", "Disable highlight"}
    },
    z = {
        name = "Wrap code",
        e = {"<cmd>set wrap<CR>", "Enable code wrap"},
        d = {"<cmd>set nowrap<CR>", "Disable code wrap"},
    },
    j = {
        name = "Hop";
        j = {"<cmd>HopWord<cr>", "Hop word"};
        a = {"<cmd>HopAnywhere<cr>", "Hop all"};
        c = {"<cmd>HopChar1<cr>", "Hop char"};
        l = {"<cmd>HopLine<cr>", "Hop line"};
        L = {"<cmd>HopLineStart<cr>", "Hop line start"};
        p = {"<cmd>HopPattern<cr>", "Hop arbitrary"};
    };
    d = {
        name = "Debug",
        b = {
            function()
                if is_dap then
                    require("dap").toggle_breakpoint()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Toggle Breakpoint",
        },
        B = {
            function()
                if is_dap then
                    require("dap").clear_breakpoints()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Clear Breakpoints",
        },
        c = {
            function()
                if is_dap then
                    require("dap").continue()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Start/Continue",
        },
        i = {
            function()
                if is_dap then
                    require("dap").step_into()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Step Into",
        },
        o = {
            function()
                if is_dap then
                    require("dap").step_over()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Step Over",
        },
        O = {
            function()
                if is_dap then
                    require("dap").step_out()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Step Out",
        },
        q = {
            function()
                if is_dap then
                    require("dap").close()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Close Session",
        },
        Q = {
            function()
                if is_dap then
                    require("dap").terminate()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Terminate Session",
        },
        p = {
            function()
                if is_dap then
                    require("dap").pause()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Pause",
        },
        r = {
            function()
                if is_dap then
                    require("dap").restart_frame()
                else
                    vim.notify("DAP Not Support", "info")
                end
            end,
            "Restart",
        },
        R = {
            function()
                if is_dap then
                    require("dap").repl.toggle()
                else
                end
            end,
            "Toggle REPL",
        },
    },
}

which_key.setup(setup)
which_key.register(mappings, opts)
-- which_key.register(mappings2, opts2)
