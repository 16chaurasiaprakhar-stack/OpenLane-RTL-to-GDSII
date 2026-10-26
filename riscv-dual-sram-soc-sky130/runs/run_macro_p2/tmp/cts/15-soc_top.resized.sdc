###############################################################################
# Created by write_sdc
# Sun Oct 25 19:58:50 2026
###############################################################################
current_design soc_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 12.5000 [get_ports {clk}]
set_clock_transition 0.1500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {irq[0]}]
set_input_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {irq[1]}]
set_input_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {irq[2]}]
set_input_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {resetn}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[0]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[1]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[2]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[3]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[4]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[5]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[6]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {gpio_out[7]}]
set_output_delay 2.5000 -clock [get_clocks {clk}] -add_delay [get_ports {trap}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0334 [get_ports {trap}]
set_load -pin_load 0.0334 [get_ports {gpio_out[7]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[6]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[5]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[4]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[3]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[2]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[1]}]
set_load -pin_load 0.0334 [get_ports {gpio_out[0]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {resetn}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {irq[2]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {irq[1]}]
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin {Y} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {irq[0]}]
set_timing_derate -early 0.9500
set_timing_derate -late 1.0500
###############################################################################
# Design Rules
###############################################################################
set_max_transition 0.7500 [current_design]
set_max_fanout 10.0000 [current_design]
