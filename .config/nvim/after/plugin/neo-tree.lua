local plugin_name = "neo-tree"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function hijack() end

local function loading()
  vim.cmd([[
        hi link NeoTreeDirectoryName Directory
        hi link NeoTreeDirectoryIcon NeoTreeDirectoryName
      ]])

  local neo_tree = require(plugin_name)
  neo_tree.setup({
    close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
    popup_border_style = "rounded",
    enable_git_status = true,
    enable_diagnostics = true,
    default_component_configs = {
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "ﰊ",
        default = "*",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
      },
      git_status = {
        -- highlight = "NeoTreeDimText", -- if you remove this the status will be colorful
      },
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function(file_path)
          --auto close
          neo_tree.close_all()
        end,
      },
      {
        event = "file_added",
        handler = function(file_path)
          require(plugin_name .. "utils").open_file({}, file_path)
        end,
      },
    },
    filesystem = {
      filtered_items = { --These filters are applied to both browsing and searching
        hide_dotfiles = false,
        hide_gitignored = false,
      },
      follow_current_file = true, -- This will find and focus the file in the active buffer every
      use_libuv_file_watcher = false, -- This will use the OS level file watchers
      hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
      window = {
        position = "left",
        width = 30,
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["l"] = "open",
          ["h"] = "close_node",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["I"] = "toggle_gitignore",
          ["R"] = "refresh",
          ["/"] = "fuzzy_finder",
          --["/"] = "filter_as_you_type", -- this was the default until v1.28
          -- ["/"] = "none", -- Assigning a key to "none" will remove the default mapping
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["m"] = "move", -- takes text input for destination
          ["q"] = "close_window",
          ["<esc>"] = "close_window",
          ["t"] = "none",
        },
      },
    },
    buffers = {
      show_unloaded = true,
      window = {
        position = "left",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["R"] = "refresh",
          ["a"] = "add",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["bd"] = "buffer_delete",
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["<2-LeftMouse>"] = "open",
          ["<cr>"] = "open",
          ["S"] = "open_split",
          ["s"] = "open_vsplit",
          ["C"] = "close_node",
          ["R"] = "refresh",
          ["d"] = "delete",
          ["r"] = "rename",
          ["c"] = "copy_to_clipboard",
          ["x"] = "cut_to_clipboard",
          ["p"] = "paste_from_clipboard",
          ["A"] = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },
  })

  -- hijack at lazy loading
  vim.api.nvim_exec(
    [[if isdirectory(expand('%:p')) | exe 'cd %:p:h' | exe 'bd!'| exe 'NeoTreeShowInSplit' | endif]],
    false
  )
end

local function keymap()
  vim.keymap.set("n", "<leader>E", "<Cmd>NeoTreeRevealToggle<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>e", "<Cmd>NeoTreeFloat<CR>", { noremap = true, silent = true })
  vim.keymap.set("n", "<leader>gg", "<Cmd>NeoTreeFloatToggle git_status<CR>", { noremap = true, silent = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
require("utils.plugin").force_load_on_event(plugin_name, keymap)
