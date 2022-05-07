`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 17:04:52
// Design Name: 
// Module Name: s2d_port
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


module s2d_port#(
    parameter NUM = 16
	)(
     input  [NUM - 1 : 0]   single_signal,
     output [NUM - 1 : 0]   double_signal_p,
     output [NUM - 1 : 0]   double_signal_n
    );

    generate
    	genvar i;
    	for(i = 0;i < NUM;i = i + 1)begin : s2d
     OBUFDS OBUFDS_inst(
      .O(double_signal_p[i]),     // Diff_p output (connect directly to top-level port)
      .OB(double_signal_n[i]),   // Diff_n output (connect directly to top-level port)
      .I(single_signal[i])      // Buffer input
    );
    	end
    endgenerate
endmodule
