-- Prettier con single quotes global (se suma al extra formatting.prettier)
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters = opts.formatters or {}
      opts.formatters.prettier = opts.formatters.prettier or {}
      opts.formatters.prettier.prepend_args = opts.formatters.prettier.prepend_args or {}
      vim.list_extend(opts.formatters.prettier.prepend_args, { "--single-quote" })
    end,
  },
}