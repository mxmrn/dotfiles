return {
  defaults = {
    prompt_prefix = "   ",
    selection_caret = " ",
    entry_prefix = " ",
    sorting_strategy = "ascending",
    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width = 0.55,
      },
      width = 0.87,
      height = 0.80,
    },
    mappings = {
      n = { ["q"] = require("telescope.actions").close },
    },
    file_ignore_patterns = { "^%.git/", "node_modules/", "^target/", "%.venv/", "__pycache__/" },
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions_list = { "themes", "terms" },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown(),
    undo = {
      use_delta = true,
      side_by_side = true,
      layout_strategy = "vertical",
      layout_config = {
        preview_height = 0.8,
      },
    },
  },
}
