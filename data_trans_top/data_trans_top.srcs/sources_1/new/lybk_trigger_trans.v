`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/18 09:32:46
// Design Name: 
// Module Name: lybk_trigger_trans
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 单个触发模块的信号转发
// 
// Dependencies:   
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lybk_trigger_trans#(
    parameter  FPGA_NUM = 16
    )(
      input                        TRIGGER_CLK,
      input                          RST_N,
      input                          TRIGGER_IN_VALID,//触发信号输入有效(触发工作状态)
      input                          TRIGGER_IN,  //触发信号输入(来自触发生成模块)
      
      input  [7:0]                   TASK_ID,//任务ID
      input  [FPGA_NUM - 1:0]        FPGA_ID,//FPGA掩码
      output [FPGA_NUM - 1:0]        TRIGGER_OUT,//触发信号输出

 (* MARK_DEBUG="true" *)     input  [FPGA_NUM - 1:0]        FPGA_READY,//FPGA发来的就绪信号     
 (* MARK_DEBUG="true" *)     output [FPGA_NUM - 1:0]        READY_STATE,//就绪状态
//////////////////////////////////////////////////////
      output [7:0]                   TO_ZKBK_READY_ID,//发向中控的任务ID
      output                         TO_ZKBK_READY_VALID//发向中控的就绪信号    


    );
      wire   ready_valid;
      reg    ready_valid_r;
      reg  [FPGA_NUM - 1:0]  ready_state = 0;
      wire [FPGA_NUM - 1:0]  fpga_ready_valid;

      assign READY_STATE = ready_state & FPGA_ID; //SE版本
      assign ready_valid =  (READY_STATE == FPGA_ID)? 1 : 0;   
      
      assign TO_ZKBK_READY_VALID   = ready_valid & (~ready_valid_r);
      assign TO_ZKBK_READY_ID =  TASK_ID ;

      always @(posedge TRIGGER_CLK)
         ready_valid_r <= ready_valid;
    

  generate
    genvar i;
    for (i = 0 ; i < FPGA_NUM ; i = i + 1)
    begin : transport
        assign TRIGGER_OUT[i] =(TRIGGER_IN_VALID)?(FPGA_ID[i])?TRIGGER_IN : 0 : 0;//触发通道选择

      always @(posedge TRIGGER_CLK or negedge RST_N)
        if (!RST_N | TO_ZKBK_READY_VALID) begin
            ready_state[i]<= 0;
        end
        else if (fpga_ready_valid[i]) begin
            ready_state[i] <= 1; 
        end

       TrigInFilter #(.LEGTH(5)) theTrigInFilter(
           .clk(TRIGGER_CLK),
           /*.rst(~RST_N),*/
           .TrigIn(FPGA_READY[i]),
           .TrigIn_vald(fpga_ready_valid[i])); 
    end
  endgenerate
     
endmodule
