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
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.autowrite = true

vim.o.number = true
vim.o.statusline = '%#identifier#%f%M'

vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.expandtab = true
vim.o.smartindent = true

vim.o.laststatus = 2
vim.o.title = true
vim.o.visualbell = false
vim.o.errorbells = false
vim.o.timeoutlen = 500

vim.o.background = 'dark'
vim.o.termguicolors = true
vim.cmd('colorscheme flexoki-dark')
vim.cmd('highlight clear VertSplit')
vim.cmd('highlight Normal guibg=none')

vim.o.list = true
vim.o.listchars = [[tab:¦\ ,trail:⋅,conceal:┊,extends:❯,precedes:❮]]

vim.o.showbreak = '↪ '
vim.o.breakindent = true
vim.o.linebreak = true
vim.o.wrap = true

vim.o.confirm = true
vim.o.modeline = false
vim.o.shortmess = 'filnxtToOfcI'
vim.o.scrolloff = 10

vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.matchpairs = '(:),{:},[:],<:>'

vim.g.netrw_localrmdir = 'rm -rf'
vim.g.netrw_banner = 0
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3

--
-- autocommands
--

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  command = [[%s/\s\+$//e]]
})

--
-- commands
--

vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', { bang = true })
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('E', 'Explore', {})

--
-- keymaps
--

vim.keymap.set('n', 'Y', 'yy', { silent = true })
vim.keymap.set('n', '<leader>\\', ':vs<cr>', { silent = true })
vim.keymap.set('n', '<leader>-', ':split<cr>', { silent = true })
vim.keymap.set('n', '<leader>1', ':e ~/.config/nvim/init.lua<cr>', { silent = true })

-- visual mode
vim.keymap.set('v', '>', '>gv', { silent = true })
vim.keymap.set('v', '<', '<gv', { silent = true })
vim.keymap.set('v', 'J', [[:m '>+1<cr>gv=gv]], { silent = true })
vim.keymap.set('v', 'K', [[:m '<-2<cr>gv=gv]], { silent = true })
vim.keymap.set('v', '=', '=gv', { silent = true })

-- base64 encode/decode
vim.keymap.set('v', '<leader>en', [[c<c-r>=system('base64', @")<cr><esc>]], { silent = true })
vim.keymap.set('v', '<leader>de', [[c<c-r>=system('base64 --decode', @")<cr><esc>]], { silent = true })

--
-- plugins
--

-- fzf
require('fzf-lua').setup()

vim.keymap.set('n', '<leader>t', ':FzfLua git_files<cr>', { silent = true })
vim.keymap.set('n', '<leader>l', ':FzfLua buffers<cr>', { silent = true })
vim.keymap.set('n', '<leader>a', ':FzfLua live_grep resume=true<cr>', { silent = true })
vim.keymap.set('v', '<leader>a', '<cmd>FzfLua grep_visual<cr>', { silent = true })
vim.keymap.set('n', '<leader>A', ':FzfLua grep_cword<cr>', { silent = true })

-- treesitter
-- Enable highlighting and indentation
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    if vim.treesitter.language.get_lang(vim.bo.filetype) then
      pcall(vim.treesitter.start)
    end
  end
})

-- Register heex to use elixir parser
vim.treesitter.language.register('elixir', 'heex')

-- Setup folding
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.opt_local.foldlevel = 20
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
  end
})

-- gitsigns
require('gitsigns').setup()

vim.api.nvim_create_user_command('Gblame', 'Gitsigns blame_line full=true', {})
vim.api.nvim_create_user_command('Gsigns', 'Gitsigns toggle_signs', {})
vim.api.nvim_create_user_command('Gshow', 'Gitsigns show <f-args>', { nargs = 1 })

-- lsp
-- All these servers are bundled privately with neovim
-- They don't pollute system PATH and project LSPs take precedence

-- Configure LSP servers
vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
})

vim.lsp.config('elixirls', {
  cmd = { 'elixir-ls' },
  filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
  root_markers = { 'mix.exs' },
})

vim.lsp.config('lua_ls', {
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
  root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
})

vim.lsp.config('nil_ls', {
  cmd = { 'nil' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', 'default.nix', 'shell.nix' },
})

vim.lsp.config('html', {
  cmd = { 'vscode-html-language-server', '--stdio' },
  filetypes = { 'html' },
  root_markers = { 'package.json' },
})

vim.lsp.config('cssls', {
  cmd = { 'vscode-css-language-server', '--stdio' },
  filetypes = { 'css', 'scss', 'less' },
  root_markers = { 'package.json' },
})

vim.lsp.config('jsonls', {
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { 'package.json' },
})

-- Enable configured LSP servers (ESLint removed due to configuration issues)
vim.lsp.enable({ 'ts_ls', 'elixirls', 'lua_ls', 'nil_ls', 'html', 'cssls', 'jsonls' })

-- Enable LSP-based completion
vim.lsp.completion.enable()

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = { buffer = args.buf, silent = true }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format({ async = true }) end, opts)
  end,
})

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { silent = true })
