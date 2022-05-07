
######slot2 : awg
set_property PACKAGE_PIN AP15 [get_ports {TRIGGER0_P[0]}]

######slot3 : awg
set_property PACKAGE_PIN AT15 [get_ports {TRIGGER0_P[1]}]

######slot4 : awg
set_property PACKAGE_PIN AV16 [get_ports {TRIGGER0_P[2]}]

######slot5 : awg
set_property PACKAGE_PIN AT14 [get_ports {TRIGGER0_P[3]}]

######slot6 : dac
set_property PACKAGE_PIN AV14 [get_ports {TRIGGER0_P[4]}]

set_property PACKAGE_PIN AT35 [get_ports {TRIGGER1_P[0]}]

######slot7 : adda
set_property PACKAGE_PIN AF15 [get_ports {TRIGGER0_P[5]}]

set_property PACKAGE_PIN AW33 [get_ports {TRIGGER1_P[1]}]

######slot9 : dac
set_property PACKAGE_PIN AR12 [get_ports {TRIGGER0_P[6]}]

set_property PACKAGE_PIN AV33 [get_ports {TRIGGER1_P[2]}]

######slot10 : dac
set_property PACKAGE_PIN AP14 [get_ports {TRIGGER0_P[7]}]

set_property PACKAGE_PIN AT34 [get_ports {TRIGGER1_P[3]}]

######slot11 : awg
set_property PACKAGE_PIN AH14 [get_ports {TRIGGER0_P[8]}]

######slot12 : awg
set_property PACKAGE_PIN AH13 [get_ports {TRIGGER0_P[9]}]

######slot13 : awg
set_property PACKAGE_PIN AK13 [get_ports {TRIGGER0_P[10]}]



set_property IOSTANDARD LVDS [get_ports {TRIGGER1_P[0]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER1_P[1]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER1_P[2]}]
set_property IOSTANDARD LVDS [get_ports {TRIGGER1_P[3]}]

set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[10]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[10]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[9]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[9]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[8]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[8]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[7]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[6]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[5]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[4]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[3]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[2]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[1]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_P[0]}]
set_property IOSTANDARD LVDS_25 [get_ports {TRIGGER0_N[0]}]



# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[10]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[9]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[8]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[7]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[6]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[5]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[4]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[3]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[2]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[1]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER0_P[0]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER1_P[3]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER1_P[2]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER1_P[1]}]
# set_property DIFF_TERM_ADV TERM_100 [get_ports {TRIGGER1_P[0]}]

set_false_path -from [get_pins trig_control_reg/C] -to [get_pins {obufds_trig1[*].trigger1_delay/delay_en_reg/D}]
set_false_path -from [get_pins trig_control_reg/C] -to [get_pins {obufds_trig0[*].trigger0_delay/delay_en_reg/D}]

#########debug
