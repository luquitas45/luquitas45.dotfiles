-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Navegación tmux ↔ nvim (vim-tmux-navigator).
-- Este archivo se carga DESPUÉS del core de LazyVim: pisamos sus
-- C-h/j/k/l ("Go to Left Window") para cruzar panes de tmux primero.
-- (Los binds de tmux lado-servidor viven en ~/.config/tmux/tmux.conf)
--
-- OJO: usar la FORMA CLÁSICA ":<C-U>cmd<cr>", NO "<cmd><C-U>...".
-- En nvim el <C-U> dentro de un mapping <cmd> se vuelve literal (^U) y el
-- comando falla con E492 ("^UTmuxNavigateRight") — el cruce no ocurre.
local nav = { "n", "x" }
vim.keymap.set(nav, "<C-h>", ":<C-U>TmuxNavigateLeft<cr>", { desc = "Tmux: Left" })
vim.keymap.set(nav, "<C-j>", ":<C-U>TmuxNavigateDown<cr>", { desc = "Tmux: Down" })
vim.keymap.set(nav, "<C-k>", ":<C-U>TmuxNavigateUp<cr>", { desc = "Tmux: Up" })
vim.keymap.set(nav, "<C-l>", ":<C-U>TmuxNavigateRight<cr>", { desc = "Tmux: Right" })
vim.keymap.set(nav, "<C-\\>", ":<C-U>TmuxNavigatePrevious<cr>", { desc = "Tmux: Previous" })