########7044 100M
set_property PACKAGE_PIN F32 [get_ports SYS_CLK_P]

set_property PACKAGE_PIN AR27 [get_ports SCLK]
set_property PACKAGE_PIN AT27 [get_ports SDATA]
set_property PACKAGE_PIN AW26 [get_ports SLEN]

####### 晶振 200M
set_property PACKAGE_PIN AN13 [get_ports osc_clk_p]

#####  5338
set_property PACKAGE_PIN AM25 [get_ports SI5338_SCL]
set_property PACKAGE_PIN AP26 [get_ports SI5338_SDA]

set_property PACKAGE_PIN AR26 [get_ports SI5338_OCLK]





####################################################################################
# Constraints from file : 'fpga_pins.xdc'
####################################################################################



####################################################################################
# Constraints from file : 'fpga_pins.xdc'
####################################################################################



####################################################################################
# Constraints from file : 'debug.xdc'
####################################################################################


#create_clock -period 10.000 [get_ports SYS_CLK_P]
set_property IOSTANDARD LVDS [get_ports SYS_CLK_P]
set_property IOSTANDARD LVCMOS12 [get_ports SCLK]
set_property IOSTANDARD LVCMOS12 [get_ports SDATA]
set_property IOSTANDARD LVCMOS12 [get_ports SLEN]
#create_clock -period 5.000 [get_ports osc_clk_p]
set_property IOSTANDARD LVDS_25 [get_ports osc_clk_p]
set_property IOSTANDARD LVCMOS12 [get_ports SI5338_SCL]
set_property IOSTANDARD LVCMOS12 [get_ports SI5338_SDA]
set_property PULLUP true [get_ports SI5338_SCL]
set_property PULLUP true [get_ports SI5338_SDA]
set_property IOSTANDARD LVCMOS12 [get_ports SI5338_OCLK]

####################################################################################
# Constraints from file : 'debug.xdc'
####################################################################################



