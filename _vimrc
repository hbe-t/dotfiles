scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8

"  hbe-t / noisegen@gmail.com dotvimfile.
"
" Kaoriya 版の場合は、.vimrc を実行
if isdirectory('$VIM/plugins/kaoriya/')
   source $HOME/.vimrc
endif

"  :scriptnames ロードされたスクリプト一覧

let mapleader = "\<Space>"
"
" ############################################################
" TABの設定
" https://qiita.com/wadako111/items/755e753677dd72d8036d
" Anywhere SID.
" ############################################################

function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

"map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
"map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
"map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ

" タブ動作
nnoremap <silent> ta :tabnew<return>
nnoremap <silent> tn :tabnext<return>
nnoremap <silent> tp :tabp<return>
nnoremap <silent> tx :tabclose<return>


" ############################################################
" クリップボード設定
" ############################################################
map <C-C> <C-Ins>
map! <C-C> <C-Ins>
map <C-V> <S-Ins>
map! <C-V> <S-Ins>
set clipboard+=unnamed



" pwd を、今見ているバッファのpwdにする。(VimShellと共存できないので停止)
"set autochdir
" 複数ファイルを開く
set hidden

set directory=~/temp
set undodir=~/temp
set cursorline
set cursorcolumn
set number
set visualbell

set listchars=tab:>-,trail:-,eol:$,extends:>,precedes:<,nbsp:%
set list

if has("syntax")
    syntax on
 
    " PODバグ対策
    syn sync fromstart
 
    function! ActivateInvisibleIndicator()
        " 下の行の"　"は全角スペース
        syntax match InvisibleJISX0208Space "　" display containedin=ALL
        highlight InvisibleJISX0208Space term=underline ctermbg=Blue guibg=darkgray gui=underline
        "syntax match InvisibleTrailedSpace "[ \t]\+$" display containedin=ALL
        "highlight InvisibleTrailedSpace term=underline ctermbg=Red guibg=NONE gui=undercurl guisp=darkorange
        "syntax match InvisibleTab "\t" display containedin=ALL
        "highlight InvisibleTab term=underline ctermbg=white gui=undercurl guisp=darkslategray
    endfunction
 
    augroup invisible
        autocmd! invisible
        autocmd BufNew,BufRead * call ActivateInvisibleIndicator()
    augroup END
endif

" https://qiita.com/enomotok/items/9d38b716fe883675d35b
set iminsert=0
set imsearch=-1
" http://sifue.hatenablog.com/entry/20120411/1334161078
"set imdisable これはダメでした。

if &compatible
  set nocompatible
endif

" ############################################################
" deinの設定とプラグインのインストール
" ############################################################

"let g:vimproc#download_windows_dll = 1

set runtimepath+=~/.vim/.cache/dein/repos/github.com/Shougo/dein.vim

let s:dein_dir = expand('~/.vim/.cache/dein')

let s:dein_repo_dir = s:dein_dir . '/repos/github.com'
if !isdirectory(s:dein_repo_dir)
  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
endif

if isdirectory('$VIM/plugins/kaoriya/')
  let s:toml_file = "C:/Program Files/vim/.vim/.dein/.dein.toml"
else
  let s:toml_file = "~/.vim/.dein/.dein.toml"
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
"  call dein#load_toml(s:toml_file)

  call dein#add('Shougo/unite.vim')
  call dein#add('Shougo/vimproc.vim', { 'build' : 'make' })
  call dein#add('Shougo/VimShell.vim')

  call dein#add('Shougo/neocomplete.vim')
  call dein#add('Shougo/neosnippet')
  call dein#add('Shougo/neosnippet-snippets')

  call dein#add('Shougo/neomru.vim')
  call dein#add('tyru/open-browser.vim')

  call dein#add('vim-scripts/dbext.vim')

  "call dein#add('taku-o/downloads/raw/master/copypath.vim')
"  call dein#add('taku-o/downloads/copypath.vim')

"  call dein#add( 'plasticboy/vim-markdown' )
  call dein#add( 'kannokanno/previm' )

  call dein#end()
  call dein#save_state()
endif

"
" 不足プラグインの自動インストール
if has('vim_starting') && dein#check_install()
  call dein#install()
endif

" ############################################################
"     全角空白のハイライト表示
" ############################################################
autocmd ColorScheme * highlight FullWidthSpace guibg=darkgray
autocmd VimEnter * match FullWidthSpace /　/

