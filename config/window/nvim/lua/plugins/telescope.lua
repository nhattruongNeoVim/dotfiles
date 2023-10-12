local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
    return
end

local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
    return
end


telescope.setup({
    defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        -- path_display = { "truncate" },
        -- sorting_strategy = "ascending",
        -- layout_config = {
        --     height = 0.95,
        --     width = 0.80,
        --     horizontal = {
        --         prompt_position = "top",
        --     },
        --     vertical = {
        --         mirror = false
        --     },
        --     preview_cutoff = 120,
        -- },
        mappings = {
            i = {
                ["<S-tab>"] = actions.move_selection_previous,             -- move to prev result
                ["<tab>"] = actions.move_selection_next,                   -- move to next result
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
            },
        },
    },
})

telescope.load_extension("fzf")
