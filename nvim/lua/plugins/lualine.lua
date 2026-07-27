local function git_sync_status()
    local result = {}

    local ahead = vim.fn.system("git rev-list @{upstream}..HEAD 2>/dev/null | wc -l")
    local behind = vim.fn.system("git rev-list HEAD..@{upstream} 2>/dev/null | wc -l")

    ahead = tonumber(vim.fn.trim(ahead)) or 0
    behind = tonumber(vim.fn.trim(behind)) or 0

    if ahead > 0 then table.insert(result, "↑" .. ahead) end
    if behind > 0 then table.insert(result, "↓" .. behind) end

    return table.concat(result, " ")
end

local function git_dirty()
    local dirty = vim.fn.system("git status --porcelain 2>/dev/null")
    if dirty ~= "" then return "*" end
    return ""
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("lualine").setup({
            sections = {
                lualine_b = {
                    "branch",
                    git_dirty,
                    git_sync_status,
                },
            },
        })
    end,
}
