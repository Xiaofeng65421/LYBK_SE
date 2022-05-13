`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/11 11:45:47
// Design Name: 
// Module Name: lybk_calib
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lybk_calib(
  input            clk_100m,//7044 100M
  input            sync_rst,
  input            soft_rst,

(*mark_debug = "true"*)  input            SMA_TRIG_IN,
  output           SMA_TrigOK_OUT,
  output   [3:0]   state,
  output   [7:0]   resetorder_type,
  output           resetorder_type_valid,
  output   [15:0]  FPGA_ID_local,
  output   [7:0]   TASK_ID_thread,

  input    [15:0]  fpga_ready_state_mask,
  input            ready_check_en,
  output           ready_receive_valid,

  input            rxd_p,
  input            rxd_n,
  output           txd_p,
  output           txd_n,

  input            ready_id_valid,
  input    [7:0]   ready_id,

  output   [7:0]   zk_task_id,
  output           trig_flag,
  output           sync,

//-------------下层板卡----------------//
  output   [63:0]  bk_order_datapkg,
  output           bk_order_datapkg_valid   

    );

  wire       sync_en;

RouterSychTop RouterSychTop_inst(

    .clk(clk_100m),//100M 7044
    .TrigIn(SMA_TRIG_IN),
    .sync_rst(sync_rst),
    .soft_rst(soft_rst),

    .rxd_p(rxd_p),
    .rxd_n(rxd_n),
    .txd_p(txd_p),
    .txd_n(txd_n),
    .TrigOkOut(SMA_TrigOK_OUT),
    .state(state),
    .resetorder_type(resetorder_type),
    .resetorder_type_valid(resetorder_type_valid),
    .FPGA_ID_local(FPGA_ID_local),
    .TASK_ID_thread(TASK_ID_thread),

    .FPGA_READY_STATE_MASK(fpga_ready_state_mask),
    .READY_CHECK_EN(ready_check_en),
    .READY_RECEIVE_VALID(ready_receive_valid),

    .ready_id_valid(ready_id_valid),
    .ready_id(ready_id),

    .zk_task_id(zk_task_id),
    .trigout(trig_flag),
    .sync(sync),
    .sync_en(sync_en)   
  );

bk_order_create bk_order_create_inst(
     .clk(clk_100m),
     .rst(sync_rst),
     .sync_en(sync_en),
     .bk_order_datapkg(bk_order_datapkg),
     .bk_order_datapkg_valid(bk_order_datapkg_valid) 
  );

endmodule
