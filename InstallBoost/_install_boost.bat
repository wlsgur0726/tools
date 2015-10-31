:: 32bit와 64bit 모두 빌드하여 VC_Directory에 복사해넣는 방식으로 설치하는 스크립트.
:: Program Files 경로로 복사할 때 관리자권한이 필요 할 수 있음.
:: Visual Studio 2015 기준으로 작성.
::
:: Parameter 설명
::  %1  :  Boost Source의 경로 (기본값 : 현재경로)
::  %2  :  설치할 위치 (기본값 : C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC)

@echo off

set BoostRoot=%1
if "%BoostRoot%"=="" set BoostRoot=.
cd /d "%BoostRoot%"

set InstallDir=%2
if "%InstallDir%"=="" set InstallDir=C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC

:: 로그의 시작
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

:: 로그의 끝
echo [%DATE% %TIME%] complete
echo [%DATE% %TIME%] complete >> %LogFileName%
