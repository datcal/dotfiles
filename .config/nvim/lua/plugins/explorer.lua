-- File explorer: use the Snacks explorer (enabled via the
-- editor.snacks_explorer extra in lazyvim.json), not neo-tree.
return {
  -- Turn neo-tree off; the Snacks explorer replaces it.
  { "nvim-neo-tree/neo-tree.nvim", enabled = false },

  -- Always show dotfiles (.gitignore, .env, …) and git-ignored files in the tree.
  -- Inside the tree, `H` toggles dotfiles and `I` toggles git-ignored on the fly.
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true,
            ignored = true,
          },
        },
      },
    },
  },
}
