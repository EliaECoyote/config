" vim: set fdm=marker:

" vim-plug plugins {{{

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Plug 'vimwiki/vimwiki'
" Statusline
Plug 'itchyny/lightline.vim'
" Vimify UNIX shell commands
Plug 'tpope/vim-eunuch'
" Loads editorconfig files
Plug 'editorconfig/editorconfig-vim'
" Adds emmet management
" - run `<leader>,,` to convert emmet to template
Plug 'mattn/emmet-vim'
" Handle text surround with quotes, tags, brackets
Plug 'machakann/vim-sandwich'
" Automatic tab size management plugin
Plug 'tpope/vim-sleuth'
" Async toolbox for plugins
Plug 'tpope/vim-dispatch'
" Base vim config
Plug 'tpope/vim-sensible'
" Preview markdown files on the browser
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
" LS for linters
Plug 'mattn/efm-langserver'
" LSP server configurations for various langs
Plug 'neovim/nvim-lspconfig'
" Autocompletion engine
Plug 'hrsh7th/nvim-compe'
" Display LSP status in statusline
Plug 'nvim-lua/lsp-status.nvim'
" Git management plugin
Plug 'tpope/vim-fugitive'
" Adds Tree explorer
Plug 'vifm/vifm.vim'
" Adds git diff markers on the left + hunks management
Plug 'mhinz/vim-signify'
" Fuzzy finder
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Adds comments with `gc`
Plug 'tpope/vim-commentary'
" Alignment plugin:
" - select in visual mode
" - run easy-align cmd with `ga`
" - align with `=`
Plug 'junegunn/vim-easy-align'
" Navigate seamlessly between tmux and vim splits
Plug 'christoomey/vim-tmux-navigator'
" Themes!
Plug 'joshdick/onedark.vim'
Plug 'morhetz/gruvbox'
" Golang support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" Language packs for syntax highlight & indentation support
Plug 'sheerun/vim-polyglot', { 'do' : './build' }

" Handle multi-file find and replace
Plug 'mhinz/vim-grepper'
" Plug 'takac/vim-hardtime'

" Initialize plugin system
call plug#end()

" }}}

let mapleader = " "

" Training! {{{

" Set hardtime on by default
" let g:hardtime_default_on = 1

" }}}

" Vimwiki {{{

" Don't use vimwiki for all markdown files
let g:vimwiki_global_ext = 0
let g:vimwiki_list = [{'path': '~/Dropbox/vimwiki/',
      \ 'syntax': 'markdown', 'ext': '.md'}]

" Remove conflicting vimwiki mappings
let g:vimwiki_key_mappings =
      \ {
      \ 'headers': 0,
      \ }

nmap <leader>ww :e ~/Dropbox/vimwiki/index.md<cr>

" }}}

" Syntax Highlighting {{{

autocmd BufEnter *.{js,jsx,ts,tsx} :syntax sync fromstart
autocmd BufLeave *.{js,jsx,ts,tsx} :syntax sync clear
autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_fenced_languages = [
      \ 'css',
      \ 'javascript',
      \ 'typescript',
      \ 'js=javascript',
      \ 'ts=typescript',
      \ 'json=javascript',
      \ 'sass',
      \ 'xml'
      \ ]

" }}}

" Vifm {{{

let loaded_netrwPlugin = 1
noremap <silent> - :Vifm<cr>

" }}}

" Netrw {{{

let g:netrw_banner = 0     " Hide annoying 'help' banner
let g:netrw_liststyle = 3  " Use tree view
let g:netrw_winsize = '30' " Smaller default window size

" }}}

" Scroll settings {{{

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" }}}

" Indentation & font settings {{{

" Filetype indent on
set autoindent
set tabstop=2
set shiftwidth=2
" Always use spaces instead of tab characters
set expandtab
" Case options
set ignorecase
set smartcase

" }}}

" Theme {{{

" let g:gruvbox_italic=1
" let g:gruvbox_invert_selection=0
" colorscheme gruvbox
colorscheme onedark

" Use truecolor
if (has("termguicolors"))
  set termguicolors
endif

if !has('nvim')
  " Fix vim colors
  if !has('gui_running')
    set t_Co=256
  endif
  " Use cursorline when in insert mode"
  autocmd InsertEnter,InsertLeave * set cul!
endif

" Soft line wrap
set linebreak wrap tw=0

