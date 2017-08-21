@echo off
set scripts=%~dp0
set scripts=%scripts:~0,-1%

set project=%1%.Tests

if not "%2" == "" set framework=%2

if not defined framework set framework=netcoreapp2.0
if not defined configuration set configuration=Release

set assembly=%project%\%project%.csproj
set output=bin\%configuration%\%framework%

%scripts%\OpenCover\OpenCover.Console.exe -returntargetcode -register:path32 -target:"dotnet.exe" -targetargs:"test --no-build --logger trx -c %configuration% -o %output% %assembly% " -output:coverage.xml -oldstyle
set result=%errorlevel%

powershell -File %scripts%\test-upload.ps1 -project %project%
if %errorlevel% neq 0 exit /b %errorlevel%
if %result% neq 0 exit /b %result%

%scripts%\coveralls.io\coveralls.net.exe --opencover coverage.xml
if %errorlevel% neq 0 exit /b %errorlevel%