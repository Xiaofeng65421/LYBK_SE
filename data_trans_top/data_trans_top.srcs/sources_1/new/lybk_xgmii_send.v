`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/31 11:50:45
// Design Name: 
// Module Name: lybk_xgmii_send
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


module lybk_xgmii_send(
     input  [63:0] FPGA_DATAPKG,
     input         FPGA_DATAPKG_VALID,
     input  [7:0]  FPGA_ID,

     output [63:0] FPGA1_AURORA_DATAPKG,
     output        FPGA1_AURORA_VALID,

     output [63:0] FPGA2_AURORA_DATAPKG,
     output        FPGA2_AURORA_VALID,

     output [63:0] FPGA3_AURORA_DATAPKG,
     output        FPGA3_AURORA_VALID,
     
     output [63:0] FPGA4_AURORA_DATAPKG,
     output        FPGA4_AURORA_VALID,

     output [63:0] FPGA5_AURORA_DATAPKG,
     output        FPGA5_AURORA_VALID,

     output [63:0] FPGA6_AURORA_DATAPKG,
     output        FPGA6_AURORA_VALID,

     output [63:0] FPGA7_AURORA_DATAPKG,
     output        FPGA7_AURORA_VALID,

     output [63:0] FPGA8_AURORA_DATAPKG,
     output        FPGA8_AURORA_VALID,

     output [63:0] FPGA9_AURORA_DATAPKG,
     output        FPGA9_AURORA_VALID,

     output [63:0] FPGA10_AURORA_DATAPKG,
     output        FPGA10_AURORA_VALID,

     output [63:0] FPGA11_AURORA_DATAPKG,
     output        FPGA11_AURORA_VALID,

     output [63:0] FPGA12_AURORA_DATAPKG,
     output        FPGA12_AURORA_VALID,

     output [63:0] FPGA13_AURORA_DATAPKG,
     output        FPGA13_AURORA_VALID,

     output [63:0] FPGA14_AURORA_DATAPKG,
     output        FPGA14_AURORA_VALID,

     output [63:0] FPGA15_AURORA_DATAPKG,
     output        FPGA15_AURORA_VALID,

     output [63:0] FPGA16_AURORA_DATAPKG,
     output        FPGA16_AURORA_VALID

    );

    assign FPGA1_AURORA_VALID = (FPGA_ID == 1)? FPGA_DATAPKG_VALID : 0;
    assign FPGA1_AURORA_DATAPKG = (FPGA_ID == 1)? FPGA_DATAPKG : 0;

    assign FPGA2_AURORA_VALID = (FPGA_ID == 2)? FPGA_DATAPKG_VALID : 0;
    assign FPGA2_AURORA_DATAPKG = (FPGA_ID == 2)? FPGA_DATAPKG : 0;

    assign FPGA3_AURORA_VALID = (FPGA_ID == 3)? FPGA_DATAPKG_VALID : 0;
    assign FPGA3_AURORA_DATAPKG = (FPGA_ID == 3)? FPGA_DATAPKG : 0;

    assign FPGA4_AURORA_VALID = (FPGA_ID == 4)? FPGA_DATAPKG_VALID : 0;
    assign FPGA4_AURORA_DATAPKG = (FPGA_ID == 4)? FPGA_DATAPKG : 0;

    assign FPGA5_AURORA_VALID = (FPGA_ID == 9)? FPGA_DATAPKG_VALID : 0;
    assign FPGA5_AURORA_DATAPKG = (FPGA_ID == 9)? FPGA_DATAPKG : 0;

    assign FPGA6_AURORA_VALID = (FPGA_ID == 10)? FPGA_DATAPKG_VALID : 0;
    assign FPGA6_AURORA_DATAPKG = (FPGA_ID == 10)? FPGA_DATAPKG : 0;

    assign FPGA7_AURORA_VALID = (FPGA_ID == 16)? FPGA_DATAPKG_VALID : 0;
    assign FPGA7_AURORA_DATAPKG = (FPGA_ID == 16)? FPGA_DATAPKG : 0;

    assign FPGA8_AURORA_VALID = (FPGA_ID == 15)? FPGA_DATAPKG_VALID : 0;
    assign FPGA8_AURORA_DATAPKG = (FPGA_ID == 15)? FPGA_DATAPKG : 0;

    assign FPGA9_AURORA_VALID = (FPGA_ID == 11)? FPGA_DATAPKG_VALID : 0;
    assign FPGA9_AURORA_DATAPKG = (FPGA_ID == 11)? FPGA_DATAPKG : 0;

    assign FPGA10_AURORA_VALID = (FPGA_ID == 12)? FPGA_DATAPKG_VALID : 0;
    assign FPGA10_AURORA_DATAPKG = (FPGA_ID == 12)? FPGA_DATAPKG : 0;

    assign FPGA11_AURORA_VALID = (FPGA_ID == 13)? FPGA_DATAPKG_VALID : 0;
    assign FPGA11_AURORA_DATAPKG = (FPGA_ID == 13)? FPGA_DATAPKG : 0;

    assign FPGA12_AURORA_VALID = (FPGA_ID == 14)? FPGA_DATAPKG_VALID : 0;
    assign FPGA12_AURORA_DATAPKG = (FPGA_ID == 14)? FPGA_DATAPKG : 0;

    assign FPGA13_AURORA_VALID = (FPGA_ID == 5)? FPGA_DATAPKG_VALID : 0;
    assign FPGA13_AURORA_DATAPKG = (FPGA_ID == 5)? FPGA_DATAPKG : 0;

    assign FPGA14_AURORA_VALID = (FPGA_ID == 6)? FPGA_DATAPKG_VALID : 0;
    assign FPGA14_AURORA_DATAPKG = (FPGA_ID == 6)? FPGA_DATAPKG : 0;

    assign FPGA15_AURORA_VALID = (FPGA_ID == 7)? FPGA_DATAPKG_VALID : 0;
    assign FPGA15_AURORA_DATAPKG = (FPGA_ID == 7)? FPGA_DATAPKG : 0;
    
    assign FPGA16_AURORA_VALID = (FPGA_ID == 8)? FPGA_DATAPKG_VALID : 0;
    assign FPGA16_AURORA_DATAPKG = (FPGA_ID == 8)? FPGA_DATAPKG : 0;
endmodule
