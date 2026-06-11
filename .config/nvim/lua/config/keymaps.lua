-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- File explorer (Snacks): Ctrl-n jumps the cursor INTO the tree (opens it if
-- needed, but never closes it). <leader>e toggles the tree open/closed instead.
map("n", "<C-n>", function()
  local explorer = Snacks.picker.get({ source = "explorer" })[1]
  if explorer then
    explorer:focus("list")
  else
    Snacks.explorer({ cwd = LazyVim.root() })
  end
end, { desc = "Explorer (focus)" })

-- Quick horizontal terminal at the bottom of the current window. Toggle with the
-- same key (works from inside the terminal too). Handy for a quick command without
-- leaving Neovim. Ctrl-/ and Ctrl-_ are the same physical key in most terminals.
local function toggle_term()
  Snacks.terminal.toggle(nil, { win = { position = "bottom", height = 0.3 } })
end
map({ "n", "t" }, "<C-/>", toggle_term, { desc = "Terminal (horizontal)" })
map({ "n", "t" }, "<C-_>", toggle_term, { desc = "which_key_ignore" })
