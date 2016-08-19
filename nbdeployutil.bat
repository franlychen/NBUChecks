@echo off 
color 1f
SET DIR="E:\Program Files\Veritas\NetBackup\var\global\reports\"
pushd %DIR%
for /D %%A in ("20*") DO ECHO nbdeployutil --report --capacity %DIR%%%A
popd
@pause
