`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/24 13:54:57
// Design Name: 
// Module Name: CrossClkEvent
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


module CrossClkEvent(
       input    wire    clka, clkb,
       input    wire    in,
       output   wire    busy,
       output   wire    out
    );
        reg     ra0 = 0, ra1 = 0, ra2 = 0;
        reg     rb0 = 0, rb1 = 0, rb2 = 0;
        
        always @(posedge clka) begin
                if(in) ra0 <= 1'b1;
                else if(ra2) ra0 <= 1'b0;
        end
        
        always @(posedge clka) begin
                {ra2, ra1} <= {ra1, rb1};   
        end
        
        assign busy = ra0 | ra2;
        
        always @(posedge clkb) begin
                {rb2, rb1, rb0} <= {rb1, rb0, ra0};
        end
        
        assign out = rb1 & ~rb2;
        
        
endmodule
