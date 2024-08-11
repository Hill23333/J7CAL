:VersionParser.test
setlocal enabledelayedexpansion
set "VersionParser.GetClientJarInfo.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft"
set "VersionParser.GetClientJarInfo.version=1.21"
call:VersionParser.GetClientJarInfo
set VersionParser.NameToPath.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft
set VersionParser.NameToPath.name=ca.weblite:java-objc-bridge:1.1
call:VersionParser.NameToPath
echo %VersionParser.NameToPath.result%
set VersionParser.GetClientLibrariesInfo.minecraftPath=C:\Users\Hill233\AppData\Roaming\.minecraft
set VersionParser.GetClientLibrariesInfo.version=1.8.9
call:VersionParser.GetClientLibrariesInfo
for /l %%i in (0,1,36) do (
    echo !VersionParser.GetClientLibrariesInfo.result.%%i.sha1!
    echo !VersionParser.GetClientLibrariesInfo.result.%%i.size!
    echo !VersionParser.GetClientLibrariesInfo.result.%%i.url!
    echo !VersionParser.GetClientLibrariesInfo.result.%%i.name!
    echo !VersionParser.GetClientLibrariesInfo.result.%%i.isNatives!
)

goto :EOF


:VersionParser.GetClientJarInfo
::获取指定版本的客户端的信息
set "VersionParser.GetClientJarInfo.jsonPath=%VersionParser.GetClientJarInfo.minecraftPath%\versions\%VersionParser.GetClientJarInfo.version%\%VersionParser.GetClientJarInfo.version%.json"
set Filter=sha1,size,url
for %%i in (%Filter%) do for /f "delims=" %%a in ('jq -j .downloads.client.%%i "%VersionParser.GetClientJarInfo.jsonPath%"') do set "VersionParser.GetClientJarInfo.%%i=%%a"

goto :EOF


:VersionParser.GetClientLibrariesInfo
::获取指定版本的类库信息
set "VersionParser.GetClientLibrariesInfo.jsonPath=%VersionParser.GetClientLibrariesInfo.minecraftPath%\versions\%VersionParser.GetClientLibrariesInfo.version%\%VersionParser.GetClientLibrariesInfo.version%.json"
for /f "delims=" %%i in ('jq -r ".libraries|length" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do set VersionParser.GetClientJarInfo.librariesNumbers=%%i
call:Helper.GetProcessorBitness
set Helper.GetProcessorBitness.result=64
set count=0
for /f "delims=" %%i in ('jq --arg arch %Helper.GetProcessorBitness.result% -r ".libraries|map(if.natives.windows?then(.natives.windows|gsub(\"\\$\\{arch\\}\";$arch))as$native|[(.name),(.downloads.classifiers[$native].sha1),(.downloads.classifiers[$native].size),(.downloads.classifiers[$native].url),true]|join(\",\")else[(.name),(.downloads.artifact.sha1),(.downloads.artifact.size),(.downloads.artifact.url),false]|join(\",\") end)|unique|.[]" "%VersionParser.GetClientLibrariesInfo.jsonPath%"') do (
    for /f "tokens=1,2,3,4,5 delims= " %%a in ("%%i") do (
        set VersionParser.GetClientLibrariesInfo.result.!count!.name=%%a
        set VersionParser.GetClientLibrariesInfo.result.!count!.sha1=%%b
        set VersionParser.GetClientLibrariesInfo.result.!count!.size=%%c
        set VersionParser.GetClientLibrariesInfo.result.!count!.url=%%d
        set VersionParser.GetClientLibrariesInfo.result.!count!.isNatives=%%e
    )
    set /a count+=1
)

goto :EOF


:VersionParser.NameToPath
::将Library的Name转换成可供访问的绝对路径
for /f "tokens=1,2,3 delims=:" %%a in ("%VersionParser.NameToPath.name%") do (
    set "splited1=%%a"
    set "splited2=%%b"
    set "splited3=%%c"
)

if defined VersionParser.NameToPath.natives (
    set "VersionParser.NameToPath.result=%VersionParser.NameToPath.minecraftPath%\libraries\%splited1:.=\%\%splited2%\%splited3%\%splited2%-%splited3%-%VersionParser.NameToPath.natives%.jar"
) else (
    set "VersionParser.NameToPath.result=%VersionParser.NameToPath.minecraftPath%\libraries\%splited1:.=\%\%splited2%\%splited3%\%splited2%-%splited3%.jar"
)

goto :EOF


