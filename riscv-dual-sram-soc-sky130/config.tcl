set ::env(DESIGN_NAME) "soc_top"
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]
set ::env(VERILOG_FILES_BLACKBOX) "$::env(DESIGN_DIR)/src/sram_1kb_bb.v"

# Hard Macro Collateral (LEF, LIB, GDS)
set ::env(EXTRA_LEFS) "$::env(DESIGN_DIR)/macros/lef/sky130_sram_1k.lef"
set ::env(SYNTH_READ_BLACKBOX_LIB) 0

# Floorplan & Macro Placement Configuration
set ::env(FP_SIZING) "absolute"
set ::env(FP_CORE_UTIL) 40
set ::env(DIE_AREA) "0 0 1600 1600"
set ::env(CORE_AREA) "25 25 1575 1575"
set ::env(MACRO_PLACEMENT_CFG) "$::env(DESIGN_DIR)/floorplan/macro_placement.cfg"
set ::env(FP_PIN_ORDER_CFG) "$::env(DESIGN_DIR)/floorplan/pin_order.cfg"
set ::env(FP_PDN_HORIZONTAL_HALO) 10
set ::env(FP_PDN_VERTICAL_HALO) 10
set ::env(PL_MACRO_HALO) "10 10"
set ::env(PL_TARGET_DENSITY) 0.48
set ::env(GRT_ADJUSTMENT) 0.20

# Clock Tree & Timing Optimization
set ::env(CLOCK_PORT) "clk"
set ::env(CLOCK_PERIOD) "12.5" ;# 80 MHz target
set ::env(CTS_TARGET_SKEW) "150"
set ::env(CTS_ROOT_BUFFER) "sky130_fd_sc_hd__clkbuf_16"
set ::env(GRT_MAX_DIODE_INS_ITERS) 5
set ::env(MAGIC_GENERATE_LEF) 0
set ::env(MAGIC_GENERATE_MAGLEF) 0
set ::env(FP_PDN_MACRO_HOOKS) "u_sram_inst vccd1 vssd1 vccd1 vssd1, u_sram_data vccd1 vssd1 vccd1 vssd1"
set ::env(QUIT_ON_LVS_ERROR) 0
