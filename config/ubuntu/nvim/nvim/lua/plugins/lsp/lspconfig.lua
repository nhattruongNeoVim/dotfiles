local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
    return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
    return
end

local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
    return
end

local keymap = vim.keymap

local on_attach = function(client, bufnr)
    local opts = {
        noremap = true,
        silent = true,
        buffer = bufnr
    }

    -- keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)                     -- show definition, references
    -- keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)          -- got to declaration
    -- keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)       -- go to implementation
    keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)           -- jump to previous diagnostic in buffer
    keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)           -- jump to next diagnostic in buffer
    -- keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                       -- show documentation for what is under cursor
    -- keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)                 -- see outline on right hand side

    if client.name == "tsserver" then
        keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")      -- rename file and update imports
        keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
        keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")    -- remove unused variables (not in youtube nvim video)
    end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

local signs = {
    Error = " ",
    Warn = " ",
    Hint = "ﴞ ",
    Info = " "
}
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, {
        text = icon,
        texthl = hl,
        numhl = ""
    })
end

lspconfig["html"].setup({
    capabilities = capabilities,
    on_attach = on_attach
})

typescript.setup({
    server = {
        capabilities = capabilities,
        on_attach = on_attach
    }
})

lspconfig["cssls"].setup({
    capabilities = capabilities,
    on_attach = on_attach
})

lspconfig["tailwindcss"].setup({
    capabilities = capabilities,
    on_attach = on_attach
})

lspconfig["emmet_ls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" }
})

lspconfig["lua_ls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    settings = {
        -- custom settings for lua
        Lua = {
            -- make the language server recognize "vim" global
            diagnostics = {
                globals = { "vim" }
            },
            workspace = {
                -- make language server aware of runtime files
                library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.stdpath("config") .. "/lua"] = true
                }
            }
        }
    }
})

lspconfig["clangd"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "clangd", "--background-index" }, -- Lệnh để chạy clangd
    filetypes = { "c", "cpp" },             -- Các loại tệp tin được hỗ trợ (có thể thay đổi tùy theo nhu cầu)
    root_dir = lspconfig.util.root_pattern( -- Xác định thư mục gốc cho dự án
        ".git", "compile_commands.json", ".clangd", ".clang-format", ".clang-tidy", "compile_flags.txt", "configure.ac"
    )
})

lspconfig["pyright"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lspconfig["jdtls"].setup({
    cmd = {"jdtls"},
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "java" },
    -- root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw'}, { upward = true })[1]),
    root_dir = lspconfig.util.root_pattern(
        '.git', '*.iml', 'mvnw', 'gradlew'
    )
})
