scriptencoding utf-8
set encoding=utf-8
set fileencodings=utf-8
" vim:set ts=8 sts=2 sw=2 tw=0: (この行に関しては:help modelineを参照)
"
" An example for a Japanese version vimrc file.
" 日本語版のデフォルト設定ファイル(vimrc) - Vim 8.1
"
" Last Change: 21-Jan-2020.
" Maintainer:  MURAOKA Taro <koron.kaoriya@gmail.com>
"
" 解説:
" このファイルにはVimの起動時に必ず設定される、編集時の挙動に関する設定が書
" かれています。GUIに関する設定はgvimrcに書かかれています。
"
" 個人用設定は_vimrcというファイルを作成しそこで行ないます。_vimrcはこのファ
" イルの後に読込まれるため、ここに書かれた内容を上書きして設定することが出来
" ます。_vimrcは$HOMEまたは$VIMに置いておく必要があります。$HOMEは$VIMよりも
" 優先され、$HOMEでみつかった場合$VIMは読込まれません。
"
" 管理者向けに本設定ファイルを直接書き換えずに済ませることを目的として、サイ
" トローカルな設定を別ファイルで行なえるように配慮してあります。Vim起動時に
" サイトローカルな設定ファイル($VIM/vimrc_local.vim)が存在するならば、本設定
" ファイルの主要部分が読み込まれる前に自動的に読み込みます。
"
" 読み込み後、変数g:vimrc_local_finishが非0の値に設定されていた場合には本設
" 定ファイルに書かれた内容は一切実行されません。デフォルト動作を全て差し替え
" たい場合に利用して下さい。
"
" 参考:
"   :help vimrc
"   :echo $HOME
"   :echo $VIM
"   :version

"---------------------------------------------------------------------------
" サイトローカルな設定($VIM/vimrc_local.vim)があれば読み込む。読み込んだ後に
" 変数g:vimrc_local_finishに非0な値が設定されていた場合には、それ以上の設定
" ファイルの読込を中止する。
if 1 && filereadable($VIM . '/vimrc_local.vim')
  unlet! g:vimrc_local_finish
  source $VIM/vimrc_local.vim
  if exists('g:vimrc_local_finish') && g:vimrc_local_finish != 0
    finish
  endif
endif

"---------------------------------------------------------------------------
" ユーザ優先設定($HOME/.vimrc_first.vim)があれば読み込む。読み込んだ後に変数
" g:vimrc_first_finishに非0な値が設定されていた場合には、それ以上の設定ファ
" イルの読込を中止する。
if 1 && exists('$HOME') && filereadable($HOME . '/.vimrc_first.vim')
  unlet! g:vimrc_first_finish
  source $HOME/.vimrc_first.vim
  if exists('g:vimrc_first_finish') && g:vimrc_first_finish != 0
    finish
  endif
endif

" plugins下のディレクトリをruntimepathへ追加する。
for s:path in split(glob($VIM.'/plugins/*'), '\n')
  if s:path !~# '\~$' && isdirectory(s:path)
    let &runtimepath = &runtimepath.','.s:path
  end
endfor
unlet s:path

"---------------------------------------------------------------------------
" 日本語対応のための設定:
"
" ファイルを読込む時にトライする文字エンコードの順序を確定する。漢字コード自
" 動判別機能を利用する場合には別途iconv.dllが必要。iconv.dllについては
" README_w32j.txtを参照。ユーティリティスクリプトを読み込むことで設定される。
source $VIM/plugins/kaoriya/encode_japan.vim
" メッセージを日本語にする (Windowsでは自動的に判断・設定されている)
if !(has('win32') || has('mac')) && has('multi_lang')
  if !exists('$LANG') || $LANG.'X' ==# 'X'
    if !exists('$LC_CTYPE') || $LC_CTYPE.'X' ==# 'X'
      language ctype ja_JP.eucJP
    endif
    if !exists('$LC_MESSAGES') || $LC_MESSAGES.'X' ==# 'X'
      language messages ja_JP.eucJP
    endif
  endif
endif
" MacOS Xメニューの日本語化 (メニュー表示前に行なう必要がある)
if has('mac')
  set langmenu=japanese
endif
" 日本語入力用のkeymapの設定例 (コメントアウト)
if has('keymap')
  " ローマ字仮名のkeymap
  "silent! set keymap=japanese
  "set iminsert=0 imsearch=0
endif
" 非GUI日本語コンソールを使っている場合の設定
if !has('gui_running') && &encoding != 'cp932' && &term == 'win32'
  set termencoding=cp932
endif

