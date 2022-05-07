

set_property OFFCHIP_TERM FP_VTT_50 [get_ports I2C_SCL]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports I2C_SDA]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SCLK]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SDATA]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SI5338_OCLK]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SI5338_SCL]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SI5338_SDA]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports SLEN]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[7]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[6]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[5]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[4]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[3]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[2]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[1]]
set_property OFFCHIP_TERM FP_VTT_50 [get_ports GPIO_LED[0]]
set_false_path -from [get_clocks -of_objects [get_pins clk_pll_inst/inst/mmcme3_adv_inst/CLKOUT0]] -to [get_clocks SMA_MGT_REF_CLK_P]
set_false_path -from [get_clocks -of_objects [get_pins U06_lybk_ddr/LYBK_DDR/ddr4_00/inst/u_ddr4_infrastructure/gen_mmcme3.u_mmcme_adv_inst/CLKOUT0]] -to [get_clocks SMA_MGT_REF_CLK_P]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list ddr_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {U06_lybk_ddr/ddr_final_length[0]} {U06_lybk_ddr/ddr_final_length[1]} {U06_lybk_ddr/ddr_final_length[2]} {U06_lybk_ddr/ddr_final_length[3]} {U06_lybk_ddr/ddr_final_length[4]} {U06_lybk_ddr/ddr_final_length[5]} {U06_lybk_ddr/ddr_final_length[6]} {U06_lybk_ddr/ddr_final_length[7]} {U06_lybk_ddr/ddr_final_length[8]} {U06_lybk_ddr/ddr_final_length[9]} {U06_lybk_ddr/ddr_final_length[10]} {U06_lybk_ddr/ddr_final_length[11]} {U06_lybk_ddr/ddr_final_length[12]} {U06_lybk_ddr/ddr_final_length[13]} {U06_lybk_ddr/ddr_final_length[14]} {U06_lybk_ddr/ddr_final_length[15]} {U06_lybk_ddr/ddr_final_length[16]} {U06_lybk_ddr/ddr_final_length[17]} {U06_lybk_ddr/ddr_final_length[18]} {U06_lybk_ddr/ddr_final_length[19]} {U06_lybk_ddr/ddr_final_length[20]} {U06_lybk_ddr/ddr_final_length[21]} {U06_lybk_ddr/ddr_final_length[22]} {U06_lybk_ddr/ddr_final_length[23]} {U06_lybk_ddr/ddr_final_length[24]} {U06_lybk_ddr/ddr_final_length[25]} {U06_lybk_ddr/ddr_final_length[26]} {U06_lybk_ddr/ddr_final_length[27]} {U06_lybk_ddr/ddr_final_length[28]} {U06_lybk_ddr/ddr_final_length[29]} {U06_lybk_ddr/ddr_final_length[30]} {U06_lybk_ddr/ddr_final_length[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {U06_lybk_ddr/final_data_length[0]} {U06_lybk_ddr/final_data_length[1]} {U06_lybk_ddr/final_data_length[2]} {U06_lybk_ddr/final_data_length[3]} {U06_lybk_ddr/final_data_length[4]} {U06_lybk_ddr/final_data_length[5]} {U06_lybk_ddr/final_data_length[6]} {U06_lybk_ddr/final_data_length[7]} {U06_lybk_ddr/final_data_length[8]} {U06_lybk_ddr/final_data_length[9]} {U06_lybk_ddr/final_data_length[10]} {U06_lybk_ddr/final_data_length[11]} {U06_lybk_ddr/final_data_length[12]} {U06_lybk_ddr/final_data_length[13]} {U06_lybk_ddr/final_data_length[14]} {U06_lybk_ddr/final_data_length[15]} {U06_lybk_ddr/final_data_length[16]} {U06_lybk_ddr/final_data_length[17]} {U06_lybk_ddr/final_data_length[18]} {U06_lybk_ddr/final_data_length[19]} {U06_lybk_ddr/final_data_length[20]} {U06_lybk_ddr/final_data_length[21]} {U06_lybk_ddr/final_data_length[22]} {U06_lybk_ddr/final_data_length[23]} {U06_lybk_ddr/final_data_length[24]} {U06_lybk_ddr/final_data_length[25]} {U06_lybk_ddr/final_data_length[26]} {U06_lybk_ddr/final_data_length[27]} {U06_lybk_ddr/final_data_length[28]} {U06_lybk_ddr/final_data_length[29]} {U06_lybk_ddr/final_data_length[30]} {U06_lybk_ddr/final_data_length[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 64 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {U06_lybk_ddr/aurora_data[0]} {U06_lybk_ddr/aurora_data[1]} {U06_lybk_ddr/aurora_data[2]} {U06_lybk_ddr/aurora_data[3]} {U06_lybk_ddr/aurora_data[4]} {U06_lybk_ddr/aurora_data[5]} {U06_lybk_ddr/aurora_data[6]} {U06_lybk_ddr/aurora_data[7]} {U06_lybk_ddr/aurora_data[8]} {U06_lybk_ddr/aurora_data[9]} {U06_lybk_ddr/aurora_data[10]} {U06_lybk_ddr/aurora_data[11]} {U06_lybk_ddr/aurora_data[12]} {U06_lybk_ddr/aurora_data[13]} {U06_lybk_ddr/aurora_data[14]} {U06_lybk_ddr/aurora_data[15]} {U06_lybk_ddr/aurora_data[16]} {U06_lybk_ddr/aurora_data[17]} {U06_lybk_ddr/aurora_data[18]} {U06_lybk_ddr/aurora_data[19]} {U06_lybk_ddr/aurora_data[20]} {U06_lybk_ddr/aurora_data[21]} {U06_lybk_ddr/aurora_data[22]} {U06_lybk_ddr/aurora_data[23]} {U06_lybk_ddr/aurora_data[24]} {U06_lybk_ddr/aurora_data[25]} {U06_lybk_ddr/aurora_data[26]} {U06_lybk_ddr/aurora_data[27]} {U06_lybk_ddr/aurora_data[28]} {U06_lybk_ddr/aurora_data[29]} {U06_lybk_ddr/aurora_data[30]} {U06_lybk_ddr/aurora_data[31]} {U06_lybk_ddr/aurora_data[32]} {U06_lybk_ddr/aurora_data[33]} {U06_lybk_ddr/aurora_data[34]} {U06_lybk_ddr/aurora_data[35]} {U06_lybk_ddr/aurora_data[36]} {U06_lybk_ddr/aurora_data[37]} {U06_lybk_ddr/aurora_data[38]} {U06_lybk_ddr/aurora_data[39]} {U06_lybk_ddr/aurora_data[40]} {U06_lybk_ddr/aurora_data[41]} {U06_lybk_ddr/aurora_data[42]} {U06_lybk_ddr/aurora_data[43]} {U06_lybk_ddr/aurora_data[44]} {U06_lybk_ddr/aurora_data[45]} {U06_lybk_ddr/aurora_data[46]} {U06_lybk_ddr/aurora_data[47]} {U06_lybk_ddr/aurora_data[48]} {U06_lybk_ddr/aurora_data[49]} {U06_lybk_ddr/aurora_data[50]} {U06_lybk_ddr/aurora_data[51]} {U06_lybk_ddr/aurora_data[52]} {U06_lybk_ddr/aurora_data[53]} {U06_lybk_ddr/aurora_data[54]} {U06_lybk_ddr/aurora_data[55]} {U06_lybk_ddr/aurora_data[56]} {U06_lybk_ddr/aurora_data[57]} {U06_lybk_ddr/aurora_data[58]} {U06_lybk_ddr/aurora_data[59]} {U06_lybk_ddr/aurora_data[60]} {U06_lybk_ddr/aurora_data[61]} {U06_lybk_ddr/aurora_data[62]} {U06_lybk_ddr/aurora_data[63]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 4 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {U06_lybk_ddr/remain[0]} {U06_lybk_ddr/remain[1]} {U06_lybk_ddr/remain[2]} {U06_lybk_ddr/remain[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 4 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {U06_lybk_ddr/state[0]} {U06_lybk_ddr/state[1]} {U06_lybk_ddr/state[2]} {U06_lybk_ddr/state[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 32 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {U06_lybk_ddr/passback_data_length_debug[0]} {U06_lybk_ddr/passback_data_length_debug[1]} {U06_lybk_ddr/passback_data_length_debug[2]} {U06_lybk_ddr/passback_data_length_debug[3]} {U06_lybk_ddr/passback_data_length_debug[4]} {U06_lybk_ddr/passback_data_length_debug[5]} {U06_lybk_ddr/passback_data_length_debug[6]} {U06_lybk_ddr/passback_data_length_debug[7]} {U06_lybk_ddr/passback_data_length_debug[8]} {U06_lybk_ddr/passback_data_length_debug[9]} {U06_lybk_ddr/passback_data_length_debug[10]} {U06_lybk_ddr/passback_data_length_debug[11]} {U06_lybk_ddr/passback_data_length_debug[12]} {U06_lybk_ddr/passback_data_length_debug[13]} {U06_lybk_ddr/passback_data_length_debug[14]} {U06_lybk_ddr/passback_data_length_debug[15]} {U06_lybk_ddr/passback_data_length_debug[16]} {U06_lybk_ddr/passback_data_length_debug[17]} {U06_lybk_ddr/passback_data_length_debug[18]} {U06_lybk_ddr/passback_data_length_debug[19]} {U06_lybk_ddr/passback_data_length_debug[20]} {U06_lybk_ddr/passback_data_length_debug[21]} {U06_lybk_ddr/passback_data_length_debug[22]} {U06_lybk_ddr/passback_data_length_debug[23]} {U06_lybk_ddr/passback_data_length_debug[24]} {U06_lybk_ddr/passback_data_length_debug[25]} {U06_lybk_ddr/passback_data_length_debug[26]} {U06_lybk_ddr/passback_data_length_debug[27]} {U06_lybk_ddr/passback_data_length_debug[28]} {U06_lybk_ddr/passback_data_length_debug[29]} {U06_lybk_ddr/passback_data_length_debug[30]} {U06_lybk_ddr/passback_data_length_debug[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 32 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {U06_lybk_ddr/pdl_ddr_r[0]} {U06_lybk_ddr/pdl_ddr_r[1]} {U06_lybk_ddr/pdl_ddr_r[2]} {U06_lybk_ddr/pdl_ddr_r[3]} {U06_lybk_ddr/pdl_ddr_r[4]} {U06_lybk_ddr/pdl_ddr_r[5]} {U06_lybk_ddr/pdl_ddr_r[6]} {U06_lybk_ddr/pdl_ddr_r[7]} {U06_lybk_ddr/pdl_ddr_r[8]} {U06_lybk_ddr/pdl_ddr_r[9]} {U06_lybk_ddr/pdl_ddr_r[10]} {U06_lybk_ddr/pdl_ddr_r[11]} {U06_lybk_ddr/pdl_ddr_r[12]} {U06_lybk_ddr/pdl_ddr_r[13]} {U06_lybk_ddr/pdl_ddr_r[14]} {U06_lybk_ddr/pdl_ddr_r[15]} {U06_lybk_ddr/pdl_ddr_r[16]} {U06_lybk_ddr/pdl_ddr_r[17]} {U06_lybk_ddr/pdl_ddr_r[18]} {U06_lybk_ddr/pdl_ddr_r[19]} {U06_lybk_ddr/pdl_ddr_r[20]} {U06_lybk_ddr/pdl_ddr_r[21]} {U06_lybk_ddr/pdl_ddr_r[22]} {U06_lybk_ddr/pdl_ddr_r[23]} {U06_lybk_ddr/pdl_ddr_r[24]} {U06_lybk_ddr/pdl_ddr_r[25]} {U06_lybk_ddr/pdl_ddr_r[26]} {U06_lybk_ddr/pdl_ddr_r[27]} {U06_lybk_ddr/pdl_ddr_r[28]} {U06_lybk_ddr/pdl_ddr_r[29]} {U06_lybk_ddr/pdl_ddr_r[30]} {U06_lybk_ddr/pdl_ddr_r[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 32 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {U06_lybk_ddr/receive_passback_cnt[0]} {U06_lybk_ddr/receive_passback_cnt[1]} {U06_lybk_ddr/receive_passback_cnt[2]} {U06_lybk_ddr/receive_passback_cnt[3]} {U06_lybk_ddr/receive_passback_cnt[4]} {U06_lybk_ddr/receive_passback_cnt[5]} {U06_lybk_ddr/receive_passback_cnt[6]} {U06_lybk_ddr/receive_passback_cnt[7]} {U06_lybk_ddr/receive_passback_cnt[8]} {U06_lybk_ddr/receive_passback_cnt[9]} {U06_lybk_ddr/receive_passback_cnt[10]} {U06_lybk_ddr/receive_passback_cnt[11]} {U06_lybk_ddr/receive_passback_cnt[12]} {U06_lybk_ddr/receive_passback_cnt[13]} {U06_lybk_ddr/receive_passback_cnt[14]} {U06_lybk_ddr/receive_passback_cnt[15]} {U06_lybk_ddr/receive_passback_cnt[16]} {U06_lybk_ddr/receive_passback_cnt[17]} {U06_lybk_ddr/receive_passback_cnt[18]} {U06_lybk_ddr/receive_passback_cnt[19]} {U06_lybk_ddr/receive_passback_cnt[20]} {U06_lybk_ddr/receive_passback_cnt[21]} {U06_lybk_ddr/receive_passback_cnt[22]} {U06_lybk_ddr/receive_passback_cnt[23]} {U06_lybk_ddr/receive_passback_cnt[24]} {U06_lybk_ddr/receive_passback_cnt[25]} {U06_lybk_ddr/receive_passback_cnt[26]} {U06_lybk_ddr/receive_passback_cnt[27]} {U06_lybk_ddr/receive_passback_cnt[28]} {U06_lybk_ddr/receive_passback_cnt[29]} {U06_lybk_ddr/receive_passback_cnt[30]} {U06_lybk_ddr/receive_passback_cnt[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list U06_lybk_ddr/aurora_data_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list U06_lybk_ddr/empty]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list U06_lybk_ddr/full]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list U06_lybk_ddr/full_0]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 1 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list U06_lybk_ddr/sys_rst_tru]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 1 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list U06_lybk_ddr/trans_finish]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 1 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list U06_lybk_ddr/wr_start]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 1 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list U06_lybk_ddr/passback_data_length_valid]]
create_debug_core u_ila_1 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_1]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_1]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_1]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_1]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_1]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_1]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_1]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_1]
set_property port_width 1 [get_debug_ports u_ila_1/clk]
connect_debug_port u_ila_1/clk [get_nets [list clk_7044_100m]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe0]
set_property port_width 8 [get_debug_ports u_ila_1/probe0]
connect_debug_port u_ila_1/probe0 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/Rdy_id[0]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[1]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[2]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[3]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[4]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[5]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[6]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe1]
set_property port_width 8 [get_debug_ports u_ila_1/probe1]
connect_debug_port u_ila_1/probe1 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/delay_data[0]} {U02_lybk_calib/RouterSychTop_inst/delay_data[1]} {U02_lybk_calib/RouterSychTop_inst/delay_data[2]} {U02_lybk_calib/RouterSychTop_inst/delay_data[3]} {U02_lybk_calib/RouterSychTop_inst/delay_data[4]} {U02_lybk_calib/RouterSychTop_inst/delay_data[5]} {U02_lybk_calib/RouterSychTop_inst/delay_data[6]} {U02_lybk_calib/RouterSychTop_inst/delay_data[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe2]
set_property port_width 8 [get_debug_ports u_ila_1/probe2]
connect_debug_port u_ila_1/probe2 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/ready_id[0]} {U02_lybk_calib/RouterSychTop_inst/ready_id[1]} {U02_lybk_calib/RouterSychTop_inst/ready_id[2]} {U02_lybk_calib/RouterSychTop_inst/ready_id[3]} {U02_lybk_calib/RouterSychTop_inst/ready_id[4]} {U02_lybk_calib/RouterSychTop_inst/ready_id[5]} {U02_lybk_calib/RouterSychTop_inst/ready_id[6]} {U02_lybk_calib/RouterSychTop_inst/ready_id[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe3]
set_property port_width 4 [get_debug_ports u_ila_1/probe3]
connect_debug_port u_ila_1/probe3 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/state_debug[0]} {U02_lybk_calib/RouterSychTop_inst/state_debug[1]} {U02_lybk_calib/RouterSychTop_inst/state_debug[2]} {U02_lybk_calib/RouterSychTop_inst/state_debug[3]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe4]
set_property port_width 8 [get_debug_ports u_ila_1/probe4]
connect_debug_port u_ila_1/probe4 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/trig_task_id[0]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[1]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[2]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[3]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[4]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[5]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[6]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe5]
set_property port_width 16 [get_debug_ports u_ila_1/probe5]
connect_debug_port u_ila_1/probe5 [get_nets [list {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[0]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[1]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[2]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[3]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[4]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[5]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[6]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[7]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[8]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[9]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[10]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[11]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[12]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[13]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[14]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_delay[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe6]
set_property port_width 16 [get_debug_ports u_ila_1/probe6]
connect_debug_port u_ila_1/probe6 [get_nets [list {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[0]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[1]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[2]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[3]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[4]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[5]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[6]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[7]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[8]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[9]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[10]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[11]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[12]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[13]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[14]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/s_circle_times[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe7]
set_property port_width 16 [get_debug_ports u_ila_1/probe7]
connect_debug_port u_ila_1/probe7 [get_nets [list {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[0]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[1]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[2]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[3]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[4]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[5]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[6]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[7]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[8]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[9]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[10]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[11]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[12]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[13]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[14]} {U03_lybk_function/lybk_trigger_inst/lybk_trigger_trans_inst/READY_STATE[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe8]
set_property port_width 8 [get_debug_ports u_ila_1/probe8]
connect_debug_port u_ila_1/probe8 [get_nets [list {U03_lybk_function/order_type[0]} {U03_lybk_function/order_type[1]} {U03_lybk_function/order_type[2]} {U03_lybk_function/order_type[3]} {U03_lybk_function/order_type[4]} {U03_lybk_function/order_type[5]} {U03_lybk_function/order_type[6]} {U03_lybk_function/order_type[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe9]
set_property port_width 64 [get_debug_ports u_ila_1/probe9]
connect_debug_port u_ila_1/probe9 [get_nets [list {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[0]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[1]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[2]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[3]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[4]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[5]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[6]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[7]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[8]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[9]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[10]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[11]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[12]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[13]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[14]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[15]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[16]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[17]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[18]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[19]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[20]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[21]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[22]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[23]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[24]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[25]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[26]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[27]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[28]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[29]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[30]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[31]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[32]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[33]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[34]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[35]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[36]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[37]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[38]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[39]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[40]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[41]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[42]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[43]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[44]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[45]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[46]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[47]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[48]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[49]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[50]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[51]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[52]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[53]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[54]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[55]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[56]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[57]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[58]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[59]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[60]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[61]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[62]} {U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXD[63]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe10]
set_property port_width 16 [get_debug_ports u_ila_1/probe10]
connect_debug_port u_ila_1/probe10 [get_nets [list {U03_lybk_function/FPGA_RESET_FINISH[0]} {U03_lybk_function/FPGA_RESET_FINISH[1]} {U03_lybk_function/FPGA_RESET_FINISH[2]} {U03_lybk_function/FPGA_RESET_FINISH[3]} {U03_lybk_function/FPGA_RESET_FINISH[4]} {U03_lybk_function/FPGA_RESET_FINISH[5]} {U03_lybk_function/FPGA_RESET_FINISH[6]} {U03_lybk_function/FPGA_RESET_FINISH[7]} {U03_lybk_function/FPGA_RESET_FINISH[8]} {U03_lybk_function/FPGA_RESET_FINISH[9]} {U03_lybk_function/FPGA_RESET_FINISH[10]} {U03_lybk_function/FPGA_RESET_FINISH[11]} {U03_lybk_function/FPGA_RESET_FINISH[12]} {U03_lybk_function/FPGA_RESET_FINISH[13]} {U03_lybk_function/FPGA_RESET_FINISH[14]} {U03_lybk_function/FPGA_RESET_FINISH[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe11]
set_property port_width 16 [get_debug_ports u_ila_1/probe11]
connect_debug_port u_ila_1/probe11 [get_nets [list {U03_lybk_function/FPGA_READY[0]} {U03_lybk_function/FPGA_READY[1]} {U03_lybk_function/FPGA_READY[2]} {U03_lybk_function/FPGA_READY[3]} {U03_lybk_function/FPGA_READY[4]} {U03_lybk_function/FPGA_READY[5]} {U03_lybk_function/FPGA_READY[6]} {U03_lybk_function/FPGA_READY[7]} {U03_lybk_function/FPGA_READY[8]} {U03_lybk_function/FPGA_READY[9]} {U03_lybk_function/FPGA_READY[10]} {U03_lybk_function/FPGA_READY[11]} {U03_lybk_function/FPGA_READY[12]} {U03_lybk_function/FPGA_READY[13]} {U03_lybk_function/FPGA_READY[14]} {U03_lybk_function/FPGA_READY[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe12]
set_property port_width 16 [get_debug_ports u_ila_1/probe12]
connect_debug_port u_ila_1/probe12 [get_nets [list {U03_lybk_function/FPGA_SYS_RST[0]} {U03_lybk_function/FPGA_SYS_RST[1]} {U03_lybk_function/FPGA_SYS_RST[2]} {U03_lybk_function/FPGA_SYS_RST[3]} {U03_lybk_function/FPGA_SYS_RST[4]} {U03_lybk_function/FPGA_SYS_RST[5]} {U03_lybk_function/FPGA_SYS_RST[6]} {U03_lybk_function/FPGA_SYS_RST[7]} {U03_lybk_function/FPGA_SYS_RST[8]} {U03_lybk_function/FPGA_SYS_RST[9]} {U03_lybk_function/FPGA_SYS_RST[10]} {U03_lybk_function/FPGA_SYS_RST[11]} {U03_lybk_function/FPGA_SYS_RST[12]} {U03_lybk_function/FPGA_SYS_RST[13]} {U03_lybk_function/FPGA_SYS_RST[14]} {U03_lybk_function/FPGA_SYS_RST[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe13]
set_property port_width 8 [get_debug_ports u_ila_1/probe13]
connect_debug_port u_ila_1/probe13 [get_nets [list {U03_lybk_function/TO_ZKBK_TASK_ID[0]} {U03_lybk_function/TO_ZKBK_TASK_ID[1]} {U03_lybk_function/TO_ZKBK_TASK_ID[2]} {U03_lybk_function/TO_ZKBK_TASK_ID[3]} {U03_lybk_function/TO_ZKBK_TASK_ID[4]} {U03_lybk_function/TO_ZKBK_TASK_ID[5]} {U03_lybk_function/TO_ZKBK_TASK_ID[6]} {U03_lybk_function/TO_ZKBK_TASK_ID[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe14]
set_property port_width 16 [get_debug_ports u_ila_1/probe14]
connect_debug_port u_ila_1/probe14 [get_nets [list {U03_lybk_function/TRIGGER_OUT[0]} {U03_lybk_function/TRIGGER_OUT[1]} {U03_lybk_function/TRIGGER_OUT[2]} {U03_lybk_function/TRIGGER_OUT[3]} {U03_lybk_function/TRIGGER_OUT[4]} {U03_lybk_function/TRIGGER_OUT[5]} {U03_lybk_function/TRIGGER_OUT[6]} {U03_lybk_function/TRIGGER_OUT[7]} {U03_lybk_function/TRIGGER_OUT[8]} {U03_lybk_function/TRIGGER_OUT[9]} {U03_lybk_function/TRIGGER_OUT[10]} {U03_lybk_function/TRIGGER_OUT[11]} {U03_lybk_function/TRIGGER_OUT[12]} {U03_lybk_function/TRIGGER_OUT[13]} {U03_lybk_function/TRIGGER_OUT[14]} {U03_lybk_function/TRIGGER_OUT[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe15]
set_property port_width 8 [get_debug_ports u_ila_1/probe15]
connect_debug_port u_ila_1/probe15 [get_nets [list {U03_lybk_function/ZKBK_TASK_ID[0]} {U03_lybk_function/ZKBK_TASK_ID[1]} {U03_lybk_function/ZKBK_TASK_ID[2]} {U03_lybk_function/ZKBK_TASK_ID[3]} {U03_lybk_function/ZKBK_TASK_ID[4]} {U03_lybk_function/ZKBK_TASK_ID[5]} {U03_lybk_function/ZKBK_TASK_ID[6]} {U03_lybk_function/ZKBK_TASK_ID[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe16]
set_property port_width 8 [get_debug_ports u_ila_1/probe16]
connect_debug_port u_ila_1/probe16 [get_nets [list {U03_lybk_function/b_circle_amount[0]} {U03_lybk_function/b_circle_amount[1]} {U03_lybk_function/b_circle_amount[2]} {U03_lybk_function/b_circle_amount[3]} {U03_lybk_function/b_circle_amount[4]} {U03_lybk_function/b_circle_amount[5]} {U03_lybk_function/b_circle_amount[6]} {U03_lybk_function/b_circle_amount[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe17]
set_property port_width 16 [get_debug_ports u_ila_1/probe17]
connect_debug_port u_ila_1/probe17 [get_nets [list {U03_lybk_function/fpga_id[0]} {U03_lybk_function/fpga_id[1]} {U03_lybk_function/fpga_id[2]} {U03_lybk_function/fpga_id[3]} {U03_lybk_function/fpga_id[4]} {U03_lybk_function/fpga_id[5]} {U03_lybk_function/fpga_id[6]} {U03_lybk_function/fpga_id[7]} {U03_lybk_function/fpga_id[8]} {U03_lybk_function/fpga_id[9]} {U03_lybk_function/fpga_id[10]} {U03_lybk_function/fpga_id[11]} {U03_lybk_function/fpga_id[12]} {U03_lybk_function/fpga_id[13]} {U03_lybk_function/fpga_id[14]} {U03_lybk_function/fpga_id[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe18]
set_property port_width 32 [get_debug_ports u_ila_1/probe18]
connect_debug_port u_ila_1/probe18 [get_nets [list {U03_lybk_function/PASSBACK_LENGTH[0]} {U03_lybk_function/PASSBACK_LENGTH[1]} {U03_lybk_function/PASSBACK_LENGTH[2]} {U03_lybk_function/PASSBACK_LENGTH[3]} {U03_lybk_function/PASSBACK_LENGTH[4]} {U03_lybk_function/PASSBACK_LENGTH[5]} {U03_lybk_function/PASSBACK_LENGTH[6]} {U03_lybk_function/PASSBACK_LENGTH[7]} {U03_lybk_function/PASSBACK_LENGTH[8]} {U03_lybk_function/PASSBACK_LENGTH[9]} {U03_lybk_function/PASSBACK_LENGTH[10]} {U03_lybk_function/PASSBACK_LENGTH[11]} {U03_lybk_function/PASSBACK_LENGTH[12]} {U03_lybk_function/PASSBACK_LENGTH[13]} {U03_lybk_function/PASSBACK_LENGTH[14]} {U03_lybk_function/PASSBACK_LENGTH[15]} {U03_lybk_function/PASSBACK_LENGTH[16]} {U03_lybk_function/PASSBACK_LENGTH[17]} {U03_lybk_function/PASSBACK_LENGTH[18]} {U03_lybk_function/PASSBACK_LENGTH[19]} {U03_lybk_function/PASSBACK_LENGTH[20]} {U03_lybk_function/PASSBACK_LENGTH[21]} {U03_lybk_function/PASSBACK_LENGTH[22]} {U03_lybk_function/PASSBACK_LENGTH[23]} {U03_lybk_function/PASSBACK_LENGTH[24]} {U03_lybk_function/PASSBACK_LENGTH[25]} {U03_lybk_function/PASSBACK_LENGTH[26]} {U03_lybk_function/PASSBACK_LENGTH[27]} {U03_lybk_function/PASSBACK_LENGTH[28]} {U03_lybk_function/PASSBACK_LENGTH[29]} {U03_lybk_function/PASSBACK_LENGTH[30]} {U03_lybk_function/PASSBACK_LENGTH[31]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe19]
set_property port_width 4 [get_debug_ports u_ila_1/probe19]
connect_debug_port u_ila_1/probe19 [get_nets [list {U03_lybk_function/lybk_xgmii_unpack_inst/cur_state[0]} {U03_lybk_function/lybk_xgmii_unpack_inst/cur_state[1]} {U03_lybk_function/lybk_xgmii_unpack_inst/cur_state[2]} {U03_lybk_function/lybk_xgmii_unpack_inst/cur_state[3]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe20]
set_property port_width 64 [get_debug_ports u_ila_1/probe20]
connect_debug_port u_ila_1/probe20 [get_nets [list {U03_lybk_function/lybk_datapkg[0]} {U03_lybk_function/lybk_datapkg[1]} {U03_lybk_function/lybk_datapkg[2]} {U03_lybk_function/lybk_datapkg[3]} {U03_lybk_function/lybk_datapkg[4]} {U03_lybk_function/lybk_datapkg[5]} {U03_lybk_function/lybk_datapkg[6]} {U03_lybk_function/lybk_datapkg[7]} {U03_lybk_function/lybk_datapkg[8]} {U03_lybk_function/lybk_datapkg[9]} {U03_lybk_function/lybk_datapkg[10]} {U03_lybk_function/lybk_datapkg[11]} {U03_lybk_function/lybk_datapkg[12]} {U03_lybk_function/lybk_datapkg[13]} {U03_lybk_function/lybk_datapkg[14]} {U03_lybk_function/lybk_datapkg[15]} {U03_lybk_function/lybk_datapkg[16]} {U03_lybk_function/lybk_datapkg[17]} {U03_lybk_function/lybk_datapkg[18]} {U03_lybk_function/lybk_datapkg[19]} {U03_lybk_function/lybk_datapkg[20]} {U03_lybk_function/lybk_datapkg[21]} {U03_lybk_function/lybk_datapkg[22]} {U03_lybk_function/lybk_datapkg[23]} {U03_lybk_function/lybk_datapkg[24]} {U03_lybk_function/lybk_datapkg[25]} {U03_lybk_function/lybk_datapkg[26]} {U03_lybk_function/lybk_datapkg[27]} {U03_lybk_function/lybk_datapkg[28]} {U03_lybk_function/lybk_datapkg[29]} {U03_lybk_function/lybk_datapkg[30]} {U03_lybk_function/lybk_datapkg[31]} {U03_lybk_function/lybk_datapkg[32]} {U03_lybk_function/lybk_datapkg[33]} {U03_lybk_function/lybk_datapkg[34]} {U03_lybk_function/lybk_datapkg[35]} {U03_lybk_function/lybk_datapkg[36]} {U03_lybk_function/lybk_datapkg[37]} {U03_lybk_function/lybk_datapkg[38]} {U03_lybk_function/lybk_datapkg[39]} {U03_lybk_function/lybk_datapkg[40]} {U03_lybk_function/lybk_datapkg[41]} {U03_lybk_function/lybk_datapkg[42]} {U03_lybk_function/lybk_datapkg[43]} {U03_lybk_function/lybk_datapkg[44]} {U03_lybk_function/lybk_datapkg[45]} {U03_lybk_function/lybk_datapkg[46]} {U03_lybk_function/lybk_datapkg[47]} {U03_lybk_function/lybk_datapkg[48]} {U03_lybk_function/lybk_datapkg[49]} {U03_lybk_function/lybk_datapkg[50]} {U03_lybk_function/lybk_datapkg[51]} {U03_lybk_function/lybk_datapkg[52]} {U03_lybk_function/lybk_datapkg[53]} {U03_lybk_function/lybk_datapkg[54]} {U03_lybk_function/lybk_datapkg[55]} {U03_lybk_function/lybk_datapkg[56]} {U03_lybk_function/lybk_datapkg[57]} {U03_lybk_function/lybk_datapkg[58]} {U03_lybk_function/lybk_datapkg[59]} {U03_lybk_function/lybk_datapkg[60]} {U03_lybk_function/lybk_datapkg[61]} {U03_lybk_function/lybk_datapkg[62]} {U03_lybk_function/lybk_datapkg[63]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe21]
set_property port_width 16 [get_debug_ports u_ila_1/probe21]
connect_debug_port u_ila_1/probe21 [get_nets [list {U03_lybk_function/ready_state[0]} {U03_lybk_function/ready_state[1]} {U03_lybk_function/ready_state[2]} {U03_lybk_function/ready_state[3]} {U03_lybk_function/ready_state[4]} {U03_lybk_function/ready_state[5]} {U03_lybk_function/ready_state[6]} {U03_lybk_function/ready_state[7]} {U03_lybk_function/ready_state[8]} {U03_lybk_function/ready_state[9]} {U03_lybk_function/ready_state[10]} {U03_lybk_function/ready_state[11]} {U03_lybk_function/ready_state[12]} {U03_lybk_function/ready_state[13]} {U03_lybk_function/ready_state[14]} {U03_lybk_function/ready_state[15]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe22]
set_property port_width 8 [get_debug_ports u_ila_1/probe22]
connect_debug_port u_ila_1/probe22 [get_nets [list {U03_lybk_function/task_id[0]} {U03_lybk_function/task_id[1]} {U03_lybk_function/task_id[2]} {U03_lybk_function/task_id[3]} {U03_lybk_function/task_id[4]} {U03_lybk_function/task_id[5]} {U03_lybk_function/task_id[6]} {U03_lybk_function/task_id[7]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe23]
set_property port_width 64 [get_debug_ports u_ila_1/probe23]
connect_debug_port u_ila_1/probe23 [get_nets [list {U03_lybk_function/state_passback_data[0]} {U03_lybk_function/state_passback_data[1]} {U03_lybk_function/state_passback_data[2]} {U03_lybk_function/state_passback_data[3]} {U03_lybk_function/state_passback_data[4]} {U03_lybk_function/state_passback_data[5]} {U03_lybk_function/state_passback_data[6]} {U03_lybk_function/state_passback_data[7]} {U03_lybk_function/state_passback_data[8]} {U03_lybk_function/state_passback_data[9]} {U03_lybk_function/state_passback_data[10]} {U03_lybk_function/state_passback_data[11]} {U03_lybk_function/state_passback_data[12]} {U03_lybk_function/state_passback_data[13]} {U03_lybk_function/state_passback_data[14]} {U03_lybk_function/state_passback_data[15]} {U03_lybk_function/state_passback_data[16]} {U03_lybk_function/state_passback_data[17]} {U03_lybk_function/state_passback_data[18]} {U03_lybk_function/state_passback_data[19]} {U03_lybk_function/state_passback_data[20]} {U03_lybk_function/state_passback_data[21]} {U03_lybk_function/state_passback_data[22]} {U03_lybk_function/state_passback_data[23]} {U03_lybk_function/state_passback_data[24]} {U03_lybk_function/state_passback_data[25]} {U03_lybk_function/state_passback_data[26]} {U03_lybk_function/state_passback_data[27]} {U03_lybk_function/state_passback_data[28]} {U03_lybk_function/state_passback_data[29]} {U03_lybk_function/state_passback_data[30]} {U03_lybk_function/state_passback_data[31]} {U03_lybk_function/state_passback_data[32]} {U03_lybk_function/state_passback_data[33]} {U03_lybk_function/state_passback_data[34]} {U03_lybk_function/state_passback_data[35]} {U03_lybk_function/state_passback_data[36]} {U03_lybk_function/state_passback_data[37]} {U03_lybk_function/state_passback_data[38]} {U03_lybk_function/state_passback_data[39]} {U03_lybk_function/state_passback_data[40]} {U03_lybk_function/state_passback_data[41]} {U03_lybk_function/state_passback_data[42]} {U03_lybk_function/state_passback_data[43]} {U03_lybk_function/state_passback_data[44]} {U03_lybk_function/state_passback_data[45]} {U03_lybk_function/state_passback_data[46]} {U03_lybk_function/state_passback_data[47]} {U03_lybk_function/state_passback_data[48]} {U03_lybk_function/state_passback_data[49]} {U03_lybk_function/state_passback_data[50]} {U03_lybk_function/state_passback_data[51]} {U03_lybk_function/state_passback_data[52]} {U03_lybk_function/state_passback_data[53]} {U03_lybk_function/state_passback_data[54]} {U03_lybk_function/state_passback_data[55]} {U03_lybk_function/state_passback_data[56]} {U03_lybk_function/state_passback_data[57]} {U03_lybk_function/state_passback_data[58]} {U03_lybk_function/state_passback_data[59]} {U03_lybk_function/state_passback_data[60]} {U03_lybk_function/state_passback_data[61]} {U03_lybk_function/state_passback_data[62]} {U03_lybk_function/state_passback_data[63]}]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe24]
set_property port_width 1 [get_debug_ports u_ila_1/probe24]
connect_debug_port u_ila_1/probe24 [get_nets [list U03_lybk_function/lybk_trigger_inst/lybk_trigger_create_inst/IDLE]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe25]
set_property port_width 1 [get_debug_ports u_ila_1/probe25]
connect_debug_port u_ila_1/probe25 [get_nets [list U03_lybk_function/lybk_datapkg_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe26]
set_property port_width 1 [get_debug_ports u_ila_1/probe26]
connect_debug_port u_ila_1/probe26 [get_nets [list U03_lybk_function/order_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe27]
set_property port_width 1 [get_debug_ports u_ila_1/probe27]
connect_debug_port u_ila_1/probe27 [get_nets [list U02_lybk_calib/RouterSychTop_inst/Rdy_id_vald]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe28]
set_property port_width 1 [get_debug_ports u_ila_1/probe28]
connect_debug_port u_ila_1/probe28 [get_nets [list U02_lybk_calib/RouterSychTop_inst/ready_id_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe29]
set_property port_width 1 [get_debug_ports u_ila_1/probe29]
connect_debug_port u_ila_1/probe29 [get_nets [list U03_lybk_function/reset_done]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe30]
set_property port_width 1 [get_debug_ports u_ila_1/probe30]
connect_debug_port u_ila_1/probe30 [get_nets [list U03_lybk_function/state_passback_dv]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe31]
set_property port_width 1 [get_debug_ports u_ila_1/probe31]
connect_debug_port u_ila_1/probe31 [get_nets [list U02_lybk_calib/RouterSychTop_inst/sync]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe32]
set_property port_width 1 [get_debug_ports u_ila_1/probe32]
connect_debug_port u_ila_1/probe32 [get_nets [list U03_lybk_function/sys_rst_n]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe33]
set_property port_width 1 [get_debug_ports u_ila_1/probe33]
connect_debug_port u_ila_1/probe33 [get_nets [list U03_lybk_function/thread_reset_en]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe34]
set_property port_width 1 [get_debug_ports u_ila_1/probe34]
connect_debug_port u_ila_1/probe34 [get_nets [list U03_lybk_function/TO_ZKBK_READY]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe35]
set_property port_width 1 [get_debug_ports u_ila_1/probe35]
connect_debug_port u_ila_1/probe35 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_pulse]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe36]
set_property port_width 1 [get_debug_ports u_ila_1/probe36]
connect_debug_port u_ila_1/probe36 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_task_valid]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe37]
set_property port_width 1 [get_debug_ports u_ila_1/probe37]
connect_debug_port u_ila_1/probe37 [get_nets [list U03_lybk_function/trigger_rst_n]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe38]
set_property port_width 1 [get_debug_ports u_ila_1/probe38]
connect_debug_port u_ila_1/probe38 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trigin]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe39]
set_property port_width 1 [get_debug_ports u_ila_1/probe39]
connect_debug_port u_ila_1/probe39 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trigout]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe40]
set_property port_width 1 [get_debug_ports u_ila_1/probe40]
connect_debug_port u_ila_1/probe40 [get_nets [list U03_lybk_function/lybk_xgmii_unpack_inst/XGMII_RXDV]]
create_debug_port u_ila_1 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_1/probe41]
set_property port_width 1 [get_debug_ports u_ila_1/probe41]
connect_debug_port u_ila_1/probe41 [get_nets [list U03_lybk_function/ZKBK_TRIGGER]]
create_debug_core u_ila_2 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_2]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_2]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_2]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_2]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_2]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_2]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_2]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_2]
set_property port_width 1 [get_debug_ports u_ila_2/clk]
connect_debug_port u_ila_2/clk [get_nets [list xgmii_clk]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe0]
set_property port_width 64 [get_debug_ports u_ila_2/probe0]
connect_debug_port u_ila_2/probe0 [get_nets [list {U06_lybk_ddr/DDR_RD_DATA[0]} {U06_lybk_ddr/DDR_RD_DATA[1]} {U06_lybk_ddr/DDR_RD_DATA[2]} {U06_lybk_ddr/DDR_RD_DATA[3]} {U06_lybk_ddr/DDR_RD_DATA[4]} {U06_lybk_ddr/DDR_RD_DATA[5]} {U06_lybk_ddr/DDR_RD_DATA[6]} {U06_lybk_ddr/DDR_RD_DATA[7]} {U06_lybk_ddr/DDR_RD_DATA[8]} {U06_lybk_ddr/DDR_RD_DATA[9]} {U06_lybk_ddr/DDR_RD_DATA[10]} {U06_lybk_ddr/DDR_RD_DATA[11]} {U06_lybk_ddr/DDR_RD_DATA[12]} {U06_lybk_ddr/DDR_RD_DATA[13]} {U06_lybk_ddr/DDR_RD_DATA[14]} {U06_lybk_ddr/DDR_RD_DATA[15]} {U06_lybk_ddr/DDR_RD_DATA[16]} {U06_lybk_ddr/DDR_RD_DATA[17]} {U06_lybk_ddr/DDR_RD_DATA[18]} {U06_lybk_ddr/DDR_RD_DATA[19]} {U06_lybk_ddr/DDR_RD_DATA[20]} {U06_lybk_ddr/DDR_RD_DATA[21]} {U06_lybk_ddr/DDR_RD_DATA[22]} {U06_lybk_ddr/DDR_RD_DATA[23]} {U06_lybk_ddr/DDR_RD_DATA[24]} {U06_lybk_ddr/DDR_RD_DATA[25]} {U06_lybk_ddr/DDR_RD_DATA[26]} {U06_lybk_ddr/DDR_RD_DATA[27]} {U06_lybk_ddr/DDR_RD_DATA[28]} {U06_lybk_ddr/DDR_RD_DATA[29]} {U06_lybk_ddr/DDR_RD_DATA[30]} {U06_lybk_ddr/DDR_RD_DATA[31]} {U06_lybk_ddr/DDR_RD_DATA[32]} {U06_lybk_ddr/DDR_RD_DATA[33]} {U06_lybk_ddr/DDR_RD_DATA[34]} {U06_lybk_ddr/DDR_RD_DATA[35]} {U06_lybk_ddr/DDR_RD_DATA[36]} {U06_lybk_ddr/DDR_RD_DATA[37]} {U06_lybk_ddr/DDR_RD_DATA[38]} {U06_lybk_ddr/DDR_RD_DATA[39]} {U06_lybk_ddr/DDR_RD_DATA[40]} {U06_lybk_ddr/DDR_RD_DATA[41]} {U06_lybk_ddr/DDR_RD_DATA[42]} {U06_lybk_ddr/DDR_RD_DATA[43]} {U06_lybk_ddr/DDR_RD_DATA[44]} {U06_lybk_ddr/DDR_RD_DATA[45]} {U06_lybk_ddr/DDR_RD_DATA[46]} {U06_lybk_ddr/DDR_RD_DATA[47]} {U06_lybk_ddr/DDR_RD_DATA[48]} {U06_lybk_ddr/DDR_RD_DATA[49]} {U06_lybk_ddr/DDR_RD_DATA[50]} {U06_lybk_ddr/DDR_RD_DATA[51]} {U06_lybk_ddr/DDR_RD_DATA[52]} {U06_lybk_ddr/DDR_RD_DATA[53]} {U06_lybk_ddr/DDR_RD_DATA[54]} {U06_lybk_ddr/DDR_RD_DATA[55]} {U06_lybk_ddr/DDR_RD_DATA[56]} {U06_lybk_ddr/DDR_RD_DATA[57]} {U06_lybk_ddr/DDR_RD_DATA[58]} {U06_lybk_ddr/DDR_RD_DATA[59]} {U06_lybk_ddr/DDR_RD_DATA[60]} {U06_lybk_ddr/DDR_RD_DATA[61]} {U06_lybk_ddr/DDR_RD_DATA[62]} {U06_lybk_ddr/DDR_RD_DATA[63]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe1]
set_property port_width 32 [get_debug_ports u_ila_2/probe1]
connect_debug_port u_ila_2/probe1 [get_nets [list {U06_lybk_ddr/pdl_xgmii_r[0]} {U06_lybk_ddr/pdl_xgmii_r[1]} {U06_lybk_ddr/pdl_xgmii_r[2]} {U06_lybk_ddr/pdl_xgmii_r[3]} {U06_lybk_ddr/pdl_xgmii_r[4]} {U06_lybk_ddr/pdl_xgmii_r[5]} {U06_lybk_ddr/pdl_xgmii_r[6]} {U06_lybk_ddr/pdl_xgmii_r[7]} {U06_lybk_ddr/pdl_xgmii_r[8]} {U06_lybk_ddr/pdl_xgmii_r[9]} {U06_lybk_ddr/pdl_xgmii_r[10]} {U06_lybk_ddr/pdl_xgmii_r[11]} {U06_lybk_ddr/pdl_xgmii_r[12]} {U06_lybk_ddr/pdl_xgmii_r[13]} {U06_lybk_ddr/pdl_xgmii_r[14]} {U06_lybk_ddr/pdl_xgmii_r[15]} {U06_lybk_ddr/pdl_xgmii_r[16]} {U06_lybk_ddr/pdl_xgmii_r[17]} {U06_lybk_ddr/pdl_xgmii_r[18]} {U06_lybk_ddr/pdl_xgmii_r[19]} {U06_lybk_ddr/pdl_xgmii_r[20]} {U06_lybk_ddr/pdl_xgmii_r[21]} {U06_lybk_ddr/pdl_xgmii_r[22]} {U06_lybk_ddr/pdl_xgmii_r[23]} {U06_lybk_ddr/pdl_xgmii_r[24]} {U06_lybk_ddr/pdl_xgmii_r[25]} {U06_lybk_ddr/pdl_xgmii_r[26]} {U06_lybk_ddr/pdl_xgmii_r[27]} {U06_lybk_ddr/pdl_xgmii_r[28]} {U06_lybk_ddr/pdl_xgmii_r[29]} {U06_lybk_ddr/pdl_xgmii_r[30]} {U06_lybk_ddr/pdl_xgmii_r[31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe2]
set_property port_width 32 [get_debug_ports u_ila_2/probe2]
connect_debug_port u_ila_2/probe2 [get_nets [list {U06_lybk_ddr/passback_cnt[0]} {U06_lybk_ddr/passback_cnt[1]} {U06_lybk_ddr/passback_cnt[2]} {U06_lybk_ddr/passback_cnt[3]} {U06_lybk_ddr/passback_cnt[4]} {U06_lybk_ddr/passback_cnt[5]} {U06_lybk_ddr/passback_cnt[6]} {U06_lybk_ddr/passback_cnt[7]} {U06_lybk_ddr/passback_cnt[8]} {U06_lybk_ddr/passback_cnt[9]} {U06_lybk_ddr/passback_cnt[10]} {U06_lybk_ddr/passback_cnt[11]} {U06_lybk_ddr/passback_cnt[12]} {U06_lybk_ddr/passback_cnt[13]} {U06_lybk_ddr/passback_cnt[14]} {U06_lybk_ddr/passback_cnt[15]} {U06_lybk_ddr/passback_cnt[16]} {U06_lybk_ddr/passback_cnt[17]} {U06_lybk_ddr/passback_cnt[18]} {U06_lybk_ddr/passback_cnt[19]} {U06_lybk_ddr/passback_cnt[20]} {U06_lybk_ddr/passback_cnt[21]} {U06_lybk_ddr/passback_cnt[22]} {U06_lybk_ddr/passback_cnt[23]} {U06_lybk_ddr/passback_cnt[24]} {U06_lybk_ddr/passback_cnt[25]} {U06_lybk_ddr/passback_cnt[26]} {U06_lybk_ddr/passback_cnt[27]} {U06_lybk_ddr/passback_cnt[28]} {U06_lybk_ddr/passback_cnt[29]} {U06_lybk_ddr/passback_cnt[30]} {U06_lybk_ddr/passback_cnt[31]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe3]
set_property port_width 64 [get_debug_ports u_ila_2/probe3]
connect_debug_port u_ila_2/probe3 [get_nets [list {xgmii_passback_data[0]} {xgmii_passback_data[1]} {xgmii_passback_data[2]} {xgmii_passback_data[3]} {xgmii_passback_data[4]} {xgmii_passback_data[5]} {xgmii_passback_data[6]} {xgmii_passback_data[7]} {xgmii_passback_data[8]} {xgmii_passback_data[9]} {xgmii_passback_data[10]} {xgmii_passback_data[11]} {xgmii_passback_data[12]} {xgmii_passback_data[13]} {xgmii_passback_data[14]} {xgmii_passback_data[15]} {xgmii_passback_data[16]} {xgmii_passback_data[17]} {xgmii_passback_data[18]} {xgmii_passback_data[19]} {xgmii_passback_data[20]} {xgmii_passback_data[21]} {xgmii_passback_data[22]} {xgmii_passback_data[23]} {xgmii_passback_data[24]} {xgmii_passback_data[25]} {xgmii_passback_data[26]} {xgmii_passback_data[27]} {xgmii_passback_data[28]} {xgmii_passback_data[29]} {xgmii_passback_data[30]} {xgmii_passback_data[31]} {xgmii_passback_data[32]} {xgmii_passback_data[33]} {xgmii_passback_data[34]} {xgmii_passback_data[35]} {xgmii_passback_data[36]} {xgmii_passback_data[37]} {xgmii_passback_data[38]} {xgmii_passback_data[39]} {xgmii_passback_data[40]} {xgmii_passback_data[41]} {xgmii_passback_data[42]} {xgmii_passback_data[43]} {xgmii_passback_data[44]} {xgmii_passback_data[45]} {xgmii_passback_data[46]} {xgmii_passback_data[47]} {xgmii_passback_data[48]} {xgmii_passback_data[49]} {xgmii_passback_data[50]} {xgmii_passback_data[51]} {xgmii_passback_data[52]} {xgmii_passback_data[53]} {xgmii_passback_data[54]} {xgmii_passback_data[55]} {xgmii_passback_data[56]} {xgmii_passback_data[57]} {xgmii_passback_data[58]} {xgmii_passback_data[59]} {xgmii_passback_data[60]} {xgmii_passback_data[61]} {xgmii_passback_data[62]} {xgmii_passback_data[63]}]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe4]
set_property port_width 1 [get_debug_ports u_ila_2/probe4]
connect_debug_port u_ila_2/probe4 [get_nets [list U06_lybk_ddr/DDR_RD_REQ]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe5]
set_property port_width 1 [get_debug_ports u_ila_2/probe5]
connect_debug_port u_ila_2/probe5 [get_nets [list U06_lybk_ddr/DDR_RD_VALID]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe6]
set_property port_width 1 [get_debug_ports u_ila_2/probe6]
connect_debug_port u_ila_2/probe6 [get_nets [list U06_lybk_ddr/empty_0]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe7]
set_property port_width 1 [get_debug_ports u_ila_2/probe7]
connect_debug_port u_ila_2/probe7 [get_nets [list U06_lybk_ddr/passback_finish]]
create_debug_port u_ila_2 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_2/probe8]
set_property port_width 1 [get_debug_ports u_ila_2/probe8]
connect_debug_port u_ila_2/probe8 [get_nets [list xgmii_passback_data_valid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
