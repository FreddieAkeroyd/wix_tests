@echo off
setlocal
set MYDIR=%~dp0

for /D %%I in ( "c:\Program Files (x86)\WiX Toolset v3.*" ) do SET "WIXBIN=%%I\bin"

set TARGETDIR=testfiles

del test.wxi
del test.msi

REM -sw5150 supresses warning about self registering DLLs
"%WIXBIN%\heat.exe" dir .\%TARGETDIR% -gg -scom -sreg -svb6 -sfrag -sw5150 -template feature -var var.MySource -dr INSTALLDIR -cg MyCG -t %MYDIR%wxs2wxi.xsl -out test.wxi
if %errorlevel% neq 0 goto ERROR

copy %MYDIR%test_master.wxs test.wxs
"%WIXBIN%\candle.exe" -dMySource=.\%TARGETDIR% -dVersionLong=1.0.0.0 -dVersionShort=1.0 test.wxs
if %errorlevel% neq 0 goto ERROR

REM -sice:ICE60 is to stop font install warnings (from JRE)
REM add  -ext WixUtilExtension  if using WixQuietExec
"%WIXBIN%\light.exe" -sice:ICE60 -ext WixUIExtension test.wixobj
if %errorlevel% neq 0 goto ERROR


goto :EOF

:ERROR

@echo ERROR creating test.msi


exit /b 1
