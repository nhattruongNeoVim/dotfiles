local cmp_status, cmp = pcall(require, "cmp") -- autocomplete code
if not cmp_status then
    return
end

local luasnip_status, luasnip = pcall(require, "luasnip") -- snippet
if not luasnip_status then
    return
end

local lspkind_status, lspkind = pcall(require, "lspkind")
if not lspkind_status then
    return
end

local new_kind_icon = require("core.icons")

require("luasnip/loaders/from_vscode").lazy_load()

vim.opt.completeopt = "menu,menuone,noselect"

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<S-tab>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<tab>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(),    -- close completion window
        ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = "cmp_tabnine"}, -- TabNine
        { name = "nvim_lsp"  }, -- lsp
        { name = "nvim_lua" }, -- lsp
        { name = "luasnip" }, -- snippets
        { name = "buffer" }, -- text within current buffer
        { name = "path" }, -- file system paths
    }),
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = function(entry, vim_item)
			-- vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
			vim_item.kind = string.format("%s", new_kind_icon["kind"][vim_item.kind])
			-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				-- nvim_lsp = "[LSP]",
				-- luasnip = "[Snippet]",
				-- buffer = "[Buffer]",
				-- path = "[Path]",
				nvim_lsp = "(LSP)",
				luasnip = "(Snippet)",
				buffer = "(Buffer)",
				path = "(Path)",
			})[entry.source.name]
			return vim_item
		end,
	},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
})

-- -- `:` cmdline setup
-- cmp.setup.cmdline(':', {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = cmp.config.sources({
--         { name = 'path' }
--     }, {
--         { name = 'cmdline' }
--     })
-- })
--
-- `/` cmdline setup.
-- cmp.setup.cmdline({ '/', '?' }, {
--     mapping = cmp.mapping.preset.cmdline(),
--     sources = {
--         { name = 'buffer' }
--     }
-- })
