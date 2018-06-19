" Vim plugin script
" File: session.vim
" Summary: session make
" Authors: rozeroze <rosettastone1886@gmail.com>
" License: MIT
" Version: 2018-06-19


function! session#session(...)
   " smoke call, this is short cut
   if a:0 == 0
      call session#session(g:session.smoker)
      return
   endif
   " banker alive?
   if !session#alive()
      echo 'error: session-banker was dead. - session.vim'
      return
   endif
   " call make or load?
   let type = session#gettype(a:1)
   if type == 'make'
      call session#make(a:000[1:])
      return
   elseif type == 'load'
      call session#load(a:000[1:])
      return
   elseif type == 'list'
      call session#list()
      return
   elseif type == 'error'
      echo 'ERROR: type is wrong. - session.vim'
      return
   else
      echo 'ERROR: error. - session.vim'
      return
   endif
endfunction

function! session#alive()
   let path = expand(g:session.banker)
   if isdirectory(path)
      return v:true
   endif
   if glob(path) != ''
      return v:false
   endif
   if exists('*mkdir')
      call mkdir(path, 'p')
   endif
   return isdirectory(path)
endfunction

function! session#gettype(type)
   if a:type == ''
      return 'error'
   endif
   if session#in(a:type, g:session.topt.make)
      return 'make'
   endif
   if session#in(a:type, g:session.topt.load)
      return 'load'
   endif
   if session#in(a:type, g:session.topt.list)
      return 'list'
   endif
   return 'error'
endfunction

function! session#in(target, list)
   if type(a:list) != v:t_list
      " argument error
      return v:false
   endif
   for item in a:list
      if a:target ==? item
         return v:true
      endif
   endfor
   return v:false
endfunction

function! session#make(args)
   let name = session#getname(a:args)
   if !session#makable(name)
      echo 'error: permission denied. cannot make session file. -session.vim'
      return
   endif
   let path = expand(g:session.banker . name)
   execute 'mksession! ' . path
   if g:session.viminfo
      let vname = name . '.viminfo'
      if session#makable(vname)
         let path = expand(g:session.banker . vname)
         execute 'wviminfo! ' . path
      else
         echo 'error: permission denied. cannot make viminfo file. -session.vim'
      endif
   endif
   if g:session.quickfix
      let qname = name . '.quickfix'
      if session#makable(qname)
         let path = expand(g:session.banker . qname)
         let qflist = getqflist()
         for qf in qflist
            let qf.filename = fnamemodify(bufname(qf.bufnr), ':p')
            unlet qf.bufnr
         endfor
         call map(qflist, 'string(v:val)')
         call writefile(qflist, path)
      else
         echo 'error: permission denied. cannot make quickfix file. -session.vim'
      endif
   endif
   echo 'code: make session file is complete! -session.vim'
endfunction

function! session#load(args)
   let name = session#getname(a:args)
   if !session#exist(name)
      echo 'error: cannot read session file. -session.vim'
      return
   endif
   if !session#loadable(name)
      echo 'error: permission denied. cannot load session file. -session.vim'
      return
   endif
   let path = expand(g:session.banker . name)
   execute 'source ' . path
   if g:session.viminfo
      let vname .= '.viminfo'
      if session#loadable(vname)
         let path = expand(g:session.banker . vname)
         execute 'rviminfo! ' . path
      else
         echo 'error: permission denied. cannot load viminfo file. -session.vim'
      endif
   endif
   if g:session.quickfix
      let qname = name . '.quickfix'
      if session#loadable(qname)
         let path = expand(g:session.banker . qname)
         let qflist = readfile(path)
         call map(qflist, 'eval(v:val)')
         call setqflist(qflist)
      else
         echo 'error: permission denied. cannot load quickfix file. -session.vim'
      endif
   endif
   echo 'code: load session file is complete! -session.vim'
endfunction

function! session#getname(args)
   if type(a:args) != v:t_list
      " argument error
      return g:session.defaultname
   endif
   if len(a:args) == 0
      " name wasnt defined
      return g:session.defaultname
   endif
   return a:args[0]
endfunction

function! session#exist(name)
   let path = expand(g:session.banker . a:name)
   return glob(path) != ''
endfunction

function! session#makable(name)
   let path = expand(g:session.banker . a:name)
   return glob(path) == '' || filewritable(path)
endfunction
function! session#loadable(name)
   let path = expand(g:session.banker . a:name)
   return filereadable(path)
endfunction

function! session#list()
   let path = expand(g:session.banker) . '*'
   let spath = glob(path, v:false, v:true)
   call filter(spath, 'v:val !~# ".*\.quickfix"')
   call filter(spath, 'v:val !~# ".*\.viminfo"')
   call map(spath, 'fnamemodify(v:val, ":t")')
   for s in spath
      echo s
   endfor
endfunction


" vim: set ts=3 sts=3 sw=3 et tw=0 fdm=marker :