" Cusomize vimdiff colors
hi DiffAdd      gui=none    guifg=NONE          guibg=#23414f
hi DiffChange   gui=none    guifg=NONE          guibg=#383725
hi DiffDelete   gui=none    guifg=#3d2b28       guibg=#3d2b28
hi DiffText     gui=none    guifg=NONE          guibg=#454425

" Makes vimdiff easier to read
set diffopt+=algorithm:patience
set diffopt+=vertical
" set diffopt+=indent-heuristic

set cursorline
set relativenumber
set number
set updatetime=300
set shortmess+=c

" }}}

" LSP setup {{{

lua require('lsp')

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gi    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> F2    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> F12   <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <leader>a <cmd>lua vim.lsp.buf.code_action()<CR>

" }}}

" Statusline {{{

" Hides 'mode' label on the last line
set noshowmode
" Set lightline theme
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'lsp' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'filetype' ],
      \              [ 'percent' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'lsp': 'LspStatus',
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

" }}}

" Golang {{{

" Disable `vim-go` gd mapping
let g:go_def_mapping_enabled = 0

" }}}

" Diagnostics {{{

" Use `[g` and `]g` to navigate diagnostics
nmap ]g <cmd>lua vim.lsp.diagnostic.goto_next()<cr>
nmap [g <cmd>lua vim.lsp.diagnostic.goto_prev()<cr>

" }}}

" `nvim-compe` plugin {{{

" From nvim-compe prerequisites: https://github.com/hrsh7th/nvim-compe#prerequisite
set completeopt=menuone,noselect

let g:compe = {}
let g:compe.enabled = v:true
let g:compe.autocomplete = v:true
let g:compe.debug = v:false
let g:compe.min_length = 1
let g:compe.preselect = 'enable'
let g:compe.throttle_time = 80
let g:compe.source_timeout = 200
let g:compe.incomplete_delay = 400
let g:compe.max_abbr_width = 100
let g:compe.max_kind_width = 100
let g:compe.max_menu_width = 100
let g:compe.documentation = v:true

let g:compe.source = {}
let g:compe.source.path = v:true
let g:compe.source.buffer = v:true
let g:compe.source.calc = v:true
let g:compe.source.nvim_lsp = v:true
let g:compe.source.nvim_lua = v:true
let g:compe.source.vsnip = v:true

" }}}

" emmet-vim {{{

let g:user_emmet_leader_key = '<C-,>'

" }}}

" vim-fugitive {{{

nmap <leader>2 :Gvdiffsplit<cr>

" Map keys to move between Gstatus files
let g:nremap = {
      \ ')' : '<Tab>',
      \ '(' : '<S-Tab>'
      \ }

" }}}

" vim-tmux-navigator {{{

let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <C-w>h :TmuxNavigateLeft<cr>
nnoremap <silent> <C-w>j :TmuxNavigateDown<cr>
nnoremap <silent> <C-w>k :TmuxNavigateUp<cr>
nnoremap <silent> <C-w>l :TmuxNavigateRight<cr>
nnoremap <silent> <C-w>\ :TmuxNavigatePrevious<cr>

" }}}

" vim-sandwich {{{

" Use vim-surround keybindings to avoid replacing `s`:
" https://github.com/machakann/vim-sandwich/wiki/Introduce-vim-surround-keymappings
runtime macros/sandwich/keymap/surround.vim

" }}}

" Copy settings {{{

" Stamp (del & replace with yanked text)
nnoremap <C-s> "_diwP

" Yanked text to-clipboard shortcut\
noremap Y "+y

" Yank current path to clipboard
command CopyPath :let @+ = expand("%")

" }}}

" Search & replace {{{

" Press * to search for the term under the cursor or a visual selection and
" then press a key below to replace all instances of it in the current file.
nnoremap <Leader>r :%s///gc<Left><Left><Left>

" The same as above but instead of acting on the whole file it will be
" restricted to the previously visually selected range. You can do that by
" pressing *, visually selecting the range you want it to apply to and then
" press a key below to replace all instances of it in the current selection.
xnoremap <Leader>r :s///gc<Left><Left><Left>

" After searching for text, press this mapping to do a project wide find and
" replace. It's similar to <leader>r except this one applies to all matches
" across all files instead of just the current file.
nnoremap <Leader>R
      \ :let @s='\<'.expand('<cword>').'\>'<CR>
      \ :Grepper -cword -noprompt<CR>
      \ :cfdo %s/<C-r>s//g \| update
      \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" The same as above except it works with a visual selection.
xmap <Leader>R
      \ "sy
      \ gvgr
      \ :cfdo %s/<C-r>s//g \| update
      \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

" }}}

" Search visual selected text {{{

vnoremap <silent> * :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy/<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
      \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gVzv:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
      \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
      \gvy?<C-R>=&ic?'\c':'\C'<CR><C-R><C-R>=substitute(
      \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
      \gVzv:call setreg('"', old_reg, old_regtype)<CR>

" }}}

" telescope.nvim {{{1

nnoremap <leader>p <cmd>Telescope find_files<cr>
nnoremap <leader>ff <cmd>Telescope live_grep<cr>
nnoremap <leader>o <cmd>Telescope buffers<cr>
nnoremap <leader>ft <cmd>Telescope help_tags<cr>

" }}}

" fzf branch checkout {{{2

function! GitCheckoutBranch(branch)
  let l:name = trim(a:branch)
  execute "Git checkout ".l:name
endfunction

" -a option lists all branches (remotes aswell)
" -vv option shows more information about branch
" --color and --ansi enables colors
" --nth=1 makes sure you only search by names and not branch info
command! -bang Gbranches call fzf#run(fzf#wrap({"source": "git for-each-ref --format='%(refname:short)' refs/heads", 'sink': function('GitCheckoutBranch'), 'options': '--ansi --nth=1'}, <bang>0))

nnoremap <silent> <leader>ch :Gbranches <cr>

" }}}

" }}}

" vim-easy-align {{{

" Align GitHub-flavored Markdown tables
au FileType markdown map <Bar> vip :EasyAlign*<Bar><Enter>

" }}}

" Vim tabs {{{1

nnoremap tn :tabnew<cr>
nnoremap td :tabclose<cr>

" }}}

" Vim buffers {{{1

" Makes so any buffer can be hidden (keeping its changes) without first writing the buffer to a file. This affects all commands and all buffers.
set hidden 

" Automatically save any changes made to the buffer before it is hidden
set autowrite

nnoremap <silent> <leader>bo :BufOnly!<cr>
nnoremap <silent> <leader>bd :Kwbd<cr>
nnoremap <silent> <leader>bn :bnext<cr>
nnoremap <silent> <leader>bb :bprevious<cr>
nnoremap <silent> <leader>ba :bufdo bwipeout<cr>

" Delete all the buffers except the current/named buffer {{{2

" https://www.vim.org/scripts/script.php?script_id=1071
" Usage:
" \bo / :Bonly / :BOnly / :Bufonly / :BufOnly [buffer] 
" Without any arguments the current buffer is kept.  With an argument the
" buffer name/number supplied is kept.

command! -nargs=? -complete=buffer -bang Bonly
      \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BOnly
      \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang Bufonly
      \ :call BufOnly('<args>', '<bang>')
command! -nargs=? -complete=buffer -bang BufOnly
      \ :call BufOnly('<args>', '<bang>')

function! BufOnly(buffer, bang)
  if a:buffer == ''
    " No buffer provided, use the current buffer.
    let buffer = bufnr('%')
  elseif (a:buffer + 0) > 0
    " A buffer number was provided.
    let buffer = bufnr(a:buffer + 0)
  else
    " A buffer name was provided.
    let buffer = bufnr(a:buffer)
  endif

  if buffer == -1
    echohl ErrorMsg
    echomsg "No matching buffer for" a:buffer
    echohl None
    return
  endif

  let last_buffer = bufnr('$')

  let delete_count = 0
  let n = 1
  while n <= last_buffer
    if n != buffer && buflisted(n)
      if a:bang == '' && getbufvar(n, '&modified')
        echohl ErrorMsg
        echomsg 'No write since last change for buffer'
              \ n '(add ! to override)'
        echohl None
      else
        silent exe 'bdel' . a:bang . ' ' . n
        if ! buflisted(n)
          let delete_count = delete_count+1
        endif
      endif
    endif
    let n = n+1
  endwhile

  if delete_count == 1
    echomsg delete_count "buffer deleted"
  elseif delete_count > 1
    echomsg delete_count "buffers deleted"
  endif

endfunction

" }}}

" Delete buffer without closing window {{{2

function s:Kwbd(kwbdStage)
  if(a:kwbdStage == 1)
    if(&modified)
      let answer = confirm("This buffer has been modified.  Are you sure you want to delete it?", "&Yes\n&No", 2)
      if(answer != 1)
        return
      endif
    endif
    if(!buflisted(winbufnr(0)))
      bd!
      return
    endif
    let s:kwbdBufNum = bufnr("%")
    let s:kwbdWinNum = winnr()
    windo call s:Kwbd(2)
    execute s:kwbdWinNum . 'wincmd w'
    let s:buflistedLeft = 0
    let s:bufFinalJump = 0
    let l:nBufs = bufnr("$")
    let l:i = 1
    while(l:i <= l:nBufs)
      if(l:i != s:kwbdBufNum)
        if(buflisted(l:i))
          let s:buflistedLeft = s:buflistedLeft + 1
        else
          if(bufexists(l:i) && !strlen(bufname(l:i)) && !s:bufFinalJump)
            let s:bufFinalJump = l:i
          endif
        endif
      endif
      let l:i = l:i + 1
    endwhile
    if(!s:buflistedLeft)
      if(s:bufFinalJump)
        windo if(buflisted(winbufnr(0))) | execute "b! " . s:bufFinalJump | endif
      else
        enew
        let l:newBuf = bufnr("%")
        windo if(buflisted(winbufnr(0))) | execute "b! " . l:newBuf | endif
      endif
      execute s:kwbdWinNum . 'wincmd w'
    endif
    if(buflisted(s:kwbdBufNum) || s:kwbdBufNum == bufnr("%"))
      execute "bd! " . s:kwbdBufNum
    endif
    if(!s:buflistedLeft)
      set buflisted
      set bufhidden=delete
      set buftype=
      setlocal noswapfile
    endif
  else
    if(bufnr("%") == s:kwbdBufNum)
      let prevbufvar = bufnr("#")
      if(prevbufvar > 0 && buflisted(prevbufvar) && prevbufvar != s:kwbdBufNum)
        b #
      else
        bn
      endif
    endif
  endif
endfunction

command! Kwbd call s:Kwbd(1)

" }}}

" }}}

" Folding {{{1

" Remap toggle fold
nnoremap <s-tab> zA

" Fold by syntax by default
set foldmethod=syntax
" // TODO: remove this once you get used to it
" Activate JS syntax folds
let javaScript_fold=1
" No fold closed by default
set foldlevelstart=99

" Customize foldtext
source ~/.config/nvim/foldtext.vim

" Move between folds {{{2

nnoremap <silent> ]z :call RepeatCmd('call NextClosedFold("j")')<cr>
nnoremap <silent> [z :call RepeatCmd('call NextClosedFold("k")')<cr>

function! RepeatCmd(cmd) range abort
    let n = v:count < 1 ? 1 : v:count
    while n > 0
        exe a:cmd
        let n -= 1
    endwhile
endfunction

function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

" }}}

" }}}

" Fix CoC open zip files {{{

" Taken from https://github.com/neoclide/coc-tsserver/issues/244#issuecomment-755271565
function! OpenZippedFile(f)
  " get number of new (empty) buffer
  let l:b = bufnr('%')
  " construct full path
  let l:f = substitute(a:f, '.zip/', '.zip::', '')
  let l:f = substitute(l:f, '/zip:', 'zipfile:', '')

  " swap back to original buffer
  b #
  " delete new one
  exe 'bd! ' . l:b
  " open buffer with correct path
  sil exe 'e ' . l:f
  " read in zip data
  call zip#Read(l:f, 1)
endfunction

au BufReadCmd /zip:*.yarn/cache/*.zip/* call OpenZippedFile(expand('<afile>'))
" }}}

" Vim built-ins {{{

set undofile
set undodir=$HOME/.vim/undo

set undolevels=1000
set undoreload=10000

" Autosave on focus lost
" https://vim.fandom.com/wiki/Auto_save_files_when_focus_is_lost
au FocusLost * silent! wa

" Refresh file when it changes on disk
au FocusGained,BufEnter * :checktime

" Enable mouse visual selection
set mouse=a

" Enables Vim per-project configuration files
set exrc

" Prevents :autocmd, shell and write commands from being run
" inside project-specific .vimrc files unless they’re owned by you.
set secure

" }}}

