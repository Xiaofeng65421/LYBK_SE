`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/15 14:14:03
// Design Name: 
// Module Name: trigger_delay
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


module trigger_delay(
     CLK_300M,
     RST,
     TRIGGER_SEND,
     TRIGGER_BACK,
     DELAY_CNT
 );
    input                CLK_300M;
    input                RST;
    input                TRIGGER_SEND;
    input                TRIGGER_BACK;
    output  reg  [31:0]  DELAY_CNT;
 
    reg                  delay_en = 0;

   always @(posedge CLK_300M)
      if (RST) begin
       	  delay_en <= 0;
       end  else if (TRIGGER_SEND) begin
       	  delay_en <= 1;
       end  else if (TRIGGER_BACK) begin
       	  delay_en <= 0;
       end

   always @(posedge CLK_300M)
      if (RST) begin
      	 DELAY_CNT <= 0;
      end else if (&DELAY_CNT) begin
      	 DELAY_CNT <= DELAY_CNT;
      end else if (delay_en) begin
      	 DELAY_CNT <= DELAY_CNT + 1;
      end

endmodule
