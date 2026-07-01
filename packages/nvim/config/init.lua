-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.mouse = ''
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.autowrite = true

vim.o.number = true
vim.o.signcolumn = 'yes'
vim.o.statusline = '%f%M'

vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.shiftround = true
vim.o.expandtab = true

vim.o.title = true
vim.o.timeoutlen = 500
vim.o.updatetime = 250
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.termguicolors = true
vim.cmd('colorscheme flexoki-dark')

vim.o.list = true
vim.o.listchars = [[tab:¦\ ,trail:⋅,conceal:┊,extends:❯,precedes:❮]]

vim.o.showbreak = '↪ '
vim.o.breakindent = true
vim.o.linebreak = true

vim.o.confirm = true
vim.o.autocomplete = true
vim.o.completeopt = 'menuone,noselect'
vim.o.pumheight = 5
vim.o.pumborder = 'rounded'
vim.o.winborder = 'rounded'
vim.o.wildmode = 'longest:full,full'
vim.opt.complete:append('o')
vim.o.shortmess = 'filnxtToOfcI'
vim.o.scrolloff = 10

vim.o.path = '.,**'
vim.o.wildignore = '*.git/*,*/node_modules/*,*/dist/*,*/build/*,*/_build/*,*/deps/*,.elixir_ls/*'

vim.o.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.matchpairs:append('<:>')

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
require('fzf-lua').setup({
  global = {
    pickers = {
      { 'git_files' },
      { 'buffers',  prefix = '#' },
    },
  },
})

vim.keymap.set('n', '<leader>t', ':FzfLua global<cr>', { silent = true })
vim.keymap.set('n', '<leader>p', ':FzfLua builtin<cr>', { silent = true })
vim.keymap.set('n', '<leader>g', ':FzfLua git_status<cr>', { silent = true })
vim.keymap.set('v', '<leader>a', ':FzfLua grep_visual<cr>', { silent = true })
vim.keymap.set('n', '<leader>A', ':FzfLua grep_cword<cr>', { silent = true })

-- treesitter
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    if vim.treesitter.language.get_lang(vim.bo.filetype) then
      if pcall(vim.treesitter.start) then
        vim.opt_local.foldlevel = 20
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      end
    end
  end
})

-- gitsigns
require('gitsigns').setup({
  signs        = { add = { text = '▎' }, change = { text = '▎' } },
  signs_staged = { add = { text = '▎' }, change = { text = '▎' } },
})

vim.api.nvim_create_user_command('Gblame', 'Gitsigns blame_line full=true', {})
vim.api.nvim_create_user_command('Gsigns', 'Gitsigns toggle_signs', {})

-- lsp
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { silent = true })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { silent = true })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1 }) end, { silent = true })
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1 }) end, { silent = true })

local servers = {
  ts_ls = {
    cmd = { 'typescript-language-server', '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json' },
  },
  elixirls = {
    cmd = { 'elixir-ls' },
    filetypes = { 'elixir', 'eelixir', 'heex', 'surface' },
    root_markers = { 'mix.exs' },
  },
  lua_ls = {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { '.luarc.json', '.luarc.jsonc', '.luacheckrc', '.stylua.toml', 'stylua.toml', 'selene.toml', 'selene.yml' },
  },
  nil_ls = {
    cmd = { 'nil' },
    filetypes = { 'nix' },
    root_markers = { 'flake.nix', 'default.nix', 'shell.nix' },
  },
  html = {
    cmd = { 'vscode-html-language-server', '--stdio' },
    filetypes = { 'html' },
    root_markers = { 'package.json' },
  },
  cssls = {
    cmd = { 'vscode-css-language-server', '--stdio' },
    filetypes = { 'css', 'scss', 'less' },
    root_markers = { 'package.json' },
  },
  jsonls = {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    root_markers = { 'package.json' },
  },
  basedpyright = {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', '.git' },
  },
  ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = { 'pyproject.toml', 'ruff.toml', '.git' },
  },
}

for name, config in pairs(servers) do
  vim.lsp.config(name, config)
end
vim.lsp.enable(vim.tbl_keys(servers))

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local opts = { buffer = args.buf, silent = true }
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end
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
