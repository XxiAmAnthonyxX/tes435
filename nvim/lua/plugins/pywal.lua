return {
  -- Add neopywal
  {
    "RedsXDD/neopywal.nvim",
    name = "neopywal",
    lazy = false,
    priority = 1000,
    opts = {}, -- put any neopywal options here
  },

  -- Tell LazyVim to use it
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "neopywal",
      -- or "neopywal-dark" / "neopywal-light" if you prefer
    },
  },
}
