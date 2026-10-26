# ==============================================================================
# Makefile: Macro-Dominated SoC Subsystem Implementation & Signoff
# PDK: SkyWater 130nm (sky130_fd_sc_hd)
# Target: Physical Design / STA Closure (NVIDIA, Qualcomm Standards)
# ==============================================================================

SHELL       := /bin/bash
PYTHON      := python
IVERILOG    := iverilog
VVP         := vvp
GTKWAVE     := gtkwave

BUILD_DIR   := build
SRC_DIR     := src
TB_DIR      := tb
SCRIPTS_DIR := scripts

SRCS        := $(SRC_DIR)/soc_top.v \
               $(SRC_DIR)/picorv32.v \
               $(SRC_DIR)/axi_xbar.v \
               $(SRC_DIR)/sram_1kb_bb.v

VVP_OUT     := $(BUILD_DIR)/tb_soc_top.vvp
VCD_OUT     := tb_soc_top.vcd

.PHONY: all audit sim wave collateral sta flow clean help

all: audit sim

audit:
	@$(PYTHON) $(SCRIPTS_DIR)/verify_project.py

sim: $(VVP_OUT)
	@$(VVP) $(VVP_OUT)

$(VVP_OUT): $(TB_DIR)/tb_soc_top.v $(SRCS)
	@mkdir -p $(BUILD_DIR)
	@$(IVERILOG) -g2012 -o $(VVP_OUT) $(TB_DIR)/tb_soc_top.v $(SRCS)

wave: $(VCD_OUT)
	@$(GTKWAVE) $(VCD_OUT) &

collateral:
	@$(PYTHON) $(SCRIPTS_DIR)/gen_collateral.py

sta:
	@sta $(SCRIPTS_DIR)/sta_multicorner.tcl

flow:
	@bash $(SCRIPTS_DIR)/run_openlane.sh

clean:
	@rm -rf $(BUILD_DIR) $(VCD_OUT) runs/
	@echo "Clean completed."

help:
	@echo "Available Targets:"
	@echo "  make audit      : Run full metric derivations and collateral audit"
	@echo "  make sim        : Compile and run Verilog simulation (PicoRV32 + SRAMs)"
	@echo "  make wave       : View waveform in GTKWave"
	@echo "  make collateral : Regenerate LEF, multi-corner LIBs, and GDSII"
	@echo "  make sta        : Execute multi-corner STA signoff in OpenSTA"
	@echo "  make flow       : Trigger OpenLane RTL-to-GDSII flow in Docker"
	@echo "  make clean      : Remove build artifacts"
