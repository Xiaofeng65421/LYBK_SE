`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/31 12:22:17
// Design Name: 
// Module Name: ready_trigger_port
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


module ready_trigger_port#(
   parameter NUM = 16 
	)(
	output[NUM-1 :0] fpga_ready,
	input [NUM-1 :0] trig_out,
	input [NUM-1 :0] sync_out,
    output[NUM-1 :0] TRIGGER_OUT_P,
    output[NUM-1 :0] TRIGGER_OUT_N,
    input [NUM-1 :0] FPGA_READY_P,
    input [NUM-1 :0] FPGA_READY_N     
    );

d2s_port #(.NUM(NUM)) ready_port(
    .single_signal(fpga_ready),
    .double_signal_p(FPGA_READY_P),
    .double_signal_n(FPGA_READY_N)
	);

s2d_port #(.NUM(NUM)) trigger_port(
    .single_signal(trig_out | sync_out),
    .double_signal_p(TRIGGER_OUT_P),
    .double_signal_n(TRIGGER_OUT_N)
	);
endmodule
