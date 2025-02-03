-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

--
-- settings
--

vim.o.mouse = ''
vim.o.undofile = false
vim.o.undolevels = 1000
vim.o.history = 1000
vim.o.backup = false --  no backup before overwriting a file
vim.o.writebackup = false --  no backups when writing a file
vim.o.swapfile = false -- no swapfiles
vim.o.autowrite = true --  Automatically :write before running commands

vim.o.number = true
vim.o.statusline = '%#identifier#%f%M'

vim.o.tabstop = 2 --  Number of spaces a <TAB> is
vim.o.softtabstop = 2 --  Fine tunes the amount of white space to be added
vim.o.shiftwidth = 2 --  Number of spaces for indentation
vim.o.shiftround = true
vim.o.expandtab = true --  Expand tab to spaces
vim.o.smarttab = true --  <TAB> in front of line inserts blanks according to shiftwidth
vim.o.autoindent = true --  copy indent from current line
vim.o.smartindent = true --  do smart indenting when starting a new line
vim.o.backspace = 'indent,eol,start' -- allow backspacing over autoindent, line breaks, the start of insert

vim.o.laststatus = 2 -- Always show the statusline
vim.g.title = true
vim.g.hidden = true
vim.o.visualbell = false --  don't display visual bell
vim.o.errorbells = false --  No sound
vim.o.timeoutlen = 500 --  Wait less time for mapped sequences

vim.g.background = 'dark'
vim.cmd('colorscheme flexoki-dark') -- set colorscheme
vim.cmd('highlight clear VertSplit') -- remove vsplit divider background
vim.cmd('highlight Normal guibg=none') -- remove background color

vim.o.list = true
vim.o.listchars = [[tab:¦\ ,trail:⋅,conceal:┊,extends:❯,precedes:❮]] --  Display extra whitespace

vim.o.showbreak = '↪ ' --  string to put at the start of lines that have been wrapped
vim.o.breakindent = true --  every wrapped line will continue visually indented
vim.o.linebreak = true --  wrap long lines at a character in breakat
vim.o.wrap = true --  lines longer than the width of the window will not wrap

vim.o.confirm = true

vim.o.encoding = 'utf-8' -- Default file encoding displayed
vim.o.fileencoding = 'utf-8' --  Default file encoding written

vim.o.modeline = false --  no lines are checked for set commands

vim.o.shortmess = 'filnxtToOfcI' --  Shut off completion and intro messages
-- vim.o.shortmess = 'atToOI'

vim.o.scrolloff = 10 --  show lines above and below
vim.o.lazyredraw = true --  redraw only when we need to.

vim.o.showmatch = true --  highlight matching [{()}]
vim.o.hlsearch = true --  highlight matches
vim.o.incsearch = true --  search as characters are entered
vim.o.inccommand = 'split' --  live search and replace
vim.o.ignorecase = true --  Ignore case when searching
vim.o.smartcase = true --  When searching try to be smart about cases
vim.o.magic = true
vim.opt.matchpairs = '(:),{:},[:],<:>'

vim.g.netrw_localrmdir = 'rm -rf' -- allow removal of non empty folders
vim.g.netrw_banner = 0 -- no banner
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3

vim.api.nvim_create_autocmd({ 'BufWritePre' }, { pattern = { '*' }, command = [[%s/\s\+$//e]] }) -- Remove trailing whitespace

vim.api.nvim_create_user_command('W', 'w', {}) -- save real fast
vim.api.nvim_create_user_command('Q', 'q', { bang = true }) -- quit real fast
vim.api.nvim_create_user_command('Wq', 'wq', {}) -- save quit real fast
vim.api.nvim_create_user_command('E', 'Explore', {}) -- use netrw for browsing

vim.api.nvim_set_keymap('n', 'Y', 'yy', { silent = true, noremap = true }) -- copy whole line

vim.api.nvim_set_keymap('n', '<leader>\\', ':vs<cr>', { silent = true, noremap = true }) -- vertical split - <leader>\
vim.api.nvim_set_keymap('n', '<leader>-', ':split<cr>', { silent = true, noremap = true }) -- horisontal split - <leader>-
vim.api.nvim_set_keymap('n', '<leader>1', ':e ~/.config/nvim/init.lua<cr>', { silent = true, noremap = true }) -- edit config - <leader>1

-- Indent/move visual selected without unselecting
vim.api.nvim_set_keymap('v', '>', '>gv', { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', 'J', [[:m '>+1<cr>gv=gv]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', 'K', [[:m '<-2<cr>gv=gv]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '=', '=gv', { silent = true, noremap = true })

-- Base 64 encode/decode in visual mode
vim.api.nvim_set_keymap('v', '<leader>en', [[c<c-r>=system('base64', @")<cr><esc>]], { silent = true, noremap = true })
vim.api.nvim_set_keymap('v', '<leader>de', [[c<c-r>=system('base64 --decode', @")<cr><esc>]], { silent = true, noremap = true })

--
-- plugins
--

-- fzf
-- fzf tip: shift+tab selects multiple items

require'fzf-lua'.setup({
  grep = {
    cmd = 'ag -S --noheading --column --color --nobreak --hidden',
  }
})
vim.api.nvim_set_keymap('n', '<leader>t', ':FzfLua git_files<cr>', { silent = true, noremap = true }) -- find files via fzf
vim.api.nvim_set_keymap('n', '<leader>l', ':FzfLua buffers<cr>', { silent = true, noremap = true }) -- list buffers via fzf
vim.api.nvim_set_keymap('n', '<leader>a', ':FzfLua live_grep resume=true<cr>', { silent = true, noremap = true }) -- search for a pattern
vim.api.nvim_set_keymap('v', '<leader>a', '<cmd>FzfLua grep_visual<cr>', { silent = true, noremap = true }) -- search for a visual selection
vim.api.nvim_set_keymap('n', '<leader>A', ':FzfLua grep_cword<cr>', { silent = true, noremap = true }) -- search word under cursor

-- treesitter

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  }
})

vim.opt.foldlevel = 20 -- do not fold on file open
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- gitsigns

require('gitsigns').setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = {  text = '~' },
  },
  preview_config = {
    border = 'rounded'
  }
})

vim.api.nvim_create_user_command('Gblame', 'Gitsigns blame_line full=true', {}) -- blame line
vim.api.nvim_create_user_command('Gsigns', 'Gitsigns toggle_signs', {}) -- toggle gitsigns
vim.api.nvim_create_user_command('Gshow', 'Gitsigns show <f-args>', { nargs = 1 }) -- view index version of the file
vim.cmd('highlight clear SignColumn') -- remove sign background

-- lsp

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true, noremap = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { silent = true, noremap = true })

require('lspconfig')['elixirls'].setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  cmd = { "elixir-ls" }
})

require('lspconfig')['ts_ls'].setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
     vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
  end
})

-- cmp

local cmp = require('cmp')

cmp.setup {
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body) -- You need Neovim v0.10 to use vim.snippet
    end
  },
  mapping = {
    ['<Down>'] = cmp.mapping.select_next_item(),
    ['<Up>'] =  cmp.mapping.select_prev_item(),
    ['<cr>'] = cmp.mapping.confirm({ select = false }),
    ['<esc>'] = cmp.mapping.abort()
  },
  formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lsp = '[LSP]',
        buffer = '[Buffer]',
        path = '[Path]',
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'path' }
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}