"---------------------------------------------------------------------------
" メニューファイルが存在しない場合は予め'guioptions'を調整しておく
if 1 && !filereadable($VIMRUNTIME . '/menu.vim') && has('gui_running')
  set guioptions+=M
endif

"---------------------------------------------------------------------------
" Bram氏の提供する設定例をインクルード (別ファイル:vimrc_example.vim)。これ
" 以前にg:no_vimrc_exampleに非0な値を設定しておけばインクルードはしない。
if 1 && (!exists('g:no_vimrc_example') || g:no_vimrc_example == 0)
  if &guioptions !~# "M"
    " vimrc_example.vimを読み込む時はguioptionsにMフラグをつけて、syntax on
    " やfiletype plugin onが引き起こすmenu.vimの読み込みを避ける。こうしない
    " とencに対応するメニューファイルが読み込まれてしまい、これの後で読み込
    " まれる.vimrcでencが設定された場合にその設定が反映されずメニューが文字
    " 化けてしまう。
    set guioptions+=M
    source $VIMRUNTIME/vimrc_example.vim
    set guioptions-=M
  else
    source $VIMRUNTIME/vimrc_example.vim
  endif
endif

"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" タブの画面上での幅
set tabstop=8
" タブをスペースに展開しない (expandtab:展開する)
set expandtab
" 自動的にインデントする (noautoindent:インデントしない)
set autoindent
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start
" 検索時にファイルの最後まで行ったら最初に戻る (nowrapscan:戻らない)
set wrapscan
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 行番号を非表示 (number:表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" タブや改行を非表示 (list:表示)
set list
" どの文字でタブや改行を表示するかを設定
"set listchars=tab:>-,extends:<,trail:-,eol:<
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set title
" 画面を黒地に白にする (次行の先頭の " を削除すれば有効になる)
"colorscheme evening " (Windows用gvim使用時はgvimrcを編集すること)

"---------------------------------------------------------------------------
" ファイル操作に関する設定:
"
" バックアップファイルを作成しない (次行の先頭の " を削除すれば有効になる)
set nobackup


"---------------------------------------------------------------------------
" ファイル名に大文字小文字の区別がないシステム用の設定:
"   (例: DOS/Windows/MacOS)
"
if filereadable($VIM . '/vimrc') && filereadable($VIM . '/ViMrC')
  " tagsファイルの重複防止
  set tags=./tags,tags
endif

"---------------------------------------------------------------------------
" コンソールでのカラー表示のための設定(暫定的にUNIX専用)
if has('unix') && !has('gui_running')
  let s:uname = system('uname')
  if s:uname =~? "linux"
    " no need to use builtin_term for Linux
  elseif s:uname =~? "freebsd"
    set term=builtin_cons25
  elseif s:uname =~? "Darwin"
    set term=builtin_beos-ansi
  else
    set term=builtin_xterm
  endif
  unlet s:uname
endif

"---------------------------------------------------------------------------
" コンソール版で環境変数$DISPLAYが設定されていると起動が遅くなる件へ対応
if !has('gui_running') && has('xterm_clipboard')
  set clipboard=exclude:cons\\\|linux\\\|cygwin\\\|rxvt\\\|screen
endif

"---------------------------------------------------------------------------
" プラットホーム依存の特別な設定

" WinではPATHに$VIMが含まれていないときにexeを見つけ出せないので修正
if has('win32') && $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
  let $PATH = $VIM . ';' . $PATH
endif

if has('mac')
  " Macではデフォルトの'iskeyword'がcp932に対応しきれていないので修正
  set iskeyword=@,48-57,_,128-167,224-235
endif

"---------------------------------------------------------------------------
" KaoriYaでバンドルしているプラグインのための設定

" autofmt: 日本語文章のフォーマット(折り返し)プラグイン.
set formatexpr=autofmt#japanese#formatexpr()

" vimdoc-ja: 日本語ヘルプを無効化する.
if kaoriya#switch#enabled('disable-vimdoc-ja')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimdoc-ja"'), ',')
endif

" vimproc: 同梱のvimprocを無効化する
if kaoriya#switch#enabled('disable-vimproc')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]vimproc$"'), ',')
endif

" go-extra: 同梱の vim-go-extra を無効化する
if kaoriya#switch#enabled('disable-go-extra')
  let &rtp = join(filter(split(&rtp, ','), 'v:val !~ "[/\\\\]plugins[/\\\\]golang$"'), ',')
endif

