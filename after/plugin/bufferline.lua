local available, bufferline = pcall(require, "bufferline")

if not available then
    return
end

local map = vim.keymap.set

-- Prevent accidentally deleting modified buffers.
local function delete_buffer(buffer_number)
    buffer_number = buffer_number
        or vim.api.nvim_get_current_buf()

    if not vim.api.nvim_buf_is_valid(buffer_number) then
        return
    end

    if vim.bo[buffer_number].modified then
        local name = vim.api.nvim_buf_get_name(buffer_number)

        if name == "" then
            name = "[No Name]"
        else
            name = vim.fn.fnamemodify(name, ":t")
        end

        vim.notify(
            "Save changes before closing " .. name,
            vim.log.levels.WARN
        )

        return
    end

    local success, error_message = pcall(
        vim.api.nvim_buf_delete,
        buffer_number,
        {
            force = false,
        }
    )

    if not success then
        vim.notify(
            tostring(error_message),
            vim.log.levels.ERROR
        )
    end
end

vim.opt.showtabline = 2

bufferline.setup({
    options = {
        mode = "buffers",

        -- Display buffer numbers for Space+b+1 through Space+b+9.
        numbers = "ordinal",

        close_command = delete_buffer,
        right_mouse_command = delete_buffer,

        diagnostics = "nvim_lsp",

        diagnostics_indicator = function(
            count,
            level
        )
            local icon = ""

            if level:match("error") then
                icon = ""
            elseif level:match("warning") then
                icon = ""
            end

            return string.format(
                " %s %d",
                icon,
                count
            )
        end,

        indicator = {
            style = "underline",
        },

        separator_style = "thin",
        always_show_bufferline = true,

        show_buffer_close_icons = true,
        show_close_icon = false,

        -- Keep the bufferline aligned when nvim-tree is open.
        offsets = {
            {
                filetype = "NvimTree",
                text = "Explorer",
                highlight = "Directory",
                separator = true,
                text_align = "left",
            },
        },

        pick = {
            alphabet = "asdfghjklqwertyuiopzxcvbnm",
        },
    },
})

-- LazyVim-style sequential navigation.
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", {
    desc = "Previous buffer",
})

map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", {
    desc = "Next buffer",
})

map("n", "[b", "<cmd>BufferLineCyclePrev<CR>", {
    desc = "Previous buffer",
})

map("n", "]b", "<cmd>BufferLineCycleNext<CR>", {
    desc = "Next buffer",
})

-- Alternate between the current and previous buffer.
map("n", "<leader>bb", "<cmd>buffer #<CR>", {
    desc = "Switch to previous buffer",
})

-- Search every open buffer using Telescope.
map("n", "<leader>bs", function()
    local telescope_available, builtin = pcall(
        require,
        "telescope.builtin"
    )

    if not telescope_available then
        return
    end

    builtin.buffers({
        sort_mru = true,
    })
end, {
    desc = "Search buffers",
})

-- Pick a visible buffer by the letter displayed above it.
map("n", "<leader>bf", "<cmd>BufferLinePick<CR>", {
    desc = "Pick buffer",
})

-- Pick a visible buffer and close it.
map("n", "<leader>bx", "<cmd>BufferLinePickClose<CR>", {
    desc = "Pick buffer to close",
})

-- Safe deletion.
map("n", "<leader>bd", function()
    delete_buffer()
end, {
    desc = "Delete current buffer",
})

map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<CR>", {
    desc = "Delete other buffers",
})

map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", {
    desc = "Delete buffers to the left",
})

map("n", "<leader>br", "<cmd>BufferLineCloseRight<CR>", {
    desc = "Delete buffers to the right",
})

-- Pin important buffers.
map("n", "<leader>bp", "<cmd>BufferLineTogglePin<CR>", {
    desc = "Toggle buffer pin",
})

map(
    "n",
    "<leader>bP",
    "<cmd>BufferLineGroupClose ungrouped<CR>",
    {
        desc = "Delete non-pinned buffers",
    }
)

-- Jump directly to the numbered visible buffer.
for buffer_index = 1, 9 do
    map(
        "n",
        "<leader>b" .. buffer_index,
        string.format(
            "<cmd>BufferLineGoToBuffer %d<CR>",
            buffer_index
        ),
        {
            desc = string.format(
                "Go to buffer %d",
                buffer_index
            ),
        }
    )
end
