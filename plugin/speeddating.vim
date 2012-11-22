" speeddating.vim - Use CTRL-A/CTRL-X to increment dates, times, and more
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      20100301
" GetLatestVimScripts: 2120 1 :AutoInstall: speeddating.vim

" Initialization {{{1

if exists("g:loaded_speeddating") || &cp || v:version < 700
    finish
endif
let g:loaded_speeddating = 1

let s:cpo_save = &cpo
set cpo&vim

let g:speeddating_handlers = []
let g:speeddating_formats = []

" }}}1
" Time Handler {{{1

function! SpeedDatingFmt(master,count,bang)
  " Calls with neither argument nor count are for information,
  " and so should be handled immediately.
  " Call loadformats to cause autoloading to happen
  if a:master == "" && !a:count
    call speeddating#loadformats()
  endif

  if exists("g:speeddating_loaded_formats")
    " Autoloading already done pass on request immediately
    call speeddating#adddate(a:master,a:count,a:bang)
  else
    " Defer handling of format specifications until autoloading is done
    let g:speeddating_formats += [[a:master,a:count,a:bang]]
  endif
endfunction

command! -bar -bang -count=0 -nargs=? SpeedDatingFormat :call SpeedDatingFmt(<q-args>,<count>,<bang>0)

" }}}1
" Maps {{{1

nnoremap <silent> <Plug>SpeedDatingUp   :<C-U>call speeddating#increment(v:count1)<CR>
nnoremap <silent> <Plug>SpeedDatingDown :<C-U>call speeddating#increment(-v:count1)<CR>
vnoremap <silent> <Plug>SpeedDatingUp   :<C-U>call speeddating#incrementvisual(v:count1)<CR>
vnoremap <silent> <Plug>SpeedDatingDown :<C-U>call speeddating#incrementvisual(-v:count1)<CR>
nnoremap <silent> <Plug>SpeedDatingNowLocal :<C-U>call speeddating#timestamp(0,v:count)<CR>
nnoremap <silent> <Plug>SpeedDatingNowUTC   :<C-U>call speeddating#timestamp(1,v:count)<CR>

if !exists("g:speeddating_no_mappings") || !g:speeddating_no_mappings
    nmap  <C-A>     <Plug>SpeedDatingUp
    nmap  <C-X>     <Plug>SpeedDatingDown
    xmap  <C-A>     <Plug>SpeedDatingUp
    xmap  <C-X>     <Plug>SpeedDatingDown
    nmap d<C-A>     <Plug>SpeedDatingNowUTC
    nmap d<C-X>     <Plug>SpeedDatingNowLocal
endif

" }}}1

let &cpo = s:cpo_save

" vim:set et sw=2 sts=2:
