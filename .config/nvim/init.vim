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
" Intellisense engine plugin
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Preview markdown files on the browser
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
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
" Treesitter!
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
" Adds comments with `gc`
Plug 'tpope/vim-commentary'
" Alignment plugin:
" - select in visual mode
" - run easy-align cmd with `ga`
" - align with `=`
Plug 'junegunn/vim-easy-align'
" Navigate seamlessly between tmux and vim splits
Plug 'christoomey/vim-tmux-navigator'
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
" Plug 'takac/vim-hardtime'

" Initialize plugin system
call plug#end()

" }}}

lua require"setup"

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

set smartindent
filetype plugin indent on
" Use spaces instead of tabs
set expandtab
" Case options
set ignorecase
set smartcase

" }}}

" Statusline {{{

" Hides 'mode' label on the last line
set noshowmode
" Set lightline theme
function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction
let g:lightline = {
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'cocstatus', 'currentfunction' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'filetype' ],
      \              [ 'percent' ],
      \              [ 'gitbranch' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status',
      \   'currentfunction': 'CocCurrentFunction',
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }
let s:palette = g:lightline#colorscheme#{g:lightline.colorscheme}#palette
let s:palette.normal.middle = [ [ 'none', 'none', 'none', 'none' ] ]
let s:palette.inactive.middle = s:palette.normal.middle
let s:palette.tabline.middle = s:palette.normal.middle
call insert(s:palette.normal.right, s:palette.normal.left[1], 0)

" }}}

" Coc {{{1

" Coc Completion {{{2

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" }}}

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')


" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" coc-prettier {{{2

" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
nmap <leader>0 :Prettier<cr>

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" }}}

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)<CR>
nmap <leader>a  <Plug>(coc-codeaction-selected)<CR>

" Remap for do codeAction of current line
nmap <leader>ca  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" use `:OR` for organize import of current buffer
command! -nargs=0 OR :call CocAction('runCommand', 'editor.action.organizeImport')

let g:coc_global_extensions = [
      \ 'coc-snippets',
      \ 'coc-tsserver',
      \ 'coc-eslint', 
      \ 'coc-prettier', 
      \ 'coc-json', 
      \ ]

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

