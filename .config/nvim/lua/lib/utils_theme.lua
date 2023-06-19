local M = {}

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
-- @param status_colors (table) table with keys "info_fg", "success",
-- "success_fg", "warn", "warn_fg", "error", "error_fg".
--   Each key should map to a valid 6 digit hex color.
--
-- @framework (cf. https://github.com/tinted-theming/home/blob/main/styling.md)
-- ```txt
-- base00 - Default Background
-- base01 - Lighter Background (Used for status bars, line number and folding marks)
-- base02 - Visual selections background
-- base03 - Comments, Invisibles, Line Highlighting
-- base04 - Foreground (Used for status bars)
-- base05 - Default Foreground, Caret, Delimiters, Operators
-- base06 - Light Foreground (Not often used)
-- base07 - Light Background for search text
-- base08 - Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
-- base09 - Integers, Boolean, Constants, XML Attributes, Markup Link Url
-- base0A - Classes, Markup Bold
-- base0B - Strings, Inherited Class, Markup Code, Diff Inserted
-- base0C - Support, Regular Expressions, Escape Characters, Markup Quotes, Errors
-- base0D - Functions, Methods, Attribute IDs, Headings
-- base0E - Keywords, Storage, Selector, Markup Italic, Diff Changed
-- base0F - Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
-- ```
--
-- @example
-- ```lua
-- setup_theme.setup(
--   {
--     base00 = "#16161D", base01 = "#2c313c", base02 = "#3e4451", base03 = "#6c7891",
--     base04 = "#565c64", base05 = "#abb2bf", base06 = "#9a9bb3", base07 = "#c5c8e6",
--     base08 = "#e06c75", base09 = "#d19a66", base0A = "#e5c07b", base0B = "#98c379",
--     base0C = "#56b6c2", base0D = "#0184bc", base0E = "#c678dd", base0F = "#a06949",
--   },
--   {
--     info_fg = "#75beff",
--     success = "#d4f8db",
--     success_fg = "#22863a",
--     warn = "#fff5b1",
--     warn_fg = "#e36209",
--     error = "#fae5e7",
--     error_fg = "#d73a49",
--   }
-- )
-- ```
function M.setup_theme(colors, status_colors)
  -- Clear predefined colors or background
  if vim.fn.exists("syntax_on") ~= 0 then
    vim.cmd("syntax reset")
  end

  local hi_config = {
    -- Vim editor highlights
    Normal                        = { fg = colors.base05, bg = colors.base00, ctermbg = false },
    Bold                          = { bold = true },
    Debug                         = { fg = colors.base08 },
    Directory                     = { fg = colors.base0D },
    Error                         = { fg = status_colors.error_fg },
    ErrorMsg                      = { fg = status_colors.error_fg },
    Exception                     = { fg = colors.base08 },
    FoldColumn                    = { fg = colors.base05, bg = colors.base01, },
    Folded                        = { fg = colors.base05, bg = colors.base01, },
    IncSearch                     = { fg = colors.base01, bg = colors.base09 },
    Italic                        = { italic = true },
    Macro                         = { fg = colors.base08 },
    MatchParen                    = { bg = colors.base03 },
    ModeMsg                       = { fg = colors.base0B },
    MoreMsg                       = { fg = colors.base0B },
    Question                      = { fg = colors.base0D },
    Search                        = { bold = true, fg = colors.base05, bg = colors.base07 },
    Substitute                    = { fg = colors.base00, bg = colors.base0A },
    SpecialKey                    = { fg = colors.base03 },
    TooLong                       = { fg = colors.base08 },
    Underlined                    = { fg = colors.base08, underline = true },
    Visual                        = { bg = colors.base02 },
    VisualNOS                     = { fg = colors.base08 },
    WarningMsg                    = { fg = status_colors.warn_fg },
    WildMenu                      = { fg = colors.base00, bg = colors.base05 },
    Title                         = { fg = colors.base0D, bold = true },
    Conceal                       = { fg = colors.base0D, bg = colors.base00 },
    Cursor                        = { fg = colors.base05, bg = colors.base00, reverse = true },
    NonText                       = { fg = colors.base03 },
    Whitespace                    = { fg = colors.base03 },
    LineNr                        = { fg = colors.base03, bg = colors.base01 },
    SignColumn                    = { fg = colors.base03, bg = colors.base01 },
    StatusLine                    = { fg = colors.base04, bg = colors.base01 },
    StatusLineNC                  = { fg = colors.base03, bg = colors.base01 },
    StatusLineLspError            = { fg = status_colors.error_fg, bg = status_colors.error },
    StatusLineLspWarn             = { fg = status_colors.warn_fg, bg = status_colors.warn },
    StatusLineLspInfo             = { fg = status_colors.info_fg, bg = status_colors.info },
    StatusLineLspHint             = { fg = status_colors.info_fg, bg = status_colors.info },
    WinBar                        = { fg = colors.base03 },
    WinBarNC                      = { fg = colors.base04 },
    WinSeparator                  = { fg = colors.base03 },
    ColorColumn                   = { bg = colors.base01 },
    CursorColumn                  = { bg = colors.base01 },
    CursorLine                    = { bg = colors.base01 },
    CursorLineNr                  = { fg = colors.base05, bg = colors.base01, bold = true },
    QuickFixLine                  = { bg = colors.base01 },
    PMenu                         = { fg = colors.base05, bg = colors.base01 },
    PMenuSel                      = { fg = colors.base00, bg = colors.base05 },
    TabLine                       = { fg = colors.base03, bg = colors.base01 },
    TabLineFill                   = { fg = colors.base03, bg = colors.base01 },
    TabLineSel                    = { fg = colors.base0B, bg = colors.base01 },
    EndOfBuffer                   = {},
    Boolean                       = { fg = colors.base09 },
    Character                     = { fg = colors.base08 },
    Comment                       = { fg = colors.base03 },
    Conditional                   = { fg = colors.base0E },
    Constant                      = { fg = colors.base09 },
    Define                        = { fg = colors.base0E, bold = true },
    Delimiter                     = { fg = colors.base05 },
    Float                         = { fg = colors.base09 },
    Function                      = { fg = colors.base0D },
    Identifier                    = { fg = colors.base08 },
    Include                       = { fg = colors.base0D },
    Keyword                       = { fg = colors.base0E, italic = true },
    Label                         = { fg = colors.base0A },
    Number                        = { fg = colors.base09 },
    Operator                      = { fg = colors.base05 },
    PreProc                       = { fg = colors.base0A },
    Repeat                        = { fg = colors.base0E, bold = true },
    Special                       = { fg = colors.base0C },
    SpecialChar                   = { fg = colors.base0C },
    Statement                     = { fg = colors.base08 },
    StorageClass                  = { fg = colors.base0A },
    String                        = { fg = colors.base0B },
    Structure                     = { fg = colors.base0E, bold = true },
    Tag                           = { fg = colors.base0A },
    Todo                          = { fg = colors.base0A, bg = colors.base01 },
    Type                          = { fg = colors.base0A },
    Typedef                       = { fg = colors.base0A },
    -- Standard highlights to be used by plugins
    Deprecated                    = { strikethrough = true },
    SearchMatch                   = { fg = colors.base0C },
    GitAddSign                    = { fg = colors.base0B, bg = colors.base00 },
    ErrorSign                     = { fg = status_colors.error_fg },
    WarningSign                   = { fg = status_colors.warn_fg },
    InfoSign                      = { fg = status_colors.info_fg },
    HintSign                      = { fg = status_colors.info_fg },
    ErrorFloat                    = { fg = status_colors.error_fg },
    WarningFloat                  = { fg = status_colors.warn_fg },
    InfoFloat                     = { fg = status_colors.info_fg },
    HintFloat                     = { fg = status_colors.info_fg },
    ErrorHighlight                = { underline = true, sp = status_colors.error_fg },
    WarningHighlight              = { underline = true, sp = status_colors.warn_fg },
    InfoHighlight                 = { underline = true, sp = status_colors.info_fg },
    HintHighlight                 = { underline = true, sp = status_colors.info_fg },
    SpellBad                      = { undercurl = true, sp = status_colors.error_fg },
    SpellLocal                    = { undercurl = true, sp = colors.base0C },
    SpellCap                      = { undercurl = true, sp = colors.base0D },
    SpellRare                     = { undercurl = true, sp = colors.base0E },
    ReferenceText                 = { fg = colors.base00, bg = colors.base0A },
    ReferenceRead                 = { fg = colors.base00, bg = colors.base0B },
    ReferenceWrite                = { fg = colors.base00, bg = colors.base08 },
    -- CMP Highlights
    CmpItemAbbrDeprecated         = { link = "Deprecated" },
    CmpItemAbbrMatch              = { link = "SearchMatch" },
    CmpItemAbbrMatchFuzzy         = { link = "SearchMatch" },
    CmpItemKindText               = { link = "@text" },
    CmpItemKindMethod             = { link = "@method" },
    CmpItemKindFunction           = { link = "@function" },
    CmpItemKindConstructor        = { link = "@constructor" },
    CmpItemKindField              = { link = "@field" },
    CmpItemKindVariable           = { link = "@variable" },
    CmpItemKindInterface          = { link = "@text" },
    CmpItemKindProperty           = { link = "@property" },
    CmpItemKindUnit               = { link = "@keyword" },
    CmpItemKindKeyword            = { link = "@keyword" },
    CmpItemKindConstant           = { link = "@constant" },
    CmpItemKindOperator           = { link = "@operator" },
    CmpItemKindTypeParameter      = { link = "@type" },
    DiffAdd                       = { bg = status_colors.success },
    DiffDelete                    = { bg = status_colors.error },
    DiffChange                    = { bg = status_colors.warn },
    DiffText                      = { bg = status_colors.warn, bold = true },
    DiffAdded                     = { bg = status_colors.success },
    DiffFile                      = { fg = status_colors.warn_fg, bg = status_colors.warn },
    DiffNewFile                   = { fg = status_colors.success_fg, bg = status_colors.success },
    DiffLine                      = { fg = status_colors.warn_fg, bg = status_colors.warn },
    DiffRemoved                   = { fg = status_colors.error_fg, bg = status_colors.error },
    GitSignsAdd                   = { fg = status_colors.success_fg, bg = colors.base00 },
    GitSignsChange                = { fg = status_colors.warn_fg, bg = colors.base00 },
    GitSignsDelete                = { fg = status_colors.error_fg, bg = colors.base00 },
    GitSignsAddNr                 = { bg = status_colors.success },
    GitSignsChangeNr              = { bg = status_colors.warn },
    GitSignsDeleteNr              = { bg = status_colors.error },
    -- Git highlights
    gitcommitOverflow             = { fg = colors.base08 },
    gitcommitSummary              = { fg = colors.base0B },
    gitcommitComment              = { fg = colors.base03 },
    gitcommitUntracked            = { fg = colors.base03 },
    gitcommitDiscarded            = { fg = colors.base03 },
    gitcommitSelected             = { fg = colors.base03 },
    gitcommitHeader               = { fg = colors.base0E },
    gitcommitSelectedType         = { fg = colors.base0D },
    gitcommitUnmergedType         = { fg = colors.base0D },
    gitcommitDiscardedType        = { fg = colors.base0D },
    gitcommitBranch               = { fg = colors.base09, bold = true },
    gitcommitUntrackedFile        = { fg = colors.base0A },
    gitcommitUnmergedFile         = { fg = colors.base08, bold = true },
    gitcommitDiscardedFile        = { fg = colors.base08, bold = true },
    gitcommitSelectedFile         = { fg = colors.base0B, bold = true },
    -- HTML highlights
    htmlBold                      = { fg = colors.base05, bold = true },
    htmlItalic                    = { fg = colors.base05, italic = true },
    htmlEndTag                    = { fg = colors.base05 },
    htmlTag                       = { fg = colors.base05 },
    -- Javascript highlights
    javaScript                    = { fg = colors.base05 },
    javaScriptBraces              = { fg = colors.base05 },
    javaScriptNumber              = { fg = colors.base09 },
    -- Markdown highlights
    markdownCode                  = { fg = colors.base0B },
    markdownError                 = { link = "ErrorHighlight" },
    markdownCodeBlock             = { fg = colors.base0B },
    markdownHeadingDelimiter      = { fg = colors.base0D },
    -- Python highlights
    pythonOperator                = { fg = colors.base0E },
    pythonRepeat                  = { fg = colors.base0E },
    pythonInclude                 = { fg = colors.base0E },
    pythonStatement               = { fg = colors.base0E },
    -- C highlights
    cOperator                     = { fg = colors.base0C },
    cPreCondit                    = { fg = colors.base0E },
    -- Ruby highlights
    rubyAttribute                 = { fg = colors.base0D },
    rubyConstant                  = { fg = colors.base0A },
    rubyInterpolationDelimiter    = { fg = colors.base0F },
    rubyRegexp                    = { fg = colors.base0C },
    rubySymbol                    = { fg = colors.base0B },
    rubyStringDelimiter           = { fg = colors.base0B },
    -- Sass highlights
    sassidChar                    = { fg = colors.base08 },
    sassClassChar                 = { fg = colors.base09 },
    sassInclude                   = { fg = colors.base0E },
    sassMixing                    = { fg = colors.base0E },
    sassMixinName                 = { fg = colors.base0D },
    -- Java highlights
    javaOperator                  = { fg = colors.base0D },
    -- LSP
    DiagnosticError               = { link = "ErrorSign" },
    DiagnosticWarn                = { link = "WarningSign" },
    DiagnosticInfo                = { link = "InfoSign" },
    DiagnosticHint                = { link = "HintSign" },
    DiagnosticFloatingError       = { link = "ErrorFloat" },
    DiagnosticFloatingWarn        = { link = "WarningFloat" },
    DiagnosticFloatingInfo        = { link = "InfoFloat" },
    DiagnosticFloatingHint        = { link = "HintFloat" },
    DiagnosticSignError           = { fg = status_colors.error_fg, bg = colors.base01 },
    DiagnosticSignWarn            = { fg = status_colors.warn_fg, bg = colors.base01 },
    DiagnosticSignInfo            = { fg = status_colors.info_fg, bg = colors.base01 },
    DiagnosticSignHint            = { fg = status_colors.hint_fg, bg = colors.base01 },
    DiagnosticUnderlineError      = { link = "ErrorHighlight" },
    DiagnosticUnderlineWarn       = { link = "WarningHighlight" },
    DiagnosticUnderlineInfo       = { link = "InfoHighlight" },
    DiagnosticUnderlineHint       = { link = "HintHighlight" },
    DiagnosticsVirtualTextError   = { link = "ErrorSign" },
    DiagnosticsVirtualTextWarning = { link = "WarningSign" },
    DiagnosticsVirtualTextInfo    = { link = "InfoSign" },
    DiagnosticsVirtualTextHint    = { link = "HintSign" },
    LspReferenceText              = { link = "ReferenceText" },
    LspReferenceRead              = { link = "ReferenceRead" },
    LspReferenceWrite             = { link = "ReferenceWrite" },
    -- Treesitter highlights
    ["@error"]                    = { link = "Error" },
    ["@preproc"]                  = { link = "PreProc" },
    ["@define"]                   = { link = "Define" },
    ["@string.special"]           = { link = "SpecialChar" },
    ["@character.special"]        = { link = "SpecialChar" },
    ["@text.quote"]               = { italic = true, fg = colors.base0C },
    ["@text.strong"]              = { link = "Bold" },
    ["@text.emphasis"]            = { link = "Italic" },
    ["@text.underline"]           = { link = "Underlined" },
    ["@text.strike"]              = { strikethrough = true },
    ["@text.math"]                = { link = "Number" },
    ["@text.environment"]         = { link = "Macro" },
    ["@text.environment.name"]    = { link = "Type" },
    ["@text.todo"]                = { link = "Todo" },
    ["@text.note"]                = { link = "Tag" },
    ["@text.warning"]             = { link = "DiagnosticWarn" },
    ["@text.danger"]              = { link = "DiagnosticError" },
    ["@tag.attribute"]            = { link = "Attribute" },
    -- LSP highlights
    ['@lsp.type.namespace']       = { link = '@namespace' },
    ['@lsp.type.type']            = { link = '@type' },
    ['@lsp.type.class']           = { link = '@type' },
    ['@lsp.type.enum']            = { link = '@type' },
    ['@lsp.type.interface']       = { link = '@type' },
    ['@lsp.type.struct']          = { link = '@structure' },
    ['@lsp.type.parameter']       = { link = '@parameter' },
    ['@lsp.type.variable']        = { link = '@variable' },
    ['@lsp.type.property']        = { link = '@property' },
    ['@lsp.type.enumMember']      = { link = '@constant' },
    ['@lsp.type.function']        = { link = '@function' },
    ['@lsp.type.method']          = { link = '@method' },
    ['@lsp.type.macro']           = { link = '@macro' },
    ['@lsp.type.decorator']       = { link = '@function' },
    NvimInternalError             = { fg = colors.base00, bg = colors.base08 },
    NormalFloat                   = {},
    FloatBorder                   = { fg = colors.base05 },
    TermCursor                    = { fg = colors.base00, bg = colors.base05 },
    User1                         = { fg = colors.base08, bg = colors.base02 },
    User2                         = { fg = colors.base0E, bg = colors.base02 },
    User3                         = { fg = colors.base05, bg = colors.base02 },
    User4                         = { fg = colors.base0C, bg = colors.base02 },
    User5                         = { fg = colors.base05, bg = colors.base02 },
    User6                         = { fg = colors.base05, bg = colors.base02 },
    User7                         = { fg = colors.base05, bg = colors.base02 },
    User8                         = { fg = colors.base00, bg = colors.base02 },
    User9                         = { fg = colors.base00, bg = colors.base02 },
  }

  for name, value in pairs(hi_config) do
    value.ctermfg = value.ctermfg or (value.ctermfg ~= false and value.fg) or nil
    value.ctermbg = value.ctermbg or (value.ctermbg ~= false and value.bg) or nil
    vim.api.nvim_set_hl(0, name, value)
  end
end

return M
