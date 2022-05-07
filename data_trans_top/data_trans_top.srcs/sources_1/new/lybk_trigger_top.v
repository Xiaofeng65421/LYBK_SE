`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/17 13:55:43
// Design Name: 
// Module Name: lybk_trigger_top
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


module lybk_trigger_top#(
     parameter FPGA_AMOUNT = 15//FPGA数量
	)(
        input                      DATA_CLK,      
        input                      TRIGGER_CLK,
        input    [4:0]             RST_N,
        input                      EN,
        input    [7:0]             ZKBK_TASK_ID,
        input                      ZKBK_TRIGGER,
        input    [7:0]             B_CIRCLE_AMOUNT,
        input    [7:0]             TASK_ID,     
        input [FPGA_AMOUNT-1:0]    FPGA_ID,         
        input    [63:0]            S_CIRCLE_DATA,         
        
        input [FPGA_AMOUNT-1:0]    FPGA_READY,
        input [5*FPGA_AMOUNT-1:0]  FPGA_READY_VALID,//就绪5位掩码（共14组）
        output[FPGA_AMOUNT-1:0]    TRIGGER_OUT,
        output[5*FPGA_AMOUNT-1:0]  FPGA_TRIGGER_VALID,//触发5位掩码（共14组）
        output[5*FPGA_AMOUNT-1:0]  READY_STATE,//所有模块的就绪状态
        output[19:0]               B_CIRCLE_ID,//所有模块的大循环编号

        output                     SEND_ERROR,//任务下发错误反馈 
        output [4:0]               READY_ERROR,//就绪错误反馈
        output [4:0]               TRIGGER_SUCCESS,//中控触发成功
        output [4:0]               TRIGGER_FAILURE,//中控触发失败

        output [4:0]               TO_ZKBK_TASK_ID,//触发模块就绪掩码
        output                     TO_ZKBK_READY,
        output                     TO_ZKBK_VALID 
    );
        reg     EN_1,EN_2,EN_3,EN_4,EN_5;
        reg [7:0] B_CIRCLE_AMOUNT_1,B_CIRCLE_AMOUNT_2,B_CIRCLE_AMOUNT_3,
        B_CIRCLE_AMOUNT_4,B_CIRCLE_AMOUNT_5;
        
        reg [7:0] TASK_ID_1,TASK_ID_2,TASK_ID_3,TASK_ID_4,TASK_ID_5;
        reg [FPGA_AMOUNT-1:0] FPGA_ID_1,FPGA_ID_2,FPGA_ID_3,FPGA_ID_4,FPGA_ID_5;
        reg [63:0] S_CIRCLE_DATA_1,S_CIRCLE_DATA_2,S_CIRCLE_DATA_3,
        S_CIRCLE_DATA_4,S_CIRCLE_DATA_5; 

        wire   IDLE_1,IDLE_2,IDLE_3,IDLE_4,IDLE_5;
        wire [FPGA_AMOUNT-1:0] FPGA_READY_VALID_1,FPGA_READY_VALID_2,FPGA_READY_VALID_3,
        FPGA_READY_VALID_4,FPGA_READY_VALID_5;

        wire [FPGA_AMOUNT-1:0]  TRIGGER_OUT_1,TRIGGER_OUT_2,TRIGGER_OUT_3,TRIGGER_OUT_4,TRIGGER_OUT_5;
        wire [FPGA_AMOUNT-1:0] FPGA_TRIGGER_VALID_1,FPGA_TRIGGER_VALID_2,FPGA_TRIGGER_VALID_3,
        FPGA_TRIGGER_VALID_4,FPGA_TRIGGER_VALID_5;

        wire [FPGA_AMOUNT-1:0] READY_STATE_1,READY_STATE_2,READY_STATE_3,READY_STATE_4,READY_STATE_5;
        wire  TO_ZKBK_READY_1,TO_ZKBK_READY_2,TO_ZKBK_READY_3,TO_ZKBK_READY_4,TO_ZKBK_READY_5;
        wire  TO_ZKBK_VALID_1,TO_ZKBK_VALID_2,TO_ZKBK_VALID_3,TO_ZKBK_VALID_4,TO_ZKBK_VALID_5;
        wire [3:0]  b_circle_id1,b_circle_id2,b_circle_id3,b_circle_id4,b_circle_id5;//大循环编号


        reg  send_error = 0;
        wire  ready_error1,ready_error2,ready_error3,ready_error4,ready_error5;
        wire  trigger_success1,trigger_success2,trigger_success3,trigger_success4,trigger_success5;
        wire  trigger_failure1,trigger_failure2,trigger_failure3,trigger_failure4,trigger_failure5;
/////////////////////////////////数据分发//////////////////////////////////////////////////////

       always @(posedge DATA_CLK)begin
        case(TASK_ID)
          1: begin
          	if (IDLE_1) begin
          		EN_1 <= EN;
          		B_CIRCLE_AMOUNT_1 <= B_CIRCLE_AMOUNT;
          		TASK_ID_1 <= TASK_ID;
          		FPGA_ID_1 <= FPGA_ID;
          		S_CIRCLE_DATA_1 <= S_CIRCLE_DATA;
          		send_error <= 0;
          	end else if (EN) begin
          		send_error <= 1;
          	end
          end
          2: begin
          	if (IDLE_2) begin
          		EN_2 <= EN;
          		B_CIRCLE_AMOUNT_2 <= B_CIRCLE_AMOUNT;
          		TASK_ID_2 <= TASK_ID;
          		FPGA_ID_2 <= FPGA_ID;
          		S_CIRCLE_DATA_2 <= S_CIRCLE_DATA;
          		send_error <= 0;
          	end else if (EN) begin
          		send_error <= 1;
          	end
          end
          3: begin
          	if (IDLE_3) begin
          		EN_3 <= EN;
          		B_CIRCLE_AMOUNT_3 <= B_CIRCLE_AMOUNT;
          		TASK_ID_3 <= TASK_ID;
          		FPGA_ID_3 <= FPGA_ID;
          		S_CIRCLE_DATA_3 <= S_CIRCLE_DATA;
          		send_error <= 0;
          	end else if (EN) begin
          		send_error <= 1;
          	end
          end
          4: begin
          	if (IDLE_4) begin
          		EN_4 <= EN;
          		B_CIRCLE_AMOUNT_4 <= B_CIRCLE_AMOUNT;
          		TASK_ID_4 <= TASK_ID;
          		FPGA_ID_4 <= FPGA_ID;
          		S_CIRCLE_DATA_4 <= S_CIRCLE_DATA;
          		send_error <= 0;
          	end else if(EN) begin
          		send_error <= 1;
          	end
          end
          5: begin
          	if (IDLE_5) begin
          		EN_5 <= EN;
          		B_CIRCLE_AMOUNT_5 <= B_CIRCLE_AMOUNT;
          		TASK_ID_5 <= TASK_ID;
          		FPGA_ID_5 <= FPGA_ID;
          		S_CIRCLE_DATA_5 <= S_CIRCLE_DATA;
          		send_error <= 0;
          	end else if (EN) begin
          		send_error <= 1;
          	end
          end
          default: ;
         endcase
       end
///////////////////////////////分发//////////////////////////////////////////////////
       
       generate
       	genvar i;
       	for(i = 0 ;i < FPGA_AMOUNT;i=i+1)
       	begin : transport
       	assign	FPGA_READY_VALID_1[i] = FPGA_READY_VALID[5*i];
       	assign	FPGA_READY_VALID_2[i] = FPGA_READY_VALID[5*i+1];
       	assign	FPGA_READY_VALID_3[i] = FPGA_READY_VALID[5*i+2];
       	assign	FPGA_READY_VALID_4[i] = FPGA_READY_VALID[5*i+3];
       	assign	FPGA_READY_VALID_5[i] = FPGA_READY_VALID[5*i+4];

       	assign FPGA_TRIGGER_VALID[5*(i+1)-1 : 5*i] = {FPGA_TRIGGER_VALID_5[i],FPGA_TRIGGER_VALID_4[i],
       	                     FPGA_TRIGGER_VALID_3[i],FPGA_TRIGGER_VALID_2[i],FPGA_TRIGGER_VALID_1[i]};
       	end
       endgenerate
       
       assign SEND_ERROR  = send_error;
       assign READY_ERROR = {ready_error5,ready_error4,ready_error3,ready_error2,ready_error1};
       assign B_CIRCLE_ID = {b_circle_id5,b_circle_id4,b_circle_id3,b_circle_id2,b_circle_id1};
       assign TRIGGER_SUCCESS = {trigger_success5,trigger_success4,trigger_success3,trigger_success2,trigger_success1};
       assign TRIGGER_FAILURE = {trigger_failure5,trigger_failure4,trigger_failure3,trigger_failure2,trigger_failure1};

       assign TRIGGER_OUT = TRIGGER_OUT_1|TRIGGER_OUT_2|TRIGGER_OUT_3|TRIGGER_OUT_4|TRIGGER_OUT_5;
       assign READY_STATE = {READY_STATE_5,READY_STATE_4,READY_STATE_3,READY_STATE_2,READY_STATE_1};
       assign TO_ZKBK_TASK_ID = {TO_ZKBK_VALID_5,TO_ZKBK_VALID_4,TO_ZKBK_VALID_3,TO_ZKBK_VALID_2,TO_ZKBK_VALID_1};
       assign TO_ZKBK_READY = TO_ZKBK_READY_1|TO_ZKBK_READY_2|TO_ZKBK_READY_3|TO_ZKBK_READY_4|TO_ZKBK_READY_5;
       assign TO_ZKBK_VALID = TO_ZKBK_VALID_1|TO_ZKBK_VALID_2|TO_ZKBK_VALID_3|TO_ZKBK_VALID_4|TO_ZKBK_VALID_5;
   


lybk_trigger#(
     .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_1_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N[0]),

        .EN(EN_1),//输入信号使能
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT_1),//大循环数量
        .TASK_ID_in(TASK_ID_1),//任务ID
        .FPGA_ID_in(FPGA_ID_1),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA_1),//小循环触发数据
        .IDLE(IDLE_1),//空闲信号

        .FPGA_READY(FPGA_READY),//下层FPGA发来的就绪信号
        .FPGA_READY_VALID(FPGA_READY_VALID_1),//接收到每个FPGA内对应线程的就绪有效位掩码(注：线程编号与触发单元一一对应)
     
        .TRIGGER_OUT(TRIGGER_OUT_1),//触发信号输出
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID_1),//发送到每个FPGA内对应线程的触发有效位掩码(注：线程编号与触发单元一一对应)
        
        .READY_STATE(READY_STATE_1),//就绪状态
        .TO_ZKBK_READY(TO_ZKBK_READY_1),//发向中控的就绪信号
        .TO_ZKBK_VALID(TO_ZKBK_VALID_1),//就绪信号输出有效 
        .B_CIRCLE_ID(b_circle_id1),
        .TRIGGER_SUCCESS(trigger_success1),//中控触发成功
        .TRIGGER_FAILURE(trigger_failure1),//中控触发失败
        .READY_ERROR(ready_error1)    

    );

 lybk_trigger#(
     .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_2_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N[1]),

        .EN(EN_2),//输入信号使能
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT_2),//大循环数量
        .TASK_ID_in(TASK_ID_2),//任务ID
        .FPGA_ID_in(FPGA_ID_2),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA_2),//小循环触发数据
        .IDLE(IDLE_2),//空闲信号

        .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
        .FPGA_READY_VALID(FPGA_READY_VALID_2),//接收到每个FPGA内对应线程的就绪有效位掩码(注：线程编号与触发单元一一对应)
     
        .TRIGGER_OUT(TRIGGER_OUT_2),//触发信号输出
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID_2),//发送到每个FPGA内对应线程的触发有效位掩码(注：线程编号与触发单元一一对应)
        
        .READY_STATE(READY_STATE_2),//就绪状态
        .TO_ZKBK_READY(TO_ZKBK_READY_2),//发向中控的就绪信号
        .TO_ZKBK_VALID(TO_ZKBK_VALID_2),//就绪信号输出有效  
        .B_CIRCLE_ID(b_circle_id2),
        .TRIGGER_SUCCESS(trigger_success2),//中控触发成功
        .TRIGGER_FAILURE(trigger_failure2),//中控触发失败   
        .READY_ERROR(ready_error2)
    );

 lybk_trigger#(
     .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_3_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N[2]),

        .EN(EN_3),//输入信号使能
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT_3),//大循环数量
        .TASK_ID_in(TASK_ID_3),//任务ID
        .FPGA_ID_in(FPGA_ID_3),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA_3),//小循环触发数据
        .IDLE(IDLE_3),//空闲信号

        .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
        .FPGA_READY_VALID(FPGA_READY_VALID_3),//接收到每个FPGA内对应线程的就绪有效位掩码(注：线程编号与触发单元一一对应)
     
        .TRIGGER_OUT(TRIGGER_OUT_3),//触发信号输出
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID_3),//发送到每个FPGA内对应线程的触发有效位掩码(注：线程编号与触发单元一一对应)
        
        .READY_STATE(READY_STATE_3),//就绪状态
        .TO_ZKBK_READY(TO_ZKBK_READY_3),//发向中控的就绪信号
        .TO_ZKBK_VALID(TO_ZKBK_VALID_3),//就绪信号输出有效
        .B_CIRCLE_ID(b_circle_id3),
        .TRIGGER_SUCCESS(trigger_success3),//中控触发成功
        .TRIGGER_FAILURE(trigger_failure3),//中控触发失败
        .READY_ERROR(ready_error3)
    );

  lybk_trigger#(
     .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_4_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N[3]),

        .EN(EN_4),//输入信号使能
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT_4),//大循环数量
        .TASK_ID_in(TASK_ID_4),//任务ID
        .FPGA_ID_in(FPGA_ID_4),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA_4),//小循环触发数据
        .IDLE(IDLE_4),//空闲信号

        .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
        .FPGA_READY_VALID(FPGA_READY_VALID_4),//接收到每个FPGA内对应线程的就绪有效位掩码(注：线程编号与触发单元一一对应)
     
        .TRIGGER_OUT(TRIGGER_OUT_4),//触发信号输出
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID_4),//发送到每个FPGA内对应线程的触发有效位掩码(注：线程编号与触发单元一一对应)
        
        .READY_STATE(READY_STATE_4),//就绪状态
        .TO_ZKBK_READY(TO_ZKBK_READY_4),//发向中控的就绪信号
        .TO_ZKBK_VALID(TO_ZKBK_VALID_4),//就绪信号输出有效 
        .B_CIRCLE_ID(b_circle_id4),
        .TRIGGER_SUCCESS(trigger_success4),//中控触发成功
        .TRIGGER_FAILURE(trigger_failure4),//中控触发失败
        .READY_ERROR(ready_error4)
    );  

   lybk_trigger#(
     .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_5_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N[4]),

        .EN(EN_5),//输入信号使能
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER),//中控板卡触发信号
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT_5),//大循环数量
        .TASK_ID_in(TASK_ID_5),//任务ID
        .FPGA_ID_in(FPGA_ID_5),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA_5),//小循环触发数据
        .IDLE(IDLE_5),//空闲信号

        .FPGA_READY(FPGA_READY),//FPGA发来的就绪信号
        .FPGA_READY_VALID(FPGA_READY_VALID_5),//接收到每个FPGA内对应线程的就绪有效位掩码(注：线程编号与触发单元一一对应)
     
        .TRIGGER_OUT(TRIGGER_OUT_5),//触发信号输出
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID_5),//发送到每个FPGA内对应线程的触发有效位掩码(注：线程编号与触发单元一一对应)
        
        .READY_STATE(READY_STATE_5),//就绪状态
        .TO_ZKBK_READY(TO_ZKBK_READY_5),//发向中控的就绪信号
        .TO_ZKBK_VALID(TO_ZKBK_VALID_5),//就绪信号输出有效 
        .B_CIRCLE_ID(b_circle_id5),
        .TRIGGER_SUCCESS(trigger_success5),//中控触发成功
        .TRIGGER_FAILURE(trigger_failure5),//中控触发失败
        .READY_ERROR(ready_error5)
    );     
endmodule
