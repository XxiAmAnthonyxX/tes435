return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = {
                  "/usr/share/hypr/stubs", -- adjust path if needed
                },
              },
              diagnostics = {
                globals = { "hl" },
              },
            },
          },
        },
      },
    },
  },
}
