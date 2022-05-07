`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 11:36:50
// Design Name: 
// Module Name: TrigOkOut
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


module TrigOkOut #(
        parameter  FILTALUE = 4'd10,
        parameter  TRIGLENGTH = 4'd15
    )(
        input   wire    clk,
        input   wire    rst,
        input   wire    TrigIn,
        output  wire    TrigOut,
        output  wire    TRigOk
    );
        
        wire            trigen;
        assign TrigOut = trigen;
        
        TrigInFilter #(.LEGTH(FILTALUE - 2'd2)) theTrigInFilter(
            .clk(clk),
            .rst(rst),
            .TrigIn(TrigIn),
            .TrigIn_vald(trigen));
            
        TrigOut #(.M(15)) theTrigOkOut(
            .clk(clk),
            .rst(rst),
            .trigen(trigen),            // ´¥·¢Ê¹ÄÜ
            .sma_trigfanout(TRigOk));   // TRiggerOk
            
endmodule