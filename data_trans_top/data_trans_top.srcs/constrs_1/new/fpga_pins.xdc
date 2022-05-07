##ZK TRIGGER
set_property PACKAGE_PIN AL39 [get_ports SMA_TRIG_IN]
##TrigOK
set_property PACKAGE_PIN AL38 [get_ports SMA_TrigOK_OUT]
## RS422
set_property PACKAGE_PIN AV38 [get_ports txd_p]
set_property PACKAGE_PIN AV39 [get_ports txd_n]
set_property PACKAGE_PIN AN39 [get_ports rxd_p]
set_property PACKAGE_PIN AP39 [get_ports rxd_n]

#### reset
set_property PACKAGE_PIN AU25 [get_ports reset]

#### LED
set_property PACKAGE_PIN N18 [get_ports {GPIO_LED[7]}]
set_property PACKAGE_PIN N19 [get_ports {GPIO_LED[6]}]
set_property PACKAGE_PIN N17 [get_ports {GPIO_LED[5]}]
set_property PACKAGE_PIN L19 [get_ports {GPIO_LED[4]}]
set_property PACKAGE_PIN K17 [get_ports {GPIO_LED[3]}]
set_property PACKAGE_PIN L17 [get_ports {GPIO_LED[2]}]
set_property PACKAGE_PIN M16 [get_ports {GPIO_LED[1]}]
set_property PACKAGE_PIN N16 [get_ports {GPIO_LED[0]}]


######slot2 : awg
set_property PACKAGE_PIN AP15 [get_ports {TRIGGER_OUT_P[0]}]
set_property PACKAGE_PIN AW19 [get_ports {FPGA_READY[0]}]
set_property PACKAGE_PIN AW20 [get_ports {FPGA_SYS_RST[0]}]
set_property PACKAGE_PIN AU20 [get_ports {FPGA_RESET_FINISH[0]}]

######slot3 : awg
set_property PACKAGE_PIN AT15 [get_ports {TRIGGER_OUT_P[1]}]
set_property PACKAGE_PIN AR20 [get_ports {FPGA_READY[1]}]
set_property PACKAGE_PIN AU17 [get_ports {FPGA_SYS_RST[1]}]
set_property PACKAGE_PIN AU16 [get_ports {FPGA_RESET_FINISH[1]}]

######slot4 : awg
set_property PACKAGE_PIN AV16 [get_ports {TRIGGER_OUT_P[2]}]
set_property PACKAGE_PIN AN17 [get_ports {FPGA_READY[2]}]
set_property PACKAGE_PIN AN16 [get_ports {FPGA_SYS_RST[2]}]
set_property PACKAGE_PIN AP19 [get_ports {FPGA_RESET_FINISH[2]}]

######slot5 : awg
set_property PACKAGE_PIN AT14 [get_ports {TRIGGER_OUT_P[3]}]
set_property PACKAGE_PIN AL18 [get_ports {FPGA_READY[3]}]
set_property PACKAGE_PIN AK17 [get_ports {FPGA_SYS_RST[3]}]
set_property PACKAGE_PIN AH16 [get_ports {FPGA_RESET_FINISH[3]}]

######slot6 : dac
set_property PACKAGE_PIN AV14 [get_ports {TRIGGER_OUT_P[8]}]
set_property PACKAGE_PIN AT35 [get_ports {TRIGGER_OUT_P[9]}]

set_property PACKAGE_PIN AE17 [get_ports {FPGA_SYS_RST[8]}]
set_property PACKAGE_PIN AF18 [get_ports {FPGA_SYS_RST[9]}]

set_property PACKAGE_PIN AH18 [get_ports {FPGA_READY[8]}]
set_property PACKAGE_PIN AL19 [get_ports {FPGA_READY[9]}]

set_property PACKAGE_PIN AJ18 [get_ports {FPGA_RESET_FINISH[8]}]
set_property PACKAGE_PIN AM19 [get_ports {FPGA_RESET_FINISH[9]}]

######slot7 : adda
set_property PACKAGE_PIN AF15 [get_ports {TRIGGER_OUT_P[15]}]
set_property PACKAGE_PIN AW33 [get_ports {TRIGGER_OUT_P[14]}]

set_property PACKAGE_PIN AK31 [get_ports {FPGA_SYS_RST[15]}]
set_property PACKAGE_PIN AH28 [get_ports {FPGA_SYS_RST[14]}]

set_property PACKAGE_PIN AK33 [get_ports {FPGA_READY[15]}]
set_property PACKAGE_PIN AE30 [get_ports {FPGA_READY[14]}]

set_property PACKAGE_PIN AL33 [get_ports {FPGA_RESET_FINISH[15]}]
set_property PACKAGE_PIN AH29 [get_ports {FPGA_RESET_FINISH[14]}]

######slot9 : dac
set_property PACKAGE_PIN AR12 [get_ports {TRIGGER_OUT_P[10]}]
set_property PACKAGE_PIN AV33 [get_ports {TRIGGER_OUT_P[11]}]

