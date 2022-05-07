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
    output  reg    [7:0]   instruction,
    output  reg            inst_vald,
    output  wire   [7:0]   dely_value,
    output  wire           dely_value_vald 
    );
    //localparam  INSTRU = 8'd02;
    
    localparam  [1:0]   IDEL = 2'b00;
    localparam  [1:0]   INST = 2'b01;
    localparam  [1:0]   DELY = 2'b10;
    localparam  [1:0]   RESERVE = 2'b11;

    reg    [7:0]     task_id;
    reg              task_id_vald; 
    reg    [1:0]     state;
/*    reg    [7:0]     reser_data   [0:4];*/
    reg    [7:0]     reser;
    reg    [1:0]     rx_data_vald_r; 
    wire             neg_rx_data_vald;
    reg    [2:0]     cnt;
    
    assign  dely_value = task_id;
    assign  dely_value_vald = task_id_vald;
   
    
    always @(posedge clk) begin
        if(rst) begin
            state <= IDEL;
            instruction <=  8'd0; 
            inst_vald <= 1'b0;
            task_id <= 8'd0;
            task_id_vald <= 1'b0;
            reser <= 8'd0;
        end
        else begin
            case(state)
                IDEL: begin
                        cnt <= 3'd0;
                        instruction <=  8'd0; 
                        inst_vald <= 1'b0;
                        task_id <= 8'd0;
                        task_id_vald <= 1'b0;
                        reser <= 8'd0;
                        state <= INST;
                      end
                INST: begin
                       
                        if(rx_data_vald && (rx_data == 8'h01 || rx_data == 8'h02))  begin 
                            instruction <=  rx_data; inst_vald <= rx_data_vald; state <= DELY;
                        end
                        else state <= INST;
                      end
                DELY: begin
                          
                           inst_vald <= 1'b0;
                           if(rx_data_vald)  begin task_id <=  rx_data; task_id_vald <= rx_data_vald; state <= RESERVE; end
                           else state <= DELY;    
                        end
                RESERVE: begin
                            task_id_vald <= 1'b0;
                            if(rx_data_vald) reser <= rx_data;
                            else reser <= reser;
                            if (neg_rx_data_vald) cnt <= cnt + 1;
                            if(cnt >= 3'd1) state <= IDEL;
                            else  state <= RESERVE;
                         end
                default: begin
                            state <= IDEL;
                            instruction <=  8'd0; 
                            inst_vald <= 1'b0;
                            task_id <= 8'd0;
                            task_id_vald <= 1'b0;
                            reser <= 8'd0;
                         end   
            endcase
        end  
    end
    
    assign  neg_rx_data_vald = rx_data_vald_r[1] & (~rx_data_vald_r[0]);
    
    always @(posedge clk) begin
        if(rst) rx_data_vald_r <= 2'b00;
        else if(state == RESERVE)begin
            rx_data_vald_r[0] <= rx_data_vald;
            rx_data_vald_r[1] <= rx_data_vald_r[0];
        end
    end
    
/*    always @(posedge clk) begin
        if(rst) reser_data <= '{0,0,0,0,0};
        else if(state == RESERVE &&  neg_rx_data_vald) begin
            reser_data[4] <= reser;
            reser_data[3] <= reser_data[4];
            reser_data[2] <= reser_data[3];
            reser_data[1] <= reser_data[2];
            reser_data[0] <= reser_data[1];
        end
    end*/
    
/*    always @(posedge clk) begin
     if(state == RESERVE &&  neg_rx_data_vald)
            cnt <= cnt + 1'b1;
    end*/
      
endmodule

