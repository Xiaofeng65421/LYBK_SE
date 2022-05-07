`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 18:53:34
// Design Name: 
// Module Name: tb_sync_test
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


module tb_sync_test();

reg    start;
reg    start_flag;
reg    stop;
reg    clk_100M;
reg    [3:0]  sync_trig_delay;
reg    [3:0]  trig_length;
reg    [5:0]  sync_length;

wire [10:0]  TRIGGER0_P;
wire [10:0]  TRIGGER0_N;
wire [3:0]  TRIGGER1_P;
wire [3:0]  TRIGGER1_N;

initial begin
    sync_trig_delay = 7;
    trig_length = 6;
    sync_length = 11;
	start = 0;
	start_flag = 0;
	stop = 0;
	clk_100M = 0;
	#100;
	start_flag = 1;
	#100;
	start_flag = 0;
	#1000;
	start = 1;
    #1000;
    start = 0;
    #1000;
    start = 1;
    #500;
    start = 0;
    #300;
    stop = 1;
    #200;
    stop = 0;
end

always #5  clk_100M = ~clk_100M;

sync_test sync_test_inst(

        .start(start),
        .start_flag(start_flag),
        .stop(stop),
        .clk_100M(clk_100M),
        .sync_trig_delay(sync_trig_delay),
        .trig_length(trig_length),
        .sync_length(sync_length),	

        .TRIGGER0_P(TRIGGER0_P),
        .TRIGGER0_N(TRIGGER0_N),         
        .TRIGGER1_P(TRIGGER1_P),
        .TRIGGER1_N(TRIGGER1_N) 


	);
endmodule
