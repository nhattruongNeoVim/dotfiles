local status_ok = pcall(require, "luasnip")
if not status_ok then
	return
end

local lpath = vim.fn.stdpath("config") .. "/my-snippets"

-- bạn muốn dùng snippets nào thì mở comment, nó sẽ rất nặng nếu mở hết mà không dùng

-- hàm lazy_load sẽ chỉ tải snippets khi đc gọi (đỡ nặng hơn)

-- require("luasnip.loaders.from_vscode").lazy_load()
-- -- specify the full path...
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/B5-Snippets",
-- })
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/laravel-blade",
-- })
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/laravel-blade2",
-- })
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/laravel5",
-- })
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/javascript",
-- })
require("luasnip.loaders.from_vscode").lazy_load({
	paths = lpath .. "/html",
})
require("luasnip.loaders.from_vscode").lazy_load({
	paths = lpath .. "/javascript-snippet",
})
-- require("luasnip.loaders.from_vscode").lazy_load({
--   paths = lpath .. "/codeigniter4",
-- })
-- require("luasnip.loaders.from_vscode").lazy_load({
-- 	paths = lpath .. "/font-awesome",
-- })

-- hàm load sẽ tải snippets một lần và sử dụng ngay lập tức, mở comment khi lazy_load không hoạt động

--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/B5-Snippets" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/laravel-blade" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/laravel-blade2" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/laravel5" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/javascript" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/html" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/codeigniter4" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/font-awesome" })
--require("luasnip.loaders.from_vscode").load({ paths = lpath .. "/javascript-snippet" })
