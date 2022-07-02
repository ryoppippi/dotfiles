local force_require = require("utils.plugin").force_require
local tb = require("utils").toboolean

vim.cmd([[set termguicolors]])
local feline = require("feline")
local winbar = feline.winbar
local lsp = require("feline.providers.lsp")
local vi_mode_utils = require("feline.providers.vi_mode")

local force_inactive = {
  filetypes = {},
  buftypes = {},
  bufnames = {},
}

local colors = {
  bg = "#282828",
  black = "#282828",
  yellow = "#d8a657",
  cyan = "#89b482",
  oceanblue = "#45707a",
  green = "#a9b665",
  orange = "#e78a4e",
  violet = "#d3869b",
  magenta = "#c14a4a",
  white = "#a89984",
  fg = "#a89984",
  skyblue = "#7daea3",
  red = "#ea6962",
}

local vi_mode_colors = {
  NORMAL = "green",
  OP = "green",
  INSERT = "skyblue",
  CONFIRM = "red",
  VISUAL = "violet",
  LINES = "violet",
  BLOCK = "violet",
  REPLACE = "violet",
  ["V-REPLACE"] = "violet",
  ENTER = "cyan",
  MORE = "cyan",
  SELECT = "orange",
  COMMAND = "green",
  SHELL = "green",
  TERM = "green",
  NONE = "yellow",
}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

local checkwidth = function(ln)
  local length = ln or 50
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > length then
    return true
  end
  return false
end

local get_file_format_icon = function()
  local os = vim.bo.fileformat:upper()
  local icon
  if os == "UNIX" then
    icon = " "
  elseif os == "MAC" then
    icon = " "
  else
    icon = " "
  end
  return icon, os
end

force_inactive.filetypes = {
  "NvimTree",
  "dbui",
  "packer",
  "startify",
  "fugitive",
  "fugitiveblame",
}

force_inactive.buftypes = {
  "terminal",
}

