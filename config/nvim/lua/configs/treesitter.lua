-- nvim-treesitter (main branch): parsers are installed explicitly and
-- highlighting/indent are started per filetype.
local M = {}

local parsers = {
  "python", "go", "gomod", "lua", "luadoc", "printf", "vim", "vimdoc",
  "json", "sql", "rust", "solidity", "javascript", "typescript", "tsx",
  "html", "css", "yaml", "markdown", "markdown_inline", "bash", "toml",
}

function M.setup()
  local ts = require "nvim-treesitter"
  ts.setup {}

  -- compiling parsers needs the tree-sitter CLI (installed via Mason)
  if vim.fn.executable "tree-sitter" == 1 then
    ts.install(parsers)
  end

  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      if vim.b[args.buf].large_file then
        return
      end
      if pcall(vim.treesitter.start, args.buf) then
        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
