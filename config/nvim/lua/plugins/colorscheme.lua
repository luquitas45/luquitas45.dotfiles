-- Black Metal theme — Gorgoroth (dark)
return {
  {
    "metalelf0/black-metal-theme-neovim",
    lazy = false,
    priority = 1000,
    config = function()
      require("black-metal").setup({
        theme = "gorgoroth",
        trve = false, -- light variants enabled for the future
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("black-metal").load("gorgoroth", "dark")
      end,
    },
  },
}