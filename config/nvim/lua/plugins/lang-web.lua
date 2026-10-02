-- Lenguajes web + shell configurados a mano
-- (en LazyVim main 2026 html/css/bash ya no existen como extras; lua_ls es core)
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {}, -- bash
        html = {}, -- html
        cssls = {}, -- css
      },
    },
  },
  {
    "mason-org/mason.nvim", -- (antes williamboman/mason.nvim; LazyVim avisa el rename)
    opts = {
      ensure_installed = {
        "bash-language-server",
        "html-lsp", -- (antes vscode-html-language-server; ese nombre ya no existe en mason)
        "css-lsp", -- (antes vscode-css-language-server)
        "stylua", -- formateador lua
        "shellcheck", -- lint bash
        "shfmt", -- format bash
      },
    },
  },
}