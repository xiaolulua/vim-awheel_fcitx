""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"Author : 路永磊
"plugin : awheel_fcitx.vim
"Date   : 2020-05-29
"Usage  : 解决vim使用中文输入法时的干扰问题
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:chinese_enable = 2                                     "若当前系统为中文输入法,则获取的输入法状态值为 2
let s:english_enable = 1                                     "若当前系统为英文输入法,则获取的输入法状态值为 1
let s:get_fcitx_language_status = "fcitx-remote"             "获取当前输入法的状态值
let s:set_fcitx_chinese         = "fcitx-remote -o"          "把输入法设置为 中文
let s:set_fcitx_english         = "fcitx-remote -c"          "把输入法设置为 英文

let s:start_language_status = system(s:set_fcitx_english)    "vim启动时,默认把输入法设置为英文



"此处可以根据编辑的文件后缀名来做更改
let g:saved_insert_mode_language_status = s:english_enable                     "初始设置 插入模式 输入法为英文
autocmd BufNewFile,BufRead *.txt,*.text,[Rr][Ee][Aa][Dd][Mm][Ee] 
			\let g:saved_insert_mode_language_status = s:chinese_enable        "在编辑*.txt,*.text文件格式的时候



"当退出 插入模式 时,会把输入法设置为英文 
function! s:fcitx_2_english()
	let s:exit_insert_status = system(s:get_fcitx_language_status)      "检查退出 插入模式 时,输入法的状态
	if s:exit_insert_status != s:english_enable                         "如果退出 插入模式 时,输入法不是英文
		let l:temp = system(s:set_fcitx_english)                        "将输入法设置为英文
	endif
	let g:saved_insert_mode_language_status = s:exit_insert_status      "保存退出 插入模式 时的输入法状态 
endfunction

"当进入 插入模式 时,输入法会自动选择语言为上一次插入模式使用的语言
function! s:fcitx_enter_insert_mode()
	let s:enter_insert_status = system(s:get_fcitx_language_status)     "获取进入 插入模式 时,输入法的状态
	if s:enter_insert_status != g:saved_insert_mode_language_status     "如果当前输入法语言和上一次退出插入模式时的语言不一样
		if g:saved_insert_mode_language_status == s:chinese_enable      "改变输入法当前语言为上一次退出插入模式时的语言
			let l:temp = system(s:set_fcitx_chinese)
		else
			let l:temp = system(s:set_fcitx_english)
		endif
	endif
endfunction



"退出插入模式调用的函数
autocmd InsertLeave * call s:fcitx_2_english()

"进入插入模式调用的函数
autocmd InsertEnter * call s:fcitx_enter_insert_mode()
