set nocompatible              " be iMproved, required

syntax enable
set tabstop=4
set shiftwidth=0
set softtabstop=-1
set expandtab
set number
set autoindent
set laststatus=2
set mouse=a
set encoding=utf-8
set background=dark
set directory=$HOME/.vim/swapfiles//

" GVim settings
set guifont=Sauce\ Code\ Pro\ 10.5
set guioptions=

" Change to dvorak-mapped keys
let g:use_dvorak = 1

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-sensible'
Plugin 'vim-scripts/vim-auto-save'
Plugin 'airblade/vim-gitgutter'
Plugin 'ryanoasis/vim-devicons'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'PotatoesMaster/i3-vim-syntax'
Plugin 'solarnz/thrift.vim'
Plugin 'jiangmiao/auto-pairs'

call vundle#end()

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"
execute "set rtp+=" . g:opamshare . "/vim/syntax/ocp-indent.vim"
let g:syntastic_ocaml_checkers = ['merlin']
let g:syntastic_ignore_files = ['\m\c.(mll|mly)$']
set omnifunc=syntaxcomplete#Complete

" YouCompleteMe python fix
let g:ycm_server_python_interpreter = '/usr/bin/python3'

" Vim-Airline config
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1
let g:airline_theme='solarized'
let g:airline#extensions#tabline#enabled = 1

" vim-auto-save
let g:auto_save = 1  " enable AutoSave on Vim startup

let mapleader="\<space>"
" Unbind arrow keys
for prefix in ['n', 'v']
    for key in ['<Up>', '<Down>', '<Left>', '<Right>']
        exe prefix . "noremap " . key . " <Nop>"
    endfor
endfor

" Dvorak Hackery
" Source: https://github.com/sporkbox/vimrc/blob/master/vimrc
if (exists("g:use_dvorak") && g:use_dvorak == 1)
	" I use a Dvorak keyboard, so standard vim movement keys are a hassle.
	" Since mnemonics are helpful all around, I need a mapping that gives me
	" pain-free file navigation without screwing up mnemonics (too much).
	"
	" Thus:
	" (D)elete is now (K)ill: d2w == k2w "kill 2 words"
	" Un(T)il is now (J)ump-To: dt( == kj( "kill, jump-to paren"
	" (N)ext is now (L)eap: cn == cl "change up to leap point"

	" Standard movement, which is the true focus of this hack.
	" Mnemonics are awesome, so let's preserve as much as possible.
	noremap d h
	noremap h j
	noremap t k
	noremap n l
	noremap D H
	noremap H J
	noremap T K
	noremap N L

	noremap gh gj
	noremap gt gk

	" I work with tabs every now and then. No, I don't have a mnemonic, so
	" stfu.
	noremap gj gt
	noremap gJ gT

	" Window movement, equally important
	noremap <C-w>d <C-w>h
	noremap <C-w>h <C-w>j
	noremap <C-w>t <C-w>k
	noremap <C-w>n <C-w>l

	nnoremap <C-w><C-d> <C-w><C-h>
	nnoremap <C-w><C-h> <C-w><C-j>
	nnoremap <C-w><C-t> <C-w><C-k>
	nnoremap <C-w><C-n> <C-w><C-l>

	"nnoremap <C-d> <C-w>h
	"nnoremap <C-h> <C-w>j
	"nnoremap <C-t> <C-w>k
	"nnoremap <C-n> <C-w>l

	" Account for tag jumping
	nnoremap <C-j> <C-t>

	" Remappings for the D key
	noremap k d
	noremap K D

	" Remappings for the T key
	noremap j t
	noremap J T

	" Remapping for the L key
	noremap l n
	noremap L N

	" General purpose help; the originals remain for convenience
	noremap - 0
	noremap _ $

	" Fold-related keybindings
	noremap zh zj
	noremap zt zk

endif

" Interface with system clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Search options
set hlsearch
set ignorecase
set smartcase

" Save aliases.
noremap <Leader>q :wq<CR>
com W w
com Q q
com Wq wq
com WQ wq
" Write with sudo
cmap w!! w !sudo tee > /dev/null %
