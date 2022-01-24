local status, onedark = pcall(require, "onedark")
if (not status) then return end

onedark.setup  {
    style = 'warmer',
    transparent = false,
    term_colors = true,
    toggle_style_key = '<leader>ws',
    code_style = {
        comments = 'italic',
        keywords = 'none',
        functions = 'none',
        strings = 'none',
        variables = 'none'
    },
}
onedark.load()
