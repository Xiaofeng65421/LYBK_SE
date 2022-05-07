`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/26 15:47:32
// Design Name: 
// Module Name: tb_lybk_trigger_top
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


module tb_lybk_trigger_top();

      reg        DATA_CLK;
      reg        TRIGGER_CLK;
      reg [4:0]  RST_N;
      reg        EN;
      reg [7:0]  ZKBK_TASK_ID;
      reg        ZKBK_TRIGGER;
      reg [7:0]  B_CIRCLE_AMOUNT;
      reg [7:0]  TASK_ID;
      reg [14:0] FPGA_ID;
      reg [63:0] S_CIRCLE_DATA;

      reg [14:0] FPGA_READY;
      reg [74:0] FPGA_READY_VALID;
      
      wire [14:0] TRIGGER_OUT;
      wire [74:0] FPGA_TRIGGER_VALID;
      wire [74:0] READY_STATE;
      wire [19:0] B_CIRCLE_ID;

      wire        SEND_ERROR;
      wire  [4:0] READY_ERROR;
      wire  [4:0] TRIGGER_SUCCESS;
      wire  [4:0] TRIGGER_FAILURE;
     
      wire  [4:0]  TO_ZKBK_TASK_ID;
      wire         TO_ZKBK_READY;
      wire         TO_ZKBK_VALID;    

      reg    [9:0]  cnt;
      reg    [5:0]  add;


initial begin
	DATA_CLK = 0;
	TRIGGER_CLK = 0;
	RST_N <= 5'b11111;
  EN <= 0;
	cnt <= 0;
	add <= 0;
	ZKBK_TRIGGER = 0;
	FPGA_READY = 0;
  #10 RST_N <= 5'b00000;
  #10 RST_N <= 5'b11111;
end

always #5 DATA_CLK = ~DATA_CLK;
always #50 TRIGGER_CLK = ~TRIGGER_CLK;

always @(posedge DATA_CLK)
   if (&cnt) begin
       cnt <= cnt;
   end else 
   cnt <= cnt + 1;

always @(posedge DATA_CLK)begin
	if (cnt == 10) begin
		EN <= 1;
		S_CIRCLE_DATA <= {16'd10 + add,16'd100 + add,16'd15 + add,16'd50 + add};//大循环1.2 
		TASK_ID <= 1 + add;//任务ID
		FPGA_ID <= 15'b101_0010_1000_1000;
		B_CIRCLE_AMOUNT <= 8'd5;//大循环数量5
  end else if (cnt == 11) begin
	    S_CIRCLE_DATA <= {16'd5 + add,16'd155 + add,16'd9 + add,16'd50 + add};//大循环3.4
	end else if (cnt == 12) begin
		S_CIRCLE_DATA <= {16'd0,16'd0,16'd25 + add,16'd125 + add};//大循环5
	end else if (cnt == 13) begin
		EN <= 0;
	end else if (cnt == 50) begin
		FPGA_READY <= 15'b101_0010_0000_0000;
		FPGA_READY_VALID <= {5'd1,5'd0,5'd1,10'd0,5'd1,5'd0,5'd1,15'd0,5'd1,15'd0};
	end else if (cnt == 60) begin
		FPGA_READY_VALID <= {5'd3,5'd0,5'd3,10'd0,5'd3,5'd0,5'd3,15'd0,5'd3,15'd0};
    FPGA_READY <= 15'b101_0010_1000_1000;
	end else if (cnt == 70) begin
		FPGA_READY_VALID <= {5'd19,5'd0,5'd19,10'd0,5'd19,5'd0,5'd19,15'd0,5'd19,15'd0};
    FPGA_READY <= 15'b101_0010_1000_1000;
	end else if (cnt == 100) begin
    ZKBK_TRIGGER <= 1;
    ZKBK_TASK_ID <= 1 + add;
  end else if (cnt == 110) begin
    ZKBK_TRIGGER <= 0;
  end 
end



lybk_trigger_top lybk_trigger_top_inst(
        .DATA_CLK(DATA_CLK),      
        .TRIGGER_CLK(TRIGGER_CLK),
        .RST_N(RST_N),
        .EN(EN),
        .ZKBK_TASK_ID(ZKBK_TASK_ID),
        .ZKBK_TRIGGER(ZKBK_TRIGGER),
        .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),
        .TASK_ID(TASK_ID),     
        .FPGA_ID(FPGA_ID),         
        .S_CIRCLE_DATA(S_CIRCLE_DATA),         
        
        .FPGA_READY(FPGA_READY),
        .FPGA_READY_VALID(FPGA_READY_VALID),
        .TRIGGER_OUT(TRIGGER_OUT),
        .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID),
        .READY_STATE(READY_STATE),//所有模块的就绪状态
        .B_CIRCLE_ID(B_CIRCLE_ID),//所有模块的大循环编号

        .SEND_ERROR(SEND_ERROR),//任务下发错误反馈 
        .READY_ERROR(READY_ERROR),//就绪错误反馈
        .TRIGGER_SUCCESS(TRIGGER_SUCCESS),//中控触发成功
        .TRIGGER_FAILURE(TRIGGER_FAILURE),//中控触发失败

        .TO_ZKBK_TASK_ID(TO_ZKBK_TASK_ID),//触发模块就绪掩码
        .TO_ZKBK_READY(TO_ZKBK_READY),
        .TO_ZKBK_VALID(TO_ZKBK_VALID) 
    );
endmodule
