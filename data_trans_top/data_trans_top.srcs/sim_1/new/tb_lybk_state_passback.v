`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/07 13:46:38
// Design Name: 
// Module Name: tb_lybk_state_passback
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


module tb_lybk_state_passback();
      reg  XGMII_CLK;
      reg  SYS_RST;
      reg  [74:0] READY_STATE;//全任务就绪状态
      reg  [19:0] B_CIRCLE_ID;//所有模块的大循环编号
      reg  [7:0]  ORDER_TYPE;//指令类型
      reg         ORDER_VALID;

      reg         XGMII_DATA_ERROR = 0;
      reg         BK_DATA_ERROR = 0;
      reg         TASK_SEND_ERROR = 0;

      reg  [4:0]  READY_ERROR = 0;
      reg  [4:0]  TRIGGER_SUCCESS = 0;
      reg  [4:0]  TRIGGER_FAILURE = 0;

      reg  [7:0]  TASK_ID;//任务ID
      reg  [15:0] FPGA_ID;//FPGA掩码
      reg  [7:0]  B_CIRCLE_AMOUNT;//大循环数量
      reg         LYBK_RX_DONE;//路由数据包接收完毕
      reg         RESET_DONE;//复位完成

      wire [63:0] XGMII_TXD;//状态数据
      wire        XGMII_TXDV;
      wire        TX_DONE;

      reg [10:0]  cnt;
      reg [2:0]  add;

      initial begin
      	XGMII_CLK <= 0;
      	SYS_RST <= 1;
      	cnt <= 0;
      	LYBK_RX_DONE <= 0;
      	RESET_DONE <= 0;
      	ORDER_VALID <= 0;
      	add <= 0;
      end

      always #10 XGMII_CLK = ~XGMII_CLK;

      always @(posedge XGMII_CLK)begin
      	cnt <= cnt + 1;
      end

      always @(posedge XGMII_CLK)
        if (&cnt) begin
        	add <= add + 1;
        end

      always @(posedge XGMII_CLK)
        if (cnt == 10) begin
        	SYS_RST <= 0;
        end else if (cnt == 20) begin
          ORDER_VALID <= 1;
        	TASK_ID <= 2;
        	ORDER_TYPE <= 8'h01 + add;
        	B_CIRCLE_AMOUNT <= 4 + add;
        	FPGA_ID <= 16'd1580 + 100*add;
        	READY_STATE <= {15'd125 + add,15'd55 + add,15'd48 + add,15'd163 + add,15'd248 + add};
          B_CIRCLE_ID <= {4'd1 + add,4'd5 + add,4'd2 + add,4'd6 + add,4'd2 + add};
        end else if (cnt == 21) begin
        	ORDER_VALID <= 0;
        end else if (cnt == 22) begin
        	LYBK_RX_DONE <= 1;
        end else if (cnt == 23) begin
        	LYBK_RX_DONE <= 0;
        end else if (cnt == 100) begin
        	RESET_DONE <= 1;
        end else if (cnt == 101) begin
        	RESET_DONE <= 0;
        end else if (cnt == 250) begin
          READY_ERROR <= 5'b01000;
        end else if (cnt == 251) begin
          READY_ERROR <= 0;
        end else if (cnt == 260) begin
          TRIGGER_SUCCESS <= 5'b10000;
        end else if (cnt == 261) begin
          TRIGGER_SUCCESS <= 0;
        end else if (cnt == 262) begin
          RESET_DONE <= 1;
        end  else if (cnt == 263) begin
          RESET_DONE <= 0;
        end else if (cnt == 270) begin
          TRIGGER_FAILURE <= 5'b00100;
        end else if (cnt == 271) begin
          TRIGGER_FAILURE <= 0;
        end else if (cnt == 280) begin
          XGMII_DATA_ERROR <= 1;
        end else if (cnt == 281) begin
          XGMII_DATA_ERROR <= 0;
        end  else if (cnt == 290) begin
          TASK_SEND_ERROR <= 1;
        end else if (cnt == 291) begin
          TASK_SEND_ERROR <= 0;
        end else if (cnt == 300) begin
           BK_DATA_ERROR <= 1;
        end else if (cnt == 301) begin
           BK_DATA_ERROR <= 0;
        end 

   lybk_state_passback lybk_state_passback_inst(
      .XGMII_CLK(XGMII_CLK),//万兆网时钟
      /*.SYS_RST(SYS_RST),*/
      .READY_STATE(READY_STATE),//全任务就绪状态
/*      .B_CIRCLE_ID(B_CIRCLE_ID),//所有模块的大循环编号*/
      .ORDER_TYPE(ORDER_TYPE),//指令类型
      .ORDER_VALID(ORDER_VALID),
      
/*      .XGMII_DATA_ERROR(XGMII_DATA_ERROR),
      .BK_DATA_ERROR(BK_DATA_ERROR),
      .TASK_SEND_ERROR(TASK_SEND_ERROR),


      .READY_ERROR(READY_ERROR),//就绪错误
      .TRIGGER_SUCCESS(TRIGGER_SUCCESS),//中控触发成功
      .TRIGGER_FAILURE(TRIGGER_FAILURE),//中控触发失败*/

      .TASK_ID(TASK_ID),//任务ID
      .FPGA_ID(FPGA_ID),//FPGA掩码
      .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
      .LYBK_RX_DONE(LYBK_RX_DONE),//路由数据包接收完毕
      .RESET_DONE(RESET_DONE),//复位完成

      .XGMII_TXDV(XGMII_TXDV),//状态数据
      .XGMII_TXD(XGMII_TXD),
      .TX_DONE(TX_DONE)

    );
endmodule
