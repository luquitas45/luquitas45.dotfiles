-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Navegación tmux ↔ nvim (vim-tmux-navigator).
-- Este archivo se carga DESPUÉS del core de LazyVim: pisamos sus
-- C-h/j/k/l ("Go to Left Window") para cruzar panes de tmux primero.
-- (Los binds de tmux lado-servidor viven en ~/.config/tmux/tmux.conf)
local nav = { "n", "x" }
vim.keymap.set(nav, "<C-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", { desc = "Tmux: Left" })
vim.keymap.set(nav, "<C-j>", "<cmd><C-U>TmuxNavigateDown<cr>", { desc = "Tmux: Down" })
vim.keymap.set(nav, "<C-k>", "<cmd><C-U>TmuxNavigateUp<cr>", { desc = "Tmux: Up" })
vim.keymap.set(nav, "<C-l>", "<cmd><C-U>TmuxNavigateRight<cr>", { desc = "Tmux: Right" })
vim.keymap.set(nav, "<C-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", { desc = "Tmux: Previous" })