`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 13:56:08
// Design Name: 
// Module Name: tb_rom_test
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


module tb_rom_test();
reg    clk_7044_100m;
reg    data_flag;

initial begin
	clk_7044_100m = 0;
	data_flag = 0;
	#1500000;
	data_flag = 1;
	#50;
	data_flag = 0;
	#1500000;
	data_flag = 1;
	#50;
	data_flag = 0;
	#1500000;
	data_flag = 1;
	#50;
	data_flag = 0;
	#1500000;
	data_flag = 1;
	#50;
	data_flag = 0;
	#1500000;
    data_flag <=1;
    #50;
    data_flag <= 0;
    #1500000;
    data_flag <=1;
    #50;
    data_flag <= 0;
    #1500000;
    data_flag <= 1;
    #50;
    data_flag <= 0;
end

always #5 clk_7044_100m = ~clk_7044_100m;

data_rom_test data_rom_test(
     .clk_7044_100m(clk_7044_100m),
     .data_flag(data_flag)
	);
endmodule