local comps = {
  vi_mode = {
    provider = function()
      local mode = vi_mode_utils.get_vim_mode()
      return " " .. mode .. " "
    end,
    short_provider = function()
      local mode = vi_mode_utils.get_vim_mode()
      return " " .. string.sub(mode, 1, 1) .. " "
    end,
    hl = function()
      local val = {}
      val.bg = vi_mode_utils.get_mode_color()
      val.fg = "black"
      val.style = "bold"
      return val
    end,
    right_sep = " ",
  },

  file_name = {
    provider = {
      name = "file_info",
      opts = {
        type = "relative",
      },
    },
    short_provider = {
      name = "file_info",
      opts = {
        type = "relative-short",
      },
    },
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    icon = "",
    priority = -20,
    left_sep = " ",
  },

  file_name_short = {
    provider = {
      name = "file_info",
      opts = {
        type = "base-only",
      },
    },
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    icon = "",
    priority = -20,
    left_sep = " ",
  },

  nvim_gps = {
    provider = function()
      local gps = force_require("nvim-gps")
      return gps and gps.get_location() or ""
    end,
    enabled = function()
      local gps = force_require("nvim-gps")
      return gps and gps.is_available() or false
    end,
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    left_sep = {
      str = " > ",
      hl = {
        fg = "white",
        bg = "bg",
        style = "bold",
      },
    },
    priority = -50,
    truncate_hide = true,
  },

  nvim_navic = {
    provider = function()
      local navic = force_require("nvim-navic")
      return navic and navic.get_location() or ""
    end,
    enabled = function()
      local navic = force_require("nvim-navic")
      return navic and navic.is_available() or false
    end,
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    left_sep = {
      str = " > ",
      hl = {
        fg = "white",
        bg = "bg",
        style = "bold",
      },
    },
    priority = -50,
    truncate_hide = true,
  },

  -- gitBranch
  git_branch = {
    provider = "git_branch",
    hl = {
      fg = "yellow",
      bg = "bg",
      style = "bold",
    },
    truncate_hide = true,
  },
  -- diffAdd
  git_diff_added = {
    provider = "git_diff_added",
    hl = {
      fg = "green",
      bg = "bg",
      style = "bold",
    },
  },
  -- diffModfified
  git_diff_changed = {
    provider = "git_diff_changed",
    hl = {
      fg = "orange",
      bg = "bg",
      style = "bold",
    },
    icon = {
      str = " ~",
      -- str = "  ",
    },
  },
  -- diffRemove
  git_diff_removed = {
    provider = "git_diff_removed",
    hl = {
      fg = "red",
      bg = "bg",
      style = "bold",
    },
  },

  -- diagnosticErrors
  lsp_diagnostic_errors = {
    provider = "diagnostic_errors",
    enabled = function()
      return lsp.diagnostics_exist(vim.diagnostic.severity.ERROR)
    end,
    hl = {
      fg = "red",
      style = "bold",
    },
    icon = {
      str = " ",
    },
  },
  -- diagnosticWarn
  lsp_diagnostic_warnings = {
    provider = "diagnostic_warnings",
    enabled = function()
      return lsp.diagnostics_exist(vim.diagnostic.severity.WARN)
    end,
    hl = {
      fg = "yellow",
      style = "bold",
    },
    icon = {
      str = " ",
    },
  },
  -- diagnosticHint
  lsp_diagnostic_hints = {
    provider = "diagnostic_hints",
    enabled = function()
      return lsp.diagnostics_exist(vim.diagnostic.severity.HINT)
    end,
    hl = {
      fg = "cyan",
      style = "bold",
    },
    icon = {
      str = " ",
    },
  },

  -- diagnosticInfo
  lsp_diagnostic_info = {
    provider = "diagnostic_info",
    enabled = function()
      return lsp.diagnostics_exist(vim.diagnostic.severity.INFO)
    end,
    hl = {
      fg = "skyblue",
      style = "bold",
    },
    icon = {
      str = " ",
    },
  },

  -- fileIcon
  file_icon = {
    provider = function()
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon = require("nvim-web-devicons").get_icon(filename, extension)
      if icon == nil then
        icon = ""
      end
      return icon
    end,
    hl = function()
      local val = {}
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
      if icon ~= nil then
        val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
      else
        val.fg = "white"
      end
      val.bg = "bg"
      val.style = "bold"
      return val
    end,
    left_sep = " ",
    right_sep = " ",
  },

  -- fileType
  file_type = {
    provider = "file_type",
    hl = function()
      local val = {}
      local filename = vim.fn.expand("%:t")
      local extension = vim.fn.expand("%:e")
      local icon, name = require("nvim-web-devicons").get_icon(filename, extension)
      if icon ~= nil then
        val.fg = vim.fn.synIDattr(vim.fn.hlID(name), "fg")
      else
        val.fg = "white"
      end
      val.bg = "bg"
      val.style = "bold"
      return val
    end,
    right_sep = " ",
    truncate_hide = true,
    priority = -100,
  },

  -- fileSize
  file_size = {
    provider = "file_size",
    enabled = function()
      return vim.fn.getfsize(vim.fn.expand("%:t")) > 0
    end,
    hl = {
      fg = "skyblue",
      bg = "bg",
      style = "bold",
    },
    right_sep = " ",
    truncate_hide = true,
  },

  -- fileFormat
  file_format = {
    provider = function()
      local icon, _ = get_file_format_icon()
      return icon
    end,
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    truncate_hide = true,
  },

  -- fileEncode
  file_encode = {
    provider = "file_encoding",
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    right_sep = " ",
    priority = -10,
    truncate_hide = true,
  },

  -- lineInfo
  line_info = {
    provider = {
      name = "position",
      opts = {
        padding = true,
      },
    },
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
    right_sep = " ",
    truncate_hide = true,
  },

  -- linePercent
  line_percent = {
    provider = "line_percentage",
    hl = {
      fg = "white",
      bg = "bg",
      style = "bold",
    },
  },

  -- scrollBar
  scroll_bar = {
    provider = "scroll_bar",
    hl = {
      fg = "yellow",
      bg = "bg",
    },
    priority = -10,
    truncate_hide = true,
  },

  -- LspName
  lsp_client_name = {
    provider = "lsp_client_names",
    enabled = function()
      return checkwidth(110)
    end,
    hl = {
      fg = "yellow",
      bg = "bg",
      style = "bold",
    },
    right_sep = " ",
    priority = -50,
    truncate_hide = true,
  },
}
local components = {
  active = {
    -- left
    {
      comps.vi_mode,
      comps.git_branch,
      comps.git_diff_added,
      comps.git_diff_changed,
      comps.git_diff_removed,
      comps.file_name,
      comps.nvim_navic,
      -- comps.nvim_gps,
    },
    -- middle
    {},
    -- right
    {
      comps.lsp_diagnostic_errors,
      comps.lsp_diagnostic_warnings,
      comps.lsp_diagnostic_hints,
      comps.lsp_diagnostic_info,
      comps.lsp_client_name,
      comps.file_icon,
      comps.file_type,
      comps.file_size,
      comps.file_format,
      comps.file_encode,
      comps.line_info,
      comps.line_percent,
    },
  },
  inactive = { {}, {}, {} },
}

feline.setup({
  theme = colors,
  vi_mode_colors = vi_mode_colors,
  default_bg = colors.bg,
  default_fg = colors.fg,
  components = components,
  force_inactive = force_inactive,
})

-- if tb(vim.fn.has("nvim-0.8")) then
-- winbar.setup({
--   components = {
--     active = {
--       {
--         comps.file_name,
--         comps.nvim_navic,
--       },
--     },
--     inactive = {
--       {
--         comps.file_name_short,
--       },
--     },
--   },
-- })
-- end

vim.cmd([[set noshowmode]])
