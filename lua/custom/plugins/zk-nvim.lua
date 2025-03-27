-- https://github.com/zk-org/zk-nvim

return {
  "zk-org/zk-nvim",
  keys = {
    -- Create a new note after asking for its title.
    { "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "New Note" },

    -- Open notes.
    { "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open Note" },

    -- Open notes associated with the selected tags.
    { "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Search Notes by tags" },

    -- Search for the notes matching a given query.
    { "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", desc = "Search Notes by query" },

    -- Search for the notes matching the current visual selection.
    { "<leader>zf", ":'<,'>ZkMatch<CR>", mode = "v", desc = "Search Notes" },

    -- CD into the notebook root.
    { "<leader>zc", "<Cmd>ZkCd<CR>", desc = "CD into the Notebook root" },

    -- ft markdown keymaps
    -- Open the link under the caret.
    { "<leader>zd", "<Cmd>lua vim.lsp.buf.definition()<CR>", ft = "markdown", desc = "Open the link under the caret" },

    { "<leader>zi", "<Cmd>ZkInsertLink<CR>", ft = "markdown", desc = "Inserts a link at the cursor position" },

    -- Create a new note after asking for its title.
    -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
    { "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", ft = "markdown", desc = "Create a new note after asking for its title" },
    -- Create a new note in the same directory as the current buffer, using the current selection for title.
    { "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", ft = "markdown", mode = "v", desc = "Create new note with selection as title" },
    -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
    { "<leader>znc", ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", ft = "markdown", mode = "v", desc = "Create new note with selection as content" },

    -- Open notes linking to the current buffer.
    { "<leader>zb", "<Cmd>ZkBacklinks<CR>", ft = "markdown", desc = "Open notes linking to the current buffer" },

    -- Alternative for backlinks using pure LSP and showing the source context.
    -- { "<leader>zb", "<Cmd>lua vim.lsp.buf.references()<CR>", ft = "markdown", desc = "Open notes linked by the current buffer" },

    -- Open notes linked by the current buffer.
    { "<leader>zl", "<Cmd>ZkLinks<CR>", ft = "markdown", desc = "Open notes linked by the current buffer" },

    -- Preview a linked note.
    { "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", ft = "markdown", desc = "Preview a linked note" },
    -- Open the code actions for a visual selection.
    { "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", ft = "markdown", mode = "v", desc = "Open the code actions for a visual selection" },
  },
  main = "zk",
  opts = {
    picker = "telescope"
  }
}
