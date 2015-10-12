@echo off
setlocal EnableDelayedExpansion

set verb=%1

::Do nothing if %1 starts with none
if "%verb:~0,4%" EQU "none" (
	exit /b
) else (
	if "%verb:~0,5%" EQU "menu-" (
		set pathfile_path="%temp%\kamesvn.tmp"
		call :menu_%verb:~5,-1%%verb:~-1% "%~2"
		goto :end_menu
		:menu_update
			if exist "%~dpnx1" (
				TortoiseProc /command:update /rev /path:"%~dpnx1"
			)
			goto end_menu
		:menu_updateall
			TortoiseProc /command:update /rev /path:"%cd%"
			goto end_menu
		:menu_blame
			if exist "%~dpnx1" (
				if not exist "%~dpnx1\" (
					TortoiseProc /command:blame /path:"%~dpnx1"
				)
			)
			goto end_menu
		:menu_diff
			if exist "%~dpnx1" (
				if not exist "%~dpnx1\" (
					TortoiseProc /command:diff /path:"%~dpnx1"
				)
			)
			goto end_menu
		:menu_console
			start cmd /k "echo This working directory is versioned using SVN."
			goto end_menu
		:menu_repobrowser
			if exist "%~dpnx1" (
				TortoiseProc /command:repobrowser /path:"%~dpnx1"
			)
			goto end_menu
		:menu_switch
			TortoiseProc /command:switch /path:"%cd%"
			goto end_menu
		:menu_branch
			TortoiseProc /command:copy /path:"%cd%"
			goto end_menu
		:menu_merge
			TortoiseProc /command:merge /path:"%cd%"
			goto end_menu
		:menu_clean
			TortoiseProc /command:cleanup /path:"%cd%"
			goto end_menu
		:menu_lock
			if exist "%~dpnx1" (
				TortoiseProc /command:lock /path:"%~dpnx1"
			)
			goto end_menu
		:menu_unlock
			if exist "%~dpnx1" (
				TortoiseProc /command:unlock /path:"%~dpnx1"
			)
			goto end_menu
		:menu_properties
			if exist "%~dpnx1" (
				TortoiseProc /command:properties /path:"%~dpnx1"
			)
			goto end_menu
		:menu_revgraph
			if exist "%~dpnx1" (
				TortoiseProc /command:revisiongraph /path:"%~dpnx1"
			)
			goto end_menu
		:menu_createpatch
			TortoiseProc /command:createpatch /path:"%cd%"
			goto end_menu
		:menu_applypatch
			TortoiseMerge /patchpath:"%cd%"
			goto end_menu
		:end_menu
		goto :eof
	) else (
		if "%1" EQU "postimport" (
			echo Checking out working copy...
			for /f "usebackq tokens=*" %%i in (`svn checkout "%~2" . --username "%~3" --password "%~4" --non-interactive`) do echo %%i
			echo.
			echo Ignoring SCIfile.txt...
			for /f "usebackq tokens=*" %%i in (`svn propset svn:ignore "SCIfile.txt" .`) do echo %%i
			for /f "usebackq tokens=*" %%i in (`svn commit . -m "Ignored SCIfile.txt" --depth=empty --username "%~3" --password "%~4" --non-interactive`) do echo %%i
			echo.
		) else (
			for /f "usebackq tokens=*" %%i in (`svn %*`) do echo %%i
		)
	)
)
exit /b