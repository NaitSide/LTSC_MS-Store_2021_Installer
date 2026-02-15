@echo off
chcp 65001 >nul
title Вшивание Microsoft Store в WIM - NaitSide Custom Build

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ОШИБКА] Требуются права администратора!
    echo Запустите скрипт правой кнопкой мыши -^> "Запуск от имени администратора"
    echo.
    pause
    exit /b
)

echo ====================================
echo   Вшивание Microsoft Store в WIM
echo   NaitSide Custom Build
echo ====================================
echo.
echo Этот скрипт вошьет Microsoft Store
echo и зависимости в смонтированный образ Windows.
echo Разворачивай WIM на VHD через DISM++
echo.
echo ====================================

:: Перейти в каталог скрипта и получить текущий путь
pushd "%~dp0"
SET "ScriptDir=%CD%"

:INPUT_DRIVE
echo.
set /p TargetDrive="Выберите букву диска VHD где развернут Windows (например, G): "

:: Формируем путь ImagePath
SET "ImagePath=%TargetDrive%:"

:: Проверка наличия целевого диска
IF NOT EXIST %ImagePath%\ (
    echo [ОШИБКА] Диск %ImagePath% не найден. Убедитесь, что VHD смонтирован.
    goto INPUT_DRIVE
)

echo.
echo =========================================================
echo Начинаем установку компонентов Microsoft Store в %ImagePath%
echo Текущий каталог скрипта: %ScriptDir%
echo =========================================================

REM --- Определение полных АБСОЛЮТНЫХ путей ---
SET "AppIns=%ScriptDir%\Packages\Microsoft.DesktopAppInstaller_1.6.29000.1000_neutral_~_8wekyb3d8bbwe.AppxBundle"
SET "AppInsXML=%ScriptDir%\Packages\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.xml"
SET "XboxId=%ScriptDir%\Packages\Microsoft.XboxIdentityProvider_12.45.6001.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
SET "XboxIdXML=%ScriptDir%\Packages\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml"
SET "StorePur=%ScriptDir%\Packages\Microsoft.StorePurchaseApp_11808.1001.413.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
SET "StorePurXML=%ScriptDir%\Packages\Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml"
SET "WinStore=%ScriptDir%\Packages\Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle"
SET "WinStoreXML=%ScriptDir%\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe.xml"

REM --- Определение зависимостей (x64) ---
SET "Dep1=%ScriptDir%\Packages\Microsoft.UI.Xaml.2.4_2.42007.9001.0_x64__8wekyb3d8bbwe.Appx"
SET "Dep2=%ScriptDir%\Packages\Microsoft.UI.Xaml.2.7_7.2208.15002.0_x64__8wekyb3d8bbwe.appx"
SET "Dep3=%ScriptDir%\Packages\Microsoft.VCLibs.140.00_14.0.26706.0_x64__8wekyb3d8bbwe.Appx"
SET "Dep4=%ScriptDir%\Packages\Microsoft.VCLibs.140.00_14.0.32530.0_x64__8wekyb3d8bbwe.appx"
SET "Dep5=%ScriptDir%\Packages\Microsoft.NET.Native.Runtime.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx"
SET "Dep6=%ScriptDir%\Packages\Microsoft.NET.Native.Framework.1.6_1.6.24903.0_x64__8wekyb3d8bbwe.Appx"


REM =========================================================
REM УСТАНОВКА КОМПОНЕНТОВ ПО ПОРЯДКУ
REM =========================================================

echo.
echo [1/4] Установка Desktop App Installer...
dism /Image:%ImagePath% /Add-ProvisionedAppxPackage /PackagePath:"%AppIns%" /LicensePath:"%AppInsXML%"
IF %ERRORLEVEL% NEQ 0 echo [ОШИБКА] Desktop App Installer не установлен.

echo.
echo [2/4] Установка Xbox Identity Provider...
dism /Image:%ImagePath% /Add-ProvisionedAppxPackage /PackagePath:"%XboxId%" /LicensePath:"%XboxIdXML%"
IF %ERRORLEVEL% NEQ 0 echo [ОШИБКА] Xbox Identity Provider не установлен.

echo.
echo [3/4] Установка Store Purchase App...
SET "DependenciesParam=/DependencyPackagePath:"%Dep1%" /DependencyPackagePath:"%Dep2%" /DependencyPackagePath:"%Dep3%" /DependencyPackagePath:"%Dep4%" /DependencyPackagePath:"%Dep5%" /DependencyPackagePath:"%Dep6%""
dism /Image:%ImagePath% /Add-ProvisionedAppxPackage /PackagePath:"%StorePur%" %DependenciesParam% /LicensePath:"%StorePurXML%"
IF %ERRORLEVEL% NEQ 0 echo [ОШИБКА] Store Purchase App не установлен.

echo.
echo [4/4] Установка Microsoft Store...
dism /Image:%ImagePath% /Add-ProvisionedAppxPackage /PackagePath:"%WinStore%" %DependenciesParam% /LicensePath:"%WinStoreXML%"
IF %ERRORLEVEL% NEQ 0 echo [ОШИБКА] Microsoft Store не установлен.

echo.
echo =========================================================
echo Процесс установки завершен. Проверьте наличие ошибок выше.
echo =========================================================

pause