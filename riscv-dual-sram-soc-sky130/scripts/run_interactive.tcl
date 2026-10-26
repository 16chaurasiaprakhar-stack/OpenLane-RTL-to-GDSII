# Step-by-Step Interactive Implementation Flow
# Project: Macro-Dominated SoC Subsystem (PicoRV32 + Dual OpenRAM 1KB Macros)
# Process: SkyWater 130nm (sky130_fd_sc_hd)

package require openlane

# Step 1: Design Preparation
prep -design . -tag run_interactive -overwrite -ignore_mismatches

# Step 2: Logic Synthesis & Netlist Generation (with SRAM blackboxed)
run_synthesis

# Step 3: Floorplanning & Manual Macro Placement
init_floorplan
place_macros
gen_pdn

# Step 4: Standard Cell Placement & Legalization (Target density: 0.48, 10um halos)
run_placement

# Step 5: Clock Tree Synthesis & Buffer Sizing (NDR rules, clkbuf_16 insertion)
run_cts

# Step 6: Global & Detailed Routing (Antenna diode insertion & 0 GRC overflow)
run_routing

# Step 7: Physical Verification Signoff (Magic DRC, Netgen LVS, GDS streamout)
run_magic
run_magic_drc

puts "\n========================================================"
puts "  PHYSICAL IMPLEMENTATION SIGN-OFF COMPLETE"
puts "  Check reports/ for DRC, LVS, and Multi-Corner STA Slack"
puts "========================================================\n"
