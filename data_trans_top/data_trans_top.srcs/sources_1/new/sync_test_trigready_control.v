`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/12 11:38:42
// Design Name: 
// Module Name: sync_test_trigready_control
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


module sync_test_trigready_control(
	   input         XGMII_CLK,
       input  [7:0]  ORDER_TYPE,
       input  [14:0] FPGA_READY,
       input         ZKBK_TRIGGER,
      
       output [14:0] TO_FPGA_TRIGGER,
       output        TO_ZKBK_READY        
    );
       wire     to_zkbk_ready;
       reg      to_zkbk_ready_pre = 0;

       always @(posedge XGMII_CLK)
          to_zkbk_ready_pre <= to_zkbk_ready;

       assign TO_ZKBK_READY = to_zkbk_ready & (~to_zkbk_ready_pre);
       assign to_zkbk_ready = (ORDER_TYPE == 8'h05)?(&FPGA_READY)? 1 : 0 : 0 ;
       assign TO_FPGA_TRIGGER = (ORDER_TYPE == 8'h05)?{15{ZKBK_TRIGGER}} : 0 ;

endmodule
