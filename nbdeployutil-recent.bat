echo off
FOR /F "delims=" %%i IN ('dir /b /ad-h /t:c /od "E:\Program Files\VERITAS\NetBackup\var\global\reports"') DO SET a=%%i
echo Most recent subfolder: %a% 
color 1f
echo Running nbdeployutil on %a%
nbdeployutil --report --capacity  "E:\Program Files\VERITAS\NetBackup\var\global\reports\%a%"
color 8A
echo Complete!
xcopy /s "E:\Program Files\VERITAS\NetBackup\var\global\reports\%a%\*.xls" "%USERPROFILE%\Desktop\"
del "E:\Program Files\VERITAS\NetBackup\var\global\reports\%a%\*.xls"
