scriptencoding utf-8

function! s:popup_menu_update(wid, ctx) abort
  let l:buf = winbufnr(a:wid)
  let l:menu = map(copy(a:ctx.menu), '(v:key == a:ctx.select ? "→" : "  ") .. v:val')
  call setbufline(l:buf, 1, [a:ctx.title] + l:menu)
endfunction

function! s:popup_filter(ctx, wid, c) abort
  if a:c ==# 'j'
    let a:ctx.select += a:ctx.select ==# len(a:ctx.menu)-1 ? 0 : 1
    call s:popup_menu_update(s:wid, a:ctx)
  elseif a:c ==# 'k'
    let a:ctx.select -= a:ctx.select ==# 0 ? 0 : 1
    call s:popup_menu_update(s:wid, a:ctx)
  elseif a:c ==# "\n" || a:c ==# "\r" || a:c ==# ' '
    call popup_close(a:wid)
    if a:ctx.select ==# 1
      bw!
    endif
  endif
  return 1
endfunction

function! s:show_popup(title, menu) abort
  let l:ctx = {'select': 0, 'title': a:title, 'menu': a:menu}
  let s:wid = popup_create([a:title] + a:menu, {
  \  'border': [1,1,1,1],
  \  'filter': function('s:popup_filter', [l:ctx]),
  \})
  call s:popup_menu_update(s:wid, l:ctx)
endfunction

function! s:open_a_file() abort
  let l:name = expand('<afile>')
  if empty(l:name)
    return
  endif
  call s:show_popup(l:name . 'があらわれた', ['たたかう', 'にげる'])
endfunction

augroup VimgonQuestMenu
  au!
  au BufRead * call s:open_a_file()
augroup END
