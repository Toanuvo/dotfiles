#SingleInstance Force
GroupAdd "AltTabWindow", "ahk_class MultitaskingViewFrame"

#HotIf !WinExist("ahk_exe VirtualBoxVM.exe")
CapsLock::Esc
ScrollLock::CapsLock
#HotIf

srun(p){
        if(0 != PID := ProcessExist(p)){
                WinActivate "ahk_pid " PID
                return
        }

        Run p,,"Max", &PID
        WinWait "ahk_pid " PID
        WinActivate "ahk_pid " PID
        WinSetStyle "-0xC00000", "A"
}

!F3::{
ids := WinGetList(,, "Program Manager")
             for this_id in ids
             {
                     WinActivate this_id
                             this_class := WinGetClass(this_id)
                                           this_title := WinGetTitle(this_id)
                                                         Result := MsgBox(
                                                                         (
                                                                          "Visiting All Windows
                                                                          " A_Index " of " ids.Length "
                                                                          ahk_id " this_id "
                                                                          ahk_class " this_class "
                                                                          " this_title "

                                                                          Continue?"
                                                                         ),, 4)
                                                                 if (Result = "No")
                                                                         break
             }
}

#HotIf !WinExist("ahk_exe dota2.exe")
!1::srun "nvim-qt.exe"
!2::srun "vifm.exe"
!3::srun "jqt.exe"
!4::srun "alacritty.exe"
#HotIf

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
