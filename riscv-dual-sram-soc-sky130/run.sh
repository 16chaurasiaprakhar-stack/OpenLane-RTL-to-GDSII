#!/bin/bash
# Master One-Click Launcher for Macro-Dominated SoC Subsystem
set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
cd "$SCRIPT_DIR"

echo "======================================================================="
echo "  MACRO-DOMINATED SOC SUBSYSTEM PHYSICAL IMPLEMENTATION SUITE"
echo "  Process: SkyWater 130nm (sky130_fd_sc_hd)"
echo "======================================================================="
echo ""
echo "Select Execution Target:"
echo "  [1] Run Full Verification Audit (Calculations + Collateral + Sim)"
echo "  [2] Run RTL Simulation (Icarus Verilog)"
echo "  [3] Regenerate Hard Macro Collaterals (LEF, Multi-Corner LIB, GDS)"
echo "  [4] Run Multi-Corner STA Signoff Script"
echo "  [5] Launch OpenLane Physical Implementation Flow (Docker)"
echo "  [6] Clean Build Directory"
echo ""

CHOICE=${1:-1}

case "$CHOICE" in
    1)
        echo "[RUNNING] Complete Verification Audit..."
        python3 scripts/verify_project.py
        ;;
    2)
        echo "[RUNNING] Functional Verilog Simulation..."
        bash scripts/run_sim.sh
        ;;
    3)
        echo "[RUNNING] Collateral Regeneration..."
        python3 scripts/gen_collateral.py
        ;;
    4)
        echo "[RUNNING] Multi-Corner STA..."
        sta scripts/sta_multicorner.tcl
        ;;
    5)
        echo "[RUNNING] OpenLane Flow..."
        bash scripts/run_openlane.sh
        ;;
    6)
        echo "[CLEANING] Removing build artifacts..."
        rm -rf build tb_soc_top.vcd runs/
        echo "Clean complete."
        ;;
    *)
        echo "Invalid choice: $CHOICE"
        exit 1
        ;;
esac
