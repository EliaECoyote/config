" vim: set fdm=marker:

" vim-plug plugins {{{

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Statusline
Plug 'itchyny/lightline.vim'
" Vimify UNIX shell commands
Plug 'tpope/vim-eunuch'
" Adds comments with `gc`
Plug 'tpope/vim-commentary'
" Automatic tab size management plugin
Plug 'tpope/vim-sleuth'
" Async toolbox for plugins
Plug 'tpope/vim-dispatch'
" Loads editorconfig files
Plug 'editorconfig/editorconfig-vim'
" Handle text surround with quotes, tags, brackets
Plug 'machakann/vim-sandwich'
" Makes gx cmd work for urls and files 
Plug 'stsewd/gx-extended.vim'
" Integrate non LSP stuff with neovim LSP diagnostic, actions...
Plug 'jose-elias-alvarez/null-ls.nvim'
" LSP server configurations for various langs
Plug 'neovim/nvim-lspconfig'
" Pretty LSP feedback
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/trouble.nvim'
" Install LSP servers automatically
Plug 'williamboman/nvim-lsp-installer'
" Autocompletion engine
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
" Snippets
Plug 'rafamadriz/friendly-snippets'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
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
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-rg.nvim'
Plug 'nvim-telescope/telescope-live-grep-args.nvim'
" Treesitter!
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Navigate seamlessly between tmux and vim splits
Plug 'christoomey/vim-tmux-navigator'
" Open current line on github
Plug 'ruanyl/vim-gh-line'
" Test runner
Plug 'vim-test/vim-test'
" Debug client
Plug 'mfussenegger/nvim-dap'
" Themes
Plug 'sainnhe/gruvbox-material'
Plug 'joshdick/onedark.vim'
Plug 'doums/darcula'
Plug 'bluz71/vim-nightfly-guicolors'
Plug 'sainnhe/sonokai'
Plug 'mhartington/oceanic-next'
Plug 'embark-theme/vim', { 'as': 'embark' }
" Handle multi-file find and replace
Plug 'mhinz/vim-grepper'

" Initialize plugin system
call plug#end()

" }}}

lua require"setup"

" Syntax Highlighting {{{

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

noremap <silent> - :Vifm<cr>

" }}}

" Scroll settings {{{

map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>

" }}}

" Default indentation & font settings {{{

set smartindent
filetype plugin indent on
" Use spaces instead of tabs
set tabstop=2 shiftwidth=2 expandtab
" Case options
set ignorecase
set smartcase

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
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'none', 'none', 'none', 'none' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle
call insert(s:palette.normal.right, s:palette.normal.left[1], 0)

function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction

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

" Vim tabs {{{1

nnoremap tn :tabnew<cr>
nnoremap td :tabclose<cr>

" }}}

" Vim buffers {{{1

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

