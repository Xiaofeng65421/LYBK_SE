`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 09:41:43
// Design Name: 
// Module Name: UartTx
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


module UartTx #(
        parameter   BR_DIV = 1736,  // 115200 @200MHz
        parameter   PARITY = 0    // parity: 0 - none, 1 - odd,
    )(
        input   wire    clk, rst,
        input   wire    [7:0]   din,
        input   wire    start,
        output  logic    busy,
        output  logic    txd
    );
        localparam [3:0]    BC_MAX = PARITY? 4'd10: 4'd9;
        logic br_en, bit_co;
        Counter #(BR_DIV) theBrCnt(clk, rst, start | busy, , br_en);
        Counter #(BC_MAX) theBitCnt(clk, rst, br_en, , bit_co);
        // busy driven
        always_ff@(posedge clk) begin
            if(rst) busy <= 1'b0;
            else if(bit_co) busy <= 1'b0;
            else if(start) busy <= 1'b1;
        end 
        // shift_reg & parity
        logic [10:0] shift_reg;
        always_ff@(posedge clk) begin
            if(rst) shift_reg <= '1;
            else if(start & ~busy) begin
                case(PARITY)
                    1: shift_reg <= {1'b1, ^din, din, 1'b0};
                    2: shift_reg <= {1'b1, ~^din, din, 1'b0};
                    default: shift_reg <= {2'b11,din, 1'b0};
                endcase
            end
            else if(br_en) shift_reg <= shift_reg >> 1;
        end
        
        // txd output 
        always_ff @(posedge clk) begin
            if(~busy) txd <= 1'b1;
            else txd <= shift_reg[0];
        end
              
endmodule
