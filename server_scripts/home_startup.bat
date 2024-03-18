@echo off
setlocal enabledelayedexpansion

:: Define the starting point of loop
:start

:: Get today's date in MM-DD format
for /f "tokens=1-3 delims=/" %%a in ('echo %date%') do (
    set "month=%%a"
    set "day=%%b"
    set "year=%%c"
)

:: Pad single-digit month and day with leading zero
if %month:~0,1% equ 0 set month=0%month:~1%
if %day:~0,1% equ 0 set day=0%day:~1%


:: Create folder for backups with today's date
set "backup_folder=E:\localhost\minecraft\b\backups\%month%-%day%"
if not exist "!backup_folder!" (
    mkdir "!backup_folder!" && (
        echo [92m[SUCCESS][0m Backup folder created successfully: "!backup_folder!"
    ) || (
        echo [91m[ERROR][0m Failed to create backup folder: "!backup_folder!"
    )
)
:: Copy files updated in the past five days to backup folder
set "folders=home home_nether home_the_end creative"

:: Copy files updated in the past five days to backup folder for each folder
for %%f in (%folders%) do (
    robocopy "E:\localhost\minecraft\b\home\%%f" "!backup_folder!\%%f" /MAXAGE:5 /S /E /COPY:DAT /R:3 /W:5 /NP > nul
    if %ERRORLEVEL% equ 0 (
        echo [92m[SUCCESS][0m Files copied successfully: \b\home\%%f to %month%-%day%\%%f
    ) else (
        echo [91m[ERROR][0m Failed to copy files: \b\home\%%f to %month%-%day%\%%f
    )
)
echo [92m[SUCCESS][0m Backups complete

:: Archive the backup folder
7z a "!backup_folder!.7z" "!backup_folder!\*" && (
    echo [92m[SUCCESS][0m Archive created successfully: "!backup_folder!.7z"
) || (
    echo [91m[ERROR][0m Failed to create archive: "!backup_folder!.7z"
)

:: Start Minecraft server
java -Xms12G -Xmx12G -jar paper.jar -nogui
goto start
