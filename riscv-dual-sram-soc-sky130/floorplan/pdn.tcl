# Custom PDN Configuration for Macro-Dominated SoC Subsystem
# Process: SkyWater 130nm
# Power Nets: VDD (1.8V nominal), VSS (0V)

# Standard Cell Core Grid
set_voltage_domain -name CORE -power VDD -ground VSS

define_pdn_grid \
    -name core_grid \
    -starts_with POWER \
    -voltage_domain CORE \
    -pins "met4 met5"

# Met1 Follow-pin standard cell rails
add_pdn_stripe \
    -grid core_grid \
    -layer met1 \
    -width 0.48 \
    -followpins

# Met4 Horizontal Power Straps (W = 3.2 um, Pitch = 100 um derived from 5% IR drop budget)
add_pdn_stripe \
    -grid core_grid \
    -layer met4 \
    -width 3.2 \
    -pitch 100.0 \
    -offset 20.0

# Met5 Vertical Power Straps
add_pdn_stripe \
    -grid core_grid \
    -layer met5 \
    -width 3.2 \
    -pitch 100.0 \
    -offset 20.0

# Vias between grid layers
add_pdn_connect \
    -grid core_grid \
    -layers "met1 met4"

add_pdn_connect \
    -grid core_grid \
    -layers "met4 met5"

# Dedicated Macro Power Rings for OpenRAM SRAM blocks
define_pdn_grid \
    -name sram_macro_rings \
    -macro \
    -default \
    -orient {R0 R180 MX MY R90 R270 MXR90 MYR90} \
    -halo {10.0 10.0 10.0 10.0}

add_pdn_ring \
    -grid sram_macro_rings \
    -layers {met4 met5} \
    -widths {3.2 3.2} \
    -spacings {2.0 2.0} \
    -core_offsets {2.0 2.0}

add_pdn_connect \
    -grid sram_macro_rings \
    -layers "met4 met5"
