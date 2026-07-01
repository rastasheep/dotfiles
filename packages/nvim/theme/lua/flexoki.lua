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

  hl('Conceal',         { fg = 'NONE' })
  hl('NonText',         { fg = c.tx3 })
  hl('EndOfBuffer',     { fg = 'NONE' })
  hl('Whitespace',      { fg = c.tx3 })

  -- syntax: only data (strings/numbers/constants) get color; everything else is default text
  -- definition sites are colored via LSP semantic tokens below, not treesitter
  hl('Comment',        { fg = c.ye })
  hl('String',         { fg = c.cy })
  hl('Character',      { fg = c.pu })
  hl('Number',         { fg = c.pu })
  hl('Float',          { fg = c.pu })
  hl('Boolean',        { fg = c.pu })
  hl('Constant',       { fg = c.or_ })

  hl('Function',       { fg = c.tx })
  hl('Identifier',     { fg = c.tx })
  hl('Keyword',        { fg = c.tx })
  hl('Statement',      { fg = c.tx })
  hl('Conditional',    { fg = c.tx })
  hl('Repeat',         { fg = c.tx })
  hl('Label',          { fg = c.tx })
  hl('Operator',       { fg = c.tx2 })
  hl('Exception',      { fg = c.tx })

  hl('Type',           { fg = c.tx })
  hl('StorageClass',   { fg = c.tx })
  hl('Structure',      { fg = c.tx })
  hl('Typedef',        { fg = c.tx })

  hl('PreProc',        { fg = c.tx })
  hl('Include',        { fg = c.tx })
  hl('Define',         { fg = c.tx })
  hl('Macro',          { fg = c.tx })
  hl('PreCondit',      { fg = c.tx })

  hl('Special',        { fg = c.tx2 })
  hl('SpecialChar',    { fg = c.tx2 })
  hl('SpecialComment', { link = 'Comment' })
  hl('Tag',            { fg = c.cy })
  hl('Delimiter',      { fg = c.tx2 })
  hl('Debug',          { fg = c.re })
  hl('Underlined',     { underline = true })
  hl('Bold',           { bold = true })
  hl('Italic',         { italic = true })
  hl('Error',          { fg = c.re, bold = true })
  hl('Todo',           { fg = c.or_, bold = true })

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

  -- treesitter: data gets color, everything else is default text
  -- treesitter cannot distinguish definition from usage, so no color on function/type
  -- definition-site color comes from LSP semantic tokens (@lsp.typemod.*) below
  hl('@comment',                { link = 'Comment' })
  hl('@string',                 { link = 'String' })
  hl('@string.escape',          { fg = c.tx2 })
  hl('@string.special',         { fg = c.tx2 })
  hl('@character',              { link = 'Character' })
  hl('@character.special',      { fg = c.tx2 })
  hl('@number',                 { link = 'Number' })
  hl('@number.float',           { link = 'Float' })
  hl('@boolean',                { link = 'Boolean' })
  hl('@constant',               { link = 'Constant' })
  hl('@constant.builtin',       { link = 'Constant' })
  hl('@constant.macro',         { fg = c.tx })
  hl('@function',               { fg = c.tx })
  hl('@function.method',        { fg = c.tx })
  hl('@function.builtin',       { fg = c.tx })
  hl('@function.macro',         { fg = c.tx })
  hl('@constructor',            { fg = c.tx })
  hl('@variable',               { fg = c.tx })
  hl('@variable.parameter',     { fg = c.tx })
  hl('@variable.member',        { fg = c.tx })
  hl('@variable.unused',        { fg = c.tx3 })
  hl('@module',                 { fg = c.tx })
  hl('@type',                   { fg = c.tx })
  hl('@type.definition',        { fg = c.tx })
  hl('@type.builtin',           { fg = c.tx })
  hl('@attribute',              { fg = c.tx2 })
  hl('@operator',               { fg = c.tx2 })
  hl('@keyword',                { fg = c.tx })
  hl('@keyword.import',         { fg = c.tx })
  hl('@keyword.exception',      { fg = c.tx })
  hl('@punctuation',            { fg = c.tx2 })
  hl('@tag',                    { link = 'Tag' })
  hl('@markup.heading',         { link = 'Title' })
  hl('@markup.link',            { link = 'Underlined' })
  hl('@markup.raw',             { link = 'String' })

  -- lsp semantic tokens: neutralize all types to default first, then color declaration sites
  -- ts_ls token types: class, enum, interface, namespace, typeParameter, type,
  --                    parameter, variable, enumMember, property, function, member
  -- ts_ls modifiers: declaration, static, async, readonly, defaultLibrary, local
  hl('@lsp.type.function',                     { fg = c.tx })
  hl('@lsp.type.member',                       { fg = c.tx })
  hl('@lsp.type.variable',                     { fg = c.tx })
  hl('@lsp.type.parameter',                    { fg = c.tx })
  hl('@lsp.type.property',                     { fg = c.tx })
  hl('@lsp.type.enumMember',                   { fg = c.tx })
  hl('@lsp.type.interface',                    { fg = c.tx })
  hl('@lsp.type.class',                        { fg = c.tx })
  hl('@lsp.type.enum',                         { fg = c.tx })
  hl('@lsp.type.type',                         { fg = c.tx })
  hl('@lsp.type.typeParameter',                { fg = c.tx })
  hl('@lsp.type.namespace',                    { fg = c.tx })
  -- declaration sites get blue
  hl('@lsp.typemod.function.declaration',      { fg = c.bl })
  hl('@lsp.typemod.member.declaration',        { fg = c.bl })
  hl('@lsp.typemod.class.declaration',         { fg = c.bl })
  hl('@lsp.typemod.interface.declaration',     { fg = c.bl })
  hl('@lsp.typemod.enum.declaration',          { fg = c.bl })
  hl('@lsp.typemod.type.declaration',          { fg = c.bl })
  hl('@lsp.typemod.namespace.declaration',     { fg = c.bl })

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
