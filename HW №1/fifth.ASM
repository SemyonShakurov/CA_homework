format PE GUI 4.0
entry start
include 'win32a.inc'

ID_EDITSurname = 3
ID_EDITName = 5
ID_EDITPatronymic = 7
ID_EDITResult = 9
ID_BUTTON = 0Ah

section '.code' code readable executable
 start:invoke GetModuleHandle, 0
 invoke DialogBoxParam, eax, 1, HWND_DESKTOP, DialogProc, 0
 invoke ExitProcess, 0
 proc DialogProc hwnddlg, msg, wparam, lparam
 xor eax, eax
 cmp [msg], WM_CLOSE
 je FreeDialog
 cmp [msg], WM_COMMAND
 jne ExitProc
 mov eax, BN_CLICKED
 shl eax, 10h
 add eax, ID_BUTTON
 cmp [wparam], eax
 jne ExitProc

 invoke GetDlgItemText, [hwnddlg], ID_EDITSurname, ResultString, 20h

mov eax, PointTabString
inc eax
invoke lstrcat, ResultString, eax
invoke GetDlgItemText, [hwnddlg], ID_EDITName, Intermediate, 2
invoke lstrcat, ResultString, Intermediate
invoke lstrcat, ResultString, PointTabString
invoke GetDlgItemText, [hwnddlg], ID_EDITPatronymic, Intermediate, 2
invoke lstrcat, ResultString, Intermediate
invoke lstrcat, ResultString, PointTabString
invoke SetDlgItemText, [hwnddlg], ID_EDITResult, ResultString
       ret
 FreeDialog:
        invoke EndDialog, [hwnddlg], 0
 ExitProc: ret
    endp

section '.bss' readable writeable
PointTabString db '. ', 00h
Intermediate db 00h, 00h
ResultString rb 28h

section '.idata' import data readable writeable
 library kernel, 'KERNEL32.DLL' ,\
 user , 'USER32.DLL'

import kernel,\
 GetModuleHandle, 'GetModuleHandleA',\
 ExitProcess , 'ExitProcess' ,\
 lstrcat , 'lstrcatA'

import user,\
 DialogBoxParam, 'DialogBoxParamA',\
 EndDialog , 'EndDialog' ,\
 GetDlgItemText, 'GetDlgItemTextA',\
 SetDlgItemText, 'SetDlgItemTextA'

section '.rsrc' resource data readable
 directory RT_DIALOG, dialogs
 resource dialogs,\
 1, LANG_NEUTRAL, WorkWithEdit
 dialog WorkWithEdit, 'Strings', 0, 0, 150, 130, WS_CAPTION+WS_SYSMENU+DS_CENTER
 dialogitem 'STATIC', 'Surname: ' , 2, 10, 5, 100, 12, WS_VISIBLE
 dialogitem 'EDIT' , '' , ID_EDITSurname, 10, 15, 130, 12, WS_VISIBLE+WS_BORDER+WS_TABSTOP
 dialogitem 'STATIC', 'Name: ' , 4, 10, 30, 100, 12, WS_VISIBLE
 dialogitem 'EDIT' , '' , ID_EDITName, 10, 40, 130, 12, WS_VISIBLE+WS_BORDER+WS_TABSTOP
 dialogitem 'STATIC', 'Patronymic: ', 6, 10, 55, 100, 12, WS_VISIBLE
 dialogitem 'EDIT' , '' , ID_EDITPatronymic, 10, 65, 130, 12, WS_VISIBLE+WS_BORDER+WS_TABSTOP
 dialogitem 'STATIC', 'Result: ' , 8, 10, 80, 100, 12, WS_VISIBLE
 dialogitem 'EDIT' , '' , ID_EDITResult, 10, 90, 130, 12, WS_VISIBLE+WS_BORDER
 dialogitem 'BUTTON', 'Show text' , ID_BUTTON, 40, 110, 50, 15, WS_VISIBLE+WS_TABSTOP
 enddialog




