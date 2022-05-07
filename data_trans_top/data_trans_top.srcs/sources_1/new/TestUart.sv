`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 19:02:15
// Design Name: 
// Module Name: TestUart
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

module TestUart(clk,rst,tx_data,tx_data_valid ,txd, rxd,rx_data,rx_data_valid,tx_fifo_empty); 
    input  wire  clk;
    input  wire  rst;
    input  wire  [7:0]   tx_data;
    input  wire  tx_data_valid;
(*mark_debug = "true"*)     output wire  txd;
(*mark_debug = "true"*)     input  wire  rxd;
    output wire  [7:0]   rx_data;
    output wire  rx_data_valid;
    output       tx_fifo_empty;

(*mark_debug = "true"*)       logic  [7:0]    tx_fifo_din, tx_fifo_dout;
      logic  [8:0]    rx_fifo_din;

      logic start, tx_busy, rx_busy, par_err;
      logic   rx_fifo_write;
(*mark_debug = "true"*)       wire   tx_fifo_write,tx_fifo_empty;
(*mark_debug = "true"*)       logic   tx_fifo_read,tx_fifo_read_r,tx_fifo_read_r1; 
                               wire    full;
      

(*mark_debug = "true"*)       assign  rx_data = rx_fifo_din;
(*mark_debug = "true"*)       assign  rx_data_valid = rx_fifo_write;
      assign  par_err = rx_fifo_din[8];
(*mark_debug = "true"*)       assign  tx_fifo_din = tx_data;
 (*mark_debug = "true"*)      assign  tx_fifo_write = tx_data_valid;


    always_ff @(posedge clk) tx_fifo_read_r <= tx_fifo_read;
    always_ff @(posedge clk) tx_fifo_read_r1 <= tx_fifo_read_r;

    uartfifo theuartfifo (
    .clk(clk),      // input wire clk
    .rst(rst),
    .din(tx_fifo_din),      // input wire [7 : 0] din
    .wr_en(tx_fifo_write),  // input wire wr_en
    .rd_en(tx_fifo_read),  // input wire rd_en
    .dout(tx_fifo_dout),    // output wire [7 : 0] dout
    .full(full),    // output wire full
    .empty(tx_fifo_empty));  // output wire empty

    Counter #(50*14)theuart(clk, rst, ~tx_fifo_empty, , tx_fifo_read);
    
    assign   start = tx_fifo_read_r1;
    
    UartTx #(50, 1) theUartTx(clk, rst, tx_fifo_dout, start, tx_busy, txd);
    UartRx #(50, 1) theUartRx(clk, rst, rxd, rx_fifo_din[7:0], rx_fifo_write, rx_fifo_din[8], rx_busy);
    
   
    
endmodule
