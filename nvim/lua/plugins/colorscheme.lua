return {
    "rebelot/kanagawa.nvim",
    priority = 1000,
    config = function()
        require("kanagawa").setup({
            overrides = function()
                return {
                    GitSignsAdd = { fg = "#0072B2" },
                    GitSignsChange = { fg = "#E69F00" },
                    GitSignsDelete = { fg = "#D55E00" },
                }
            end,
        })
        vim.cmd("colorscheme kanagawa")
    end,
}
