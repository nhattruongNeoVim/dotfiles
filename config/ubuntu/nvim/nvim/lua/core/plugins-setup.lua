local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

local packer_config = {
    display = {
        open_fn = function()
            return require('packer.util').float({ border = 'single' })
        end
    }
}

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
    return
end

return packer.startup({
    function(use)
        use("wbthomason/packer.nvim")                   -- packer - plugin manager

        use("nvim-lua/plenary.nvim")                    -- lua function bổ trơ cho các plugins khác

        use("christoomey/vim-tmux-navigator")           -- cho phép di chuyển giữa các split windows

        use("szw/vim-maximizer")                        -- phóng to cửa sổ được chia

        use("numToStr/Comment.nvim")                    -- plugin comment ( 'gcc': comment 1 hàng, 'gc5j': comment 5 hàng dưới, ...)

        use("nvim-tree/nvim-tree.lua")                  -- file explorer

        use("kyazdani42/nvim-web-devicons")             -- icon

        use("nvim-lualine/lualine.nvim")                -- statusbar

        use("stevearc/dressing.nvim")                   -- cải thiện giao diện

        use({
            "nvim-telescope/telescope-fzf-native.nvim", -- dependency cho fuzzy finder
            run = "make"
        })
        use({
            "nvim-telescope/telescope.nvim",            -- fuzzy finder (tìm kiếm)
            branch = "0.1.x"
        })

        -- tự động hoàn thành
        use("hrsh7th/nvim-cmp")                         -- completion plugin
        use("hrsh7th/cmp-buffer")                       -- nguồn cho văn bản
        use("hrsh7th/cmp-path")                         -- nguồn cho đường dẫn hệ thống tập tin
        use("hrsh7th/cmp-nvim-lua")                     -- nguồn cho cmp
        use("hrsh7th/cmp-nvim-lsp")                     -- nguồn cho cmp
        use("hrsh7th/cmp-cmdline")                      -- nguồn cho cmpline
        use({
            "tzachar/cmp-tabnine",
            run="./install.sh",
            requires = "hrsh7th/nvim-cmp"
        })

        -- snippets
        use("L3MON4D3/LuaSnip")                         -- snippet engine
        use("saadparwaiz1/cmp_luasnip")                 -- snippet cho autocompletion
        use("rafamadriz/friendly-snippets")             -- thêm snippets

        -- quản lý & cài đặt máy chủ lsp, linters & formatters
        use("williamboman/mason.nvim")                  -- phụ trách quản lý máy chủ lsp, linters & formatters
        use("williamboman/mason-lspconfig.nvim")        -- thu hẹp khoảng cách giữa mason & lspconfig
        use("williamboman/nvim-lsp-installer")

        -- cấu hình máy chủ lsp
        use("neovim/nvim-lspconfig")                    -- cấu hình máy chủ ngôn ngữ
        use({                                           -- lsp nâng cao
            "glepnir/lspsaga.nvim",
            branch = "main",
            requires = {
                { "nvim-tree/nvim-web-devicons" },
                { "nvim-treesitter/nvim-treesitter" },
            },
        })
        use("jose-elias-alvarez/typescript.nvim")       -- chức năng bổ sung cho máy chủ bản thảo (ví dụ: đổi tên tệp và cập nhật nhập)
        use("onsails/lspkind.nvim")                     -- so với mã như các biểu tượng để tự động hoàn thành

        use("jose-elias-alvarez/null-ls.nvim")          -- cấu hình formatters & linters

        use("jayp0521/mason-null-ls.nvim")              -- thu hẹp khoảng cách giữa mason & null-ls

        use({                                           -- treesitter configuration
            "nvim-treesitter/nvim-treesitter",
            run = function()
                local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
                ts_update()
            end,
        })

        use("nvim-treesitter/playground")               -- xem thông tin treesitter

        use("windwp/nvim-autopairs")                    -- tự động đóng dấu ngoặc đơn, dấu ngoặc, dấu ngoặc kép,...

        use({                                           -- tự động đóng tabs
            "windwp/nvim-ts-autotag",
            after = "nvim-treesitter"
        })

        use({
            "akinsho/toggleterm.nvim",                  -- terminal
            tag = "*",
        })

        use({
            "akinsho/bufferline.nvim",                  -- bufferline
            tag = "*",
            requires = {
                "nvim-tree/nvim-web-devicons",
                "famiu/bufdelete.nvim"
            }
        })

        use({
            "folke/tokyonight.nvim",                    -- theme tokyonight
            lazy = false,
            priority = 1000,
        })

        use({
            "goolord/alpha-nvim",                       -- dashboard
            require = { "nvim-tree/nvim-web-devicons" }
        })

        use("folke/noice.nvim")                         -- thanh cmd (không tương thích với neovide)

        use("MunifTanjim/nui.nvim")                     -- plugin phụ thuộc của thanh cmd

        use("rcarriga/nvim-notify")                     -- trình quản lí thông báo

        use("folke/which-key.nvim")                     -- bảng tắt

        use("norcalli/nvim-colorizer.lua")              -- hiện màu (vd: #ff000)

        use("lukas-reineke/indent-blankline.nvim")      -- indentline

        use("CRAG666/code_runner.nvim")                 -- chạy code

        -- use("barrett-ruth/live-server.nvim")                  -- live-server

        use("mrjones2014/smart-splits.nvim")            -- thay đổi kích thước cửa sổ

        use("karb94/neoscroll.nvim")                    -- cuộn mượt

        use("phaazon/hop.nvim")                         -- easy motion

        -- use("tribela/vim-transparent")                  -- transparent

        use("krshrimali/nvim-autorunner")               -- run code with autorunner

        if packer_bootstrap then
            require("packer").sync()
        end
    end,
    config = packer_config
})
