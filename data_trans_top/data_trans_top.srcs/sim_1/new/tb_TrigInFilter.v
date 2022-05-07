`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/07 14:51:10
// Design Name: 
// Module Name: tb_TrigInFilter
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


module tb_TrigInFilter();

reg  FPGA_READY;
reg  TRIGGER_CLK;
reg  RST_N;
wire fpga_ready_valid;

initial begin
	FPGA_READY = 0;
	TRIGGER_CLK = 0;
	RST_N = 1;
    #20;
    RST_N = 0;
    #50;
    RST_N = 1;
	#100;
	FPGA_READY = 1;
	#80;
	FPGA_READY = 0;
end


always #5 TRIGGER_CLK = ~TRIGGER_CLK;



 TrigInFilter #(.LEGTH(5)) theTrigInFilter(
     .clk(TRIGGER_CLK),
     .rst(~RST_N),
     .TrigIn(FPGA_READY),
     .TrigIn_vald(fpga_ready_valid)); 
endmodule
