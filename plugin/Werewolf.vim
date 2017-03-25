" WEREWOLF
"" version 1.2.1
"" changes your colorscheme depending on the time of day
"" by Jonathan Stoler

let g:werewolf_day_start = get(g:, 'werewolf_day_start', 8)
let g:werewolf_day_end = get(g:, 'werewolf_day_end', 20)
let g:werewolf_day_theme = get(g:, 'werewolf_day_theme', g:colors_name)
let g:werewolf_night_theme = get(g:, 'werewolf_night_theme', g:colors_name)
let g:werewolf_change_automatically = get(g:, 'werewolf_change_automatically', 1)

let s:werewolf_autocmd_allowed = 0

function! Werewolf()
  if g:werewolf_change_automatically == 0
    return
  endif

	if strftime("%H") >= g:werewolf_day_start && strftime("%H") < g:werewolf_day_end
		call Werewolf#transform(g:werewolf_day_theme, 'light')
	else
		call Werewolf#transform(g:werewolf_night_theme, 'dark')
	endif
endfunction

function! Werewolf#transform(cs, bg)
  if &background !=# a:bg
    execute "set background=" . a:bg
  endif

  if g:colors_name != a:cs
    execute "colorscheme " . a:cs
  endif
endfunction

function! WerewolfToggle()
  let g:werewolf_change_automatically = 0
	if &background ==# 'dark'
		call Werewolf#transform(g:werewolf_day_theme, 'light')
	else
		call Werewolf#transform(g:werewolf_night_theme, 'dark')
	endif
endfunction

function! Werewolf#autoChange()
	if g:werewolf_change_automatically
		let s:werewolf_autocmd_allowed = 1
		call Werewolf()
	endif
endfunction

command! WerewolfTransform call Werewolf()
command! WerewolfToggle call WerewolfToggle()
command! -bang WerewolfAuto let g:werewolf_change_automatically = <bang>g:werewolf_change_automatically
command! WerewolfOn let g:werewolf_change_automatically = 1
command! WerewolfOff let g:werewolf_change_automatically = 0
command! -nargs=1 WerewolfStart let g:werewolf_day_start = <args>
command! -nargs=1 WerewolfEnd let g:werewolf_day_end = <args>

augroup werewolf
	autocmd!
	autocmd CursorMoved,CursorHold,CursorHoldI,WinEnter,WinLeave,FocusLost,FocusGained,VimResized,ShellCmdPost * nested call Werewolf#autoChange()
augroup END
