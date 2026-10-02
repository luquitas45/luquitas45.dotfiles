-- Navegación unificada tmux <-> nvim con C-h/j/k/l (sin prefijo).
-- Los keymaps viven en lua/config/keymaps.lua (se cargan DESPUÉS del core
-- de LazyVim, que también mapea C-h/j/k/l a ventanas — ahí ganamos el cruce).
-- Aquí solo queda el `cmd` para que lazy cargue el plugin al primer uso.
return {
  "christoomey/vim-tmux-navigator",
  cmd = {
    "TmuxNavigateLeft",
    "TmuxNavigateDown",
    "TmuxNavigateUp",
    "TmuxNavigateRight",
    "TmuxNavigatePrevious",
  },
}