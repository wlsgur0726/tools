:: 32bit�� 64bit ��� �����Ͽ� VC_Directory�� �����سִ� ������� ��ġ�ϴ� ��ũ��Ʈ.
:: Program Files ��η� ������ �� �����ڱ����� �ʿ� �� �� ����.
:: Visual Studio 2015 �������� �ۼ�.
::
:: Parameter ����
::  %1  :  Boost Source�� ��� (�⺻�� : ������)
::  %2  :  ��ġ�� ��ġ (�⺻�� : C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC)

@echo off

set BoostRoot=%1
if "%BoostRoot%"=="" set BoostRoot=.
cd /d "%BoostRoot%"

set InstallDir=%2
if "%InstallDir%"=="" set InstallDir=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC

:: �α��� ����
set LogFileName=_buildlog.log
echo [%DATE% %TIME%] start > %LogFileName%

:: build b2.exe
echo [%DATE% %TIME%] call bootstrap.bat...
echo [%DATE% %TIME%] call bootstrap.bat... >> %LogFileName%
call bootstrap.bat >> %LogFileName%

:: copy header files
echo [%DATE% %TIME%] copy header files...
echo [%DATE% %TIME%] copy header files... >> %LogFileName%
xcopy /e /q /y .\boost\* "%InstallDir%\include\boost\"

:: build 32bit
echo [%DATE% %TIME%] build 32bit...
echo [%DATE% %TIME%] build 32bit... >> %LogFileName%
call b2.exe --clean >> %LogFileName%
call b2.exe stage -j4 -a address-model=32 runtime-link=static,shared variant=release,debug threading=single,multi >> %LogFileName%
xcopy /e /q /y .\stage\lib\* "%InstallDir%\lib\"

:: build 64bit
echo [%DATE% %TIME%] build 64bit...
echo [%DATE% %TIME%] build 64bit... >> %LogFileName%
call b2.exe --clean >> %LogFileName%
call b2.exe stage -j4 -a address-model=64 runtime-link=static,shared variant=release,debug threading=single,multi >> %LogFileName%
xcopy /e /q /y .\stage\lib\* "%InstallDir%\lib\amd64\"

:: �α��� ��
echo [%DATE% %TIME%] complete
echo [%DATE% %TIME%] complete >> %LogFileName%
