@echo off
setlocal enabledelayedexpansion

:: Created by Andro.Meta mostly just to have something that works that I can go to from anywhere. 
:: This is a very simple .bat file and free for anyone to use and to incorporate into their work. 
:: Must have ffmpeg installed to PATH

:: Ask the user to drag and drop the folder
echo Please drag and drop the folder onto this window and press Enter.
set /p folderPath="Folder: "

:: Remove quotes from the folder path
set "folderPath=%folderPath:"=%"

:: Check if it's a valid directory
if not exist "%folderPath%\" (
    echo The provided path is not a valid directory.
    pause
    exit /b
)

:: Ask for frames per second
set /p fps="Enter the desired frames per second (e.g., 24): "

:: Ask for the desired output video name
set /p outputName="Enter the desired name for the output video (without extension): "

:: Get the parent directory of the folderPath
for %%i in ("%folderPath%") do set "parentDir=%%~dpi"

:: Create a temporary list of all images
set "tempList=%temp%\image_list.txt"
if exist "%tempList%" del "%tempList%"

for %%f in ("%folderPath%\*.png") do (
    echo file '%%f' >> "%tempList%"
)

:: Create the video using the list
ffmpeg -f concat -safe 0 -i "%tempList%" -r %fps% -c:v libx264 -pix_fmt yuv420p "%parentDir%\%outputName%.mp4"

:: Clean up the temporary list
del "%tempList%"

echo.
echo Video creation complete! The video is saved next to the folder.
pause
