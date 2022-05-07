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
  input            rst,

  input            SMA_TRIG_IN,
  output           SMA_TrigOK_OUT,
  output   [3:0]   state,

  input            rxd_p,
  input            rxd_n,
  output           txd_p,
  output           txd_n,

  input            ready_id_valid,
  input    [7:0]   ready_id,

  output   [7:0]   zk_task_id,
  output           trig_flag,
  output           trig_pulse,
  output           sync   

    );


RouterSychTop RouterSychTop_inst(

    .clk(clk_100m),//100M 7044
    .TrigIn(SMA_TRIG_IN),
    .sync_rst(rst),

    .rxd_p(rxd_p),
    .rxd_n(rxd_n),
    .txd_p(txd_p),
    .txd_n(txd_n),
    .TrigOkOut(SMA_TrigOK_OUT),
    .state(state),

    .ready_id_valid(ready_id_valid),
    .ready_id(ready_id),

    .zk_task_id(zk_task_id),
    .trigout(trig_flag),
    .trig_pulse_out(trig_pulse),
    .sync(sync)   
	);
endmodule
