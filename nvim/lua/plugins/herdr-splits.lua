return {
    "lmilojevicc/herdr-splits.nvim",
    -- Only active inside a Herdr session; outside it the <C-hjkl> window maps
    -- in core/keymaps.lua stay in effect.
    cond = vim.env.HERDR_ENV == "1",
    event = "VeryLazy",
    config = function()
        require("herdr-splits").setup()
    end,
    keys = {
        { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Move to left window/pane" },
        { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Move to lower window/pane" },
        { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Move to upper window/pane" },
        { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Move to right window/pane" },
        { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize window/pane left" },
        { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize window/pane down" },
        { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize window/pane up" },
        { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize window/pane right" },
    },
}
