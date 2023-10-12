local status, treesitter = pcall(require, "nvim-treesitter.configs")
if not status then
    return
end

treesitter.setup({                  -- cấu hình treesitter
    highlight = {                   -- bật syntax highlighting
        enable = true,
        disable = {"css"},
    },
    indent = { enable = true },     -- bật indentation
    autotag = { enable = true },    -- bật autotagging (với nvim-ts-autotag plugin)
    ensure_installed = {            -- đảm bảo các trình phân tích cú pháp ngôn ngữ này được cài đặt
        -- "json",
        -- "javascript",
        -- "typescript",
        -- "tsx",
        -- "yaml",
        -- "html",
        -- "css",
        -- "markdown",
        -- "markdown_inline",
        -- "svelte",
        -- "graphql",
        -- "bash",
        -- "lua",
        -- "vim",
        -- "dockerfile",
        -- "gitignore",
        -- "cpp",
    },
    auto_install = true,            -- tự động cài đặt các trình phân tích cú pháp ngôn ngữ trên
})
