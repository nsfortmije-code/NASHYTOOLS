@echo off
title Nash Tool 4.0 - Ultimate Windows Utility
mode con: cols=110 lines=40
color 0A
cls

echo.
echo ===============================
echo Nash Tool 4.0 - Ultimate Utility
echo ===============================
echo.

:menu
echo Select an option:
echo.

echo 1.  Remove Windows bloatware apps
echo 2.  Restore Windows apps
echo 3.  Disable telemetry & tracking services
echo 4.  Enable telemetry & tracking services
echo 5.  Disable unnecessary Windows services
echo 6.  Enable previously disabled services
echo 7.  Apply visual performance tweaks
echo 8.  Revert visual performance tweaks
echo 9.  Apply hosts file telemetry block
echo 10. Remove hosts file block
echo 11. Flush DNS cache
echo 12. Optimize TCP settings
echo 13. Disable Windows Update service
echo 14. Enable Windows Update service
echo 15. Reset Windows Update components
echo 16. Clear temporary files
echo 17. Clear Windows update cache
echo 18. Clear prefetch files
echo 19. View system info summary
echo 20. Show running services
echo 21. Restart critical services
echo 22. Check Windows activation status
echo 23. Enable firewall
echo 24. Disable firewall
echo 25. Open Device Manager
echo 26. Open Disk Management
echo 27. Run System File Checker (SFC)
echo 28. Run DISM restore health
echo 29. Show disk usage stats
echo 30. Enable UAC
echo 31. Disable UAC
echo 32. Enable Power Saver plan
echo 33. Enable High Performance plan
echo 34. Disable indexing service
echo 35. Enable indexing service
echo 36. Disable Windows Search service
echo 37. Enable Windows Search service
echo 38. Disable OneDrive
echo 39. Enable OneDrive
echo 40. Disable Cortana
echo 41. Enable Cortana
echo 42. Download 1 cat picture
echo 43. Download 10 random cat pictures
echo 44. Show IP configuration
echo 45. Renew IP address
echo 46. Release IP address
echo 47. Run Ping Test (google.com)
echo 48. Run Tracert (google.com)
echo 49. Exit
echo.

set /p choice=Enter option [1-49]: 

rem Dispatch
if "%choice%"=="1" goto debloat_apps
if "%choice%"=="2" goto restore_apps
if "%choice%"=="3" goto disable_telemetry
if "%choice%"=="4" goto enable_telemetry
if "%choice%"=="5" goto disable_services
if "%choice%"=="6" goto enable_services
if "%choice%"=="7" goto perf_tweaks
if "%choice%"=="8" goto revert_tweaks
if "%choice%"=="9" goto apply_hosts
if "%choice%"=="10" goto remove_hosts
if "%choice%"=="11" goto flush_dns
if "%choice%"=="12" goto optimize_tcp
if "%choice%"=="13" goto disable_winupdate
if "%choice%"=="14" goto enable_winupdate
if "%choice%"=="15" goto reset_winupdate
if "%choice%"=="16" goto clear_temp
if "%choice%"=="17" goto clear_update_cache
if "%choice%"=="18" goto clear_prefetch
if "%choice%"=="19" goto system_info
if "%choice%"=="20" goto show_services
if "%choice%"=="21" goto restart_services
if "%choice%"=="22" goto activation_status
if "%choice%"=="23" goto enable_firewall
if "%choice%"=="24" goto disable_firewall
if "%choice%"=="25" start devmgmt.msc & goto menu
if "%choice%"=="26" start diskmgmt.msc & goto menu
if "%choice%"=="27" goto run_sfc
if "%choice%"=="28" goto run_dism
if "%choice%"=="29" goto disk_usage
if "%choice%"=="30" goto enable_uac
if "%choice%"=="31" goto disable_uac
if "%choice%"=="32" goto power_saver
if "%choice%"=="33" goto high_perf
if "%choice%"=="34" goto disable_indexing
if "%choice%"=="35" goto enable_indexing
if "%choice%"=="36" goto disable_search
if "%choice%"=="37" goto enable_search
if "%choice%"=="38" goto disable_onedrive
if "%choice%"=="39" goto enable_onedrive
if "%choice%"=="40" goto disable_cortana
if "%choice%"=="41" goto enable_cortana
if "%choice%"=="42" goto download_cat_pic
if "%choice%"=="43" goto download_10_cats
if "%choice%"=="44" goto ip_config
if "%choice%"=="45" goto renew_ip
if "%choice%"=="46" goto release_ip
if "%choice%"=="47" goto ping_test
if "%choice%"=="48" goto tracert_test
if "%choice%"=="49" goto exit_script

echo Invalid choice.
timeout /t 2 >nul
cls
goto menu

:: Feature implementations below

:debloat_apps
cls
echo Removing Windows bloatware apps...
powershell -command "Get-AppxPackage -AllUsers ^| Where-Object { $_.Name -notlike '*Store*' -and $_.Name -notlike '*Calculator*' } ^| Remove-AppxPackage"
powershell -command "Get-AppxProvisionedPackage -Online ^| Where-Object { $_.PackageName -notlike '*Store*' -and $_.PackageName -notlike '*Calculator*' } ^| Remove-AppxProvisionedPackage -Online"
echo Done.
pause
cls
goto menu

