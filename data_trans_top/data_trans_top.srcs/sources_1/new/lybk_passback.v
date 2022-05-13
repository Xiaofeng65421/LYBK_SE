`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/02 10:59:51
// Design Name: 
// Module Name: lybk_passback
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


module lybk_passback#(
     parameter FPGA_AMOUNT = 16
    )(
       input       XGMII_CLK,                        
       input [7:0]  ORDER_TYPE,        
       input        ORDER_VALID, 

       input [7:0]  TASK_ID,       
       input [FPGA_AMOUNT-1:0] FPGA_ID,       
       input [7:0]  B_CIRCLE_AMOUNT,       
       input        LYBK_RX_DONE,
       /*input        RESET_DONE,*/

       output        STATE_PASSBACK_DV,
       output [63:0] STATE_PASSBACK_DATA       

    );
    wire        state_txdv;
    wire [63:0] state_txd;

    assign STATE_PASSBACK_DV = state_txdv;
    assign STATE_PASSBACK_DATA  = state_txd;


////////////////////////////////////////////
lybk_state_passback#(
    .FPGA_AMOUNT(FPGA_AMOUNT)
    )lybk_state_passback_inst(
      .XGMII_CLK(XGMII_CLK),//万兆网时钟
      .ORDER_TYPE(ORDER_TYPE),//指令类型
      .ORDER_VALID(ORDER_VALID),

      .TASK_ID(TASK_ID),//任务ID
      .FPGA_ID(FPGA_ID),//FPGA掩码
      .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
      .LYBK_RX_DONE(LYBK_RX_DONE),//路由数据包接收完毕
      /*.RESET_DONE(RESET_DONE),//复位完成*/

      .XGMII_TXDV(state_txdv),
      .XGMII_TXD(state_txd)

    );
endmodule
