`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 11:42:22
// Design Name: 
// Module Name: CenterDelayValue
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


module CenterDelayValue(
    input   wire           clk,
    input   wire           rst,
    input   wire   [7:0]   rx_data,
    input   wire           rx_data_vald,
    output  reg            receive_finish,
    output  reg   [15:0]   fpga_mask,
    output  reg    [7:0]   order_type,
    output  wire           order_type_valid,
    output  reg    [7:0]   config_data,
    output  reg            config_data_valid 
    );
    
    localparam  [1:0]   IDEL = 2'b00;
    localparam  [1:0]   INST = 2'b01;
    localparam  [1:0]   DELY = 2'b10;
    localparam  [1:0]   RESERVE = 2'b11;

    reg    [1:0]     state = 0;
    reg    [2:0]     cnt = 0; 
    reg              order_type_valid_r = 0;
    
    assign order_type_valid  = (order_type != 8'h02)? order_type_valid_r : 0;//过滤

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state             <= IDEL;
            order_type_valid_r<= 1'b0;
            config_data_valid <= 1'b0;           
            receive_finish    <= 0;
        end
        else begin
            case(state)
                IDEL: begin
                        cnt <= 3'd0;
                        order_type_valid_r <= 1'b0;
                        config_data_valid  <= 1'b0;
                        receive_finish <= 0;
                        if(rx_data_vald && (rx_data == 8'hCD))begin
                            state <= INST;
                        end
                      end
                INST: begin
                       
                        if(rx_data_vald)  begin 
                            order_type <=  rx_data;  state <= DELY;
                        end
                        else state <= INST;
                      end
                DELY: begin
                           if(rx_data_vald)  begin config_data <=  rx_data; config_data_valid <= rx_data_vald; state <= RESERVE; end
                           else state <= DELY;    
                        end
                RESERVE: begin
                            config_data_valid <= 1'b0;
                            if (rx_data_vald) begin
                                cnt <= cnt + 1;
                                if (cnt == 0) begin
                                    fpga_mask[15:8] <= rx_data; 
                                end else if (cnt == 1) begin
                                    fpga_mask[7:0] <= rx_data;
                                end
                                if (rx_data == 8'hEF) begin
                                    state <= IDEL;
                                    receive_finish <= 1;
                                    order_type_valid_r <= 1;
                                end else begin
                                    state <= RESERVE;
                                end
                            end
                         end
                default: begin
                            state <= IDEL; 
                            order_type_valid_r <= 1'b0;
                            config_data_valid <= 1'b0;
                            receive_finish <= 0;
                         end   
            endcase
        end  
    end
    
      
endmodule