:restore_apps
cls
echo Restoring Windows apps...
powershell -command "Get-AppxPackage -AllUsers ^| Foreach { Add-AppxPackage -DisableDevelopmentMode -Register ('$($_.InstallLocation)\AppXManifest.xml') }"
echo Done.
pause
cls
goto menu

:disable_telemetry
cls
echo Disabling telemetry & tracking services and scheduled tasks...
sc stop DiagTrack >nul 2>&1
sc config DiagTrack start= disabled >nul 2>&1
sc stop dmwappushservice >nul 2>&1
sc config dmwappushservice start= disabled >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Disable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable >nul 2>&1
echo Done.
pause
cls
goto menu

:enable_telemetry
cls
echo Enabling telemetry & tracking services and scheduled tasks...
sc config DiagTrack start= auto >nul 2>&1
sc start DiagTrack >nul 2>&1
sc config dmwappushservice start= auto >nul 2>&1
sc start dmwappushservice >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask" /Enable >nul 2>&1
schtasks /Change /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Enable >nul 2>&1
echo Done.
pause
cls
goto menu

:disable_services
cls
echo Disabling unnecessary services...
setlocal enabledelayedexpansion
set "services=Fax XblGameSave WMPNetworkSvc MapsBroker OneSyncSvc RetailDemo SensorDataService"
for %%S in (%services%) do (
  echo Disabling %%S...
  sc stop %%S >nul 2>&1
  sc config %%S start= disabled >nul 2>&1
)
echo Done.
pause
cls
goto menu

:enable_services
cls
echo Enabling services...
setlocal enabledelayedexpansion
set "services=Fax XblGameSave WMPNetworkSvc MapsBroker OneSyncSvc RetailDemo SensorDataService"
for %%S in (%services%) do (
  echo Enabling %%S...
  sc config %%S start= demand >nul 2>&1
  sc start %%S >nul 2>&1
)
echo Done.
pause
cls
goto menu

:perf_tweaks
cls
echo Applying performance tweaks...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 2 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 0 /f >nul
echo Done.
pause
cls
goto menu

:revert_tweaks
cls
echo Reverting performance tweaks...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" /v VisualFXSetting /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_SZ /d 400 /f >nul
echo Done.
pause
cls
goto menu

:apply_hosts
cls
echo Blocking telemetry domains via hosts file...
(
echo 127.0.0.1 vortex.data.microsoft.com
echo 127.0.0.1 settings-win.data.microsoft.com
echo 127.0.0.1 telecommand.telemetry.microsoft.com
echo 127.0.0.1 telecommand.telemetry.microsoft.com.nsatc.net
echo 127.0.0.1 oca.telemetry.microsoft.com
echo 127.0.0.1 sqm.telemetry.microsoft.com
echo 127.0.0.1 watson.telemetry.microsoft.com
echo 127.0.0.1 redir.metaservices.microsoft.com
) >> "%windir%\System32\drivers\etc\hosts"
echo Done.
pause
cls
goto menu

:remove_hosts
cls
echo Removing telemetry blocks from hosts file...
findstr /v /c:"telemetry.microsoft.com" "%windir%\System32\drivers\etc\hosts" > "%temp%\hosts.tmp"
move /y "%temp%\hosts.tmp" "%windir%\System32\drivers\etc\hosts" >nul
echo Done.
pause
cls
goto menu

:flush_dns
cls
echo Flushing DNS resolver cache...
ipconfig /flushdns
pause
cls
goto menu

:optimize_tcp
cls
echo Optimizing TCP/IP settings...
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
echo Done.
pause
cls
goto menu

:disable_winupdate
cls
echo Disabling Windows Update service...
sc stop wuauserv >nul 2>&1
sc config wuauserv start= disabled >nul 2>&1
echo Done.
pause
cls
goto menu

:enable_winupdate
cls
echo Enabling Windows Update service...
sc config wuauserv start= auto >nul 2>&1
sc start wuauserv >nul 2>&1
echo Done.
pause
cls
goto menu

:reset_winupdate
cls
echo Resetting Windows Update components...
net stop wuauserv
net stop cryptSvc
net stop bits
net stop msiserver
del /f /s /q %windir%\SoftwareDistribution\* >nul 2>&1
del /f /s /q %windir%\System32\catroot2\* >nul 2>&1
net start wuauserv
net start cryptSvc
net start bits
net start msiserver
echo Done.
pause
cls
goto menu

:clear_temp
cls
echo Cleaning temporary files...
del /q /f /s "%temp%\*.*" >nul 2>&1
del /q /f /s "%windir%\Temp\*.*" >nul 2>&1
echo Done.
pause
cls
goto menu

:clear_update_cache
cls
echo Clearing Windows Update cache...
net stop wuauserv >nul 2>&1
del /f /s /q %windir%\SoftwareDistribution\Download\* >nul 2>&1
net start wuauserv >nul 2>&1
echo Done.
pause
cls
goto menu

