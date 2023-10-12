local status, colorizer = pcall(require, "colorizer")
if not status then
    return
end

colorizer.setup({
    '*',
    css = { rgb_fn = true, },  -- Enable parsing rgb(...) functions in css.
    html = { names = false, }, -- Disable parsing "names" like Blue or Gray
}, { mode = 'background' })    -- có thể chỉnh thành foreground
