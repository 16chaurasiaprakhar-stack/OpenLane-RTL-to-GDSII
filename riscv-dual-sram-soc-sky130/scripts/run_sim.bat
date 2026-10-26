@echo off
setlocal enabledelayedexpansion

echo ================================================================
echo   SOC SUBSYSTEM SIMULATION RUNNER (WINDOWS / ICARUS VERILOG)
echo   Project: Macro-Dominated SoC Subsystem (PicoRV32 + Dual SRAM)
echo ================================================================

cd /d "%~dp0\.."

set IVERILOG_BIN=C:\iverilog\bin
set PATH=%IVERILOG_BIN%;%PATH%

if not exist build mkdir build

echo [STEP 1/2] Compiling Verilog RTL and Verification Testbench...
iverilog -g2012 -o build\tb_soc_top.vvp tb\tb_soc_top.v src\soc_top.v src\picorv32.v src\axi_xbar.v src\sram_1kb_bb.v
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Verilog compilation failed!
    exit /b 1
)

echo [STEP 2/2] Running Functional Simulation in VVP...
vvp build\tb_soc_top.vvp
if %ERRORLEVEL% neq 0 (
    echo [ERROR] Simulation execution failed!
    exit /b 1
)

echo.
echo [DONE] Simulation finished successfully.
echo Waveform dumped to tb_soc_top.vcd
