local map = vim.keymap.set
local ok, gitsigns = pcall(require, "gitsigns")

if ok then
    gitsigns.setup({
        current_line_blame = false,

        on_attach = function(buffer)
            local function buffer_map(mode, lhs, rhs, description)
                map(mode, lhs, rhs, {
                    buffer = buffer,
                    silent = true,
                    desc = description,
                })
            end

            -- Navigate changed sections
            buffer_map("n", "]h", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "]c",
                        bang = true,
                    })
                else
                    gitsigns.nav_hunk("next")
                end
            end, "Next Git hunk")

            buffer_map("n", "[h", function()
                if vim.wo.diff then
                    vim.cmd.normal({
                        "[c",
                        bang = true,
                    })
                else
                    gitsigns.nav_hunk("prev")
                end
            end, "Previous Git hunk")

            -- Git hunk actions
            buffer_map("n", "<leader>gs", gitsigns.stage_hunk, "Stage hunk")
            buffer_map("n", "<leader>gr", gitsigns.reset_hunk, "Reset hunk")
            buffer_map("n", "<leader>gp", gitsigns.preview_hunk, "Preview hunk")

            buffer_map("v", "<leader>gs", function()
                gitsigns.stage_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end, "Stage selected hunk")

            buffer_map("v", "<leader>gr", function()
                gitsigns.reset_hunk({
                    vim.fn.line("."),
                    vim.fn.line("v"),
                })
            end, "Reset selected hunk")

            buffer_map("n", "<leader>gB", function()
                gitsigns.blame_line({
                    full = true,
                })
            end, "Blame current line")

            buffer_map("n", "<leader>gq", function()
                gitsigns.setqflist("all")
            end, "Send hunks to quickfix")
        end,
    })
end

-- Fugitive
if vim.fn.exists(":Git") == 2 then
    map("n", "<leader>gg", "<cmd>Git<CR>", {
        desc = "Git status",
    })

    map("n", "<leader>gb", "<cmd>Git blame<CR>", {
        desc = "Git blame file",
    })

    map("n", "<leader>gd", "<cmd>Gdiffsplit<CR>", {
        desc = "Git diff split",
    })
end
