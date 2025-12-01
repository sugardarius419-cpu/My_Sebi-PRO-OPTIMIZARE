@echo off
title My_Sebi FPS BOOST - Old PC
color 0a

echo ============================================
echo        My_Sebi FPS BOOST - Old PC
echo  Optimizare generala pentru jocuri pe PC-uri
echo              mai vechi (Windows)
echo ============================================
echo.
echo  Recomandare: ruleaza ca Administrator!
echo.
pause

:: ---------------------------
:: 1. SETARE POWER - HIGH PERFORMANCE
:: ---------------------------
echo [1/7] Setare profil de alimentare pe High Performance...
powercfg -setactive SCHEME_MAX >nul 2>&1

:: ---------------------------
:: 2. CURATARE TEMP / CACHE
:: ---------------------------
echo [2/7] Curatare fisiere temporare si cache...
del /q /f /s "%TEMP%\*" >nul 2>&1
del /q /f /s "C:\Windows\Temp\*" >nul 2>&1
del /q /f /s "C:\Windows\Prefetch\*" >nul 2>&1

:: ---------------------------
:: 3. OPRIRE SERVICII INUTILE (SAFE)
::    DiagTrack = Telemetrie
::    SysMain (Superfetch) poate incetini HDD-urile vechi
:: ---------------------------
echo [3/7] Dezactivare servicii inutile (DiagTrack, SysMain)...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1

sc stop SysMain >nul 2>&1
sc config SysMain start= disabled >nul 2>&1

:: ---------------------------
:: 4. OPTIMIZARE RETEA PENTRU JOCURI ONLINE
:: ---------------------------
echo [4/7] Optimizare retea pentru ping mai mic...
netsh int tcp set global autotuninglevel=disabled >nul 2>&1
netsh int tcp set global chimney=disabled >nul 2>&1
netsh int tcp set global rss=enabled >nul 2>&1
netsh interface tcp set global ecncapability=disabled >nul 2>&1

:: ---------------------------
:: 5. OPTIMIZARE SISTEM PENTRU JOCURI (REGISTRY)
::    Creste prioritatea task-ului "Games"
::    si reduce SystemResponsiveness
:: ---------------------------
echo [5/7] Aplicare tweak-uri pentru jocuri (Registry)...

:: SystemResponsiveness la 10 (default 20)
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" ^
 /v SystemResponsiveness /t REG_DWORD /d 10 /f >nul 2>&1

:: Task "Games" - mai multa prioritate pe CPU/GPU
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Scheduling Category" /t REG_SZ /d "High" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "SFIO Priority" /t REG_SZ /d "High" /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "GPU Priority" /t REG_DWORD /d 8 /f >nul 2>&1

reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" ^
 /v "Priority" /t REG_DWORD /d 6 /f >nul 2>&1

:: ---------------------------
:: 6. ACTIVARE GAME MODE (Windows 10/11)
:: ---------------------------
echo [6/7] Activare Game Mode (unde este disponibil)...
reg add "HKCU\Software\Microsoft\GameBar" /v AllowAutoGameMode /t REG_DWORD /d 1 /f >nul 2>&1
reg add "HKCU\Software\Microsoft\GameBar" /v AutoGameModeEnabled /t REG_DWORD /d 1 /f >nul 2>&1

:: ---------------------------
:: 7. FLUSH DNS + RESETEAZA CACHE-UL DE REȚEA
:: ---------------------------
echo [7/7] Curatare cache DNS si resetare conexiuni...
ipconfig /flushdns >nul
nbtstat -R >nul 2>&1
nbtstat -RR >nul 2>&1
netsh int ip reset >nul 2>&1

echo.
echo ============================================
echo         TOATE OPTIMIZARILE AU FOST APLICATE!
echo   Recomandare: reporneste PC-ul pentru efect
echo        maxim in jocuri (FPS mai stabil).
echo ============================================
echo.
pause
exit
