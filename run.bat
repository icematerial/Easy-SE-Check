@echo off
rem Opens index.html as a standalone app window (Chrome, or Edge if Chrome is missing).
rem This batch file stays open until that window is closed.
setlocal
set "PROFILE=%LocalAppData%\SECheck\profile"

rem The folder name contains Japanese, so the file URL must be percent-encoded for the browser.
set "URL="
for /f "usebackq delims=" %%U in (`powershell -NoProfile -Command "[uri]::new('%~dp0index.html').AbsoluteUri"`) do set "URL=%%U"
if not defined URL (
  echo Could not build the page URL.
  pause
  exit /b 1
)

set "BROWSER=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
if exist "%BROWSER%" goto run
set "BROWSER=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
if exist "%BROWSER%" goto run
set "BROWSER=%LocalAppData%\Google\Chrome\Application\chrome.exe"
if exist "%BROWSER%" goto run
set "BROWSER=%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe"
if exist "%BROWSER%" goto run
set "BROWSER=%ProgramFiles%\Microsoft\Edge\Application\msedge.exe"
if exist "%BROWSER%" goto run
echo Chrome or Edge was not found.
pause
exit /b 1

:run
rem A dedicated profile makes the browser a separate process, so /wait returns only when the window is closed.
start "" /wait "%BROWSER%" --user-data-dir="%PROFILE%" --no-first-run --no-default-browser-check --window-size=1200,760 --app="%URL%"
