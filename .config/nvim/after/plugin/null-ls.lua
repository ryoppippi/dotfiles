local status, nulls = pcall(require, "null-ls")
if (not status) then return end

nulls.setup {
    sources = {
        -- nulls.builtins.formatting.prettier.with({
        --         extra_filetypes = {
        --             "svelte",
        --         },
        --     }),
        nulls.builtins.diagnostics.tsc,
        -- nulls.builtins.diagnostics.eslint_d.with({
        --         extra_filetypes = {
        --             "svelte",
        --         },
        --     }),
        -- python
        nulls.builtins.formatting.black,
        nulls.builtins.formatting.isort,
        nulls.builtins.diagnostics.mypy,
        nulls.builtins.diagnostics.flake8,
        -- others
        nulls.builtins.formatting.fish_indent,

         nulls.builtins.diagnostics.cspell,
    }
}
