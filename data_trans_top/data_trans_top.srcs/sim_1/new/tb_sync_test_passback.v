`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/13 09:51:21
// Design Name: 
// Module Name: tb_sync_test_passback
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


module tb_sync_test_passback();

     reg  [7:0] ORDER_TYPE;
     reg        XGMII_CLK;
     reg        RST_N;
     reg  [64*15 -1 :0] FPGA_PASSBACK;
     reg  [14:0]        PASSBACK_VALID;

     wire [63:0]        HMC7044_PASSBACK;
     wire               HMC7044_PASSBACK_VALID;

     reg  [7:0]  cnt;

     initial begin
     	ORDER_TYPE <= 8'h05;
     	XGMII_CLK <= 0;
     	RST_N <= 1;
     	PASSBACK_VALID <= 0;
     	FPGA_PASSBACK <= 0;

     	cnt = 0;
     end

     always #5 XGMII_CLK = ~XGMII_CLK;

     always @(posedge XGMII_CLK)
       if (&cnt) begin
       	   cnt <= cnt;
       end else begin
       	   cnt <= cnt + 1;
       end

     always @(posedge XGMII_CLK)
       if (cnt == 5) begin
         	RST_N <= 0;
         end else if (cnt == 15) begin
         	RST_N <= 1;
         end else if (cnt == 20 || cnt == 21)begin
         	PASSBACK_VALID[0] <= 1;
         	FPGA_PASSBACK[63:0] <= 100;
         end else if (cnt == 22 || cnt == 23) begin
            PASSBACK_VALID[0] <= 0;
         	PASSBACK_VALID[1] <= 1;
         	FPGA_PASSBACK[63:0] <= 0;
         	FPGA_PASSBACK[127:64] <=200;
         end else if (cnt == 24) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 30 || cnt == 31) begin
         	PASSBACK_VALID[1:0] <= 0;
         	PASSBACK_VALID[2] <= 1;
         	FPGA_PASSBACK[127:0] <= 0;
         	FPGA_PASSBACK[191:128] <= 300;
         end else if (cnt == 32) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 35 || cnt == 36) begin
         	PASSBACK_VALID[2:0] <= 0;
         	PASSBACK_VALID[3] <= 1;
         	FPGA_PASSBACK[191:0] <= 0;
         	FPGA_PASSBACK[255:192] <= 400;
         end else if (cnt == 37 || cnt == 38) begin
         	PASSBACK_VALID[3:0] <= 0;
         	PASSBACK_VALID[4] <= 1;
         	FPGA_PASSBACK[4*64 -1 : 0] <= 0;
         	FPGA_PASSBACK[5*64 -1 : 4*64] <= 500;
         end else if (cnt == 39 || cnt == 40) begin
         	PASSBACK_VALID[4:0] <= 0;
         	PASSBACK_VALID[5] <= 1;
         	FPGA_PASSBACK[5*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[6*64 - 1 :5*64] <= 600;
         end else if (cnt == 41 || cnt == 42) begin
         	PASSBACK_VALID[5:0] <= 0;
         	PASSBACK_VALID[6] <= 1;
         	FPGA_PASSBACK[6*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[7*64-1 : 6*64] <= 700;
         end else if (cnt == 43 || cnt == 44) begin
         	PASSBACK_VALID[6:0] <= 0;
         	PASSBACK_VALID[7] <= 1;
         	FPGA_PASSBACK[7*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[8*64-1 : 7*64] <= 800;
         end else if (cnt == 45) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 50 || cnt == 51) begin
         	PASSBACK_VALID[7:0] <= 0;
         	PASSBACK_VALID[8] <= 1;
         	FPGA_PASSBACK[8*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[9*64-1 : 8*64] <= 900;
         end else if (cnt == 52 || cnt == 53) begin
         	PASSBACK_VALID[8:0] <= 0;
         	PASSBACK_VALID[9] <= 1;
         	FPGA_PASSBACK[9*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[10*64-1 : 9*64] <= 1000;
         end else if (cnt == 54 || cnt == 55) begin
         	PASSBACK_VALID[9:0] <= 0;
         	PASSBACK_VALID[10] <= 1;
         	FPGA_PASSBACK[10*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[11*64-1 : 10*64] <= 1100;
         end else if (cnt == 56 || cnt == 57) begin
         	PASSBACK_VALID[10:0] <= 0;
         	PASSBACK_VALID[11] <= 1;
         	FPGA_PASSBACK[11*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[12*64-1 : 11*64] <= 1200;
         end else if (cnt == 58 || cnt == 59) begin
         	PASSBACK_VALID[11:0] <= 0;
         	PASSBACK_VALID[12] <= 1;
         	FPGA_PASSBACK[12*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[13*64-1 : 12*64] <= 1300;
         end else if (cnt == 60 || cnt == 61) begin
         	PASSBACK_VALID[12:0] <= 0;
         	PASSBACK_VALID[13] <= 1;
         	FPGA_PASSBACK[13*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[14*64-1 : 13*64] <= 1400;
         end else if (cnt == 62 || cnt == 63) begin
         	PASSBACK_VALID[13:0] <= 0;
         	PASSBACK_VALID[14] <= 1;
         	FPGA_PASSBACK[14*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[15*64-1 : 14*64] <= 1500;
         end else if (cnt == 64) begin
         	PASSBACK_VALID <= 0;
         	FPGA_PASSBACK <= 0;
         end

    sync_test_passback sync_test_passback_inst(
      .ORDER_TYPE(ORDER_TYPE),
      .XGMII_CLK(XGMII_CLK),
      .RST_N(RST_N),
      
      .FPGA_PASSBACK(FPGA_PASSBACK),
      .PASSBACK_VALID(PASSBACK_VALID),

      .HMC7044_PASSBACK(HMC7044_PASSBACK),
      .HMC7044_PASSBACK_VALID(HMC7044_PASSBACK_VALID)
    );
endmodule
