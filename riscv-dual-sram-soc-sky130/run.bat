@echo off
setlocal enabledelayedexpansion
title RISC-V SoC Dual-SRAM Subsystem - Sky130 Physical Design Flow

cd /d "%~dp0"

echo =======================================================================
echo   MACRO-DOMINATED SOC SUBSYSTEM PHYSICAL IMPLEMENTATION SUITE
echo   Process: SkyWater 130nm (sky130_fd_sc_hd)
echo =======================================================================
echo.
echo Select Execution Target:
echo   [1] Run Full Verification Audit (Calculations + Collateral + Sim)
echo   [2] Run RTL Simulation (Icarus Verilog)
echo   [3] Regenerate Hard Macro Collaterals (LEF, Multi-Corner LIB, GDS)
echo   [4] Run Multi-Corner STA Signoff Script
echo   [5] Launch OpenLane Physical Implementation Flow (Docker)
echo   [6] Clean Build Directory
echo.

if "%~1"=="" (
    set /p CHOICE="Enter choice [1-6] (Default is 1): "
) else (
    set CHOICE=%~1
)

if "%CHOICE%"=="" set CHOICE=1

if "%CHOICE%"=="1" (
    echo [RUNNING] Complete Verification Audit...
    python scripts\verify_project.py
    if "%~1"=="" pause
    exit /b 0
)

if "%CHOICE%"=="2" (
    echo [RUNNING] Functional Verilog Simulation...
    call scripts\run_sim.bat
    if "%~1"=="" pause
    exit /b 0
)

if "%CHOICE%"=="3" (
    echo [RUNNING] Collateral Regeneration...
    python scripts\gen_collateral.py
    if "%~1"=="" pause
    exit /b 0
)

if "%CHOICE%"=="4" (
    echo [RUNNING] Multi-Corner STA...
    if exist "sta.exe" (
        sta scripts\sta_multicorner.tcl
    ) else (
        echo OpenSTA executable not found in Windows PATH.
        echo To run OpenSTA, use the OpenLane Docker container or WSL.
    )
    if "%~1"=="" pause
    exit /b 0
)

if "%CHOICE%"=="5" (
    echo [RUNNING] OpenLane Flow...
    bash scripts/run_openlane.sh
    if "%~1"=="" pause
    exit /b 0
)

if "%CHOICE%"=="6" (
    echo [CLEANING] Removing build artifacts...
    if exist build rmdir /s /q build
    if exist tb_soc_top.vcd del /f /q tb_soc_top.vcd
    echo Clean complete.
    if "%~1"=="" pause
    exit /b 0
)

echo Invalid choice: %CHOICE%
if "%~1"=="" pause
exit /b 1
