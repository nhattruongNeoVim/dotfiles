
--------- ███╗   ██╗██╗  ██╗ █████╗ ████████╗    ████████╗██████╗ ██╗   ██╗ ██████╗ ███╗   ██╗ ██████╗     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗----------------
--------- ████╗  ██║██║  ██║██╔══██╗╚══██╔══╝    ╚══██╔══╝██╔══██╗██║   ██║██╔═══██╗████╗  ██║██╔════╝     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║----------------
--------- ██╔██╗ ██║███████║███████║   ██║          ██║   ██████╔╝██║   ██║██║   ██║██╔██╗ ██║██║  ███╗    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║----------------
--------- ██║╚██╗██║██╔══██║██╔══██║   ██║          ██║   ██╔══██╗██║   ██║██║   ██║██║╚██╗██║██║   ██║    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║----------------
--------- ██║ ╚████║██║  ██║██║  ██║   ██║          ██║   ██║  ██║╚██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║----------------
--------- ╚═╝  ╚═══╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝          ╚═╝   ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝----------------


-- setting bởi NhattruongNeovim
-- setting mặc định
require("core.plugins-setup")
require("core.options")
require("plugins.tokyonight")
require("core.colorschemes")
require("core.keymaps")
require("core.neovide")

-- plugin
require("plugins.comment")
require("plugins.tree")
require("plugins.lualine")
require("plugins.telescope")
require("plugins.dressing")
require("plugins.cmp")
require("plugins.lsp.mason")
require("plugins.lsp.lspsaga")
require("plugins.lsp.lspconfig")
require("plugins.lsp.null-ls")
require("plugins.snippets")
require("plugins.autopairs")
require("plugins.treesitter")
require("plugins.bufferline")
require("plugins.whichkey")
require("plugins.alpha")
require("plugins.toggleterm")
-- require("plugins.nvterm")
require("plugins.colorizer")
require("plugins.indentline")
require("plugins.colorizer")
require("plugins.coderunner")
require("plugins.noice")
require("plugins.notify")
require("plugins.smartsplit")
require("plugins.neoscroll")
require("plugins.hop")

vim.cmd("cd~/UserData/Code")
