" Vim plugin script
" File: session.vim
" Summary: session make
" Authors: rozeroze <rosettastone1886@gmail.com>
" License: MIT
" Version: 2018-06-19


if exists('g:loaded_session_maker')
   finish
endif

let s:save_cpo = &cpo
set cpo&vim


""" session
if !exists('g:session')
   """ init
   let g:session = {}
   let g:session.banker = '$HOME/vim-sessions/'
   let g:session.option = 'blank,buffers,curdir,folds,globals,help,options,tabpages,winsize,localoptions,slash'
   let g:session.viminfo = v:false
   let g:session.smoker = 'load'
   let g:session.topt = {}
   let g:session.topt.make = ['m', '-m', 'make', '-make']
   let g:session.topt.load = ['l', '-l', 'load', '-load']
   let g:session.topt.list = ['list', '-list']
   let g:session.defaultname = 'session'
else
   """ user setted
   if type(g:session) != v:t_dict
      unlet g:session
      let g:session = {}
   endif
   " bank
   if !exists('g:session.banker')
      let g:session.banker = '$HOME/vim-sessions/'
   endif
   " option
   if !exists('g:session.option')
      let g:session.option = 'blank,buffers,curdir,folds,globals,help,localoptions,options,slash,tabpages,winsize'
   endif
   " viminfo
   if !exists('g:session.viminfo')
      let g:session.viminfo = v:false
   endif
   " smoke -- shortcut
   if !exists('g:session.smoker')
      let g:session.smoker = 'load'
   endif
   " make -opts
   let g:session.topt = {}
   if !exists('g:session.topt.make')
      let g:session.topt.make = ['m', '-m', 'make', '-make']
   endif
   " load -opts
   if !exists('g:session.topt.load')
      let g:session.topt.load = ['l', '-l', 'load', '-load']
   endif
   " list -opts
   if !exists('g:session.topt.list')
      let g:session.topt.list = ['list', '-list']
   endif
   " default-name
   if !exists('g:session.defaultname')
      let g:session.defaultname = 'session'
   endif
endif

""" auto action
" auto save
if exists('g:session.autosave')
   autocmd VimLeave * call session#session(g:session.topt.make[0] . ' ' . g:session.autosave)
endif
" auto load
if exists('g:session.autoload')
   autocmd VimEnter * call session#session(g:session.topt.load[0] . ' ' . g:session.autoload)
endif

command! -nargs=* Session :call session#session(<f-args>)


let &cpo = s:save_cpo
unlet s:save_cpo

let g:loaded_session_maker = 1


" vim: set ts=3 sts=3 sw=3 et :
