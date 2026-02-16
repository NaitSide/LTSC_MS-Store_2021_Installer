@echo off
chcp 65001 >nul
title Проверка версий пакетов

echo ====================================
echo   Проверка версий пакетов
echo   NaitSide Custom Build
echo ====================================
echo.

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage | Where-Object {$_.Name -match 'Store|Xbox|VCLibs|Xaml|NET.Native|DesktopAppInstaller'} | Select-Object Name, Version | Sort-Object Name"

pause