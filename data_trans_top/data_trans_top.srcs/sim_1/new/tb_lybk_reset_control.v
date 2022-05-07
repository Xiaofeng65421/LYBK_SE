`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/07 15:51:52
// Design Name: 
// Module Name: tb_lybk_reset_control
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


module tb_lybk_reset_control();

        reg         XGMII_CLK;
        reg [7:0]   ORDER_TYPE;
        reg         ORDER_VALID;
        reg [15:0]  FPGA_ID;
        reg [7:0]   TASK_ID;

        wire         TRIGGER_RESET;
        wire  [15:0] FPGA_RESET;
        wire         SYS_RESET;
        wire         FPGA_SYS_RST;
        wire         RESET_DONE;

        reg [7:0] cnt;
        reg [2:0] add;

       initial begin
       	  XGMII_CLK <= 0;
       	  ORDER_VALID <= 0;
       	  cnt <= 0;
       	  add <= 0;
       end

       always #5 XGMII_CLK = ~XGMII_CLK;

       always @(posedge XGMII_CLK)
          cnt <= cnt + 1;
       
       always @(posedge XGMII_CLK)
          if (&cnt) begin
              add <= add + 1;	
             end   

       always @(posedge XGMII_CLK)
         if (cnt == 10) begin
                ORDER_VALID <= 1;
                ORDER_TYPE <= 1+ add; 
                FPGA_ID <= 1052 + add*20;
                TASK_ID <= 8'h02 + add;	
            end else if (cnt == 11) begin
            	ORDER_VALID <= 0;
            end 


lybk_reset_control lybk_reset_control_inst(
        .XGMII_CLK(XGMII_CLK),//下发数据时钟
        .ORDER_TYPE(ORDER_TYPE),
        .ORDER_VALID(ORDER_VALID),
        .FPGA_ID(FPGA_ID),//本次任务涉及的FPGA掩码
        /*.TASK_ID(TASK_ID),//本次需清除的任务 */                    

        .TRIGGER_RESET(TRIGGER_RESET),//触发模块的复位信号(低电平)
        .FPGA_SYS_RST(FPGA_RESET),//FPGA的复位信号(多线程)
        .SYS_RESET(SYS_RESET),//系统复位(低电平)
        .RESET_DONE(RESET_DONE)
    );
endmodule
