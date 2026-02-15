@echo off
chcp 65001 >nul
title Проверка версий пакетов

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "Get-AppxPackage | Where-Object {$_.Name -match 'Store|Xbox|VCLibs|Xaml|NET.Native'} | Select-Object Name, Version | Sort-Object Name"

pause