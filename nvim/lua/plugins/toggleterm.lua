return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = "vertical",
            size = function(term)
                if term.direction == "vertical" then
                    return math.floor(vim.o.columns * 0.4)
                end
            end,
        })

        local Terminal = require("toggleterm.terminal").Terminal

        local claude = Terminal:new({ cmd = "claude", hidden = true, direction = "vertical" })
        local codex = Terminal:new({ cmd = "codex", hidden = true, direction = "vertical" })
        local opencode = Terminal:new({ cmd = "opencode", hidden = true, direction = "vertical" })

        vim.keymap.set("n", "<leader>ac", function() claude:toggle() end, { desc = "Toggle Claude Code" })
        vim.keymap.set("n", "<leader>ax", function() codex:toggle() end, { desc = "Toggle Codex" })
        vim.keymap.set("n", "<leader>ao", function() opencode:toggle() end, { desc = "Toggle OpenCode" })

        vim.keymap.set("v", "<leader>as", function()
            require("toggleterm").send_lines_to_terminal("visual_lines", true, { args = vim.v.count })
        end, { desc = "Send selection to active agent" })
    end,
}
