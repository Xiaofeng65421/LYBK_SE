`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/07 15:56:50
// Design Name: 
// Module Name: Rs422
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


module Rs422(
        input    wire    clk,
        input    wire    rst,
        output   wire    txd_p, 
        output   wire    txd_n,
        input    wire    rxd_p, 
        input    wire    rxd_n,
        input    wire    [7:0]   tx_data,
        input    wire            tx_data_valid,
        output   wire    [7:0]   rx_data,
        output   wire            rx_data_valid,
        output   wire            tx_fifo_empty       
    );
    
        wire     txd, rxd;     

      TestUart theTestUart(
        .clk(clk),
        .rst(rst), 
        .tx_data(tx_data),
        .tx_data_valid(tx_data_valid),
        .txd(txd), 
        .rxd(rxd),
        .rx_data(rx_data),
        .rx_data_valid(rx_data_valid),
        .tx_fifo_empty(tx_fifo_empty)
        ); 
     
        IBUFDS IBUFDS_rxd (
        .O(rxd),   // 1-bit output: Buffer output
        .I(rxd_p),   // 1-bit input: Diff_p buffer input (connect directly to top-level port)
        .IB(rxd_n));  // 1-bit input: Diff_n buffer input (connect directly to top-level port)

        OBUFDS OBUFDS_txd (
        .O(txd_p),   // 1-bit output: Diff_p output (connect directly to top-level port)
        .OB(txd_n), // 1-bit output: Diff_n output (connect directly to top-level port)
        .I(txd));    // 1-bit input: Buffer input
   
endmodule
