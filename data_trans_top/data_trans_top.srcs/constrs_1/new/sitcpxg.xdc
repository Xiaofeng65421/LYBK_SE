set_property PACKAGE_PIN AL15 [get_ports I2C_SDA]

set_property PACKAGE_PIN P16 [get_ports {GPIO_DIP_SW[3]}]
set_property PACKAGE_PIN R16 [get_ports {GPIO_DIP_SW[2]}]
set_property PACKAGE_PIN R17 [get_ports {GPIO_DIP_SW[1]}]
set_property PACKAGE_PIN T17 [get_ports {GPIO_DIP_SW[0]}]
set_property PACKAGE_PIN P19 [get_ports GPIO_SW_S]
set_property PACKAGE_PIN AV12 [get_ports I2C_SCL]
set_property PACKAGE_PIN AC8 [get_ports SMA_MGT_REF_CLK_P]

# SFP Port 1
# set_property PACKAGE_PIN AG4 [get_ports SFP_RX_P]
# set_property PACKAGE_PIN AR28 [get_ports SFP_TX_DISABLE]
# SFP Port 2
set_property PACKAGE_PIN AB2 [get_ports SFP_RX_P]
set_property PACKAGE_PIN AK27 [get_ports SFP_TX_DISABLE]



####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################



####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################



####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################


set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_DIP_SW[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_DIP_SW[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_DIP_SW[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_DIP_SW[0]}]
set_property IOSTANDARD LVCMOS12 [get_ports GPIO_SW_S]
set_property IOSTANDARD LVCMOS12 [get_ports SFP_TX_DISABLE]

####################################################################################
# Constraints from file : 'xpm_cdc_gray.tcl'
####################################################################################



#set_false_path -from [get_clocks SYS_CLK_P] -to [get_clocks -of_objects [get_pins U06_lybk_ddr/LYBK_DDR/ddr4_00/inst/u_ddr4_infrastructure/gen_mmcme3.u_mmcme_adv_inst/CLKOUT0]]
#set_false_path -from [get_clocks SYS_CLK_P] -to [get_clocks SMA_MGT_REF_CLK_P]
#set_false_path -from [get_clocks -of_objects [get_pins U06_lybk_ddr/LYBK_DDR/ddr4_00/inst/u_ddr4_infrastructure/gen_mmcme3.u_mmcme_adv_inst/CLKOUT0]] -to [get_clocks SYS_CLK_P]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
