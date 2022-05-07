`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/31 12:29:44
// Design Name: 
// Module Name: d2s_port
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


module d2s_port#(
    parameter NUM = 16
	)(
     output  [NUM - 1 : 0]   single_signal,
     input   [NUM - 1 : 0]   double_signal_p,
     input   [NUM - 1 : 0]   double_signal_n
    );

    generate
    	genvar i;
    	for(i = 0;i < NUM;i = i + 1)begin : d2s
     IBUFDS IBUFDS_inst (
      .O(single_signal[i]),  // Buffer output
      .I(double_signal_p[i]),  // Diff_p buffer input (connect directly to top-level port)
      .IB(double_signal_n[i]) // Diff_n buffer input (connect directly to top-level port)
   );
    	end
    endgenerate
endmodule
