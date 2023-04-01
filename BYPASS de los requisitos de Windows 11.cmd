
@echo off & title Instalar Windows 11 en ordenador "no soportado" || Arix
if /i "%~f0" neq "%ProgramData%\get11.cmd" goto setup
set CLI=%*& set SOURCES=%SystemDrive%\$WINDOWS.~BT\Sources& set MEDIA=.& set /a VER=11
if not defined CLI (exit /b) else if not exist %SOURCES%\SetupHost.exe (exit /b)
if not exist %SOURCES%\SetupCore.exe mklink /h %SOURCES%\SetupCore.exe %SOURCES%\SetupHost.exe >nul
for %%W in (%CLI%) do if /i %%W == /InstallFile (set "MEDIA=") else if not defined MEDIA set "MEDIA=%%~dpW"
set /a restart_application=0x800705BB & call set CLI=%%CLI:%1 =%%&;
set /a incorrect_parameter=0x80070057 & set SRV=%CLI:/Product Client =%&;
set /a launch_option_error=0xc190010a & set SRV=%SRV:/Product Server =%&;
powershell -win 1 -nop -c ";"
if %VER% == 11 for %%W in ("%MEDIA%appraiserres.dll") do if exist %%W if %%~zW == 0 set AlreadyPatched=1 & set /a VER=10
if %VER% == 11 findstr /r "P.r.o.d.u.c.t.V.e.r.s.i.o.n...1.0.\..0.\..2.[25]" %SOURCES%\SetupHost.exe >nul 2>nul || set /a VER=10
if %VER% == 11 if not exist "%MEDIA%EI.cfg" (echo;[Channel]>%SOURCES%\EI.cfg & echo;_Default>>%SOURCES%\EI.cfg) 2>nul
if %VER% == 11 set CLI=/Product Server /Compat IgnoreWarning /MigrateDrivers All /Telemetry Disable %SRV%&;
%SOURCES%\SetupCore.exe %CLI%
if %errorlevel% == %restart_application% %SOURCES%\SetupCore.exe %CLI%
exit /b

:setup
>nul reg add hkcu\software\classes\.Admin\shell\runas\command /f /ve /d "cmd /x /d /r set \"f0=%%2\"& call \"%%2\" %%3"& set _= %*
>nul fltmc|| if "%f0%" neq "%~f0" (cd.>"%temp%\runas.Admin" & start "%~n0" /high "%temp%\runas.Admin" "%~f0" "%_:"=""%" & exit /b)

for /f "delims=:" %%s in ('echo;prompt $h$s$h:^|cmd /d') do set "|=%%s"&set ">>=\..\c nul&set /p s=%%s%%s%%s%%s%%s%%s%%s<nul&popd"
set "<=pushd "%appdata%"&2>nul findstr /c:\ /a" &set ">=%>>%&echo;" &set "|=%|:~0,1%" &set /p s=\<nul>"%appdata%\c"

set CLI=%*& set IFEO=HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options&;
wmic /namespace:"\\root\subscription" path __EventFilter where Name="Omitir la limitacion de TPM" delete >nul 2>nul & rem v1
reg delete "%IFEO%\vdsldr.exe" /f 2>nul & rem v2 - v5
if /i "%CLI%"=="" reg query "%IFEO%\SetupHost.exe\0" /v Debugger >nul 2>nul && goto remove || goto install
if /i "%CLI%"=="" reg query "%IFEO%\SetupHost.exe\0" /v Debugger >nul 2>nul && goto remove || goto install
if /i "%~1"=="install" (goto install) else if /i "%~1"=="remove" goto remove
:install

copy /y "%~f0" "%ProgramData%\get11.cmd" >nul 2>nul
reg add "%IFEO%\SetupHost.exe" /f /v UseFilter /d 1 /t reg_dword >nul
reg add "%IFEO%\SetupHost.exe\0" /f /v FilterFullPath /d "%SystemDrive%\$WINDOWS.~BT\Sources\SetupHost.exe" >nul
reg add "%IFEO%\SetupHost.exe\0" /f /v Debugger /d "%ProgramData%\get11.cmd" >nul
%<%:f0 "Omitir los requisitos minimos de la actualizacion de Windows 11"%>>% & %<%:2f " INSTALADA "%>>% & %<%:f0 " Ejecuta este Script de nuevo para desactivarla. "%>%
if /i "%CLI%"=="" timeout /t 7
exit /b

:remove
del /f /q "%ProgramData%\get11.cmd" >nul 2>nul
reg delete "%IFEO%\SetupHost.exe" /f >nul 2>nul
%<%:f0 " Omitir los requisitos minimos para instalar Windows 11 "%>>% & %<%:df " DESACTIVADO "%>>% & %<%:f0 "  "%>%
if /i "%CLI%"=="" timeout /t 7
exit /b 

'@); $0 = "$env:temp\Omitir_Requisitos_Windows_11.cmd"; ${(=)||} | out-file $0 -encoding default -force; & $0
# press enter