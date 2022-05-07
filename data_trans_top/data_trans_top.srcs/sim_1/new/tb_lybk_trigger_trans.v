`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/24 14:18:08
// Design Name: 
// Module Name: tb_lybk_trigger_trans
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


module tb_lybk_trigger_trans();
       reg                          TRIGGER_CLK ;
       reg                          EN;
       reg                          TRIGGER_IN;
       reg [7:0]                    TASK_ID;//任务ID
       reg [15:0]                   FPGA_ID;//FPGA编号
       wire[15:0]                   TRIGGER_OUT;//触发信号输出
       reg [15:0]                   FPGA_READY;//FPGA发来的就绪信号
       wire[15:0]                   READY_STATE;//就绪状态
//////////////////////////////////////////////////////
       wire [7:0]                    TO_ZKBK_TASK_ID;//发向中控的任务ID
       wire                          TO_ZKBK_READY;//发向中控的就绪信号     

       reg [9:0]                     cnt;
       reg                           data_clk;
       reg                           trigger_start;
       reg [2:0]                     trigger_cnt;


       initial
       begin
       	TRIGGER_CLK <= 0;
       	data_clk <= 0;
       	EN <= 0;//就绪输入
       	TRIGGER_IN <= 0;
       	FPGA_READY <= 0;
       	
        cnt <= 0;
        trigger_start <= 0;
        trigger_cnt <= 0;
       end

       always #50  TRIGGER_CLK <= ~TRIGGER_CLK;
       always #5   data_clk <= ~data_clk;

       always @(posedge data_clk)
           begin
           	  cnt <= cnt + 1;
           end

        always @(posedge data_clk)
             if (cnt == 1) begin
                 trigger_start <= 0;
                 EN <= 0;
           end else if (cnt == 5) begin
           	   TASK_ID <= 7'd10; //任务编号10
           	   FPGA_ID <= 16'b0100_0101_0100_1100;//低15位有效,FPGA通道
           end else if (cnt == 20) begin
           	   FPGA_READY <= 16'b0100_0101_0000_1000;
           end else if (cnt == 25) begin
               FPGA_READY <= 16'b0100_0101_0100_1100;
           end else if (cnt == 30) begin
               FPGA_READY <= 16'b0101_0111_0100_1110;
           end else if (cnt == 200) begin
               trigger_start <= 1;
               EN <= 1;  //触发输出
               FPGA_READY <= 0;
           end 
        
        always @(posedge TRIGGER_CLK)
          if (trigger_start) begin
               trigger_cnt <= trigger_cnt + 1;
               if (trigger_cnt == 6) begin
                   TRIGGER_IN <= 1;
               end else begin
                   TRIGGER_IN <= 0;
               end
             end else begin
                 trigger_cnt <= 0;
             end  

 lybk_trigger_trans lybk_trigger_trans_inst(
	     .TRIGGER_CLK(data_clk),//触发生成时钟
       .TRIGGER_IN_VALID(EN),//触发信号输入有效(触发工作状态)
       .TRIGGER_IN(TRIGGER_IN),  //触发信号输入(来自触发生成模块)
      
       .TASK_ID(TASK_ID),//任务ID
       .FPGA_ID(FPGA_ID),//FPGA编号
       .TRIGGER_OUT(TRIGGER_OUT),//触发信号输出

       .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
       .READY_STATE(READY_STATE),//就绪状态
//////////////////////////////////////////////////////
       .TO_ZKBK_READY_ID(TO_ZKBK_TASK_ID),//发向中控的任务ID
       .TO_ZKBK_READY_VALID(TO_ZKBK_READY)//发向中控的就绪信号    

    );

endmodule
