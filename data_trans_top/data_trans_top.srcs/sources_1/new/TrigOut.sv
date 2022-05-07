`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 14:25:11
// Design Name: 
// Module Name: TrigOut
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


module TrigOut #(
    parameter   M = 6'd45             // 触发长度
    )(
    input   wire    clk,
    input   wire    rst,
    input   wire    trigen,            // 触发使能
    output  wire    sma_trigfanout     // 触发
    );
    
    reg [5:0]   cnt_sma;
    
    assign sma_trigfanout = (cnt_sma > 0)? 1'b1: 1'b0;
    
    always_ff @(posedge clk) begin
        if(rst) cnt_sma <= 6'd0;
        else if(trigen)  cnt_sma <= M;
        else if(cnt_sma > 0) cnt_sma <= cnt_sma - 1'b1;
        else cnt_sma <= cnt_sma;
    end
    
endmodule
