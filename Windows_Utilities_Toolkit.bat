@echo off
:: Check for admin rights
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: Set fixed window size (columns x rows)
mode con: cols=60 lines=25

:: Center the window dynamically on the primary screen
powershell -NoProfile -Command ^
  "$hwnd = (Get-Process -Id $PID).MainWindowHandle; " ^
  "Add-Type -AssemblyName System.Windows.Forms; " ^
  "$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds; " ^
  "$width = $screen.Width; $height = $screen.Height; " ^
  "$host = Get-Host; " ^
  "$size = $host.UI.RawUI.WindowSize; " ^
  "$font = $host.UI.RawUI.FontSize; " ^
  "$windowWidthPx = $size.Width * $font.Width; " ^
  "$windowHeightPx = $size.Height * $font.Height; " ^
  "$posX = [int](($width - $windowWidthPx) / 2); " ^
  "$posY = [int](($height - $windowHeightPx) / 2); " ^
  "Add-Type -Namespace Native -Name Win -MemberDefinition @'[DllImport(\"user32.dll\")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);'@; " ^
  "[Native.Win]::MoveWindow($hwnd, $posX, $posY, $windowWidthPx, $windowHeightPx, $true)"

:: Set black background with neon green text
color 0A
title W.U.T. - BY RUSSELL DEV

:MENU
cls
echo ============================================================
echo                     WINDOWS UTILITIES TOOLKIT
echo ============================================================
echo.
echo  1. Open Control Panel
echo  2. Open Device Manager
echo  3. Open Command Prompt
echo  4. Open Registry Editor
echo  5. Open Windows Firewall
echo  6. Clean Temporary Files
echo  7. Run Disk Cleanup
echo  8. Run Disk Defragmenter
echo  9. Exit
echo.
echo ============================================================
echo          THANK YOU FOR USING MY TOOLKIT - RUSSELL DEV
echo ============================================================
echo.
set /p choice="Select an option [1-9]: "

if "%choice%"=="1" start control
if "%choice%"=="2" start devmgmt.msc
if "%choice%"=="3" start cmd
if "%choice%"=="4" start regedit
if "%choice%"=="5" start firewall.cpl
if "%choice%"=="6" goto cleantemp
if "%choice%"=="7" cleanmgr
if "%choice%"=="8" dfrgui
if "%choice%"=="9" exit
goto MENU

:cleantemp
echo.
echo Cleaning temporary files...
echo Please wait...
del /s /f /q %temp%\* >nul 2>&1
del /s /f /q C:\Windows\Temp\* >nul 2>&1
echo Temporary files cleaned.
pause
goto MENU
