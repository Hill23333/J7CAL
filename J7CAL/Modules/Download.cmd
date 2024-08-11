:Download.Minecraft.Start
call:Download.Forge.List 1.21
pause
::for /f %%i in ('jq -c -r ".versions[] | select(.type==\"%Download.Minecraft.Manifest.Type%\") | .id" "version_manifest_v2.json"') do echo %%i
::set /p "Download.Minecraft.Manifest.id=你要安装什么版本？"
::for /f %%i in ('jq -c -r ".versions[] | select(.id==\"%Download.Minecraft.Manifest.id%\")" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.Info.JSON=%%i"
::for /f %%v in ('jq -j ".versions[].id" "version_manifest_v2.json"') do echo %%v
::set /p "Download.Minecraft.Manifest.Type=你要安装什么类型的版本？"


:Download.Minecraft.Manifest
curl -O -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json"
for /f "delims=" %%i in ('jq -c ".versions | map(.type) | unique" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.Type=%%i"
for /f %%i in ('echo !Download.Minecraft.Manifest.Type! ^| jq -r .[]') do for /f %%a in ('jq -c "[.versions[] | select(.type==\"%%i\") | .id]" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.%%i.id.JSON=%%a"
goto :EOF


:Download.Minecraft.Manifest.id.JSON
for /f "delims=" %%i in ('jq -c ".versions[] | select(.id==\"%~1\")" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.%~1.JSON=%%i"


:Download.Minecraft.Manifest.latest
for /f "delims=" %%i in ('jq -r ".latest.release" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.latest.release=%%i"
for /f "delims=" %%i in ('jq -r ".latest.snapshot" "version_manifest_v2.json"') do set "Download.Minecraft.Manifest.latest.snapshot=%%i"


:Download.OptiFine.List



:Download.Forge.List
curl -O -s "https://files.minecraftforge.net/net/minecraftforge/forge/index_%~1.html"
for /f %%i in (index_%~1.html) do if %%i=="<tbody>" set tbody=1 & if %%i=="</tbody>" set tbody=0 & if %tbody%==1 (echo %%i) > %~1.txt


:Download.NeoForge.List



:Download.Fabric.List



:Download.Quilt.List



:Download.LiteLoader.List



:Download.Tools




