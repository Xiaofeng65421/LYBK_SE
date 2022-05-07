`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 11:40:06
// Design Name: 
// Module Name: RouterReadyPackage
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


module RouterReadyPackage(
    input   wire            clk,
    input   wire            rst,
    input   wire    [7:0]   Rdy_id,
    input   wire            Rdy_id_vald,
    output  reg     [7:0]   tx_fifo_data,
    output  reg             tx_fifo_data_vald
    );
    localparam  [3:0]   BYTEM = 4'd7;
    
    localparam  [1:0]   IDEL = 2'b00;
    localparam  [1:0]   READY = 2'b01;
    localparam  [1:0]   WORK = 2'b10;
    localparam  [1:0]   WAITE = 2'b11;
    reg  [1:0]   state; 
    wire         co, codr;
    reg          cod;
    reg   [2:0]  cnt_co;
    reg  [7:0]  tx_data [0:6];
    
    
    
    always @(posedge clk) begin
        if(rst) tx_data <= '{0,0,0,0,0,0,0};
        else if(Rdy_id_vald) tx_data <= '{8'h01,Rdy_id,0,0,0,0,0};
        else tx_data <= tx_data;
    end
    
    always @(posedge clk) begin
        if(rst) cod <= 1'b0;
        else cod <= codr;
    end
    
    Counter #(.M(2)) theCouCenPack(.clk(clk),.rst(rst),.en(state == WORK),.cnt(),.co(co));
    Counter #(.M(BYTEM)) theCenTxData(.clk(clk),.rst(rst),.en(co),.cnt(cnt_co),.co(codr));
    
    always @(posedge clk) begin
        if(rst) begin
                    state <= IDEL;
                    tx_fifo_data <= 8'd0;
                    tx_fifo_data_vald <= 1'b0;
                end
        else begin
            case(state)
                IDEL: begin 
                         tx_fifo_data <= 8'd0;
                         tx_fifo_data_vald <= 1'b0;
                         if(Rdy_id_vald) state <= READY; 
                         else state <= IDEL;
                      end
                
                READY: begin
                          tx_fifo_data <= 8'd0;
                          tx_fifo_data_vald <= 1'b0; 
                          state <= WORK; 
                       end
                WORK: begin
                          if(co) begin 
/*                                      tx_data[0] <= tx_data[1];   
                                       tx_data[1] <= tx_data[2]; tx_data[2] <= tx_data[3]; tx_data[3] <= tx_data[4]; 
                                       tx_data[4] <= tx_data[5]; tx_data[5] <= tx_data[6]; tx_data[6] <= 8'd0; */
                                       tx_fifo_data <= tx_data[cnt_co]; tx_fifo_data_vald <= 1'b1;
                                 end
                          else begin tx_fifo_data <= 8'd0; tx_fifo_data_vald <= 1'b0; tx_data <= tx_data; end
                          
                          if(cod)   state <= WAITE;
                          else  state <= WORK; 
                      end
                WAITE: begin
                          tx_fifo_data <= 8'd0;
                          tx_fifo_data_vald <= 1'b0; 
                          if(Rdy_id_vald) state <= READY; 
                          else state <= WAITE;
                       end
                default: begin
                            tx_fifo_data <= 8'd0;
                            tx_fifo_data_vald <= 1'b0;
                            state <= IDEL;
                         end
            endcase
        end
    end 
    
endmodule

