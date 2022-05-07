`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 12:37:36
// Design Name: 
// Module Name: Counter
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


module Counter #(
        parameter   M = 100
    )(
        input   wire    clk, rst, en,
        output  logic   [$clog2(M) - 1:0]   cnt,
        output  logic   co
    );
        assign co = en & (cnt == M - 1);
        always_ff @(posedge clk) begin
            if(rst) cnt <= '0;
            else if(en) begin
                if(cnt < M - 1) cnt <= cnt + 1'b1;
                else cnt <= '0;
            end
        end
endmodule
