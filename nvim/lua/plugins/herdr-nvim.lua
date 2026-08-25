return {
    "ChmaraX/herdr-nvim",
    cond = vim.env.HERDR_ENV == "1",
    opts = {
        -- Keep <leader>a available for the existing toggleterm agent mappings.
        prefix = "<leader>r",
    },
}
