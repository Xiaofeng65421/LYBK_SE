`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/02/24 14:26:25
// Design Name: 
// Module Name: CrossClkData
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


module CrossClkData#(
    parameter DATA_WIDTH = 32
	)(
    input    wire           clka, clkb,
    input    wire           read,
    input    wire   [DATA_WIDTH - 1 :0]   data_in,
    output   wire   [DATA_WIDTH - 1 :0]   data_out,
    output   wire           data_out_veld
    );
    
    wire    busy, en;
    reg     [DATA_WIDTH - 1:0]    data_reg = 0;
    
    
    always_ff @(posedge clka)begin
         if(~busy) data_reg <= data_in;
            else data_reg <= data_reg;    
        
    end
    
    CrossClkEvent theCrossClkEvent(
       .clka(clka), 
       .clkb(clkb),
       .in(read),   // 读信号从clka 传到 clkb.
       .busy(busy),
       .out(out));
     
     Rising2En #(.SYNC_STG(1)) theRising2En(.clk(clkb), .in(out),.en(en), .out());
     
     assign data_out = (en)?data_reg: 'd0;
     assign data_out_veld = en;
     
endmodule 