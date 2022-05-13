`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 14:03:23
// Design Name: 
// Module Name: bk_order_create
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


module bk_order_create(
     input         clk,
     input         rst,
     input         sync_en,
     output [63:0] bk_order_datapkg,
     output        bk_order_datapkg_valid           

    );
    
     reg  [63:0]  datapkg = 0;
     reg          datapkg_valid = 0;

     reg          sync_en_pre = 0;
     wire         sync_en_start;

     assign sync_en_start = sync_en & (~sync_en_pre);
     assign bk_order_datapkg = datapkg;
     assign bk_order_datapkg_valid = datapkg_valid;

     always @(posedge clk)begin
         sync_en_pre <= sync_en;
     end

     always @(posedge clk or posedge rst)
       if (rst) begin
           datapkg_valid <= 0;
           datapkg <= 0;
       end else if (sync_en_start) begin
           datapkg_valid <= 1;
           datapkg[63:56] <= 8'h05;
       end else begin
           datapkg_valid <= 0;
           datapkg <= 0;
       end  

endmodule