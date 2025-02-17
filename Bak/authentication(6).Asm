.386
.model flat, stdcall  ;32 bit memory model
option casemap :none  ;case sensitive

include authentication.inc

.code

start:

	invoke GetModuleHandle,NULL
	mov		hInstance,eax

    invoke InitCommonControls
	invoke DialogBoxParam,hInstance,IDD_DIALOG1,NULL,addr menuP,NULL
	invoke ExitProcess,0

;########################################################################

menuP proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM

	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		invoke ShowWindow, hWin, SW_HIDE
		invoke DialogBoxParam, hInstance, IDD_DIALOG2, NULL, addr loginRegister, hWin							

	.elseif eax==WM_COMMAND
			mov eax, wParam
			.if eax == LOGOUT_BUTTON
				invoke ShowWindow, hWin, SW_HIDE
				invoke DialogBoxParam, hInstance, IDD_DIALOG2, NULL, addr loginRegister, hWin
			.endif
	.elseif eax==WM_CLOSE
		invoke EndDialog,hWin,0
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

menuP endp

loginRegister proc hWin:HWND,uMsg:UINT,wParam:WPARAM,lParam:LPARAM
 LOCAL hMainWin:HWND
	mov		eax,uMsg
	.if eax==WM_INITDIALOG
		mov hMainWin, lParam
	.elseif eax==WM_COMMAND
		mov eax, wParam
		.if eax == LOGIN_BUTTON
			invoke GetDlgItemText, hWin, USER_TEXT, ADDR inputUser, SIZEOF inputUser
			invoke lstrcmp, ADDR adminUser, ADDR inputUser
			.if eax == 0
				invoke GetDlgItemText, hWin, PASSWORD_TEXT, ADDR inputPassword, SIZEOF inputPassword
				invoke lstrcmp, ADDR adminPassword, ADDR inputPassword 
				.if eax == 0
				    invoke MessageBox, NULL, ADDR successLogin, ADDR loginTitle, MB_OK or MB_ICONINFORMATION
				    invoke EndDialog,hWin,0
				    invoke SendMessage, hMainWin, WM_SHOWWINDOW, TRUE, 0
				.endif

			.endif			
		.endif

	.elseif eax==WM_CLOSE
		
	.else
		mov		eax,FALSE
		ret
	.endif
	mov		eax,TRUE
	ret

loginRegister endp


end start
