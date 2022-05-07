`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/1 15:26:03
// Design Name: 
// Module Name: lybk_function
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


module lybk_function#(
     parameter FPGA_AMOUNT = 16
  )(
       input  [63:0]   XGMII_RXD, //万兆网下发数据    
       input           XGMII_RXDV, 
       input           XGMII_RX_CLK,//万兆网下发传输时钟 100M
       input           XGMII_TX_CLK,//万兆网回传时钟 156.25M
       input           TRIGGER_CLK,
       input           VIO_RST_N,

       input           SYNC_PULSE,
  (* MARK_DEBUG="true" *)     input           ZKBK_TRIGGER,
  (* MARK_DEBUG="true" *)     input  [7:0]    ZKBK_TASK_ID,
       input           DDR_RD_REQ,
       input  [3:0]    SYSTEM_STATE,

 (* MARK_DEBUG="true" *)      input  [FPGA_AMOUNT-1:0]   FPGA_READY,//FPGA回传的就绪信号
 (* MARK_DEBUG="true" *)      input  [FPGA_AMOUNT-1:0]   FPGA_RESET_FINISH,//FPGA复位完成信号
 (* MARK_DEBUG="true" *)      output          TO_ZKBK_READY,
 (* MARK_DEBUG="true" *)      output [7:0]    TO_ZKBK_TASK_ID,
 (* MARK_DEBUG="true" *)      output [31:0]   PASSBACK_LENGTH,
       output                     PASSBACK_LENGTH_VALID,
 (* MARK_DEBUG="true" *)      output [FPGA_AMOUNT-1:0]   TRIGGER_OUT,//触发信号
 (* MARK_DEBUG="true" *)      output [FPGA_AMOUNT-1:0]   FPGA_SYS_RST,//FPGA系统复位(高电平)
       output                     SYS_RST,//系统复位
       output                     TASK_RST,//线程复位

       output [63:0]  TO_FPGA1_AURORA_DATAPKG,
       output         TO_FPGA1_AURORA_VALID,
       output [63:0]  TO_FPGA2_AURORA_DATAPKG,
       output         TO_FPGA2_AURORA_VALID,
       output [63:0]  TO_FPGA3_AURORA_DATAPKG,
       output         TO_FPGA3_AURORA_VALID,
       output [63:0]  TO_FPGA4_AURORA_DATAPKG,
       output         TO_FPGA4_AURORA_VALID,
       output [63:0]  TO_FPGA5_AURORA_DATAPKG,
       output         TO_FPGA5_AURORA_VALID,
       output [63:0]  TO_FPGA6_AURORA_DATAPKG,
       output         TO_FPGA6_AURORA_VALID,
       output [63:0]  TO_FPGA7_AURORA_DATAPKG,
       output         TO_FPGA7_AURORA_VALID,
       output [63:0]  TO_FPGA8_AURORA_DATAPKG,
       output         TO_FPGA8_AURORA_VALID,
       output [63:0]  TO_FPGA9_AURORA_DATAPKG,
       output         TO_FPGA9_AURORA_VALID,
       output [63:0]  TO_FPGA10_AURORA_DATAPKG,
       output         TO_FPGA10_AURORA_VALID,
       output [63:0]  TO_FPGA11_AURORA_DATAPKG,
       output         TO_FPGA11_AURORA_VALID,
       output [63:0]  TO_FPGA12_AURORA_DATAPKG,
       output         TO_FPGA12_AURORA_VALID,
       output [63:0]  TO_FPGA13_AURORA_DATAPKG,
       output         TO_FPGA13_AURORA_VALID,
       output [63:0]  TO_FPGA14_AURORA_DATAPKG,
       output         TO_FPGA14_AURORA_VALID,
       output [63:0]  TO_FPGA15_AURORA_DATAPKG,
       output         TO_FPGA15_AURORA_VALID,
       output [63:0]  TO_FPGA16_AURORA_DATAPKG,
       output         TO_FPGA16_AURORA_VALID,

       output [63:0]  STATE_PASSBACK_DATA,//万兆网回传数据
       output         STATE_PASSBACK_DV,
       output         PASSBACK_DONE
    );
     wire          XGMII_CLK;
(* MARK_DEBUG="true" *)     wire          sys_rst_n,trigger_rst_n,reset_done;
(* MARK_DEBUG="true" *)     wire  [7:0]   send_fpga_id;
(* MARK_DEBUG="true" *)     wire  [63:0]  lybk_datapkg,fpga_datapkg;
(* MARK_DEBUG="true" *)     wire          lybk_datapkg_valid,fpga_datapkg_valid;
     
     wire  [63:0]  fpga1_aurora,fpga2_aurora,fpga3_aurora,fpga4_aurora,fpga5_aurora,
                   fpga6_aurora,fpga7_aurora,fpga8_aurora,fpga9_aurora,fpga10_aurora,
                   fpga11_aurora,fpga12_aurora,fpga13_aurora,fpga14_aurora,fpga15_aurora,fpga16_aurora;
     
     wire          fpga1_valid,fpga2_valid,fpga3_valid,fpga4_valid,fpga5_valid,fpga6_valid,
                   fpga7_valid,fpga8_valid,fpga9_valid,fpga10_valid,fpga11_valid,fpga12_valid,
                   fpga13_valid,fpga14_valid,fpga15_valid,fpga16_valid;                    
     
(* MARK_DEBUG="true" *)     wire           s_circle_dv;
(* MARK_DEBUG="true" *)     wire  [7:0]    b_circle_amount;
(* MARK_DEBUG="true" *)     wire  [7:0]    order_type;
(* MARK_DEBUG="true" *)     wire           order_valid;
(* MARK_DEBUG="true" *)     wire  [7:0]    task_id;
(* MARK_DEBUG="true" *)     wire  [FPGA_AMOUNT-1:0]   fpga_id;
(* MARK_DEBUG="true" *)     wire  [FPGA_AMOUNT-1:0]   ready_state;
(* MARK_DEBUG="true" *)     wire  [63:0]   s_circle_data;
     wire           lybk_rx_done;
     wire           idle;
(* MARK_DEBUG="true" *)     wire  [63:0]   state_passback_data;
(* MARK_DEBUG="true" *)     wire           state_passback_dv;
     wire           to_zkbk_ready;
(* MARK_DEBUG="true" *)     wire           thread_reset_en;
//////////////////////////////////////////////////////////数据传输
    assign SYS_RST = ~sys_rst_n;
    assign TASK_RST = ~trigger_rst_n;
    assign XGMII_CLK = XGMII_RX_CLK;
    assign TO_ZKBK_READY = to_zkbk_ready & (~thread_reset_en);//(~((SYSTEM_STATE == 4'd4)&&thread_reset_en));

    assign TO_FPGA1_AURORA_DATAPKG  = fpga1_aurora;
    assign TO_FPGA2_AURORA_DATAPKG  = fpga2_aurora;
    assign TO_FPGA3_AURORA_DATAPKG  = fpga3_aurora;
    assign TO_FPGA4_AURORA_DATAPKG  = fpga4_aurora;
    assign TO_FPGA5_AURORA_DATAPKG  = fpga5_aurora;
    assign TO_FPGA6_AURORA_DATAPKG  = fpga6_aurora;
    assign TO_FPGA7_AURORA_DATAPKG  = fpga7_aurora;
    assign TO_FPGA8_AURORA_DATAPKG  = fpga8_aurora;
    assign TO_FPGA9_AURORA_DATAPKG  = fpga9_aurora;
    assign TO_FPGA10_AURORA_DATAPKG = fpga10_aurora;
    assign TO_FPGA11_AURORA_DATAPKG = fpga11_aurora;
    assign TO_FPGA12_AURORA_DATAPKG = fpga12_aurora;
    assign TO_FPGA13_AURORA_DATAPKG = fpga13_aurora;
    assign TO_FPGA14_AURORA_DATAPKG = fpga14_aurora;
    assign TO_FPGA15_AURORA_DATAPKG = fpga15_aurora;
    assign TO_FPGA16_AURORA_DATAPKG = fpga16_aurora;

    assign TO_FPGA1_AURORA_VALID    = fpga1_valid;
    assign TO_FPGA2_AURORA_VALID    = fpga2_valid;
    assign TO_FPGA3_AURORA_VALID    = fpga3_valid;
    assign TO_FPGA4_AURORA_VALID    = fpga4_valid;
    assign TO_FPGA5_AURORA_VALID    = fpga5_valid;
    assign TO_FPGA6_AURORA_VALID    = fpga6_valid;
    assign TO_FPGA7_AURORA_VALID    = fpga7_valid;
    assign TO_FPGA8_AURORA_VALID    = fpga8_valid;
    assign TO_FPGA9_AURORA_VALID    = fpga9_valid;
    assign TO_FPGA10_AURORA_VALID   = fpga10_valid;
    assign TO_FPGA11_AURORA_VALID   = fpga11_valid;
    assign TO_FPGA12_AURORA_VALID   = fpga12_valid;
    assign TO_FPGA13_AURORA_VALID   = fpga13_valid;
    assign TO_FPGA14_AURORA_VALID   = fpga14_valid; 
    assign TO_FPGA15_AURORA_VALID   = fpga15_valid; 
    assign TO_FPGA16_AURORA_VALID   = fpga16_valid;

///////////////10G_unpack/////////////
lybk_xgmii_unpack lybk_xgmii_unpack_inst(
    .XGMII_RXD(XGMII_RXD),
    .XGMII_RXDV(XGMII_RXDV),
    .XGMII_CLK(XGMII_CLK),
    .RST_N(sys_rst_n & trigger_rst_n & VIO_RST_N),

    .FPGA_ID(send_fpga_id),//FPGA编号
    .LYBK_DATAPKG(lybk_datapkg),//路由板卡数据包
    .FPGA_DATAPKG(fpga_datapkg),//FPGA数据包 
    .LYBK_DATAPKG_VALID(lybk_datapkg_valid),//路由数据包有效
    .FPGA_DATAPKG_VALID(fpga_datapkg_valid)//FPGA数据包有效

    );

lybk_xgmii_send lybk_xgmii_send_inst(
     .FPGA_DATAPKG(fpga_datapkg),
     .FPGA_DATAPKG_VALID(fpga_datapkg_valid),
     .FPGA_ID(send_fpga_id),

     .FPGA1_AURORA_DATAPKG(fpga1_aurora),
     .FPGA1_AURORA_VALID(fpga1_valid),
     .FPGA2_AURORA_DATAPKG(fpga2_aurora),
     .FPGA2_AURORA_VALID(fpga2_valid),
     .FPGA3_AURORA_DATAPKG(fpga3_aurora),
     .FPGA3_AURORA_VALID(fpga3_valid),
     .FPGA4_AURORA_DATAPKG(fpga4_aurora),
     .FPGA4_AURORA_VALID(fpga4_valid),
     .FPGA5_AURORA_DATAPKG(fpga5_aurora),
     .FPGA5_AURORA_VALID(fpga5_valid),
     .FPGA6_AURORA_DATAPKG(fpga6_aurora),
     .FPGA6_AURORA_VALID(fpga6_valid),
     .FPGA7_AURORA_DATAPKG(fpga7_aurora),
     .FPGA7_AURORA_VALID(fpga7_valid),
     .FPGA8_AURORA_DATAPKG(fpga8_aurora),
     .FPGA8_AURORA_VALID(fpga8_valid),
     .FPGA9_AURORA_DATAPKG(fpga9_aurora),
     .FPGA9_AURORA_VALID(fpga9_valid),
     .FPGA10_AURORA_DATAPKG(fpga10_aurora),
     .FPGA10_AURORA_VALID(fpga10_valid),
     .FPGA11_AURORA_DATAPKG(fpga11_aurora),
     .FPGA11_AURORA_VALID(fpga11_valid),
     .FPGA12_AURORA_DATAPKG(fpga12_aurora),
     .FPGA12_AURORA_VALID(fpga12_valid),
     .FPGA13_AURORA_DATAPKG(fpga13_aurora),
     .FPGA13_AURORA_VALID(fpga13_valid),
     .FPGA14_AURORA_DATAPKG(fpga14_aurora),
     .FPGA14_AURORA_VALID(fpga14_valid),
     .FPGA15_AURORA_DATAPKG(fpga15_aurora),
     .FPGA15_AURORA_VALID(fpga15_valid),
     .FPGA16_AURORA_DATAPKG(fpga16_aurora),
     .FPGA16_AURORA_VALID(fpga16_valid)
    );
///////////////////////////////////////
////////////////data_config////////////
lybk_config_trans lybk_config_trans_inst(
      .RST_N(sys_rst_n & trigger_rst_n & VIO_RST_N),
      .XGMII_CLK(XGMII_CLK),
      .LYBK_DP_VALID(lybk_datapkg_valid),
      .LYBK_DP(lybk_datapkg),
      
      .S_CIRCLE_DATA_VALID(s_circle_dv),//数据有效信号(任务下发有效)
      .B_CIRCLE_AMOUNT(b_circle_amount),//大循环数量
      .ORDER_TYPE(order_type),//指令类型
      .ORDER_VALID(order_valid),//指令有效信号
      .TASK_ID(task_id),//任务ID(指令和数据共用)
      .FPGA_ID(fpga_id),//fpga掩码(指令和数据共用)
      .S_CIRCLE_DATA(s_circle_data),//小循环触发数据
      .THREAD_RESET_EN(thread_reset_en),

      .RX_DONE(lybk_rx_done)
);
////////////////////////////////////////
///////////////reset_control////////////////////
lybk_reset_control lybk_reset_control_inst(
       .XGMII_CLK(XGMII_CLK),
       .ORDER_TYPE(order_type),
       .ORDER_VALID(order_valid),
       /*.FPGA_ID(fpga_id),*/
       .FPGA_RESET_FINISH(FPGA_RESET_FINISH),
       /*.TASK_ID(task_id),*/
       .TASK_IDLE(idle),                     

       .TRIGGER_RESET(trigger_rst_n),//触发模块的复位信号(低电平)
       .FPGA_SYS_RST(FPGA_SYS_RST),//FPGA的复位信号(高电平)
       .SYS_RESET(sys_rst_n),//系统复位(低电平)
       .RESET_DONE(reset_done)
      );
///////////////////////////////////////
//////////////////trigger_top//////////
lybk_trigger lybk_trigger_inst(

       .DATA_CLK(XGMII_CLK),//数据传输时钟
       .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，300M
       .RST_N(trigger_rst_n & sys_rst_n & VIO_RST_N),

       .S_CIRCLE_DATA_VALID(s_circle_dv),//输入使能信号
       .SYNC_PULSE(SYNC_PULSE),//同步脉冲
       .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡下发的任务
       .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
       .B_CIRCLE_AMOUNT(b_circle_amount),//大循环数量
       .TASK_ID_in(task_id),//任务ID
       .FPGA_ID_in(fpga_id),//fpga掩码号
       .S_CIRCLE_DATA(s_circle_data),//小循环触发数据
       .PASSBACK_LENGTH(PASSBACK_LENGTH),
       .PASSBACK_LENGTH_VALID(PASSBACK_LENGTH_VALID),
       
       .IDLE(idle),//空闲信号

       .FPGA_READY(FPGA_READY),//下层FPGA发来的就绪信号
       .TRIGGER_OUT(TRIGGER_OUT),//触发信号输出

       .READY_STATE(ready_state),
       .TO_ZKBK_TASK_ID(TO_ZKBK_TASK_ID),//发向中控的任务（可略去）
       .TO_ZKBK_READY(to_zkbk_ready)//发向上层中控的就绪

	);
///////////////////////////////////////////
////////////////state_passback////////////
lybk_passback lybk_passback_inst(
       .XGMII_CLK(XGMII_CLK),                          
       .ORDER_TYPE(order_type),        
       .ORDER_VALID(order_valid),
       .READY_STATE(ready_state),        

       .TASK_ID(task_id),       
       .FPGA_ID(fpga_id),       
       .B_CIRCLE_AMOUNT(b_circle_amount),       
       .LYBK_RX_DONE(lybk_rx_done),
       .RESET_DONE(reset_done),

       .STATE_PASSBACK_DV(state_passback_dv),
       .STATE_PASSBACK_DATA(state_passback_data),
       .PASSBACK_DONE(PASSBACK_DONE) 
       );
wire    empty;
wire    rd_en;
reg     ddr_rd_req;

always @(posedge XGMII_TX_CLK)
   ddr_rd_req <= DDR_RD_REQ;

assign  rd_en =  ddr_rd_req & (~empty);
assign  STATE_PASSBACK_DV = rd_en;

pass_back_fifo pass_back_fifo (
  .wr_clk(XGMII_CLK),            // input wire wr_clk
  .rd_clk(XGMII_TX_CLK),            // input wire rd_clk
  .din(state_passback_data),                  // input wire [63 : 0] din
  .wr_en(state_passback_dv),              // input wire wr_en
  .rd_en(rd_en),              // input wire rd_en
  .dout(STATE_PASSBACK_DATA),                // output wire [63 : 0] dout
  .full(),                // output wire full
  .empty(empty)              // output wire empty
);
//////////////////////////////////////////////

endmodule
