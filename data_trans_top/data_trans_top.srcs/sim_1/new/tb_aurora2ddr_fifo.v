`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/03 17:18:47
// Design Name: 
// Module Name: tb_aurora2ddr_fifo
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


module tb_aurora2ddr_fifo();

reg   wr_clk;
reg   rd_clk;
reg   rst;
reg  [63:0] din;
reg   wr_start;
reg   wr_en;
wire  rd_en;
wire [511:0] dout;
wire  full;
wire  empty;
wire  prog_full;
wire  wr_rst_busy;
wire  rd_rst_busy;

wire [63:0]  dout_p1;
wire [63:0]  dout_p2;
wire [63:0]  dout_p3;
wire [63:0]  dout_p4;
wire [63:0]  dout_p5;
wire [63:0]  dout_p6;
wire [63:0]  dout_p7;
wire [63:0]  dout_p8;

assign dout_p1 = dout[64 * 1 - 1 : 0 + 64 * 0];
assign dout_p2 = dout[64 * 2 - 1 : 0 + 64 * 1];
assign dout_p3 = dout[64 * 3 - 1 : 0 + 64 * 2];
assign dout_p4 = dout[64 * 4 - 1 : 0 + 64 * 3];
assign dout_p5 = dout[64 * 5 - 1 : 0 + 64 * 4];
assign dout_p6 = dout[64 * 6 - 1 : 0 + 64 * 5];
assign dout_p7 = dout[64 * 7 - 1 : 0 + 64 * 6];
assign dout_p8 = dout[64 * 8 - 1 : 0 + 64 * 7];


initial begin
	wr_clk <= 0;
	rd_clk <= 0;
end

always #3.2 wr_clk = ~wr_clk;
always #3.2 rd_clk = ~rd_clk;

initial begin
	rst <= 1;
	wr_start <= 0;
	#100;
	rst <= 0;
	#500;
	wr_start <= 1;
	din <= 0;
end

always @(posedge wr_clk)
   wr_en <= wr_start;


always @(posedge wr_clk)
   if (wr_en) begin
   	   din <= din + 1;
   end

//--------------add------------------// 
wire   p_full;
reg    rd_valid = 0;
reg [3:0] rd_l_cnt;
assign p_full = (~full)? prog_full : 0; 

always @(posedge rd_clk)
    if (p_full) begin
    	rd_valid <= 1;
    end else if (rd_l_cnt == 11) begin
    	rd_valid <= 0;
    end

always @(posedge rd_clk)
    if (rd_valid) begin
    	rd_l_cnt <= rd_l_cnt + 1;
    end else begin
    	rd_l_cnt <= 0;
    end

assign rd_en = rd_valid; 

aurora2ddr_fifo aurora2ddr_fifo (
  .rst(rst),                  // input wire rst
  .wr_clk(wr_clk),            // input wire wr_clk
  .rd_clk(rd_clk),            // input wire rd_clk
  .din(din),                  // input wire [63 : 0] din
  .wr_en(wr_en),              // input wire wr_en
  .rd_en(rd_en),              // input wire rd_en
  .dout(dout),                // output wire [511 : 0] dout
  .full(full),                // output wire full
  .empty(empty),              // output wire empty
  .prog_full(prog_full),      // output wire prog_full
  .wr_rst_busy(wr_rst_busy),  // output wire wr_rst_busy
  .rd_rst_busy(rd_rst_busy)  // output wire rd_rst_busy
);




endmodule
