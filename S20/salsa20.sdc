# SDC file for salsa20
# Auto-generated based on config.json and salsa20.v

set clk_name clk
set clk_port_name clk
set clk_period 38.0000
set io_delay [expr 0.2 * $clk_period]

# Create clock
create_clock [get_ports $clk_port_name] -name $clk_name -period $clk_period

# Clock uncertainty and transition (standard defaults)
set_clock_uncertainty 0.25 [get_clocks $clk_name]
set_clock_transition 0.15 [get_clocks $clk_name]

# Max fanout constraint (from config.json)
set_max_fanout 6.0 [current_design]

# Input Delays
set_input_delay $io_delay -clock [get_clocks $clk_name] [get_ports {reset_n}]
set_input_delay $io_delay -clock [get_clocks $clk_name] [get_ports {cs}]
set_input_delay $io_delay -clock [get_clocks $clk_name] [get_ports {we}]
set_input_delay $io_delay -clock [get_clocks $clk_name] [get_ports {address[*]}]
set_input_delay $io_delay -clock [get_clocks $clk_name] [get_ports {write_data[*]}]

# Output Delays
set_output_delay $io_delay -clock [get_clocks $clk_name] [get_ports {read_data[*]}]
set_output_delay $io_delay -clock [get_clocks $clk_name] [get_ports {error}]
