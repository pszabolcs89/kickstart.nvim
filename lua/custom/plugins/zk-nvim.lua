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
  },
  config = function()
    require("zk").setup({
      picker = "telescope"
    })
  end
}
