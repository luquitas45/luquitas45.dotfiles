-- yazi.nvim: tu yazi real dentro de nvim (flotante)
-- Usa el binario yazi del sistema (ya instalado con la fase yazi)
return {
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    keys = {
      -- stylua: ignore
      { "<leader>e", "<cmd>Yazi<cr>", desc = "Yazi (cwd)" },
      { "<leader>E", "<cmd>Yazi toggle<cr>", desc = "Yazi (toggle)" },
    },
    opts = {
      open_for_directories = false, -- no secuestrar `nvim .` (el default abre el archivo elegido)
    },
  },
}