local M = {}

function M.get_background()
  local theme = os.getenv("THEME")
  if (theme == nil or (theme ~= "dark" and theme ~= "light")) then
    return "light"
  end
  return theme
end

function M.extend_hi(group, new_config)
  local hl = vim.api.nvim_get_hl_by_name(group, true)
  vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, new_config))
end

-- Sets theme highlights based on a input base16 colorscheme.
--
-- This configuration is inspired by
-- https://github.com/tinted-theming/base16-vim/blob/main/templates/default.mustache
--
-- @param colors (table) table with keys "base00", "base01", "base02",
--   "base03", "base04", "base05", "base06", "base07", "base08", "base09",
--   "base0A", "base0B", "base0C", "base0D", "base0E", "base0F".
--   Each key should map to a valid 6 digit hex color.
--
-- @framework (cf. https://github.com/tinted-theming/home/blob/main/styling.md)
-- ```txt
-- base00 - Default Background
-- base01 - Lighter Background (Used for status bars, line number and folding marks)
-- base02 - Selection Background
-- base03 - Comments, Invisibles, Line Highlighting
-- base04 - Dark Foreground (Used for status bars)
-- base05 - Default Foreground, Caret, Delimiters, Operators
-- base06 - Light Foreground (Not often used)
-- base07 - Light Background (Not often used)
-- base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
-- base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
-- base0A - Classes, Markup Bold, Search Text Background
-- base0B - Strings, Inherited Class, Markup Code, Diff Inserted
-- base0C - Support, Regular Expressions, Escape Characters, Markup Quotes, Errors
-- base0D - Functions, Methods, Attribute IDs, Headings
-- base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
-- base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
-- ```
--
-- @example
-- ```lua
-- setup_theme.setup({
--   base00 = "#16161D", base01 = "#2c313c", base02 = "#3e4451", base03 = "#6c7891",
--   base04 = "#565c64", base05 = "#abb2bf", base06 = "#9a9bb3", base07 = "#c5c8e6",
--   base08 = "#e06c75", base09 = "#d19a66", base0A = "#e5c07b", base0B = "#98c379",
--   base0C = "#56b6c2", base0D = "#0184bc", base0E = "#c678dd", base0F = "#a06949",
-- })
-- ```
function M.setup_theme(colors, diff_colors)
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  diff_colors = diff_colors or {
    add = { bg = colors.base01, fg = colors.base01 },
    delete = { bg = colors.base02, fg = colors.base02 },
    change = { bg = colors.base01, fg = colors.base01 },
    diff = { bg = colors.base01 },
  }

  local hi_config = {
    -- Vim editor highlights
    Normal       = { fg = colors.base05, bg = colors.base00 },
    Bold         = { bold = true },
    Debug        = { fg = colors.base08 },
    Directory    = { fg = colors.base0D },
    Error        = { fg = colors.base00, bg = colors.base08 },
    ErrorMsg     = { fg = colors.base08, bg = colors.base00, },
    Exception    = { fg = colors.base08 },
    FoldColumn   = { fg = colors.base03, bg = colors.base00, },
    Folded       = { fg = colors.base02, bg = colors.base00, },
    IncSearch    = { fg = colors.base01, bg = colors.base09, },
    Italic       = { italic = true },
    Macro        = { fg = colors.base08 },
    MatchParen   = { bg = colors.base03 },
    ModeMsg      = { fg = colors.base0B },
    MoreMsg      = { fg = colors.base0B },
    Question     = { fg = colors.base0D },
    Search       = { fg = colors.base01, bg = colors.base0A },
    Substitute   = { fg = colors.base01, bg = colors.base0A },
    SpecialKey   = { fg = colors.base03 },
    TooLong      = { fg = colors.base08 },
    Underlined   = { fg = colors.base08, underline = true },
    Visual       = { bg = colors.base02 },
    VisualNOS    = { fg = colors.base08 },
    WarningMsg   = { fg = colors.base08 },
    WildMenu     = { fg = colors.base00, bg = colors.base05 },
    Title        = { fg = colors.base0D },
    Conceal      = { fg = colors.base0D, bg = colors.base00 },
    Cursor       = { fg = colors.base05, bg = colors.base00, reverse = true },
    NonText      = { fg = colors.base03 },
    Whitespace   = { fg = colors.base03 },
    LineNr       = { fg = colors.base03, bg = colors.base00 },
    SignColumn   = { fg = colors.base03, bg = colors.base00 },
    StatusLine   = { fg = colors.base04, bg = colors.base01 },
    StatusLineNC = { fg = colors.base03, bg = colors.base01 },
    WinBar       = { fg = colors.base03 },
    WinBarNC     = { fg = colors.base04 },
    VertSplit    = { fg = colors.base01, bg = colors.base00 },
    ColorColumn  = { bg = colors.base01 },
    CursorColumn = { bg = colors.base01 },
    CursorLine   = { bg = colors.base01 },
    CursorLineNr = { fg = colors.base04, bg = colors.base01, bold = true },
    QuickFixLine = { bg = colors.base01 },
    PMenu        = { fg = colors.base06, bg = colors.base01 },
    PMenuSel     = { fg = colors.base06, bg = colors.base02 },
    PMenuSbar    = { bg = colors.base03 },
    PMenuThumb   = { bg = colors.base04 },
    TabLine      = { fg = colors.base03, bg = colors.base01 },
    TabLineFill  = { fg = colors.base03, bg = colors.base01 },
    TabLineSel   = { fg = colors.base0B, bg = colors.base01 },
    EndOfBuffer  = {},

    Boolean      = { fg = colors.base09 },
    Character    = { fg = colors.base08 },
    Comment      = { fg = colors.base03 },
    Conditional  = { fg = colors.base0E, bold = true },
    Constant     = { fg = colors.base09 },
    Define       = { fg = colors.base0E, bold = true },
    Delimiter    = { fg = colors.base05 },
    Float        = { fg = colors.base09 },
    Function     = { fg = colors.base0D },
    Identifier   = { fg = colors.base08 },
    Include      = { fg = colors.base0D },
    Keyword      = { fg = colors.base0E, italic = true },
    Label        = { fg = colors.base0A },
    Number       = { fg = colors.base09 },
    Operator     = { fg = colors.base05 },
    PreProc      = { fg = colors.base0A },
    Repeat       = { fg = colors.base0E, bold = true },
    Special      = { fg = colors.base0C },
    SpecialChar  = { fg = colors.base0C },
    Statement    = { fg = colors.base08 },
    StorageClass = { fg = colors.base0A },
    String       = { fg = colors.base0B },
    Structure    = { fg = colors.base0E, bold = true },
    Tag          = { fg = colors.base0A },
    Todo         = { fg = colors.base0A, bg = colors.base01 },
    Type         = { fg = colors.base0A },
    Typedef      = { fg = colors.base0A },

    -- Standard highlights to be used by plugins
    Deprecated  = { strikethrough = true },
    SearchMatch = { fg = colors.base0C },

    GitAddSign          = { fg = colors.base0B },
    GitChangeSign       = { fg = colors.base04 },
    GitDeleteSign       = { fg = colors.base08 },
    GitChangeDeleteSign = { fg = colors.base04 },

    ErrorSign   = { fg = colors.base08 },
    WarningSign = { fg = colors.base09 },
    InfoSign    = { fg = colors.base0D },
    HintSign    = { fg = colors.base0C },

    ErrorFloat   = { fg = colors.base08, bg = colors.base01 },
    WarningFloat = { fg = colors.base09, bg = colors.base01 },
    InfoFloat    = { fg = colors.base0D, bg = colors.base01 },
    HintFloat    = { fg = colors.base0C, bg = colors.base01 },

    ErrorHighlight   = { underline = true, sp = colors.base08 },
    WarningHighlight = { underline = true, sp = colors.base09 },
    InfoHighlight    = { underline = true, sp = colors.base0D },
    HintHighlight    = { underline = true, sp = colors.base0C },

    SpellBad   = { undercurl = true, sp = colors.base08 },
    SpellLocal = { undercurl = true, sp = colors.base0C },
    SpellCap   = { undercurl = true, sp = colors.base0D },
    SpellRare  = { undercurl = true, sp = colors.base0E },

    ReferenceText  = { fg = colors.base01, bg = colors.base0A },
    ReferenceRead  = { fg = colors.base01, bg = colors.base0B },
    ReferenceWrite = { fg = colors.base01, bg = colors.base08 },

    -- CMP Highlights
    CmpItemAbbrDeprecated    = { link = "Deprecated" },
    CmpItemAbbrMatch         = { link = "SearchMatch" },
    CmpItemAbbrMatchFuzzy    = { link = "SearchMatch" },
    CmpItemKindText          = { link = "@text" },
    CmpItemKindMethod        = { link = "@method" },
    CmpItemKindFunction      = { link = "@function" },
    CmpItemKindConstructor   = { link = "@constructor" },
    CmpItemKindField         = { link = "@field" },
    CmpItemKindVariable      = { link = "@variable" },
    CmpItemKindInterface     = { link = "@text" },
    CmpItemKindProperty      = { link = "@property" },
    CmpItemKindUnit          = { link = "@keyword" },
    CmpItemKindKeyword       = { link = "@keyword" },
    CmpItemKindConstant      = { link = "@constant" },
    CmpItemKindOperator      = { link = "@operator" },
    CmpItemKindTypeParameter = { link = "@type" },

    DiffAdd     = { bg = diff_colors.add.bg },
    DiffChange  = { bg = diff_colors.change.bg },
    DiffDelete  = { bg = diff_colors.delete.bg },
    DiffText    = { bg = diff_colors.diff.bg, bold = true },
    DiffAdded   = { bg = colors.base00 },
    DiffFile    = { fg = colors.base08, bg = colors.base00 },
    DiffNewFile = { fg = colors.base0B, bg = colors.base00 },
    DiffLine    = { fg = colors.base0D, bg = colors.base00 },
    DiffRemoved = { fg = colors.base08, bg = colors.base00 },

    GitSignsAdd    = { fg = diff_colors.add.fg },
    GitSignsChange = { fg = diff_colors.change.fg },
    GitSignsDelete = { fg = diff_colors.delete.fg },

    -- Git highlights
    gitcommitOverflow      = { fg = colors.base08 },
    gitcommitSummary       = { fg = colors.base0B },
    gitcommitComment       = { fg = colors.base03 },
    gitcommitUntracked     = { fg = colors.base03 },
    gitcommitDiscarded     = { fg = colors.base03 },
    gitcommitSelected      = { fg = colors.base03 },
    gitcommitHeader        = { fg = colors.base0E },
    gitcommitSelectedType  = { fg = colors.base0D },
    gitcommitUnmergedType  = { fg = colors.base0D },
    gitcommitDiscardedType = { fg = colors.base0D },
    gitcommitBranch        = { fg = colors.base09, bold = true },
    gitcommitUntrackedFile = { fg = colors.base0A },
    gitcommitUnmergedFile  = { fg = colors.base08, bold = true },
    gitcommitDiscardedFile = { fg = colors.base08, bold = true },
    gitcommitSelectedFile  = { fg = colors.base0B, bold = true },

    -- HTML highlights
    htmlBold   = { fg = colors.base05, bold = true },
    htmlItalic = { fg = colors.base05, italic = true },
    htmlEndTag = { fg = colors.base05 },
    htmlTag    = { fg = colors.base05 },

    -- Javascript highlights
    javaScript       = { fg = colors.base05 },
    javaScriptBraces = { fg = colors.base05 },
    javaScriptNumber = { fg = colors.base09 },

    -- Markdown highlights
    markdownCode             = { fg = colors.base0B },
    markdownError            = { fg = colors.base05, bg = colors.base00 },
    markdownCodeBlock        = { fg = colors.base0B },
    markdownHeadingDelimiter = { fg = colors.base0D },

    -- Python highlights
    pythonOperator  = { fg = colors.base0E },
    pythonRepeat    = { fg = colors.base0E },
    pythonInclude   = { fg = colors.base0E },
    pythonStatement = { fg = colors.base0E },

    -- C highlights
    cOperator  = { fg = colors.base0C },
    cPreCondit = { fg = colors.base0E },

    -- Ruby highlights
    rubyAttribute              = { fg = colors.base0D },
    rubyConstant               = { fg = colors.base0A },
    rubyInterpolationDelimiter = { fg = colors.base0F },
    rubyRegexp                 = { fg = colors.base0C },
    rubySymbol                 = { fg = colors.base0B },
    rubyStringDelimiter        = { fg = colors.base0B },

    -- Sass highlights
    sassidChar    = { fg = colors.base08 },
    sassClassChar = { fg = colors.base09 },
    sassInclude   = { fg = colors.base0E },
    sassMixing    = { fg = colors.base0E },
    sassMixinName = { fg = colors.base0D },

    -- Java highlights
    javaOperator = { fg = colors.base0D },


    -- LSP
    DiagnosticError = { link = "ErrorSign" },
    DiagnosticWarn  = { link = "WarningSign" },
    DiagnosticInfo  = { link = "InfoSign" },
    DiagnosticHint  = { link = "HintSign" },

    DiagnosticFloatingError = { link = "ErrorFloat" },
    DiagnosticFloatingWarn  = { link = "WarningFloat" },
    DiagnosticFloatingInfo  = { link = "InfoFloat" },
    DiagnosticFloatingHint  = { link = "HintFloat" },

    DiagnosticUnderlineError = { link = "ErrorHighlight" },
    DiagnosticUnderlineWarn  = { link = "WarningHighlight" },
    DiagnosticUnderlineInfo  = { link = "InfoHighlight" },
    DiagnosticUnderlineHint  = { link = "HintHighlight" },

    DiagnosticsVirtualTextError   = { link = "ErrorSign" },
    DiagnosticsVirtualTextWarning = { link = "WarningSign" },
    DiagnosticsVirtualTextInfo    = { link = "InfoSign" },
    DiagnosticsVirtualTextHint    = { link = "HintSign" },

    LspDiagnosticsSignError   = { link = "ErrorSign" },
    LspDiagnosticsSignWarning = { link = "WarningSign" },
    LspDiagnosticsSignInfo    = { link = "InfoSign" },
    LspDiagnosticsSignHint    = { link = "HintSign" },

    LspDiagnosticsVirtualTextError   = { link = "ErrorSign" },
    LspDiagnosticsVirtualTextWarning = { link = "WarningSign" },
    LspDiagnosticsVirtualTextInfo    = { link = "InfoSign" },
    LspDiagnosticsVirtualTextHint    = { link = "HintSign" },

    LspDiagnosticsFloatingError   = { link = "ErrorFloat" },
    LspDiagnosticsFloatingWarning = { link = "WarningFloat" },
    LspDiagnosticsFloatingInfo    = { link = "InfoFloat" },
    LspDiagnosticsFloatingHint    = { link = "HintFloat" },

    LspDiagnosticsUnderlineError   = { link = "ErrorHighlight" },
    LspDiagnosticsUnderlineWarning = { link = "WarningHighlight" },
    LspDiagnosticsUnderlineInfo    = { link = "InfoHighlight" },
    LspDiagnosticsUnderlineHint    = { link = "HintHighlight" },

    LspReferenceText  = { link = "ReferenceText" },
    LspReferenceRead  = { link = "ReferenceRead" },
    LspReferenceWrite = { link = "ReferenceWrite" },

    -- Treesitter highlights
    ["@preproc"]               = { link = "PreProc" },
    ["@define"]                = { link = "Define" },
    ["@string.special"]        = { link = "SpecialChar" },
    ["@character.special"]     = { link = "SpecialChar" },
    ["@text.math"]             = { link = "Number" },
    ["@text.environment"]      = { link = "Macro" },
    ["@text.environment.name"] = { link = "Type" },
    ["@text.todo"]             = { link = "Todo" },
    ["@text.note"]             = { link = "Tag" },
    ["@text.warning"]          = { link = "DiagnosticWarn" },
    ["@text.danger"]           = { link = "DiagnosticError" },
    ["@tag.attribute"]         = { link = "Attribute" },

    NvimInternalError = { fg = colors.base00, bg = colors.base08 },

    NormalFloat = {},
    FloatBorder = { fg = colors.base05 },
    TermCursor  = { fg = colors.base00, bg = colors.base05 },

    User1 = { fg = colors.base08, bg = colors.base02 },
    User2 = { fg = colors.base0E, bg = colors.base02 },
    User3 = { fg = colors.base05, bg = colors.base02 },
    User4 = { fg = colors.base0C, bg = colors.base02 },
    User5 = { fg = colors.base05, bg = colors.base02 },
    User6 = { fg = colors.base05, bg = colors.base02 },
    User7 = { fg = colors.base05, bg = colors.base02 },
    User8 = { fg = colors.base00, bg = colors.base02 },
    User9 = { fg = colors.base00, bg = colors.base02 },
  }

  for name, value in pairs(hi_config) do
    vim.api.nvim_set_hl(0, name, value)
  end
end

return M
