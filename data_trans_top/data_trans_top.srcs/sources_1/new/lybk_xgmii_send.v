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

     input  [63:0] BK_ORDER_DATAPKG,
     input         BK_ORDER_DATAPKG_VALID,

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

    assign FPGA1_AURORA_VALID = ((FPGA_ID == 1)? FPGA_DATAPKG_VALID : 0) | BK_ORDER_DATAPKG_VALID;
    assign FPGA1_AURORA_DATAPKG = ((FPGA_ID == 1)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA2_AURORA_VALID = ((FPGA_ID == 2)? FPGA_DATAPKG_VALID : 0) | BK_ORDER_DATAPKG_VALID;
    assign FPGA2_AURORA_DATAPKG = ((FPGA_ID == 2)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA3_AURORA_VALID = ((FPGA_ID == 3)? FPGA_DATAPKG_VALID : 0) | BK_ORDER_DATAPKG_VALID;
    assign FPGA3_AURORA_DATAPKG = ((FPGA_ID == 3)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA4_AURORA_VALID = ((FPGA_ID == 4)? FPGA_DATAPKG_VALID : 0) | BK_ORDER_DATAPKG_VALID;
    assign FPGA4_AURORA_DATAPKG = ((FPGA_ID == 4)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA5_AURORA_VALID = ((FPGA_ID == 9)? FPGA_DATAPKG_VALID : 0) | BK_ORDER_DATAPKG_VALID;
    assign FPGA5_AURORA_DATAPKG = ((FPGA_ID == 9)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA6_AURORA_VALID = ((FPGA_ID == 10)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA6_AURORA_DATAPKG = ((FPGA_ID == 10)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA7_AURORA_VALID = ((FPGA_ID == 16)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA7_AURORA_DATAPKG = ((FPGA_ID == 16)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA8_AURORA_VALID = ((FPGA_ID == 15)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA8_AURORA_DATAPKG = ((FPGA_ID == 15)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA9_AURORA_VALID = ((FPGA_ID == 11)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA9_AURORA_DATAPKG = ((FPGA_ID == 11)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA10_AURORA_VALID =((FPGA_ID == 12)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA10_AURORA_DATAPKG = ((FPGA_ID == 12)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA11_AURORA_VALID = ((FPGA_ID == 13)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA11_AURORA_DATAPKG = ((FPGA_ID == 13)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA12_AURORA_VALID = ((FPGA_ID == 14)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA12_AURORA_DATAPKG = ((FPGA_ID == 14)? FPGA_DATAPKG : 0)| BK_ORDER_DATAPKG;

    assign FPGA13_AURORA_VALID = ((FPGA_ID == 5)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA13_AURORA_DATAPKG = ((FPGA_ID == 5)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA14_AURORA_VALID = ((FPGA_ID == 6)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA14_AURORA_DATAPKG = ((FPGA_ID == 6)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;

    assign FPGA15_AURORA_VALID = ((FPGA_ID == 7)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA15_AURORA_DATAPKG = ((FPGA_ID == 7)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;
    
    assign FPGA16_AURORA_VALID = ((FPGA_ID == 8)? FPGA_DATAPKG_VALID : 0)| BK_ORDER_DATAPKG_VALID;
    assign FPGA16_AURORA_DATAPKG = ((FPGA_ID == 8)? FPGA_DATAPKG : 0) | BK_ORDER_DATAPKG;
endmodule
