-- Single source of truth for Mason packages
-- (used by mason-tool-installer and :MasonInstallAll)
return {
  -- LSP servers
  "gopls",
  "ruff",
  "pyright",
  "html-lsp",
  "css-lsp",
  "typescript-language-server",
  "json-lsp",
  "lua-language-server",
  "rust-analyzer",
  "nomicfoundation-solidity-language-server",
  "sqls",
  -- linters
  "golangci-lint",
  "shellcheck",
  "eslint_d",
  -- formatters
  "prettier",
  "stylua",
  "gofumpt",
  "goimports-reviser",
  "golines",
  "black",
  -- treesitter parser builds (nvim-treesitter main branch)
  "tree-sitter-cli",
}
