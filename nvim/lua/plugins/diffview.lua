return {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
        { "<leader>dv", "<cmd>DiffviewOpen<cr>", desc = "Open diffview" },
        { "<leader>dh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
        { "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close diffview" },
    },
    config = function()
        require("diffview").setup({})
    end,
}
