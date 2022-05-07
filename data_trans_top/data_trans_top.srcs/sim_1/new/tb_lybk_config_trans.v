`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/31 17:31:05
// Design Name: 
// Module Name: tb_lybk_config_trans
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


module tb_lybk_config_trans();

     reg   RST_N;
     reg   XGMII_CLK;
     reg   XGMII_RXDV;
     reg [63:0] LYBK_DP;

     wire  DATA_VALID;
     wire [7:0] B_CIRCLE_AMOUNT;
     wire [7:0] ORDER_TYPE;
     wire       ORDER_VALID;
     wire [7:0] TASK_ID;
     wire [15:0] FPGA_ID;
     wire [63:0] S_CIRCLE_DATA;

     wire  ERROR;
     wire  RX_DONE;

     reg [9:0] cnt;

     initial
     begin
     	RST_N <= 1;
        XGMII_CLK <= 0;
        XGMII_RXDV <= 0;

        cnt <= 0;

     end

     always #5 XGMII_CLK = ~XGMII_CLK;

     always @(posedge XGMII_CLK)
       cnt <= cnt + 1;

     always @(posedge XGMII_CLK)
       if (cnt == 5) begin
       	  RST_N <= 0;
       end else if (cnt == 15) begin
       	  RST_N <= 1;
       end else if (cnt == 25) begin
       	  XGMII_RXDV <= 1;
       	/*  LYBK_DP <= {16'd0 ,8'd1,8'd0,16'h3a,8'h01,8'h01};//大循环数量：5*/
        LYBK_DP <= {8'h01,8'h01,16'h3a,8'd0,8'd1,16'd0};
       end else if (cnt == 26) begin
       	  LYBK_DP <= 64'h1234_2233_4455_6677; 
       end else if (cnt == 27) begin
       	  XGMII_RXDV <= 0;
       end else if (cnt == 50) begin
       	  XGMII_RXDV <= 1;
       	 /* LYBK_DP <= {40'd0,16'h11,8'h02};*/
          LYBK_DP <= {8'h02,16'h11,40'd0};
       end else if (cnt == 51) begin
       	  XGMII_RXDV <= 0;
       end else if (cnt == 80) begin
       	  XGMII_RXDV <= 1;
       	  /*LYBK_DP <= {32'd0,16'h22,8'h03,8'h03};*/
          LYBK_DP <= {8'h03,8'h03,16'h22,32'd0};
       end else if (cnt == 81) begin
       	  XGMII_RXDV <= 0;
       end else if (cnt == 100) begin
       	  XGMII_RXDV <= 1;
       	 /* LYBK_DP <= {56'd0,8'h04};*/
          LYBK_DP <= {8'h04,56'd0};
       end else if (cnt == 101) begin
       	  XGMII_RXDV <= 0;
       end  else if (cnt == 150) begin
       	  XGMII_RXDV <= 1;
       	  /*LYBK_DP <= {48'd0,8'h03,8'h05};*/
          LYBK_DP <= {8'h05,8'h03,48'd0};
       end else if (cnt == 151) begin
       	  XGMII_RXDV <= 0;
       end else if (cnt == 200) begin
       	  XGMII_RXDV <= 1;
       	  /*LYBK_DP <= {56'd0,8'h06};*/
          LYBK_DP <= {8'h06,56'd0};
       end else if (cnt == 201) begin
       	  XGMII_RXDV <= 0;
       end

lybk_config_trans lybk_config_trans_inst(
	 .RST_N(RST_N),
     .XGMII_CLK(XGMII_CLK),
     .LYBK_DP_VALID(XGMII_RXDV),
     .LYBK_DP(LYBK_DP),
     
     .S_CIRCLE_DATA_VALID(DATA_VALID),//有效信号(任务下发)
     .B_CIRCLE_AMOUNT(B_CIRCLE_AMOUNT),//大循环数量
     .ORDER_TYPE(ORDER_TYPE),//指令类型
     .ORDER_VALID(ORDER_VALID),
     .TASK_ID(TASK_ID),//任务ID
     .FPGA_ID(FPGA_ID),//fpga编号
     .S_CIRCLE_DATA(S_CIRCLE_DATA),//小循环触发数据

     .RX_DONE(RX_DONE),
     .ERROR(ERROR)
        
);

endmodule
