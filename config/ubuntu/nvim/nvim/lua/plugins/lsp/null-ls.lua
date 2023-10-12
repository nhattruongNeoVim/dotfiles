local setup, null_ls = pcall(require, "null-ls")
if not setup then
  return
end

local formatting = null_ls.builtins.formatting          -- để setup formatters
local diagnostics = null_ls.builtins.diagnostics        -- để setup linters

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    source = {
        sources = {
    --  để vô hiệu hóa các loại tập tin sử dụng
    --  "formatting.prettier.with({disabled_filetypes = {}})" (xem thêm tại tài liệu null-ls)
    formatting.prettier,                -- js/ts formatter
    formatting.stylua,                  -- lua formatter
    diagnostics.eslint_d.with({         -- js/ts linter
      -- only enable eslint if root has .eslintrc.js
      condition = function(utils)
        return utils.root_has_file(".eslintrc.js") -- change file extension if you use something else
      end,
    }),
  },
  -- configure format on save
  on_attach = function(current_client, bufnr)
    if current_client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({
            filter = function(client)
              --  only use null-ls for formatting instead of lsp server
              return client.name == "null-ls"
            end,
            bufnr = bufnr,
          })
        end,
      })
    end
  end,
  }
})
