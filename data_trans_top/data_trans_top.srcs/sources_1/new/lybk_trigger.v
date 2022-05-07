`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/18 09:41:45
// Design Name: 
// Module Name: lybk_trigger
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


module lybk_trigger#(
     parameter FPGA_AMOUNT = 16//FPGA数量
	)(
        input                    DATA_CLK,//数据传输时钟
        input                    TRIGGER_CLK,//触发时钟，100M
        input                    RST_N,

        input                    S_CIRCLE_DATA_VALID,//输入使能信号
        input                    SYNC_PULSE,
        input  [7:0]             ZKBK_TASK_ID,
        input                    ZKBK_TRIGGER,//中控板卡触发信号
        input  [7:0]             B_CIRCLE_AMOUNT,//大循环数量
        input  [7:0]             TASK_ID_in,//任务ID
        input  [FPGA_AMOUNT-1:0] FPGA_ID_in,//fpga掩码号
        input  [63:0]            S_CIRCLE_DATA,//小循环触发数据
        
        output                   IDLE,

        input  [FPGA_AMOUNT-1:0] FPGA_READY,
        output [FPGA_AMOUNT-1:0] TRIGGER_OUT,
        output [31:0]            PASSBACK_LENGTH,
        output                   PASSBACK_LENGTH_VALID,

        output [FPGA_AMOUNT-1:0] READY_STATE,
        output [7:0]             TO_ZKBK_TASK_ID,
        output                   TO_ZKBK_READY,

        output [3:0]             B_CIRCLE_ID,//大循环编号
        output                   TRIGGER_SUCCESS,//中控触发成功
        output                   TRIGGER_FAILURE,//中控触发失败
        output                   READY_ERROR //就绪错误
    );
    parameter  TIME_1S = 100000000;//1s

    wire                    TASK_FINIFH;
    wire                    S_CIRCLE_FINISH;

    wire                    trigger;
    wire                    trigger_valid;
    wire   [7:0]            task_id;
    wire  [FPGA_AMOUNT-1:0] fpga_id;

    reg   [24:0]            ready_time_cnt = 0;//就绪计时
    reg   [24:0]            trigger_time_cnt = 0;//触发计时
    reg                     ready_delay = 0;
    reg                     trigger_delay = 0;

    wire                    zkbk_trigger_respond;

    wire                    ready_error;
    wire                    trigger_failure;
    wire                    trigger_success;

    wire                    to_zkbk_ready;

    assign READY_ERROR = (B_CIRCLE_ID == 1)?ready_error : 0;
    assign TRIGGER_SUCCESS = (B_CIRCLE_ID == 1)?trigger_success : 0;
    assign TRIGGER_FAILURE = (B_CIRCLE_ID == 1)?trigger_failure : 0;

    assign ready_error = (ready_delay)? (ready_time_cnt == (TIME_1S -1))?1 : 0 : 0;
    assign trigger_failure = (trigger_delay)?(trigger_time_cnt == (TIME_1S -1))?1 : 0 : 0;
    assign trigger_success = (zkbk_trigger_respond)?(trigger_time_cnt < (TIME_1S - 1))?1 : 0 : 0;

    assign TO_ZKBK_READY   = to_zkbk_ready & IDLE;
//////////////////////////(首次)就绪延迟///////////////////////////////////////
    always @(posedge DATA_CLK or negedge RST_N)
      if (!RST_N) begin
          ready_delay <= 0;
      end else if (S_CIRCLE_DATA_VALID) begin
          ready_delay <= 1;
      end else if (TO_ZKBK_READY) begin
          ready_delay <= 0;
      end

    always @(posedge TRIGGER_CLK or negedge RST_N)
       if (!RST_N | TASK_FINIFH) begin
           ready_time_cnt <= 0;
       end else if (&ready_time_cnt) begin
           ready_time_cnt <= ready_time_cnt;
       end else begin
          if (ready_delay) begin
              ready_time_cnt <= ready_time_cnt + 1;
          end 
       end  
//////////////////////////(首次)触发延迟/////////////////////////////////////////
   always @(posedge DATA_CLK or negedge RST_N)
      if (!RST_N) begin
          trigger_delay <= 0;
       end else if (TO_ZKBK_READY) begin
          trigger_delay <= 1;
       end else if (zkbk_trigger_respond) begin
          trigger_delay <= 0;
       end 
 
   always @(posedge TRIGGER_CLK or negedge RST_N)
       if (!RST_N | TASK_FINIFH) begin
           trigger_time_cnt <= 0;
       end else if (&trigger_time_cnt) begin
           trigger_time_cnt <= trigger_time_cnt;
       end else begin
          if (trigger_delay) begin
              trigger_time_cnt <= trigger_time_cnt + 1;
          end 
       end
////////////////////////////////////////////////////////////////////////


 lybk_trigger_create#(
    .FPGA_NUM(FPGA_AMOUNT) 
    )lybk_trigger_create_inst(
      .DATA_CLK(DATA_CLK),//万兆传输时钟
      .TRIGGER_CLK(TRIGGER_CLK),//7044 100M
      .RST_N(RST_N),//低电平复位
      .S_CIRCLE_DATA_VALID(S_CIRCLE_DATA_VALID),//输入使能信号(数据有效信号)
      .SYNC_PULSE(SYNC_PULSE),
      .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
      .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号

      .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
      .TASK_ID_in(TASK_ID_in),//任务ID
      .FPGA_ID_in(FPGA_ID_in),//fpga编号
      .S_CIRCLE_DATA(S_CIRCLE_DATA),//小循环触发数据

      .IDLE(IDLE),//空闲信号
      .TRIGGER(trigger),//小循环触发信号
      .TRIGGER_VALID(trigger_valid),//小循环触发有效信号
      .TASK_ID_out(task_id),//任务ID
      .FPGA_ID_out(fpga_id),//FPGA掩码
      .B_CIRCLE_ID(B_CIRCLE_ID),//大循环编号
      .PASSBACK_LENGTH(PASSBACK_LENGTH),
      .PASSBACK_LENGTH_VALID(PASSBACK_LENGTH_VALID),

      .ZKBK_TRIGGER_RESPOND(zkbk_trigger_respond),
      
      .TASK_FINIFH(TASK_FINIFH),//任务执行完成(仿真用)
      .S_CIRCLE_FINISH(S_CIRCLE_FINISH) //小循环完成(仿真用)

);

 lybk_trigger_trans#(
    .FPGA_NUM(FPGA_AMOUNT)
	)lybk_trigger_trans_inst(
	   .TRIGGER_CLK(TRIGGER_CLK),//逻辑时钟
     .RST_N(RST_N),
       .TRIGGER_IN_VALID(trigger_valid),//触发信号输入有效(触发工作状态)
       .TRIGGER_IN(trigger),  //触发信号输入(来自触发生成模块)
     
       .TASK_ID(task_id),//任务ID
       .FPGA_ID(fpga_id),//FPGA编号
       .TRIGGER_OUT(TRIGGER_OUT),//触发信号输出

       .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
       .READY_STATE(READY_STATE),//就绪状态

       .TO_ZKBK_READY_ID(TO_ZKBK_TASK_ID),//发向中控的任务ID
       .TO_ZKBK_READY_VALID(to_zkbk_ready)//发向中控的就绪信号    
);


endmodule
