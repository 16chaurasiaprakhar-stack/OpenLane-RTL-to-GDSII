#!/bin/bash
# Push-Button OpenLane RTL-to-GDSII Execution Script
# Project: Macro-Dominated SoC Subsystem (PicoRV32 + Dual OpenRAM 1KB Macros)

set -e

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
PROJECT_DIR=$(dirname "$SCRIPT_DIR")
TAG=${1:-"run_tapeout"}

export MISMATCHES_OK=1

echo "================================================================="
echo "  OPENLANE RTL-TO-GDSII AUTOMATED FLOW"
echo "  Design: soc_top | Process: SkyWater 130nm"
echo "  Macro Configuration: Dual 1KB OpenRAM (Instruction & Data)"
echo "  Run Tag: $TAG"
echo "================================================================="

if [ -f "/openlane/flow.tcl" ]; then
    # Running directly inside OpenLane container
    cd /openlane
    ./flow.tcl -design "$PROJECT_DIR" -tag "$TAG" -overwrite -ignore_mismatches
elif command -v docker &> /dev/null; then
    # Launch via Docker container
    PDK_ROOT=${PDK_ROOT:-"$HOME/.volare"}
    OPENLANE_IMAGE=${OPENLANE_IMAGE:-"efabless/openlane:v1.0.2"}
    echo "[INFO] Invoking OpenLane Docker container ($OPENLANE_IMAGE)..."
    docker run --rm \
        -v "$PROJECT_DIR":/work/soc_top \
        -v "$PDK_ROOT":/pdk \
        -e PDK_ROOT=/pdk \
        -e PDK=sky130A \
        -e MISMATCHES_OK=1 \
        -u "$(id -u):$(id -g)" \
        "$OPENLANE_IMAGE" \
        /bin/bash -c "cd /work/soc_top && flow.tcl -design . -tag $TAG -overwrite -ignore_mismatches"
else
    echo "[ERROR] OpenLane or Docker not found in system PATH."
    echo "Please ensure Docker or an OpenLane environment is installed."
    exit 1
fi

echo "================================================================="
echo "  OPENLANE RUN COMPLETED"
echo "  Deliverables Generated:"
echo "    - Layout DEF: runs/$TAG/results/final/def/soc_top.def"
echo "    - Tapeout GDS: runs/$TAG/results/final/gds/soc_top.gds"
echo "    - Signoff Reports: runs/$TAG/reports/manufacturability.rpt"
echo "================================================================="
