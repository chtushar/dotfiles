return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
        require("kanagawa").setup({
            overrides = function()
                return {
                    -- gutter signs
                    GitSignsAdd = { fg = "#0072B2" },
                    GitSignsChange = { fg = "#E69F00" },
                    GitSignsDelete = { fg = "#D55E00" },
                    -- hunk preview line backgrounds
                    GitSignsAddLn = { bg = "#002B55" },
                    GitSignsDeleteLn = { bg = "#4A1800" },
                    -- inline word diff highlights
                    GitSignsAddInline = { bg = "#0072B2", fg = "#FFFFFF" },
                    GitSignsDeleteInline = { bg = "#D55E00", fg = "#FFFFFF" },
                    GitSignsChangeInline = { bg = "#E69F00", fg = "#000000" },
                }
            end,
        })
        vim.cmd("colorscheme kanagawa")
    end,
}
