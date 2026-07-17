-- leader
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

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

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

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
-- terminal
--

vim.api.nvim_create_user_command('T', function(o)
  local cmd = o.args ~= '' and { vim.o.shell, '-c', o.args } or vim.o.shell
  local label = o.args ~= '' and o.args or 'shell'
  vim.cmd('botright new | resize 15')
  local buf = vim.api.nvim_get_current_buf()
  local job = vim.fn.jobstart(cmd, {
    term = true,
    on_exit = function() vim.cmd('stopinsert') end,
  })
  vim.api.nvim_buf_set_name(buf, string.format('T://%s:%d', label, vim.fn.jobpid(job)))
  vim.cmd.startinsert()
end, { nargs = '*', complete = 'shellcmd', desc = 'Run terminal command' })

vim.api.nvim_create_autocmd('TermOpen', {
  callback = function(args)
    if vim.bo[args.buf].filetype == 'fzf' then return end
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { buffer = args.buf })
  end,
})

--
-- keymaps
--

vim.keymap.set('n', 'Y', 'yy', { silent = true })

-- smart autotiled split
local function autotile(file, ratio)
  local width = vim.api.nvim_win_get_width(0)
  local height = vim.api.nvim_win_get_height(0)
  local cmd = (width >= height * (ratio or 2)) and 'vsplit' or 'split'
  vim.cmd(file and file ~= '' and (cmd .. ' ' .. file) or cmd)
end

vim.api.nvim_create_user_command('Split', function(opts)
  autotile(opts.args)
end, { nargs = '?', complete = 'file' })

vim.keymap.set('n', '<leader>\\', autotile, { silent = true })

-- clipboard
vim.keymap.set('v', '<D-c>', '"+y')
vim.keymap.set('v', '<D-v>', '"+p')
vim.keymap.set('i', '<D-v>', '<C-r>+')

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
local fzf = require('fzf-lua')

fzf.setup({
  global = {
    query_delay = 200,
    pickers = {
      { 'git_files' },
      { 'buffers',  prefix = '#' },
    },
  },
  winopts = {
    height = 0.85,
    width = 0.85,
    border = 'rounded',
    title_pos = 'center',
  },
})

fzf.config.defaults.actions.files['alt-enter'] = function(selected, opts)
  if not selected or #selected == 0 then return end
  local file = fzf.path.entry_to_file(selected[1], opts).path
  vim.cmd('Split ' .. vim.fn.fnameescape(file))
end

vim.keymap.set('n', '<leader>t', ':FzfLua global<cr>', { silent = true })
vim.keymap.set('n', '<leader>p', ':FzfLua builtin<cr>', { silent = true })
vim.keymap.set('n', '<leader>g', ':FzfLua git_status<cr>', { silent = true })
vim.keymap.set('n', '<leader>a', ':FzfLua live_grep<cr>', { silent = true })
vim.keymap.set('v', '<leader>a', ':FzfLua grep_visual<cr>', { silent = true })
vim.keymap.set('n', '<leader>A', ':FzfLua grep_cword<cr>', { silent = true })
vim.keymap.set('n', '<leader>l', ':FzfLua buffers<cr>', { silent = true })

-- file browser
local function browse(cwd)
  cwd = vim.fs.normalize(cwd or vim.uv.cwd())

  local dirs, files = {}, {}
  for name, typ in vim.fs.dir(cwd) do
    if typ == 'directory' then
      dirs[#dirs + 1] = fzf.utils.ansi_codes.blue(name .. '/')
    else
      files[#files + 1] = name
    end
  end

  local entries = vim.iter({ fzf.utils.ansi_codes.blue('../'), dirs, files }):flatten():totable()

  fzf.fzf_exec(entries, {
    prompt = vim.fn.fnamemodify(cwd, ':~') .. '/ ',
    winopts = { height = 0.85, width = 0.85 },
    actions = {
      default = {
        reuse = true,
        fn = function(sel)
          if not sel[1] then return end
          local target = vim.fs.normalize(vim.fs.joinpath(cwd, (sel[1]:gsub('/$', ''))))
          if vim.fn.isdirectory(target) == 1 then
            browse(target)
          else
            fzf.utils.fzf_winobj():close()
            vim.cmd.edit(vim.fn.fnameescape(target))
          end
        end,
      },
    },
  })
end

vim.api.nvim_create_user_command('Explore', function()
  browse(vim.fn.expand('%:p:h'))
end, {})

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
  sourcekit = {
    cmd = { 'sourcekit-lsp' },
    filetypes = { 'swift' },
    root_markers = { 'buildServer.json', 'Package.swift', '.git' },
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
