

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
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_7044_100m]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 8 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[0]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[1]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[2]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[3]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[4]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[5]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[6]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/state[0]} {U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/state[1]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 8 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/Rdy_id[0]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[1]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[2]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[3]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[4]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[5]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[6]} {U02_lybk_calib/RouterSychTop_inst/Rdy_id[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 8 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[0]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[1]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[2]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[3]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[4]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[5]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[6]} {U02_lybk_calib/RouterSychTop_inst/Trig_delay_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 8 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/ready_id[0]} {U02_lybk_calib/RouterSychTop_inst/ready_id[1]} {U02_lybk_calib/RouterSychTop_inst/ready_id[2]} {U02_lybk_calib/RouterSychTop_inst/ready_id[3]} {U02_lybk_calib/RouterSychTop_inst/ready_id[4]} {U02_lybk_calib/RouterSychTop_inst/ready_id[5]} {U02_lybk_calib/RouterSychTop_inst/ready_id[6]} {U02_lybk_calib/RouterSychTop_inst/ready_id[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 8 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/delay_data[0]} {U02_lybk_calib/RouterSychTop_inst/delay_data[1]} {U02_lybk_calib/RouterSychTop_inst/delay_data[2]} {U02_lybk_calib/RouterSychTop_inst/delay_data[3]} {U02_lybk_calib/RouterSychTop_inst/delay_data[4]} {U02_lybk_calib/RouterSychTop_inst/delay_data[5]} {U02_lybk_calib/RouterSychTop_inst/delay_data[6]} {U02_lybk_calib/RouterSychTop_inst/delay_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 8 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/config_data[0]} {U02_lybk_calib/RouterSychTop_inst/config_data[1]} {U02_lybk_calib/RouterSychTop_inst/config_data[2]} {U02_lybk_calib/RouterSychTop_inst/config_data[3]} {U02_lybk_calib/RouterSychTop_inst/config_data[4]} {U02_lybk_calib/RouterSychTop_inst/config_data[5]} {U02_lybk_calib/RouterSychTop_inst/config_data[6]} {U02_lybk_calib/RouterSychTop_inst/config_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 8 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/resetorder_type[0]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[1]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[2]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[3]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[4]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[5]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[6]} {U02_lybk_calib/RouterSychTop_inst/resetorder_type[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 8 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/rx_data[0]} {U02_lybk_calib/RouterSychTop_inst/rx_data[1]} {U02_lybk_calib/RouterSychTop_inst/rx_data[2]} {U02_lybk_calib/RouterSychTop_inst/rx_data[3]} {U02_lybk_calib/RouterSychTop_inst/rx_data[4]} {U02_lybk_calib/RouterSychTop_inst/rx_data[5]} {U02_lybk_calib/RouterSychTop_inst/rx_data[6]} {U02_lybk_calib/RouterSychTop_inst/rx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 16 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[0]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[1]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[2]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[3]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[4]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[5]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[6]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[7]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[8]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[9]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[10]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[11]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[12]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[13]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[14]} {U02_lybk_calib/RouterSychTop_inst/FPGA_ID_local[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 8 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[0]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[1]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[2]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[3]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[4]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[5]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[6]} {U02_lybk_calib/RouterSychTop_inst/TASK_ID_thread[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 8 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[0]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[1]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[2]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[3]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[4]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[5]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[6]} {U02_lybk_calib/RouterSychTop_inst/zk_task_id_r[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe12]
set_property port_width 8 [get_debug_ports u_ila_0/probe12]
connect_debug_port u_ila_0/probe12 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/trig_task_id[0]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[1]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[2]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[3]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[4]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[5]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[6]} {U02_lybk_calib/RouterSychTop_inst/trig_task_id[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe13]
set_property port_width 4 [get_debug_ports u_ila_0/probe13]
connect_debug_port u_ila_0/probe13 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/trig_pulse_cnt[0]} {U02_lybk_calib/RouterSychTop_inst/trig_pulse_cnt[1]} {U02_lybk_calib/RouterSychTop_inst/trig_pulse_cnt[2]} {U02_lybk_calib/RouterSychTop_inst/trig_pulse_cnt[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe14]
set_property port_width 4 [get_debug_ports u_ila_0/probe14]
connect_debug_port u_ila_0/probe14 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/state_debug[0]} {U02_lybk_calib/RouterSychTop_inst/state_debug[1]} {U02_lybk_calib/RouterSychTop_inst/state_debug[2]} {U02_lybk_calib/RouterSychTop_inst/state_debug[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe15]
set_property port_width 8 [get_debug_ports u_ila_0/probe15]
connect_debug_port u_ila_0/probe15 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/tx_data[0]} {U02_lybk_calib/RouterSychTop_inst/tx_data[1]} {U02_lybk_calib/RouterSychTop_inst/tx_data[2]} {U02_lybk_calib/RouterSychTop_inst/tx_data[3]} {U02_lybk_calib/RouterSychTop_inst/tx_data[4]} {U02_lybk_calib/RouterSychTop_inst/tx_data[5]} {U02_lybk_calib/RouterSychTop_inst/tx_data[6]} {U02_lybk_calib/RouterSychTop_inst/tx_data[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe16]
set_property port_width 8 [get_debug_ports u_ila_0/probe16]
connect_debug_port u_ila_0/probe16 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[0]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[1]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[2]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[3]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[4]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[5]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[6]} {U02_lybk_calib/RouterSychTop_inst/trigger_time_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe17]
set_property port_width 8 [get_debug_ports u_ila_0/probe17]
connect_debug_port u_ila_0/probe17 [get_nets [list {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[0]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[1]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[2]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[3]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[4]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[5]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[6]} {U02_lybk_calib/RouterSychTop_inst/sync_create_cnt[7]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe18]
set_property port_width 16 [get_debug_ports u_ila_0/probe18]
connect_debug_port u_ila_0/probe18 [get_nets [list {FPGA_SYS_RST_OBUF[0]} {FPGA_SYS_RST_OBUF[1]} {FPGA_SYS_RST_OBUF[2]} {FPGA_SYS_RST_OBUF[3]} {FPGA_SYS_RST_OBUF[4]} {FPGA_SYS_RST_OBUF[5]} {FPGA_SYS_RST_OBUF[6]} {FPGA_SYS_RST_OBUF[7]} {FPGA_SYS_RST_OBUF[8]} {FPGA_SYS_RST_OBUF[9]} {FPGA_SYS_RST_OBUF[10]} {FPGA_SYS_RST_OBUF[11]} {FPGA_SYS_RST_OBUF[12]} {FPGA_SYS_RST_OBUF[13]} {FPGA_SYS_RST_OBUF[14]} {FPGA_SYS_RST_OBUF[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe19]
set_property port_width 1 [get_debug_ports u_ila_0/probe19]
connect_debug_port u_ila_0/probe19 [get_nets [list U02_lybk_calib/RouterSychTop_inst/config_data_vald]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe20]
set_property port_width 1 [get_debug_ports u_ila_0/probe20]
connect_debug_port u_ila_0/probe20 [get_nets [list U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe21]
set_property port_width 1 [get_debug_ports u_ila_0/probe21]
connect_debug_port u_ila_0/probe21 [get_nets [list U02_lybk_calib/RouterSychTop_inst/theRouterReadyPackage/order_type_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe22]
set_property port_width 1 [get_debug_ports u_ila_0/probe22]
connect_debug_port u_ila_0/probe22 [get_nets [list U02_lybk_calib/RouterSychTop_inst/Rdy_id_vald]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe23]
set_property port_width 1 [get_debug_ports u_ila_0/probe23]
connect_debug_port u_ila_0/probe23 [get_nets [list U02_lybk_calib/RouterSychTop_inst/ready_id_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe24]
set_property port_width 1 [get_debug_ports u_ila_0/probe24]
connect_debug_port u_ila_0/probe24 [get_nets [list U02_lybk_calib/RouterSychTop_inst/resetorder_type_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe25]
set_property port_width 1 [get_debug_ports u_ila_0/probe25]
connect_debug_port u_ila_0/probe25 [get_nets [list U02_lybk_calib/RouterSychTop_inst/rst]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe26]
set_property port_width 1 [get_debug_ports u_ila_0/probe26]
connect_debug_port u_ila_0/probe26 [get_nets [list U02_lybk_calib/RouterSychTop_inst/rx_data_vald]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe27]
set_property port_width 1 [get_debug_ports u_ila_0/probe27]
connect_debug_port u_ila_0/probe27 [get_nets [list U02_lybk_calib/RouterSychTop_inst/theRs422/rxd]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe28]
set_property port_width 1 [get_debug_ports u_ila_0/probe28]
connect_debug_port u_ila_0/probe28 [get_nets [list SMA_TRIG_IN_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe29]
set_property port_width 1 [get_debug_ports u_ila_0/probe29]
connect_debug_port u_ila_0/probe29 [get_nets [list U02_lybk_calib/RouterSychTop_inst/sync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe30]
set_property port_width 1 [get_debug_ports u_ila_0/probe30]
connect_debug_port u_ila_0/probe30 [get_nets [list U02_lybk_calib/RouterSychTop_inst/sync_create_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe31]
set_property port_width 1 [get_debug_ports u_ila_0/probe31]
connect_debug_port u_ila_0/probe31 [get_nets [list U02_lybk_calib/RouterSychTop_inst/sync_f]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe32]
set_property port_width 1 [get_debug_ports u_ila_0/probe32]
connect_debug_port u_ila_0/probe32 [get_nets [list U02_lybk_calib/RouterSychTop_inst/Trig_create_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe33]
set_property port_width 1 [get_debug_ports u_ila_0/probe33]
connect_debug_port u_ila_0/probe33 [get_nets [list U02_lybk_calib/RouterSychTop_inst/Trig_delay_en]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe34]
set_property port_width 1 [get_debug_ports u_ila_0/probe34]
connect_debug_port u_ila_0/probe34 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_f]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe35]
set_property port_width 1 [get_debug_ports u_ila_0/probe35]
connect_debug_port u_ila_0/probe35 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_flag]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe36]
set_property port_width 1 [get_debug_ports u_ila_0/probe36]
connect_debug_port u_ila_0/probe36 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_pulse]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe37]
set_property port_width 1 [get_debug_ports u_ila_0/probe37]
connect_debug_port u_ila_0/probe37 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trig_task_valid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe38]
set_property port_width 1 [get_debug_ports u_ila_0/probe38]
connect_debug_port u_ila_0/probe38 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trigin]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe39]
set_property port_width 1 [get_debug_ports u_ila_0/probe39]
connect_debug_port u_ila_0/probe39 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TRigOk]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe40]
set_property port_width 1 [get_debug_ports u_ila_0/probe40]
connect_debug_port u_ila_0/probe40 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TrigOkOut]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe41]
set_property port_width 1 [get_debug_ports u_ila_0/probe41]
connect_debug_port u_ila_0/probe41 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TrigOut]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe42]
set_property port_width 1 [get_debug_ports u_ila_0/probe42]
connect_debug_port u_ila_0/probe42 [get_nets [list U02_lybk_calib/RouterSychTop_inst/trigout]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe43]
set_property port_width 1 [get_debug_ports u_ila_0/probe43]
connect_debug_port u_ila_0/probe43 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TrigOut_delay]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe44]
set_property port_width 1 [get_debug_ports u_ila_0/probe44]
connect_debug_port u_ila_0/probe44 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TrigOut_delay_f]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe45]
set_property port_width 1 [get_debug_ports u_ila_0/probe45]
connect_debug_port u_ila_0/probe45 [get_nets [list U02_lybk_calib/RouterSychTop_inst/TrigOut_sync]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe46]
set_property port_width 1 [get_debug_ports u_ila_0/probe46]
connect_debug_port u_ila_0/probe46 [get_nets [list U02_lybk_calib/RouterSychTop_inst/tx_data_vald]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe47]
set_property port_width 1 [get_debug_ports u_ila_0/probe47]
connect_debug_port u_ila_0/probe47 [get_nets [list U02_lybk_calib/RouterSychTop_inst/theRs422/txd]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
