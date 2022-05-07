`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/24 14:19:48
// Design Name: 
// Module Name: tb_lybk_trigger
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


module tb_lybk_trigger();

    reg     DATA_CLK;
    reg     TRIGGER_CLK;
    reg     RST_N;
    reg     EN;

    reg [7:0] ZKBK_TASK_ID;
    reg       ZKBK_TRIGGER;

    reg [7:0] B_CIRCLE_AMOUNT;
    reg [7:0] TASK_ID_in;
    reg [15:0] FPGA_ID_in;
    reg [63:0] S_CIRCLE_DATA;

    wire       IDLE;
/*    wire       TASK_FINIFH;
    wire       S_CIRCLE_FINISH;*/

    reg [14:0] FPGA_READY;
    reg [14:0] FPGA_READY_VALID;
    wire[14:0] TRIGGER_OUT;
    wire[14:0] FPGA_TRIGGER_VALID;
    wire[14:0] READY_STATE;
    wire[7:0]  TO_ZKBK_TASK_ID;
    wire       TO_ZKBK_READY;
    wire       TO_ZKBK_VALID;

    wire [3:0] B_CIRCLE_ID;
    wire       TRIGGER_SUCCESS;
    wire       TRIGGER_FAILURE;
    wire       READY_ERROR;

    reg [10:0] cnt;
    reg [15:0]  add; 
    reg        trigger_next;
    reg [10:0] trigger_create_cnt;

    initial
    begin
      DATA_CLK <= 0;
      TRIGGER_CLK <= 0;
      RST_N <= 1;
      EN <= 0;
      add <= 0;

      cnt <= 1;
      ZKBK_TRIGGER <= 0;
      FPGA_READY <= 0;
      trigger_next <= 0;
      trigger_create_cnt <= 0;
    end
    
    always #5   DATA_CLK = ~DATA_CLK;
    always #50  TRIGGER_CLK = ~TRIGGER_CLK;   

    always @(posedge DATA_CLK)
      /*if (TASK_FINIFH)
          cnt <= 0;
      else*/ if (&cnt)
        cnt <= cnt;
      else 
      cnt <= cnt + 1; 

/*    always @(posedge DATA_CLK)
      if (cnt == 0) begin
            add <= add + 1; 
          end    */ 

    always @(posedge DATA_CLK)begin
      if (cnt == 8) begin
        RST_N <= 0;
      end else if (cnt == 15) begin
        RST_N <= 1;
      end else if (cnt == 20) begin
        TASK_ID_in <= 8'd3;//任务ID 3
        FPGA_ID_in <= 16'b0101_0010_1000_1111 + add;
        B_CIRCLE_AMOUNT <= 8'd5;//大循环数量5
      end else if (cnt == 22) begin
        S_CIRCLE_DATA <= {16'd10 + add,16'd100 + add,16'd15 + add,16'd50 + add};//大循环1.2 
        EN <= 1;
      end else if (cnt == 23) begin
        S_CIRCLE_DATA <= {16'd5 + add,16'd155 + add,16'd9 + add,16'd50 + add};//大循环3.4
      end else if (cnt == 24) begin
        S_CIRCLE_DATA <= {16'd0,16'd0,16'd25 + add,16'd125 + add};//大循环5
      end else if (cnt == 25) begin
        EN <= 0;
      end else if (cnt == 200) begin
        FPGA_READY <= 15'b101_0010_1000_1000;
        FPGA_READY_VALID <= 15'b101_0010_1000_0000;//
      end else if (cnt == 210) begin
        FPGA_READY <= 15'b101_0010_1000_1111;
        FPGA_READY_VALID <= 15'b101_0010_1000_1111;//
      end else if (cnt == 220) begin
        FPGA_READY <= 15'b101_1110_1010_1111;
        FPGA_READY_VALID <= 15'b101_0010_1000_1111;//
      end else if (cnt == 500) begin
        ZKBK_TRIGGER <= 1;
        ZKBK_TASK_ID <= 8'd3;
      end else if (cnt == 510) begin
        ZKBK_TRIGGER <= 0;
      end 
    end

/*    always @(posedge DATA_CLK)
      if (TASK_FINIFH) begin
          trigger_next <= 0;
      end else if (S_CIRCLE_FINISH) begin
          trigger_next <= 1;
      end

    always @(posedge DATA_CLK)
     if (S_CIRCLE_FINISH | TASK_FINIFH) begin
          trigger_create_cnt <= 0;
     end  else if (&trigger_create_cnt) begin
          trigger_create_cnt <= trigger_create_cnt;
     end  else if(trigger_next) begin
          trigger_create_cnt <= trigger_create_cnt + 1;
     end


     always @(posedge DATA_CLK)
       if (trigger_create_cnt == 50) begin
          FPGA_READY <= 15'b101_0010_1000_1000;
        FPGA_READY_VALID <= 15'b101_0010_1000_0000;//下层板卡发来的就绪信号
       end else if (trigger_create_cnt == 100) begin
         FPGA_READY <= 15'b101_0010_1000_1111;
        FPGA_READY_VALID <= 15'b101_0010_1000_1111;
       end else if (trigger_create_cnt == 150) begin
         FPGA_READY <= 15'b101_1110_1010_1111;
        FPGA_READY_VALID <= 15'b101_0010_1000_1111;
       end else if (trigger_create_cnt == 250) begin
         ZKBK_TRIGGER <= 1;
        ZKBK_TASK_ID <= 8'd3;
       end else if (trigger_create_cnt == 260) begin
         ZKBK_TRIGGER <= 0;
       end*/


lybk_trigger lybk_trigger_inst(
        .DATA_CLK(DATA_CLK),//数据传输时钟
        .TRIGGER_CLK(TRIGGER_CLK),//触发时钟，10M
        .RST_N(RST_N),

        .EN(EN),//输入使能信号
        .ZKBK_TASK_ID(ZKBK_TASK_ID),
        .ZKBK_TRIGGER(ZKBK_TRIGGER),
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
        .TASK_ID_in(TASK_ID_in),//任务ID
        .FPGA_ID_in(FPGA_ID_in),//fpga编号(若FPGA_ANOUNT改变，需重新定义)
        .S_CIRCLE_DATA(S_CIRCLE_DATA),//小循环触发数据
        .IDLE(IDLE),
/*        .TASK_FINIFH(TASK_FINIFH),
        .S_CIRCLE_FINISH(S_CIRCLE_FINISH),*/

        .FPGA_READY(FPGA_READY),
        .FPGA_READY_VALID(FPGA_READY_VALID),
        .TRIGGER_OUT(TRIGGER_OUT),
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID),
        
        .READY_STATE(READY_STATE),
        .TO_ZKBK_TASK_ID(TO_ZKBK_TASK_ID),
        .TO_ZKBK_READY(TO_ZKBK_READY),
        .TO_ZKBK_VALID(TO_ZKBK_VALID),

        .B_CIRCLE_ID(B_CIRCLE_ID),//大循环编号
        .TRIGGER_SUCCESS(TRIGGER_SUCCESS),//中控触发成功
        .TRIGGER_FAILURE(TRIGGER_FAILURE),//中控触发失败
        .READY_ERROR(READY_ERROR) //就绪错误

    );


endmodule
