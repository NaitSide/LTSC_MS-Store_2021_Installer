@echo off
chcp 65001 >nul
title Установка Microsoft Store - NaitSide Custom Build

:: Проверка прав администратора
net session >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo =========================================================
    echo    [ОШИБКА] Требуются права администратора!
    echo =========================================================
    echo.
    echo    Запустите скрипт правой кнопкой мыши
    echo    -^> "Запуск от имени администратора"
    echo.
    echo =========================================================
    echo.
    pause
    exit /b
)

cls
echo.
echo =========================================================
echo    LTSC MS-Store 2021 Installer
echo    Установка Microsoft Store в LTSC 2021
echo    NaitSide Custom Build
echo =========================================================
echo.
echo    Этот скрипт установит в систему:
echo.
echo    • Microsoft Store и все зависимости
echo    • Desktop App Installer (winget)
echo    • Xbox Identity Provider
echo    • Store Purchase App
echo.
echo    [!] Запускайте ТОЛЬКО на чистой Windows 10 LTSC 2021!
echo.
echo =========================================================
echo    GitHub: github.com/NaitSide/LTSC_MS-Store_2021_Installer
echo =========================================================
echo.
pause

:: Перейти в каталог скрипта
pushd "%~dp0"
SET "ScriptDir=%CD%"
SET "PACKAGES_DIR=%ScriptDir%\Packages"

echo.
echo =========================================================
echo Начинаем установку компонентов Microsoft Store
echo Текущий каталог скрипта: %ScriptDir%
echo =========================================================

REM =========================================================
REM УСТАНОВКА ЗАВИСИМОСТЕЙ
REM =========================================================

echo.
echo Установка зависимостей...

echo Установка Microsoft.NET.Native...
for %%i in ("%PACKAGES_DIR%\Microsoft.NET.Native.*.Appx") do (
    echo   Устанавливаю: %%~nxi
    powershell -Command "Add-AppxPackage -Path '%%i'" >nul 2>&1
)

echo Установка Microsoft.UI.Xaml...
for %%i in ("%PACKAGES_DIR%\Microsoft.UI.Xaml.*.appx") do (
    echo   Устанавливаю: %%~nxi
    powershell -Command "Add-AppxPackage -Path '%%i'" >nul 2>&1
)

echo Установка Microsoft.VCLibs...
for %%i in ("%PACKAGES_DIR%\Microsoft.VCLibs.*.Appx") do (
    echo   Устанавливаю: %%~nxi
    powershell -Command "Add-AppxPackage -Path '%%i'" >nul 2>&1
)

echo [OK] Зависимости установлены

REM =========================================================
REM УСТАНОВКА ОСНОВНЫХ КОМПОНЕНТОВ С ЛИЦЕНЗИЯМИ
REM =========================================================

echo.
echo [1/4] Установка Desktop App Installer...
powershell -Command "Add-AppxProvisionedPackage -Online -PackagePath '%PACKAGES_DIR%\Microsoft.DesktopAppInstaller_1.6.29000.1000_neutral_~_8wekyb3d8bbwe.AppxBundle' -LicensePath '%PACKAGES_DIR%\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.xml' | Out-Null"
IF %ERRORLEVEL% NEQ 0 (
    echo [ОШИБКА] Desktop App Installer не установлен.
) ELSE (
    echo [OK] Desktop App Installer установлен
)

echo.
echo [2/4] Установка Xbox Identity Provider...
powershell -Command "Add-AppxProvisionedPackage -Online -PackagePath '%PACKAGES_DIR%\Microsoft.XboxIdentityProvider_12.45.6001.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -LicensePath '%PACKAGES_DIR%\Microsoft.XboxIdentityProvider_8wekyb3d8bbwe.xml' | Out-Null"
IF %ERRORLEVEL% NEQ 0 (
    echo [ОШИБКА] Xbox Identity Provider не установлен.
) ELSE (
    echo [OK] Xbox Identity Provider установлен
)

echo.
echo [3/4] Установка Store Purchase App...
powershell -Command "Add-AppxProvisionedPackage -Online -PackagePath '%PACKAGES_DIR%\Microsoft.StorePurchaseApp_11808.1001.413.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -LicensePath '%PACKAGES_DIR%\Microsoft.StorePurchaseApp_8wekyb3d8bbwe.xml' | Out-Null"
IF %ERRORLEVEL% NEQ 0 (
    echo [ОШИБКА] Store Purchase App не установлен.
) ELSE (
    echo [OK] Store Purchase App установлен
)

echo.
echo [4/4] Установка Microsoft Store...
powershell -Command "Add-AppxProvisionedPackage -Online -PackagePath '%PACKAGES_DIR%\Microsoft.WindowsStore_11809.1001.713.0_neutral_~_8wekyb3d8bbwe.AppxBundle' -LicensePath '%PACKAGES_DIR%\Microsoft.WindowsStore_8wekyb3d8bbwe.xml' | Out-Null"
IF %ERRORLEVEL% NEQ 0 (
    echo [ОШИБКА] Microsoft Store не установлен.
) ELSE (
    echo [OK] Microsoft Store установлен
)

echo.
echo =========================================================
echo Процесс установки завершен. Проверьте наличие ошибок выше.
echo =========================================================
echo.
pause