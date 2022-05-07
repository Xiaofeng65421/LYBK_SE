`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 14:14:45
// Design Name: 
// Module Name: Falling2En
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


module Falling2En #(
        parameter   SYNC_STG = 1
    )( 
        input   wire    clk, in,
        output  logic    en, out
    );
        logic  [SYNC_STG:0]     dly;
        always_ff@(posedge clk) begin
            dly <= {dly[SYNC_STG - 1:0], in};
        end
        assign en = {SYNC_STG? dly[SYNC_STG -:2]:{dly, in}} == 2'b10;
        assign out = dly[SYNC_STG];
endmodule