" Copyright (C) 2009-2018 KaoriYa/MURAOKA Taro
"
"let mapleader = "\<Space>"
""
"" https://qiita.com/wadako111/items/755e753677dd72d8036d
"" Anywhere SID.
"
"function! s:SID_PREFIX()
"  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
"endfunction
"
"" Set tabline.
"function! s:my_tabline()  "{{{
"  let s = ''
"  for i in range(1, tabpagenr('$'))
"    let bufnrs = tabpagebuflist(i)
"    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
"    let no = i  " display 0-origin tabpagenr.
"    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
"    let title = fnamemodify(bufname(bufnr), ':t')
"    let title = '[' . title . ']'
"    let s .= '%'.i.'T'
"    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
"    let s .= no . ':' . title
"    let s .= mod
"    let s .= '%#TabLineFill# '
"  endfor
"  let s .= '%#TabLineFill#%T%=%#TabLine#'
"  return s
"endfunction "}}}
"let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
"set showtabline=2 " 常にタブラインを表示
"
"" The prefix key.
"nnoremap    [Tag]   <Nop>
"nmap    t [Tag]
"" Tab jump
"for n in range(1, 9)
"  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
"endfor
"" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
"
"map <silent> [Tag]c :tablast <bar> tabnew<CR>
"" tc 新しいタブを一番右に作る
"map <silent> [Tag]x :tabclose<CR>
"" tx タブを閉じる
"map <silent> [Tag]n :tabnext<CR>
"" tn 次のタブ
"map <silent> [Tag]p :tabprevious<CR>
"" tp 前のタブ
"
"
"map <C-C> <C-Ins>
"map! <C-C> <C-Ins>
"map <C-V> <S-Ins>
"map! <C-V> <S-Ins>
"
"" pwd を、今見ているバッファのpwdにする。
""set autochdir
"" 複数ファイルを開く
"set hidden
"" クリップボード設定
"set clipboard+=unnamed
"
"set directory=~HOME/temp
"set undodir=~HOME/temp
"set cursorline
"set cursorcolumn
"
"" https://qiita.com/enomotok/items/9d38b716fe883675d35b
"set iminsert=0
"set imsearch=-1
"" http://sifue.hatenablog.com/entry/20120411/1334161078
""set imdisable これはダメでした。
"
"if &compatible
"  set nocompatible
"endif
"
"" deinの設定とプラグインのインストール
"
"set runtimepath+=C:/Progra~1/vim/.vim/.dein/repos/github.com/Shougo/dein.vim
"
"let s:cache_home = empty($XDG_CACHE_HOME) ? expand('C:\Program Files/vim/.vim') : $XDG_CACHE_HOME
"let s:dein_dir = s:cache_home . '/.dein'
"let s:dein_repo_dir = s:dein_dir . '/repos/github.com'
"if !isdirectory(s:dein_repo_dir)
"  call system('git clone https://github.com/Shougo/dein.vim ' . shellescape(s:dein_repo_dir))
"endif
"
""let s:toml_file = "C:/Program Files/vim/.vim/.dein/.dein.toml"
"if dein#load_state(s:dein_dir)
"  call dein#begin(s:dein_dir, [$MYVIMRC, s:toml_file])
""  call dein#load_toml(s:toml_file)
"
"  call dein#add('Shougo/unite.vim')
"  call dein#add('Shougo/vimproc.vim', { 'build' : 'make' })
"  call dein#add('Shougo/VimShell.vim')
"
"  call dein#add('Shougo/neocomplete.vim')
"  call dein#add('Shougo/neosnippet')
"  call dein#add('Shougo/neosnippet-snippets')
"
"  call dein#add('Shougo/neomru.vim')
"  call dein#add('tyru/open-browser.vim')
"
"  call dein#add('vim-scripts/dbext.vim')
"
"  "call dein#add('taku-o/downloads/raw/master/copypath.vim')
""  call dein#add('taku-o/downloads/copypath.vim')
"
""  call dein#add( 'plasticboy/vim-markdown' )
"  call dein#add( 'kannokanno/previm' )
"
"  call dein#end()
"  call dein#save_state()
"endif
"
""
"" 不足プラグインの自動インストール
"if has('vim_starting') && dein#check_install()
"  call dein#install()
"endif
"
"autocmd ColorScheme * highlight FullWidthSpace guibg=darkgray
"autocmd VimEnter * match FullWidthSpace /　/
"
"" ファイル名表示
"set statusline=%F
"" 変更チェック表示
"set statusline+=%m
"" 読み込み専用かどうか表示
"set statusline+=%r
"" ヘルプページなら[HELP]と表示
"set statusline+=%h
"" プレビューウインドウなら[Prevew]と表示
"set statusline+=%w
"" これ以降は右寄せ表示
"set statusline+=%=
"" file encoding
"set statusline+=[%{&fileencoding}]
"" file encoding
"" set statusline+=[IN=%{&encoding}]
"" 現在行数/全行数
""set statusline+=[LOW=%l/%L]
"set statusline+=[%LL]
"set statusline+=[%{&filetype}]
"" ステータスラインを常に表示(0:表示しない、1:2つ以上ウィンドウがある時だけ表示)
"set laststatus=2
"
"" https://nanasi.jp/articles/vim/copypath_vim.html
""source C:\Program Files\vim\plugins\copypath.vim
"let g:\copypath_copy_to_unnamed_register = 1
"nnoremap <silent> <C-c>p :CopyPath<return>
"nnoremap <silent> <C-c>f :CopyFileName<return>
""
"inoremap <silent> jj <ESC>
""
"" ,is: シェルを起動
"nnoremap <Leader>is :VimShell<return>
"
"" ,Ur: 最近のファイル一覧
"nnoremap ,Ur :Unite file_mru<return>
"nnoremap <Leader>ur :Unite file_mru<return>
"" ,Ub: バッファ一覧
"nnoremap <Leader>ub :Unite buffer<return>
"" ,Ut: タブ一覧
"nnoremap <Leader>ut :Unite tab<return>
"
"" タブ動作
"nnoremap <silent> ta :tabnew<return>
"nnoremap <silent> tn :tabnext<return>
"nnoremap <silent> tp :tabp<return>
"
"" open-browser.vim  ブラウザを開く
"let g:netrw_nogx = 1
"nmap <Leader>gx <Plug>(openbrowser-smart-search)
"vmap <Leader>gx <Plug>(openbrowser-smart-search)
""
"" chrome
"" http://hanagurotanuki.blogspot.com/2015/03/windowsopen-browservimchrome.html
"if has('win32') || has('win64')
" let g:openbrowser_browser_commands = [
" \   {
" \       "name": "C:\\Program\ Files\ (x86)\\Google\\Chrome\\Application\\chrome.exe",
" \       "args": ["{browser}", "{uri}"]
" \   }
" \ ]
"endif
"
""markdown を開く
""https://qiita.com/uedatakeshi/items/31761b87ba8ecbaf2c1e
"au BufRead,BufNewFile *.md set filetype=markdown
"let g:previm_open_cmd = 'open -a chrome'
"
"
"" dbext
""    MySQL
"" let g:dbext_default_profile_mysqlnodb = 'type=MYSQL:host=127.0.0.1:user=root:passwd=password:dbname=test'
""    ORACLE
"" let g:dbext_default_profile_myORA = 'type=ORA:srvname=127.0.0.1:user=scott:passwd=tiger'"    
"
""    Postgres
"let g:dbext_default_profile_pgPermaiTRUE = 'type=PGSQL:host=202.254.188.51:user=permaite:dbname=permaite:passwd=permaite:port=5432'
"let g:dbext_default_profile_pgPermaiTEST = 'type=PGSQL:host=10.168.32.50:user=permaite:dbname=permaite:passwd=permaite:port=5432'
"let g:dbext_default_profile = 'pgPermaiTRUE'
""let g:dbext_default_PGSQLcmd_options = '\encoding UTF8'
"
"
"" 引数なしでvimを開くとNERDTreeを起動
"let file_name = expand('%')
""if has('vim_starting') &&  file_name == ''
"" autocmd VimEnter * NERDTree ./
""ndif
"
"
""----------------------------------------------------------
"" neocomplete・neosnippetの設定
""----------------------------------------------------------
"if dein#is_installed('neocomplete.vim')
"    " Vim起動時にneocompleteを有効にする
"    let g:neocomplete#enable_at_startup = 1
"    " smartcase有効化. 大文字が入力されるまで
"    " 大文字小文字の区別を無視する
"    let g:neocomplete#enable_smart_case = 1
"    " 3文字以上の単語に対して補完を有効にする
"    let g:neocomplete#min_keyword_length = 3
"    " 区切り文字まで補完する
"    let g:neocomplete#enable_auto_delimiter = 1
"    " 1文字目の入力から補完のポップアップを表示
"    let g:neocomplete#auto_completion_start_length = 1
"    " バックスペースで補完のポップアップを閉じる
"    inoremap <expr><BS> neocomplete#smart_close_popup()."<C-h>"
"
"    " エンターキーで補完候補の確定. スニペットの展開も
"    " エンターキーで確定・・・・・・②
"    imap <expr><CR> neosnippet#expandable() ? "<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "<C-y>" : "<CR>"
"    " タブキーで補完候補の選択. スニペット内のジャンプも
"    " タブキーでジャンプ・・・・・・③
"    imap <expr><TAB> pumvisible() ? "<C-n>" : neosnippet#jumpable() ? "<Plug>(neosnippet_expand_or_jump)" : "<TAB>"
"endif
"
