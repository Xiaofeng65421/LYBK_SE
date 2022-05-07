`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/24 14:15:59
// Design Name: 
// Module Name: tb_lybk_trigger_create
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


module tb_lybk_trigger_create();
       reg    DATA_CLK;
       reg    TRIGGER_CLK;
       reg    RST_N;
       reg    EN;
       reg  [7:0] ZKBK_TASK_ID;
       reg        ZKBK_TRIGGER;
       reg  [7:0] B_CIRCLE_AMOUNT;
       reg  [7:0] TASK_ID_in;
       reg  [15:0] FPGA_ID_in;
       reg  [63:0] S_CIRCLE_DATA;

       reg  [15:0] cnt;
       reg  [15:0] trigger_create_cnt; 
       reg  [15:0]  add; 
       reg         data_valid; 
       reg        ZKBK_TRIGGER_next; 

       wire        IDLE;
       wire        TRIGGER;
       wire        VALID;
       wire [7:0]  TASK_ID_out;
       wire [15:0] FPGA_ID_out;

       wire        S_CIRCLE_FINISH;
   
       wire        TASK_FINIFH; 
       reg         trigger_next;          

    initial
    begin
       	DATA_CLK <= 0;
       	TRIGGER_CLK <= 0;
       	RST_N <= 1;
       	EN <= 0;
       	ZKBK_TRIGGER <= 0;
        ZKBK_TRIGGER_next <= 0;
       	cnt <= 0;
        trigger_create_cnt <= 0;
       	data_valid <= 0; 
       	add <= 0;
        trigger_next <= 0;
       end  

    always #5   DATA_CLK = ~DATA_CLK;
    always #5  TRIGGER_CLK = ~TRIGGER_CLK;


    always @(posedge DATA_CLK)
      if (TASK_FINIFH) 
      	  cnt <= 0;
      else if (&cnt)
      	cnt <= cnt;
      else
      cnt <= cnt + 1;  

    always @(posedge DATA_CLK)
      if (TASK_FINIFH) begin
          	add <= add + 1; 
          end    

    always @(posedge DATA_CLK)begin
    	/*if (cnt == 8) begin
    		RST_N <= 0;
    	end else if (cnt == 15) begin
    		RST_N <= 1;
    	end else*/ if (cnt == 20) begin
    		data_valid <= 1;
    	end else if (cnt == 21) begin
    	  TASK_ID_in <= 8'd3;//任务ID
    		FPGA_ID_in <= 16'b0101_0010_1000_1111;
    		B_CIRCLE_AMOUNT <= 8'd1;//大循环数量1
    	end else if (cnt == 22) begin
    	  S_CIRCLE_DATA <= {16'd10 + add,16'd1233 + add,16'd15 + add,16'd50 + add};//大循环1.2 
    	  EN <= 1;
    	end else if (cnt == 23) begin
    		EN <= 0;
    		data_valid <= 0;
    	end else if (cnt == 100) begin
    		ZKBK_TRIGGER <= 1;//每次大循环触发一次
    		ZKBK_TASK_ID <= 8'd3;
    	end else if (cnt == 101) begin
    		ZKBK_TRIGGER <= 0;
    	end/* else if (cnt == 1500) begin
    		ZKBK_TRIGGER <= 1;
    		ZKBK_TASK_ID <= 8'd3;
    	end else if (cnt == 1501) begin
    		ZKBK_TRIGGER <= 0;
    	end*/
    end   

    always @(posedge DATA_CLK)
      if (TASK_FINIFH) begin
          trigger_next <= 0;
      end else if (S_CIRCLE_FINISH) begin
          trigger_next <= 1;
      end
    

    always @(posedge DATA_CLK)
     if (S_CIRCLE_FINISH | TASK_FINIFH) begin
          trigger_create_cnt <= 0;
     end  else if (trigger_create_cnt == 20) begin
          trigger_create_cnt <= trigger_create_cnt;
     end  else if (trigger_next) begin
          trigger_create_cnt <= trigger_create_cnt + 1;
     end

     always @(posedge DATA_CLK)
        if (trigger_create_cnt == 15) begin
            ZKBK_TRIGGER_next <= 1;
            ZKBK_TASK_ID <= 8'd3;
        end else begin
             ZKBK_TRIGGER_next <= 0;
        end


 lybk_trigger_create lybk_trigger_create_inst(
        .DATA_CLK(DATA_CLK),
        .TRIGGER_CLK(TRIGGER_CLK),//外部时钟10M
        .RST_N(RST_N),//低电平复位
        .S_CIRCLE_DATA_VALID(EN),//输入使能信号(数据有效信号)
        .ZKBK_TASK_ID(ZKBK_TASK_ID),//中控板卡任务ID
        .ZKBK_TRIGGER(ZKBK_TRIGGER | ZKBK_TRIGGER_next),//中控板卡触发信号

        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
        .TASK_ID_in(TASK_ID_in),//任务ID
        .FPGA_ID_in(FPGA_ID_in),//fpga编号
        .S_CIRCLE_DATA(S_CIRCLE_DATA),//小循环触发数据

        .IDLE(IDLE),//空闲信号
        .TRIGGER(TRIGGER),//小循环触发信号
        .TRIGGER_VALID(VALID),//小循环触发有效信号
        .TASK_ID_out(TASK_ID_out),//任务ID
        .FPGA_ID_out(FPGA_ID_out),//FPGA掩码

        .TASK_FINIFH(TASK_FINIFH),
        .S_CIRCLE_FINISH(S_CIRCLE_FINISH)

);
endmodule
