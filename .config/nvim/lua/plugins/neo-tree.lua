return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true, -- show dotfiles and git-ignored files by default
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
  },
}
