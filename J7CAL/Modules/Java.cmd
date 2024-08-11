:Java.Start
call:Java.Download java-runtime-delta D:\Java
goto :EOF


:Java.Add



:Java.Download
aria2c "https://launchermeta.mojang.com/v1/products/java-runtime/2ec0cc96c44e5a76b9c8b7c39df7210883d12871/all.json"
if %OS%==Windows_NT (
    if %PROCESSOR_ARCHITECTURE%==x86 set "Java.Download.Platform=windows-x86"
    if %PROCESSOR_ARCHITECTURE%==AMD64 set "Java.Download.Platform=windows-x64"
    if %PROCESSOR_ARCHITECTURE%==ARM64 set "Java.Download.Platform=windows-arm64"
)

if %Java.Download.Platform%== echo ? & exit /b 0
for /f "delims=" %%i in ('jq -c ".\"%Java.Download.Platform%\".\"%~1\"[]" "all.json"') do set "Java.Download.%~1.JSON=%%i"
for %%i in (sha1,size,url) do for /f "delims=" %%a in ('jq -c ".\"%Java.Download.Platform%\".\"%~1\"[].manifest.%%i" "all.json"') do set "Java.Download.manifest.JSON.%%i=%%a"
aria2c %Java.Download.manifest.JSON.url%
del /f "list.txt"
jq -r ".files | keys[]" "manifest.json" > "list.txt"
del /f "downloads.list"
for /f "delims=" %%i in (list.txt) do (
    for /f "delims=" %%a in ('jq -r ".files.\"%%i\".downloads.raw.url" "manifest.json" ^| findstr /v "null"') do ((echo %%a) & (echo  out=%%i)) >> "downloads.list"
)
aria2c -idownloads.list -d%~2 -j20 --auto-file-renamingfalse -x16 -s64
goto :EOF



:Java.Search
for /f "skip=1 delims= " in
goto :EOF



:Java.Select

goto :EOF




