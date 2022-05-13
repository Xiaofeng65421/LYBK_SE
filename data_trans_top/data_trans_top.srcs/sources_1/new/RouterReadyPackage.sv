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
    input   wire            rst,//回传模块只支持上电复位
/*    input   wire            reset_done,*/
(*mark_debug = "true"*)    input   wire            order_type_valid,
(*mark_debug = "true"*)    input   wire    [7:0]   order_type,
    input   wire    [15:0]  fpga_ready_state_mask,//就绪fpga掩码
    input   wire    [3:0]   ready_success_state,
    input   wire    [3:0]   sys_state,           
    input   wire    [7:0]   config_data,
    input   wire    [15:0]  fpga_mask,
    input   wire    [7:0]   Rdy_id,
    input   wire            Rdy_id_vald,
    output  reg     [7:0]   tx_fifo_data,
    output  reg             tx_fifo_data_vald
    );
    localparam  [3:0]   BYTEM  = 4'd8;
    
    localparam  [1:0]   IDEL   = 2'b00;
    localparam  [1:0]   READY  = 2'b01;
    localparam  [1:0]   WORK   = 2'b10;
    localparam  [1:0]   WAITE  = 2'b11;
 (*mark_debug = "true"*)   reg  [1:0]   state; 
    wire         co, codr;
    reg          cod;
    reg  [2:0]   cnt_co;
    reg  [7:0]   tx_data [0:7];
    reg          ready_en = 0;
    reg          ready_en_r1 = 0;
    reg          ready_en_r2 = 0;
(*mark_debug = "true"*)    reg          order_en = 0;
    reg  [7:0]   Rdy_id_r = 0;

    always @(posedge clk or posedge rst)
       if (rst) begin
           Rdy_id_r <= 0;
       end else if (Rdy_id_vald) begin
           Rdy_id_r <= Rdy_id;
       end

    always @(posedge clk)begin
        ready_en_r1 <= ready_en;
        ready_en_r2 <= ready_en_r1;
    end

    always @(posedge clk or posedge rst)
       if (rst) begin
           tx_data <= '{0,0,0,0,0,0,0,0};
       end else if ((state != WORK) & ready_en) begin
           tx_data <= '{8'hCD,8'h01,Rdy_id_r,{sys_state,ready_success_state},fpga_ready_state_mask[15:8],fpga_ready_state_mask[7:0],0,8'hEF};
       end else if ((state != WORK) & order_en) begin
           if (order_type == 8'h01) begin
               tx_data <= '{8'hCD,8'h02,config_data,0,0,0,0,8'hEF};
           end else begin
               tx_data <= '{8'hCD,order_type,config_data,fpga_mask[15:8],fpga_mask[7:0],0,0,8'hEF};  
           end
       end else begin
           tx_data <= tx_data;
       end
    
    always @(posedge clk or posedge rst) begin
        if(rst) cod <= 1'b0;
        else cod <= codr;
    end
    
    Counter #(.M(2)) theCouCenPack(.clk(clk),.rst(rst),.en(state == WORK),.cnt(),.co(co));
    Counter #(.M(BYTEM)) theCenTxData(.clk(clk),.rst(rst),.en(co),.cnt(cnt_co),.co(codr));
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
                    state <= IDEL;
                    tx_fifo_data <= 8'd0;
                    tx_fifo_data_vald <= 1'b0;
                    order_en <= 0;
                    ready_en <= 0;
                end
        else begin
            case(state)
                IDEL: begin 
                         tx_fifo_data <= 8'd0;
                         tx_fifo_data_vald <= 1'b0; 
                         if (Rdy_id_vald) begin
                             ready_en    <= 1;
                             state       <= READY;
                         end else if (order_type_valid) begin
                             state       <= READY;
                             order_en    <= 1;
                         end
                      end
                
                READY: begin
                          tx_fifo_data <= 8'd0;
                          tx_fifo_data_vald <= 1'b0; 
                          state <= WORK;
                          ready_en <= 0;
                          order_en <= 0;
                       end
                WORK: begin
                          if(co) begin 
/*                                      tx_data[0] <= tx_data[1];   
                                       tx_data[1] <= tx_data[2]; tx_data[2] <= tx_data[3]; tx_data[3] <= tx_data[4]; 
                                       tx_data[4] <= tx_data[5]; tx_data[5] <= tx_data[6]; tx_data[6] <= 8'd0; */
                                       tx_fifo_data <= tx_data[cnt_co]; tx_fifo_data_vald <= 1'b1;
                                 end
                          else begin tx_fifo_data <= 8'd0; tx_fifo_data_vald <= 1'b0; tx_data <= tx_data; end
                          
                          /*if(cod)   state <= WAITE;
                          else  state <= WORK;*/ 
                          if (cod) begin
                              state <= WAITE;
                            /*  order_en <= 0;*/
                          end else if (Rdy_id_vald) begin
                              ready_en <= 1;
                          end else if (order_type_valid) begin
                              order_en <= 1;
                          end
                      end
               WAITE: begin

                          tx_fifo_data <= 8'd0;
                          tx_fifo_data_vald <= 1'b0; 
                          /*if(Rdy_id_vald) state <= READY; 
                          else state <= WAITE;*/
                          if (Rdy_id_vald) begin
                              ready_en <= 1;
                          end else if (order_type_valid) begin
                              order_en <= 1;
                          end  
                          if (ready_en_r2 | order_en) begin
                              state <= READY;
                          end
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

