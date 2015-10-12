@echo off
echo Setting up KameGMS (SVN)
echo.

:: Check TortoiseSVN 
<NUL set /p ".=Checking TortoiseSVN... "
where TortoiseProc >NUL 2>NUL || goto :failed_tortoise
where TortoiseMerge >NUL 2>NUL || goto :failed_tortoise
echo OK

:: Check GameMaker Studio
<NUL set /p ".=Checking GameMaker Studio... "
reg query "HKCU\Software\GMStudio\Version 1.0\Preferences" /v Directory >NUL 2>NUL || goto :failed_gms
echo OK

:: Add registry entries
<NUL set /p ".=Adding registry entries... "
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v 5tudioSCMConfigFile /t REG_SZ /d "%cd%\kamesvn.scmconfig.xml" /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SVNExeLocation /t REG_SZ /d "%cd%\kamesvn.bat" /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SVNExeChoice /t REG_DWORD /d 2 /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SCMAdvancedOptions /t REG_DWORD /d 1 /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SCMColours /t REG_DWORD /d 1 /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SCMDisable /t REG_DWORD /d 0 /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SCMLogging /t REG_DWORD /d 1 /f >NUL 2>NUL || goto :failed_registry
reg add "HKCU\Software\GMStudio\Version 1.0\Preferences" /v SCMNoFolderCommits /t REG_DWORD /d 0 /f >NUL 2>NUL || goto :failed_registry
echo OK

:: Setup complete
goto :done

:: OK
:done
echo.
echo Installation complete. Thank you for choosing KameGMS.
pause
exit /b

:: Failed - No TortoiseSVN
:failed_tortoise
echo FAIL
echo .
echo Installation failed. Please install TortoiseSVN, then try again.
pause
exit /b

:: Failed - No GameMaker Studio
:failed_gms
echo FAIL
echo .
echo Installation failed. Please install GameMaker Studio, then try again.
pause
exit /b

:: Failed - Cannot add registry entries
:failed_registry
echo FAIL
echo .
echo Installation failed. Please check your user permissions, then try again.
pause
exit /b