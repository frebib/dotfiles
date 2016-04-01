set nocompatible              " be iMproved, required
filetype off                  " required

syntax enable
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set number
set autoindent
set laststatus=2
set mouse=a
set encoding=utf-8

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

call vundle#end()

" Vim-Airline config
let g:Powerline_symbols = 'fancy'
let g:airline_powerline_fonts = 1

" Interface with system clipboard
noremap <Leader>y "*y
noremap <Leader>p "*p
noremap <Leader>Y "+y
noremap <Leader>P "+p

" Write with sudo
cmap w!! w !sudo tee > /dev/null %

" airline buffer list
let g:airline#extensions#tabline#enabled = 1
