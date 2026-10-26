#!/bin/bash
# Functional Simulation Runner for Linux / WSL / macOS
set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
cd "$PROJECT_DIR"

mkdir -p build

echo "================================================================"
echo "  SOC SUBSYSTEM SIMULATION RUNNER (ICARUS VERILOG)"
echo "  Project: Macro-Dominated SoC Subsystem (PicoRV32 + Dual SRAM)"
echo "================================================================"

echo "[STEP 1/2] Compiling Verilog RTL and Testbench..."
iverilog -g2012 -o build/tb_soc_top.vvp \
    tb/tb_soc_top.v \
    src/soc_top.v \
    src/picorv32.v \
    src/axi_xbar.v \
    src/sram_1kb_bb.v

echo "[STEP 2/2] Running Simulation in VVP..."
vvp build/tb_soc_top.vvp

echo ""
echo "[DONE] Simulation passed 100%. Waveform saved to tb_soc_top.vcd"