" ############################################################
" ステータスライン表示
" ############################################################
" ファイル名表示
set statusline=%F
" 変更チェック表示
set statusline+=%m
" 読み込み専用かどうか表示
set statusline+=%r
" ヘルプページなら[HELP]と表示
set statusline+=%h
" プレビューウインドウなら[Prevew]と表示
set statusline+=%w
" これ以降は右寄せ表示
set statusline+=%=
" file encoding
set statusline+=[%{&fileencoding}]
" file encoding
" set statusline+=[IN=%{&encoding}]
" 現在行数/全行数
"set statusline+=[LOW=%l/%L]
set statusline+=[%LL]
set statusline+=[%{&filetype}]
" ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
set laststatus=2

" ############################################################
" CopyPath
" ############################################################
" https://nanasi.jp/articles/vim/copypath_vim.html
"source C:\Program Files\vim\plugins\copypath.vim

let g:copypath_copy_to_unnamed_register = 1
nnoremap <silent> <C-c>p :CopyPath<return>
nnoremap <silent> <C-c>f :CopyFileName<return>
"
" ############################################################
" alter ESC
" ############################################################
inoremap <silent> jj <ESC>
"
" ############################################################
" Leader ShortCuts
" ############################################################

" ,is: シェルを起動
nnoremap <Leader>is :VimShell<return>

" ,Ur: 最近のファイル一覧
nnoremap ,Ur :Unite file_mru<return>
nnoremap <Leader>ur :Unite file_mru<return>
" ,Ub: バッファ一覧
nnoremap <Leader>ub :Unite buffer<return>
" ,Ut: タブ一覧
nnoremap <Leader>ut :Unite tab<return>

" ############################################################
" open-browser.vim  ブラウザを開く
let g:netrw_nogx = 1
nmap <Leader>gx <Plug>(openbrowser-smart-search)
vmap <Leader>gx <Plug>(openbrowser-smart-search)
"
" chrome
" http://hanagurotanuki.blogspot.com/2015/03/windowsopen-browservimchrome.html
if has('win32') || has('win64')
 let g:openbrowser_browser_commands = [
 \   {
 \       "name": "C:\\Program\ Files\ (x86)\\Google\\Chrome\\Application\\chrome.exe",
 \       "args": ["{browser}", "{uri}"]
 \   }
 \ ]
endif

" ############################################################
"markdown を開く
"https://qiita.com/uedatakeshi/items/31761b87ba8ecbaf2c1e
" ############################################################
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'open -a chrome'

" ############################################################
" dbext
"    MySQL
" let g:dbext_default_profile_mysqlnodb = 'type=MYSQL:host=127.0.0.1:user=root:passwd=password:dbname=test'
"    ORACLE
" let g:dbext_default_profile_myORA = 'type=ORA:srvname=127.0.0.1:user=scott:passwd=tiger'"    
" ############################################################
"    Postgres
let g:dbext_default_profile_pgPermaiTRUE = 'type=PGSQL:host=10.187.160.26:user=permaite:dbname=permaite:passwd=permaite:port=5432'
let g:dbext_default_profile_pgPermaiTEST = 'type=PGSQL:host=10.168.32.50:user=permaite:dbname=permaite:passwd=permaite:port=5432'
let g:dbext_default_profile_pgPermaiLO3 = 'type=PGSQL:host=localhost:user=permaite:dbname=TEST_EQP_CHK:passwd=permaite:port=5432'
let g:dbext_default_profile_pgPermaiLODB2 = 'type=PGSQL:host=localhost:user=postgres:dbname=TEST_DB2:passwd=permaite:port=5432'
let g:dbext_default_profile_pgPermaiLO = 'type=PGSQL:host=10.168.31.111:user=permaite:dbname=TEST_DB2:passwd=permaite:port=5432'
let g:dbext_default_profile = 'pgPermaiTEST'


" 引数なしでvimを開くとNERDTreeを起動
let file_name = expand('%')
"if has('vim_starting') &&  file_name == ''
" autocmd VimEnter * NERDTree ./
"ndif


"----------------------------------------------------------
" neocomplete・neosnippetの設定
"----------------------------------------------------------
"if dein#is_installed('neocomplete.vim')
    " Vim起動時にneocompleteを有効にする
    let g:neocomplete#enable_at_startup = 1
    " smartcase有効化. 大文字が入力されるまで
    " 大文字小文字の区別を無視する
    let g:neocomplete#enable_smart_case = 1
    " 3文字以上の単語に対して補完を有効にする
    let g:neocomplete#min_keyword_length = 3
    " 区切り文字まで補完する
    let g:neocomplete#enable_auto_delimiter = 1
    " 1文字目の入力から補完のポップアップを表示
    let g:neocomplete#auto_completion_start_length = 1
    " バックスペースで補完のポップアップを閉じる
    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"

    " エンターキーで補完候補の確定. スニペットの展開も
    " エンターキーで確定・・・・・・②
    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
    " タブキーで補完候補の選択. スニペット内のジャンプも
    " タブキーでジャンプ・・・・・・③
    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
"endif

