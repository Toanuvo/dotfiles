#SingleInstance Force
GroupAdd "AltTabWindow", "ahk_class MultitaskingViewFrame"

CapsLock::Esc
ScrollLock::CapsLock

srun(s){
        run s
        WinWaitNotActive WinExist("A")
        WinMaximize "A"
        WinSetStyle "-0xC00000", "A"
}

!F1::srun "nvim-qt"
!F2::srun "vifm"

^`::WinSetStyle "-0xC00000", "A"
;<!Tab::<!^Tab

#HotIf WinExist("ahk_group AltTabWindow")  ; Indicates that the alt-tab menu is present on the screen.
h::Left
l::Right
j::Down
k::Up
#HotIf


#HotIf WinActive("ahk_class CabinetWClass")
!Enter::{
	ed :=  explr_d()
	Run 'C:\tools\neovim\Neovim\bin\nvim-qt.exe +Explore "' . ed . '"', ed
	WinWait "Neovim"
	WinActivate "Neovim"
}

explr_d(){
	explorerHwnd := WinActive("ahk_class CabinetWClass")
	if (explorerHwnd)
	{
		for window in ComObject("Shell.Application").Windows
		{
			if (window.hwnd==explorerHwnd)
			{
				return window.Document.Folder.Self.Path
			}
		}
	}
}

while 1 {
	WinWaitActive "Neovim"
	WinSetStyle "-0xC00000"
	WinWaitNotActive "Neovim"
}
