# Master Clock (80 MHz = 12.5 ns)
create_clock -name clk -period 12.5 [get_ports clk]
set_clock_uncertainty -setup 0.35 [get_clocks clk]
set_clock_uncertainty -hold  0.15 [get_clocks clk]
set_clock_transition 0.20 [get_clocks clk]

# I/O Budgeting (40% cycle margin)
set_input_delay  -clock clk -max 4.0 [all_inputs -no_clocks]
set_input_delay  -clock clk -min 1.0 [all_inputs -no_clocks]
set_output_delay -clock clk -max 4.0 [all_outputs]
set_output_delay -clock clk -min 0.5 [all_outputs]
set_false_path -from [get_ports resetn]
