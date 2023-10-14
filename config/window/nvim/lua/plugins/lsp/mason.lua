local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end

mason.setup({
    ui = {
        -- border = "single",
        border = "none",
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})

mason_lspconfig.setup({
  ensure_installed = {
    "tsserver",
    "html",
    "cssls",
    "tailwindcss",
    "lua_ls",
    "emmet_ls",
    "clangd",
    "jdtls",
  },
  automatic_installation = true,
})

mason_null_ls.setup({
    ensure_installed = {
    "prettier",                 -- ts/js formatter
    "stylua",                   -- lua formatter
    "eslint_d",                 -- ts/js linter
    "clang-format",
    "black"
  },
})
