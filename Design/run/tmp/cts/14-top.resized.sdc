###############################################################################
# Created by write_sdc
# Wed Jul  1 11:19:56 2026
###############################################################################
current_design top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 20.0000 [get_ports {clk}]
set_clock_transition 0.2500 [get_clocks {clk}]
set_clock_uncertainty 0.2500 clk
set_propagated_clock [get_clocks {clk}]
set_input_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {reset}]
set_input_delay 4.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {reset}]
set_input_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {uart_rx}]
set_input_delay 4.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {uart_rx}]
set_output_delay 0.0000 -clock [get_clocks {clk}] -min -add_delay [get_ports {uart_tx}]
set_output_delay 4.0000 -clock [get_clocks {clk}] -max -add_delay [get_ports {uart_tx}]
set_false_path\
    -from [get_ports {reset}]
###############################################################################
# Environment
###############################################################################
set_load -pin_load 0.0170 [get_ports {uart_tx}]
set_driving_cell -lib_cell sky130_fd_sc_hd__clkbuf_16 -pin {X} -input_transition_rise 0.0000 -input_transition_fall 0.0000 [get_ports {clk}]
set_input_transition -min 0.1500 [get_ports {reset}]
set_input_transition -max 0.5000 [get_ports {reset}]
set_input_transition -min 0.1500 [get_ports {uart_rx}]
set_input_transition -max 0.5000 [get_ports {uart_rx}]
###############################################################################
# Design Rules
###############################################################################
set_max_transition 1.5000 [current_design]
