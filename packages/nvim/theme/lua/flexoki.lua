local M = {}

local base = {
  black   = '#100F0F',
  paper   = '#FFFCF0',
  ['950'] = '#1C1B1A',
  ['900'] = '#282726',
  ['850'] = '#343331',
  ['800'] = '#403E3C',
  ['700'] = '#575653',
  ['500'] = '#878580',
  ['300'] = '#B7B5AC',
  ['200'] = '#CECDC3',
  ['150'] = '#DAD8CE',
  ['100'] = '#E6E4D9',
  ['50']  = '#F2F0E5',
  re600   = '#AF3029', re400   = '#D14D41',
  or600   = '#BC5215', or400   = '#DA702C',
  ye600   = '#AD8301', ye400   = '#D0A215',
  gr600   = '#66800B', gr400   = '#879A39',
  cy600   = '#24837B', cy400   = '#3AA99F',
  bl600   = '#205EA6', bl400   = '#4385BE',
  pu600   = '#5E409D', pu400   = '#8B7EC8',
  ma600   = '#A02F6F', ma400   = '#CE5D97',
}

local palettes = {
  dark = {
    bg    = base.black,  bg2   = base['950'],
    ui    = base['900'], ui2   = base['850'], ui3   = base['800'],
    tx3   = base['700'], tx2   = base['500'], tx    = base['200'],
    re    = base.re400,  re2   = base.re600,
    or_   = base.or400,  or2   = base.or600,
    ye    = base.ye400,  ye2   = base.ye600,
    gr    = base.gr400,  gr2   = base.gr600,
    cy    = base.cy400,  cy2   = base.cy600,
    bl    = base.bl400,  bl2   = base.bl600,
    pu    = base.pu400,  pu2   = base.pu600,
    ma    = base.ma400,  ma2   = base.ma600,
  },
  light = {
    bg    = base.paper,  bg2   = base['50'],
    ui    = base['100'], ui2   = base['150'], ui3   = base['200'],
    tx3   = base['300'], tx2   = base['500'], tx    = base.black,
    re    = base.re600,  re2   = base.re400,
    or_   = base.or600,  or2   = base.or400,
    ye    = base.ye600,  ye2   = base.ye400,
    gr    = base.gr600,  gr2   = base.gr400,
    cy    = base.cy600,  cy2   = base.cy400,
    bl    = base.bl600,  bl2   = base.bl400,
    pu    = base.pu600,  pu2   = base.pu400,
    ma    = base.ma600,  ma2   = base.ma400,
  },
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

M.load = function(variant)
  local c = palettes[variant]

  vim.cmd('highlight clear')
  vim.o.termguicolors = true
  vim.opt.fillchars:append({ vert = '▕', horiz = '─' })

  -- base
  hl('Normal',          { fg = c.tx,   bg = 'NONE' })
  hl('NormalNC',        { fg = 'NONE', bg = 'NONE' })
  hl('NormalFloat',     { fg = c.tx2,  bg = 'NONE' })
  hl('FloatBorder',     { fg = c.tx3,  bg = 'NONE' })

  hl('Comment',         { fg = c.tx3 })
  hl('Conceal',         { fg = 'NONE' })
  hl('NonText',         { fg = c.tx3 })
  hl('EndOfBuffer',     { fg = 'NONE' })
  hl('Whitespace',      { fg = c.tx3 })

  hl('Constant',        { fg = c.ye })
  hl('String',          { fg = c.cy })
  hl('Character',       { fg = c.cy })
  hl('Number',          { fg = c.pu })
  hl('Boolean',         { fg = c.ma })
  hl('Float',           { fg = c.pu })

  hl('Identifier',      { fg = c.bl })
  hl('Function',        { fg = c.or_ })
  hl('Keyword',         { fg = c.gr })
  hl('Statement',       { fg = 'NONE' })
  hl('Conditional',     { link = 'Keyword' })
  hl('Repeat',          { link = 'Keyword' })
  hl('Label',           { link = 'Keyword' })
  hl('Operator',        { fg = c.tx2 })
  hl('Exception',       { link = 'Keyword' })

  hl('PreProc',         { fg = c.ma })
  hl('Include',         { fg = c.re })
  hl('Define',          { fg = c.ma })
  hl('Macro',           { fg = c.ma })
  hl('PreCondit',       { fg = c.ma })

  hl('Type',            { fg = c.gr })
  hl('StorageClass',    { fg = c.or_ })
  hl('Structure',       { fg = c.or_ })
  hl('Typedef',         { fg = c.or_ })

  hl('Special',         { fg = c.tx2 })
  hl('SpecialChar',     { fg = c.ma })
  hl('SpecialComment',  { fg = c.tx })
  hl('Tag',             { fg = c.cy })
  hl('Delimiter',       { link = 'Special' })
  hl('Debug',           { fg = c.ma })
  hl('Underlined',      { underline = true })
  hl('Bold',            { bold = true })
  hl('Italic',          { italic = true })
  hl('Error',           { fg = c.re, bold = true })
  hl('Todo',            { fg = c.ma, bold = true })

  -- search
  hl('Search',          { fg = c.tx,  bg = c.ye })
  hl('IncSearch',       { fg = c.tx,  bg = c.ye })
  hl('CurSearch',       { fg = c.tx,  bg = c.ye2 })
  hl('Substitute',      { fg = c.tx,  bg = c.gr })

  -- diff
  hl('DiffAdd',         { fg = c.bg,  bg = c.gr })
  hl('DiffChange',      { fg = c.bg2, bg = c.pu })
  hl('DiffDelete',      { fg = c.bg2, bg = c.re })
  hl('DiffText',        { fg = c.bg,  bg = c.bl2 })
  hl('Added',           { fg = c.gr })
  hl('Removed',         { fg = c.re })
  hl('Changed',         { fg = c.or_ })

  -- spell
  hl('SpellBad',        { fg = c.re2, underline = true })
  hl('SpellCap',        { fg = c.ye,  underline = true })
  hl('SpellLocal',      { fg = c.gr,  underline = true })
  hl('SpellRare',       { fg = c.pu,  underline = true })

  -- ui
  hl('SignColumn',      { fg = 'NONE', bg = 'NONE' })
  hl('LineNr',          { fg = c.tx3 })
  hl('CursorLine',      { bg = c.ui })
  hl('CursorLineNr',    { fg = c.tx, bold = true })
  hl('CursorColumn',    { bg = c.bg2 })
  hl('ColorColumn',     { bg = c.ui })
  hl('Cursor',          { fg = c.bg, bg = c.tx })
  hl('Visual',          { bg = c.ui2 })
  hl('VisualNOS',       { bg = c.ui3 })

  hl('Pmenu',           { fg = c.tx2, bg = c.bg2 })
  hl('PmenuSel',        { fg = c.tx,  bg = c.cy2 })
  hl('PmenuSbar',       { bg = c.ui })
  hl('PmenuThumb',      { bg = c.ui3 })

  hl('StatusLine',      { fg = c.tx,  bg = 'NONE', underline = true, bold = true })
  hl('StatusLineNC',    { fg = c.tx3, bg = 'NONE', underline = true })
  hl('WinSeparator',    { fg = c.ui3 })

  hl('TabLine',         { fg = c.tx2, bg = c.ui })
  hl('TabLineSel',      { fg = c.tx,  bg = c.ui3 })
  hl('TabLineFill',     { bg = c.ui })

  hl('Folded',          { fg = c.ui2 })
  hl('FoldColumn',      { fg = c.ui2 })
  hl('Directory',       { fg = c.bl })
  hl('Title',           { fg = c.bl,  bold = true })
  hl('MatchParen',      { bg = c.ui })

  hl('MsgArea',         { bg = c.ui })
  hl('ModeMsg',         { bg = c.bg2 })
  hl('MsgSeparator',    { bg = c.bg2 })
  hl('MoreMsg',         { fg = c.or_ })
  hl('Question',        { fg = c.or_ })
  hl('ErrorMsg',        { fg = c.re2, bold = true })
  hl('WarningMsg',      { fg = c.re,  bg = c.bg })
  hl('WildMenu',        { bg = c.cy2 })
  hl('QuickFixLine',    { bg = c.ui })

  -- diagnostics
  hl('DiagnosticError', { fg = c.re })
  hl('DiagnosticWarn',  { fg = c.ye })
  hl('DiagnosticInfo',  { fg = c.cy })
  hl('DiagnosticHint',  { fg = c.bl })
  hl('DiagnosticOk',    { fg = c.gr })

  -- gitsigns
  hl('GitSignsAdd',     { fg = c.gr })
  hl('GitSignsChange',  { fg = c.or_ })
  hl('GitSignsDelete',  { fg = c.re })

  -- treesitter (modern capture names, 0.9+)
  hl('@variable',               { link = 'Identifier' })
  hl('@variable.parameter',     { link = 'Identifier' })
  hl('@variable.member',        { link = 'Identifier' })
  hl('@module',                 { link = 'Identifier' })
  hl('@constant',               { link = 'Constant' })
  hl('@constant.builtin',       { link = 'Special' })
  hl('@constant.macro',         { link = 'Define' })
  hl('@string',                 { link = 'String' })
  hl('@string.escape',          { link = 'SpecialChar' })
  hl('@string.special',         { link = 'SpecialChar' })
  hl('@character',              { link = 'Character' })
  hl('@character.special',      { link = 'SpecialChar' })
  hl('@number',                 { link = 'Number' })
  hl('@number.float',           { link = 'Float' })
  hl('@boolean',                { link = 'Boolean' })
  hl('@type',                   { link = 'Type' })
  hl('@type.definition',        { link = 'Typedef' })
  hl('@type.builtin',           { link = 'Type' })
  hl('@attribute',              { link = 'PreProc' })
  hl('@function',               { link = 'Function' })
  hl('@function.builtin',       { link = 'Special' })
  hl('@function.macro',         { link = 'Macro' })
  hl('@function.method',        { link = 'Function' })
  hl('@constructor',            { link = 'Special' })
  hl('@operator',               { link = 'Operator' })
  hl('@keyword',                { link = 'Keyword' })
  hl('@keyword.import',         { link = 'Include' })
  hl('@keyword.exception',      { link = 'Exception' })
  hl('@punctuation',            { link = 'Delimiter' })
  hl('@comment',                { link = 'Comment' })
  hl('@tag',                    { link = 'Tag' })
  hl('@markup.heading',         { link = 'Title' })
  hl('@markup.link',            { link = 'Underlined' })
  hl('@markup.raw',             { link = 'String' })

  -- markdown
  hl('markdownH1',                 { fg = c.bl, bold = true })
  hl('markdownH2',                 { fg = c.bl, bold = true })
  hl('markdownH3',                 { fg = c.bl })
  hl('markdownH4',                 { fg = c.bl })
  hl('markdownH5',                 { fg = c.bl })
  hl('markdownH6',                 { fg = c.bl })
  hl('markdownHeadingDelimiter',   { fg = c.bl })
  hl('markdownCode',               { fg = c.or_ })
  hl('markdownCodeBlock',          { fg = c.or_ })
  hl('markdownCodeDelimiter',      { fg = c.or_ })
  hl('markdownBlockquote',         { fg = c.gr })
  hl('markdownBold',               { fg = c.bl,  bold = true })
  hl('markdownItalic',             { italic = true })
  hl('markdownBoldItalic',         { fg = c.ye,  bold = true, italic = true })
  hl('markdownUrl',                { fg = c.cy,  underline = true })
  hl('markdownLinkText',           { fg = c.bl })
  hl('markdownListMarker',         { fg = c.bl })
  hl('markdownOrderedListMarker',  { fg = c.bl })
  hl('markdownId',                 { fg = c.pu })
  hl('markdownIdDeclaration',      { fg = c.bl })
end

return M