set_property PACKAGE_PIN AK35 [get_ports {FPGA_SYS_RST[10]}]
set_property PACKAGE_PIN AK38 [get_ports {FPGA_SYS_RST[11]}]

set_property PACKAGE_PIN AK36 [get_ports {FPGA_READY[10]}]
set_property PACKAGE_PIN L33 [get_ports {FPGA_READY[11]}]

set_property PACKAGE_PIN AM37 [get_ports {FPGA_RESET_FINISH[10]}]
set_property PACKAGE_PIN AJ39 [get_ports {FPGA_RESET_FINISH[11]}]

######slot10 : dac
set_property PACKAGE_PIN AP14 [get_ports {TRIGGER_OUT_P[12]}]
set_property PACKAGE_PIN AT34 [get_ports {TRIGGER_OUT_P[13]}]

set_property PACKAGE_PIN P30 [get_ports {FPGA_SYS_RST[12]}]
set_property PACKAGE_PIN N28 [get_ports {FPGA_SYS_RST[13]}]

set_property PACKAGE_PIN P28 [get_ports {FPGA_READY[12]}]
set_property PACKAGE_PIN M30 [get_ports {FPGA_READY[13]}]

set_property PACKAGE_PIN P29 [get_ports {FPGA_RESET_FINISH[12]}]
set_property PACKAGE_PIN N27 [get_ports {FPGA_RESET_FINISH[13]}]

######slot11 : awg
set_property PACKAGE_PIN AH14 [get_ports {TRIGGER_OUT_P[4]}]
set_property PACKAGE_PIN K30 [get_ports {FPGA_READY[4]}]
set_property PACKAGE_PIN L30 [get_ports {FPGA_SYS_RST[4]}]
set_property PACKAGE_PIN L29 [get_ports {FPGA_RESET_FINISH[4]}]

######slot12 : awg
set_property PACKAGE_PIN AH13 [get_ports {TRIGGER_OUT_P[5]}]
set_property PACKAGE_PIN E25 [get_ports {FPGA_READY[5]}]
set_property PACKAGE_PIN G27 [get_ports {FPGA_SYS_RST[5]}]
set_property PACKAGE_PIN F27 [get_ports {FPGA_RESET_FINISH[5]}]

######slot13 : awg
set_property PACKAGE_PIN AK13 [get_ports {TRIGGER_OUT_P[6]}]
set_property PACKAGE_PIN B26 [get_ports {FPGA_READY[6]}]
set_property PACKAGE_PIN E28 [get_ports {FPGA_SYS_RST[6]}]
set_property PACKAGE_PIN A25 [get_ports {FPGA_RESET_FINISH[6]}]

#####slot14 : awg
set_property PACKAGE_PIN AE13 [get_ports {TRIGGER_OUT_P[7]}]
set_property PACKAGE_PIN B29 [get_ports {FPGA_READY[7]}]
set_property PACKAGE_PIN D29 [get_ports {FPGA_SYS_RST[7]}]
set_property PACKAGE_PIN A29 [get_ports {FPGA_RESET_FINISH[7]}]

##############################################################
##################################################################
####################################################################################
# Constraints from file : 'sitcpxg.xdc'
####################################################################################




####################################################################################
# Constraints from file : 'sitcpxg.xdc'
####################################################################################







####################################################################################
# Constraints from file : 'sitcpxg.xdc'
####################################################################################


set_property IOSTANDARD LVCMOS18 [get_ports SMA_TRIG_IN]
set_property IOSTANDARD LVCMOS18 [get_ports SMA_TrigOK_OUT]
set_property IOSTANDARD LVDS [get_ports txd_p]
set_property IOSTANDARD LVDS [get_ports txd_n]
set_property IOSTANDARD LVDS [get_ports rxd_p]
set_property IOSTANDARD LVDS [get_ports rxd_n]
set_property IOSTANDARD LVCMOS12 [get_ports reset]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[7]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[6]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[5]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[4]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[3]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[2]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[1]}]
set_property IOSTANDARD LVCMOS12 [get_ports {GPIO_LED[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[7]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER_OUT_P[9]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER_OUT_P[11]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[15]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER_OUT_P[14]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER_OUT_P[13]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[12]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[10]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[8]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER_OUT_P[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_READY[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_SYS_RST[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[15]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[14]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[13]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[12]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[11]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[10]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[9]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[8]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[7]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {FPGA_RESET_FINISH[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports SYS_CLK_P]
set_property DIFF_TERM_ADV TERM_100 [get_ports SYS_CLK_N]
set_property DIFF_TERM_ADV TERM_100 [get_ports rxd_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports rxd_n]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[7]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[6]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[5]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[4]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[3]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[2]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[1]}]
set_property OUTPUT_IMPEDANCE RDRV_NONE_NONE [get_ports {GPIO_LED[0]}]
set_property DIFF_TERM_ADV TERM_100 [get_ports osc_clk_p]
set_property DIFF_TERM_ADV TERM_100 [get_ports osc_clk_n]

####################################################################################
# Constraints from file : 'sitcpxg.xdc'
####################################################################################



