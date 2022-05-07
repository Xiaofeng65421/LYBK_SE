`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/16 16:45:45
// Design Name: 
// Module Name: tb_lybk_xgmii_send
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


module tb_lybk_xgmii_send();

   reg   DATAPKG_VALID  = 0;
   reg   xgmii_clk = 0;
   reg  [8:0] cnt = 0;
   reg  [63:0] FPGA_DATAPKG;
   reg  [7:0]  FPGA_ID;
   reg [2:0] add = 0;

      wire [63:0]  FPGA1_AURORA_DATAPKG;
   wire         FPGA1_AURORA_VALID;

      wire [63:0]  FPGA2_AURORA_DATAPKG;
   wire         FPGA2_AURORA_VALID;

      wire [63:0]  FPGA3_AURORA_DATAPKG;
   wire         FPGA3_AURORA_VALID;

      wire [63:0]  FPGA4_AURORA_DATAPKG;
   wire         FPGA4_AURORA_VALID;

      wire [63:0]  FPGA5_AURORA_DATAPKG;
   wire         FPGA5_AURORA_VALID;

      wire [63:0]  FPGA6_AURORA_DATAPKG;
   wire         FPGA6_AURORA_VALID;

      wire [63:0]  FPGA7_AURORA_DATAPKG;
   wire         FPGA7_AURORA_VALID;

      wire [63:0]  FPGA8_AURORA_DATAPKG;
   wire         FPGA8_AURORA_VALID;

      wire [63:0]  FPGA9_AURORA_DATAPKG;
   wire         FPGA9_AURORA_VALID;

      wire [63:0]  FPGA10_AURORA_DATAPKG;
   wire         FPGA10_AURORA_VALID;

      wire [63:0]  FPGA11_AURORA_DATAPKG;
   wire         FPGA11_AURORA_VALID;

      wire [63:0]  FPGA12_AURORA_DATAPKG;
   wire         FPGA12_AURORA_VALID;

      wire [63:0]  FPGA13_AURORA_DATAPKG;
   wire         FPGA13_AURORA_VALID;

      wire [63:0]  FPGA14_AURORA_DATAPKG;
   wire         FPGA14_AURORA_VALID;

      wire [63:0]  FPGA15_AURORA_DATAPKG;
   wire         FPGA15_AURORA_VALID;

   always #5 xgmii_clk = ~xgmii_clk;

   always @(posedge xgmii_clk)
     cnt <= cnt + 1;

   always @(posedge xgmii_clk)
     if (&cnt) begin
       	add <= add + 1;
       end  

  always @(posedge xgmii_clk)
      if ((cnt >= 20)&&(cnt <= 400)) begin
           	FPGA_ID <= 5 + add;
        	DATAPKG_VALID <= 1;
        	FPGA_DATAPKG <= {$random} %1000;
        end  else if (cnt == 401) begin
        	DATAPKG_VALID <= 0;
        	FPGA_DATAPKG <= 0;
        end  



lybk_xgmii_send lybk_xgmii_send_inst(
     .FPGA_DATAPKG(FPGA_DATAPKG),
     .FPGA_DATAPKG_VALID(DATAPKG_VALID),
     .FPGA_ID(FPGA_ID),

     .FPGA1_AURORA_DATAPKG(FPGA1_AURORA_DATAPKG),
     .FPGA1_AURORA_VALID(FPGA1_AURORA_VALID),

     .FPGA2_AURORA_DATAPKG(FPGA2_AURORA_DATAPKG),
     .FPGA2_AURORA_VALID(FPGA2_AURORA_VALID),

     .FPGA3_AURORA_DATAPKG(FPGA3_AURORA_DATAPKG),
     .FPGA3_AURORA_VALID(FPGA3_AURORA_VALID),
     
     .FPGA4_AURORA_DATAPKG(FPGA4_AURORA_DATAPKG),
     .FPGA4_AURORA_VALID(FPGA4_AURORA_VALID),

     .FPGA5_AURORA_DATAPKG(FPGA5_AURORA_DATAPKG),
     .FPGA5_AURORA_VALID(FPGA5_AURORA_VALID),

     .FPGA6_AURORA_DATAPKG(FPGA6_AURORA_DATAPKG),
     .FPGA6_AURORA_VALID(FPGA6_AURORA_VALID),

     .FPGA7_AURORA_DATAPKG(FPGA7_AURORA_DATAPKG),
     .FPGA7_AURORA_VALID(FPGA7_AURORA_VALID),

     .FPGA8_AURORA_DATAPKG(FPGA8_AURORA_DATAPKG),
     .FPGA8_AURORA_VALID(FPGA8_AURORA_VALID),

     .FPGA9_AURORA_DATAPKG(FPGA9_AURORA_DATAPKG),
     .FPGA9_AURORA_VALID(FPGA9_AURORA_VALID),

     .FPGA10_AURORA_DATAPKG(FPGA10_AURORA_DATAPKG),
     .FPGA10_AURORA_VALID(FPGA10_AURORA_VALID),

     .FPGA11_AURORA_DATAPKG(FPGA11_AURORA_DATAPKG),
     .FPGA11_AURORA_VALID(FPGA11_AURORA_VALID),

     .FPGA12_AURORA_DATAPKG(FPGA12_AURORA_DATAPKG),
     .FPGA12_AURORA_VALID(FPGA12_AURORA_VALID),

     .FPGA13_AURORA_DATAPKG(FPGA13_AURORA_DATAPKG),
     .FPGA13_AURORA_VALID(FPGA13_AURORA_VALID),

     .FPGA14_AURORA_DATAPKG(FPGA14_AURORA_DATAPKG),
     .FPGA14_AURORA_VALID(FPGA14_AURORA_VALID),

     .FPGA15_AURORA_DATAPKG(FPGA15_AURORA_DATAPKG),
     .FPGA15_AURORA_VALID(FPGA15_AURORA_VALID)

    );
endmodule
