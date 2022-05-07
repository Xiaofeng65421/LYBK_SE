`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/10 09:21:54
// Design Name: 
// Module Name: tb_adda_aurora_unpack
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


module tb_adda_aurora_unpack();

       reg          AURORA_CLK;
       reg          RST_N;
       reg          ADDA_AURORA_VALID;
       reg [63:0]   ADDA_AURORA_RXD;

       wire [7:0]    TASK_ID;
       wire [23:0]   WORK_ID;
       wire [7:0]    WORK_AMOUNT;

       wire [7:0]   B_CIRCLE_AMOUNT;
       wire [7:0]   WORK_MODE;
       wire [15:0]  B_CIRCLE_DPL;
       wire [159:0] B_CIRCLE_ADDRESS;
       wire         B_CIRCLE_SEARCH_VALID;
       wire [63:0]  B_CIRCLE_PACKAGE;
       wire         B_CIRCLE_PACKAGE_VALID;

       wire [7:0]   PARAMETER_AMOUNT;
       wire [63:0]  PARAMETER_PACKAGE;
       wire         PARAMETER_PACKAGE_VALID;

       wire         ERROR;
       wire         RX_DONE;

       reg   [7:0]  cnt;


       initial begin
       	 AURORA_CLK <= 0;
       	 RST_N <= 1;
       	 ADDA_AURORA_VALID <= 0;

       	 cnt <= 0;

       end

       always #10 AURORA_CLK = ~AURORA_CLK;


       always @(posedge AURORA_CLK)
          cnt <= cnt + 1;

       always @(posedge AURORA_CLK)
         if (cnt  == 10) begin
         	RST_N <= 0;
         end else if (cnt == 20) begin
         	RST_N <= 1;
         end else if (cnt == 21) begin
         	ADDA_AURORA_VALID <= 1;
         	ADDA_AURORA_RXD[7:0] <= 8'h01;//指令类型
         	ADDA_AURORA_RXD[15:8] <= 8'h03;//任务ID
         	ADDA_AURORA_RXD[39:16] <= 24'd10560;//ADDA工作单元编号
         	ADDA_AURORA_RXD[47:40] <= 8'h05;//大循环数量
         	ADDA_AURORA_RXD[55:48] <= 8'h01;//工作模式
         	ADDA_AURORA_RXD[63:56] <= 8'd4;//工作单元数量
         end else if (cnt == 22) begin
         	ADDA_AURORA_RXD[15:0] <= 16'd90;//大循环数据包长度
         	ADDA_AURORA_RXD[63:16] <= {16'd300,16'd200,16'd100};//大循环1~3
         end else if (cnt == 23) begin
         	ADDA_AURORA_RXD[63:0] <= {16'd0,16'd0,16'd500,16'd400};//大循环4~7
          end else if (cnt == 24) begin
          	ADDA_AURORA_RXD <= 0;//大循环8~10
          end else if ((cnt >= 25) && (cnt < 125)) begin
          	ADDA_AURORA_RXD <= {$random}%2000;
          end else if (cnt == 125) begin
          	ADDA_AURORA_VALID <= 0;
          end else if (cnt == 200) begin
          	ADDA_AURORA_VALID <= 1;
         	ADDA_AURORA_RXD[7:0] <= 8'h02;//指令类型
         	ADDA_AURORA_RXD[15:8] <= 8'h03;//任务ID
         	ADDA_AURORA_RXD[39:16] <= 24'd10560;//ADDA工作单元编号
         	ADDA_AURORA_RXD[47:40] <= 8'h08;//空
         	ADDA_AURORA_RXD[55:48] <= 8'h01;//空
         	ADDA_AURORA_RXD[63:56] <= 8'd4;//工作单元数量
          end else if ((cnt >= 201) && (cnt < 250)) begin
          	ADDA_AURORA_RXD <= {$random}%1000;
          end else if (cnt == 250) begin
          	ADDA_AURORA_VALID <= 0;
          end




adda_aurora_unpack adda_aurora_unpack_inst(
           .AURORA_CLK(AURORA_CLK),
           .RST_N(RST_N),
           .ADDA_AURORA_VALID(ADDA_AURORA_VALID),
           .ADDA_AURORA_RXD(ADDA_AURORA_RXD),

           .TASK_ID(TASK_ID),//任务ID
           .WORK_ID(WORK_ID),//工作单元编号
           .WORK_AMOUNT(WORK_AMOUNT),//工作单元数量          
          
           .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
           .WORK_MODE(WORK_MODE),//工作模式
           .B_CIRCLE_DPL(B_CIRCLE_DPL),//大循环数据包长度
           .B_CIRCLE_ADDRESS(B_CIRCLE_ADDRESS),//大循环首地址
           .B_CIRCLE_SEARCH_VALID(B_CIRCLE_SEARCH_VALID),//大循环检索有效
           .B_CIRCLE_PACKAGE(B_CIRCLE_PACKAGE),//大循环数据包
           .B_CIRCLE_PACKAGE_VALID(B_CIRCLE_PACKAGE_VALID),//大循环数据包有效

           .PARAMETER_AMOUNT(PARAMETER_AMOUNT),//参数类型数量
           .PARAMETER_PACKAGE(PARAMETER_PACKAGE),//参数数据包
           .PARAMETER_PACKAGE_VALID(PARAMETER_PACKAGE_VALID),//参数数据包有效  

           .ERROR(ERROR),
           .RX_DONE(RX_DONE)
    );

endmodule