:clear_prefetch
cls
echo Clearing prefetch files...
del /q /f /s "%windir%\Prefetch\*.*" >nul 2>&1
echo Done.
pause
cls
goto menu

:system_info
cls
echo Gathering system information...
systeminfo | more
pause
cls
goto menu

:show_services
cls
echo Running services:
sc query type= service state= all | findstr /i "RUNNING"
pause
cls
goto menu

:restart_services
cls
echo Restarting critical services...
net stop wuauserv >nul 2>&1
net start wuauserv >nul 2>&1
net stop bits >nul 2>&1
net start bits >nul 2>&1
echo Done.
pause
cls
goto menu

:activation_status
cls
echo Checking Windows activation status...
slmgr /xpr
pause
cls
goto menu

:enable_firewall
cls
echo Enabling Windows Firewall...
netsh advfirewall set allprofiles state on
echo Done.
pause
cls
goto menu

:disable_firewall
cls
echo Disabling Windows Firewall...
netsh advfirewall set allprofiles state off
echo Done.
pause
cls
goto menu

:run_sfc
cls
echo Running System File Checker (SFC)...
sfc /scannow
pause
cls
goto menu

:run_dism
cls
echo Running DISM RestoreHealth...
dism /Online /Cleanup-Image /RestoreHealth
pause
cls
goto menu

:disk_usage
cls
echo Disk usage statistics:
wmic logicaldisk get size,freespace,caption
pause
cls
goto menu

:enable_uac
cls
echo Enabling UAC...
reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
echo Done.
pause
cls
goto menu

:disable_uac
cls
echo Disabling UAC...
reg.exe ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f
echo Done.
pause
cls
goto menu

:power_saver
cls
echo Setting Power Saver power plan...
powercfg /setactive a1841308-3541-4fab-bc81-f71556f20b4a
echo Done.
pause
cls
goto menu

:high_perf
cls
echo Setting High Performance power plan...
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
echo Done.
pause
cls
goto menu

:disable_indexing
cls
echo Disabling Windows Search indexing service...
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
echo Done.
pause
cls
goto menu

:enable_indexing
cls
echo Enabling Windows Search indexing service...
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1
echo Done.
pause
cls
goto menu

:disable_search
cls
echo Disabling Windows Search service...
sc stop WSearch >nul 2>&1
sc config WSearch start= disabled >nul 2>&1
echo Done.
pause
cls
goto menu

:enable_search
cls
echo Enabling Windows Search service...
sc config WSearch start= delayed-auto >nul 2>&1
sc start WSearch >nul 2>&1
echo Done.
pause
cls
goto menu

:disable_onedrive
cls
echo Disabling OneDrive...
taskkill /f /im OneDrive.exe >nul 2>&1
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t REG_DWORD /d 1 /f >nul 2>&1
echo Done.
pause
cls
goto menu

:enable_onedrive
cls
echo Enabling OneDrive...
reg delete "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /f >nul 2>&1
start "" "%LOCALAPPDATA%\Microsoft\OneDrive\OneDrive.exe" >nul 2>&1
echo Done.
pause
cls
goto menu

:disable_cortana
cls
echo Disabling Cortana...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
echo Done.
pause
cls
goto menu

:enable_cortana
cls
echo Enabling Cortana...
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /f
echo Done.
pause
cls
goto menu

:download_cat_pic
cls
echo Downloading a cat picture...
set "desktop=%USERPROFILE%\Desktop"
powershell -Command ^
  "$url = 'https://cataas.com/cat?random=' + (Get-Random -Maximum 10000);" ^
  "$output = '%desktop%\cat.jpg';" ^
  "Invoke-WebRequest -Uri $url -OutFile $output"
echo Done. Check Desktop for cat.jpg
pause
cls
goto menu

:download_10_cats
cls
echo Downloading 10 random cat pictures...
set "desktop=%USERPROFILE%\Desktop\Cats"
if not exist "%desktop%" mkdir "%desktop%"
for /L %%i in (1,1,10) do (
  powershell -Command ^
    "$url = 'https://cataas.com/cat?random=' + (Get-Random -Maximum 10000);" ^
    "$output = '%desktop%\cat%%i.jpg';" ^
    "Invoke-WebRequest -Uri $url -OutFile $output"
)
echo Done. Check %desktop% for cat pictures.
pause
cls
goto menu

:ip_config
cls
ipconfig /all
pause
cls
goto menu

:renew_ip
cls
echo Renewing IP address...
ipconfig /release
ipconfig /renew
echo Done.
pause
cls
goto menu

:release_ip
cls
echo Releasing IP address...
ipconfig /release
echo Done.
pause
cls
goto menu

:ping_test
cls
echo Pinging google.com...
ping google.com -n 5
pause
cls
goto menu

:tracert_test
cls
echo Tracing route to google.com...
tracert google.com
pause
cls
goto menu

:exit_script
cls
echo Exiting Nash Tool. Goodbye.
timeout /t 2 >nul
exit
