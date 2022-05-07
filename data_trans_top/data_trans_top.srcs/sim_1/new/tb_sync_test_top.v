`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/14 10:23:42
// Design Name: 
// Module Name: tb_sync_test_top
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


module tb_sync_test_top();

      reg    XGMII_CLK;
      reg    RST_N;
      reg [7:0] ORDER_TYPE;
      reg [7:0] WORK_MODE;

      reg [63:0] SYNC_TEST_DATA;
      reg        TEST_DATA_VALID;
      reg [14:0] FPGA_READY;
      reg        ZKBK_TRIGGER;

      reg [64*15 -1:0] FPGA_PASSBACK;
      reg [14:0] PASSBACK_VALID;

      wire [14:0] TO_FPGA_TRIGGER;
      wire        TO_ZKBK_READY;
      wire [63:0] HMC7044_PASSBACK;
      wire        HMC7044_PASSBACK_VALID;
                                 ///AWG
      wire [63:0] AURORA_FPGA1;
      wire [63:0] AURORA_FPGA2;
      wire [63:0] AURORA_FPGA3;
      wire [63:0] AURORA_FPGA4;
      wire [63:0] AURORA_FPGA5;
      wire [63:0] AURORA_FPGA6;
      wire [63:0] AURORA_FPGA7;
      wire        AURORA_AWG_VALID;
                               ///DA
      wire [63:0] AURORA_FPGA8;
      wire [63:0] AURORA_FPGA9;
      wire [63:0] AURORA_FPGA10;
      wire [63:0] AURORA_FPGA11;
      wire [63:0] AURORA_FPGA12;
      wire [63:0] AURORA_FPGA13;
      wire [63:0] AURORA_FPGA14;
      wire        AURORA_DA_VALID;
                               ////AD
      wire [63:0] AURORA_FPGA15;
      wire        AURORA_AD_VALID;

      reg [15:0] cnt;

      initial begin
      	XGMII_CLK <= 0;
      	RST_N <= 1;
      	ORDER_TYPE <= 8'h05;
      	WORK_MODE <= 8'haa;
      	FPGA_READY <= 0;
      	ZKBK_TRIGGER <= 0;
      	PASSBACK_VALID <= 0;
      	FPGA_PASSBACK <= 0;

        cnt <= 0;
      end

      always #5 XGMII_CLK <= ~XGMII_CLK;

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
         end else if ((cnt >= 20) && (cnt < 160)) begin
         	 TEST_DATA_VALID <= 1;
             SYNC_TEST_DATA <= $random % 2000;
         end else if (cnt == 160) begin
         	 TEST_DATA_VALID <= 0;
         end else if (cnt == 170) begin
         	 FPGA_READY <= 15'h3abc;
         end else if (cnt == 175) begin
         	 FPGA_READY <= 15'h7fff;
         end else if (cnt == 250) begin
         	 ZKBK_TRIGGER <= 1;
         end else if (cnt == 252) begin
         	 ZKBK_TRIGGER <= 0;
         end else if (cnt == 300 || cnt == 301)begin
         	PASSBACK_VALID[0] <= 1;
         	FPGA_PASSBACK[63:0] <= 100;
         end else if (cnt == 302 || cnt == 303) begin
            PASSBACK_VALID[0] <= 0;
         	PASSBACK_VALID[1] <= 1;
         	FPGA_PASSBACK[63:0] <= 0;
         	FPGA_PASSBACK[127:64] <=200;
         end else if (cnt == 304) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 310 || cnt == 311) begin
         	PASSBACK_VALID[1:0] <= 0;
         	PASSBACK_VALID[2] <= 1;
         	FPGA_PASSBACK[127:0] <= 0;
         	FPGA_PASSBACK[191:128] <= 300;
         end else if (cnt == 312) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 320 || cnt == 321) begin
         	PASSBACK_VALID[2:0] <= 0;
         	PASSBACK_VALID[3] <= 1;
         	FPGA_PASSBACK[191:0] <= 0;
         	FPGA_PASSBACK[255:192] <= 400;
         end else if (cnt == 322 || cnt == 323) begin
         	PASSBACK_VALID[3:0] <= 0;
         	PASSBACK_VALID[4] <= 1;
         	FPGA_PASSBACK[4*64 -1 : 0] <= 0;
         	FPGA_PASSBACK[5*64 -1 : 4*64] <= 500;
         end else if (cnt == 324 || cnt == 325) begin
         	PASSBACK_VALID[4:0] <= 0;
         	PASSBACK_VALID[5] <= 1;
         	FPGA_PASSBACK[5*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[6*64 - 1 :5*64] <= 600;
         end else if (cnt == 326 || cnt == 327) begin
         	PASSBACK_VALID[5:0] <= 0;
         	PASSBACK_VALID[6] <= 1;
         	FPGA_PASSBACK[6*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[7*64-1 : 6*64] <= 700;
         end else if (cnt == 328 || cnt == 329) begin
         	PASSBACK_VALID[6:0] <= 0;
         	PASSBACK_VALID[7] <= 1;
         	FPGA_PASSBACK[7*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[8*64-1 : 7*64] <= 800;
         end else if (cnt == 330) begin
         	PASSBACK_VALID <= 0;
         end 
         else if (cnt == 350 || cnt == 351) begin
         	PASSBACK_VALID[7:0] <= 0;
         	PASSBACK_VALID[8] <= 1;
         	FPGA_PASSBACK[8*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[9*64-1 : 8*64] <= 900;
         end else if (cnt == 352 || cnt == 353) begin
         	PASSBACK_VALID[8:0] <= 0;
         	PASSBACK_VALID[9] <= 1;
         	FPGA_PASSBACK[9*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[10*64-1 : 9*64] <= 1000;
         end else if (cnt == 354 || cnt == 355) begin
         	PASSBACK_VALID[9:0] <= 0;
         	PASSBACK_VALID[10] <= 1;
         	FPGA_PASSBACK[10*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[11*64-1 : 10*64] <= 1100;
         end else if (cnt == 356 || cnt == 357) begin
         	PASSBACK_VALID[10:0] <= 0;
         	PASSBACK_VALID[11] <= 1;
         	FPGA_PASSBACK[11*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[12*64-1 : 11*64] <= 1200;
         end else if (cnt == 358 || cnt == 359) begin
         	PASSBACK_VALID[11:0] <= 0;
         	PASSBACK_VALID[12] <= 1;
         	FPGA_PASSBACK[12*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[13*64-1 : 12*64] <= 1300;
         end else if (cnt == 360 || cnt == 361) begin
         	PASSBACK_VALID[12:0] <= 0;
         	PASSBACK_VALID[13] <= 1;
         	FPGA_PASSBACK[13*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[14*64-1 : 13*64] <= 1400;
         end else if (cnt == 362 || cnt == 363) begin
         	PASSBACK_VALID[13:0] <= 0;
         	PASSBACK_VALID[14] <= 1;
         	FPGA_PASSBACK[14*64 - 1 :0] <= 0;
         	FPGA_PASSBACK[15*64-1 : 14*64] <= 1500;
         end else if (cnt == 364) begin
         	PASSBACK_VALID <= 0;
         	FPGA_PASSBACK <= 0;
         end

sync_test_top sync_test_top_inst(
      .XGMII_CLK(XGMII_CLK),
      .RST_N(RST_N),
      .ORDER_TYPE(ORDER_TYPE),
      .WORK_MODE(WORK_MODE),

      .SYNC_TEST_DATA(SYNC_TEST_DATA),
      .TEST_DATA_VALID(TEST_DATA_VALID),
      .FPGA_READY(FPGA_READY),
      .ZKBK_TRIGGER(ZKBK_TRIGGER),

      .FPGA_PASSBACK(FPGA_PASSBACK),
      .PASSBACK_VALID(PASSBACK_VALID),

      .TO_FPGA_TRIGGER(TO_FPGA_TRIGGER),
      .TO_ZKBK_READY(TO_ZKBK_READY),
      .HMC7044_PASSBACK(HMC7044_PASSBACK),
      .HMC7044_PASSBACK_VALID(HMC7044_PASSBACK_VALID),
                  ///AWG
      .AURORA_FPGA1(AURORA_FPGA1),
      .AURORA_FPGA2(AURORA_FPGA2),
      .AURORA_FPGA3(AURORA_FPGA3),
      .AURORA_FPGA4(AURORA_FPGA4),
      .AURORA_FPGA5(AURORA_FPGA5),
      .AURORA_FPGA6(AURORA_FPGA6),
      .AURORA_FPGA7(AURORA_FPGA7),
      .AURORA_AWG_VALID(AURORA_AWG_VALID),
                  ///DA
      .AURORA_FPGA8(AURORA_FPGA8),
      .AURORA_FPGA9(AURORA_FPGA9),
      .AURORA_FPGA10(AURORA_FPGA10),
      .AURORA_FPGA11(AURORA_FPGA11),
      .AURORA_FPGA12(AURORA_FPGA12),
      .AURORA_FPGA13(AURORA_FPGA13),
      .AURORA_FPGA14(AURORA_FPGA14),
      .AURORA_DA_VALID(AURORA_DA_VALID),
                  ////AD
      .AURORA_FPGA15(AURORA_FPGA15),
      .AURORA_AD_VALID(AURORA_AD_VALID)
    );

endmodule
