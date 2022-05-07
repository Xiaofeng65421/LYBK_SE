`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/28 10:25:18
// Design Name: 
// Module Name: tb_lybk_top
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


module tb_lybk_top();

      reg [63:0]   XGMII_RXD;
      reg    XGMII_RXDV;
      reg    XGMII_CLK;
      reg    TRIGGER_CLK;
      reg [14:0] FPGA_READY;
      reg [74:0] FPGA_READY_VALID;

      reg        ZKBK_TRIGGER;
      reg  [7:0] ZKBK_TASK_ID;

      wire        TO_ZKBK_READY;
      wire        TO_ZKBK_VALID;
      wire [4:0]  TO_ZKBK_TASK_ID;      

      wire [14:0] TRIGGER_OUT;
      wire [74:0] FPGA_TRIGGER_VALID;
      wire [59:0] FPGA_RESET;
      wire [14:0] FPGA_RESET_VALID;
     
      wire [63:0] FPGA1_AURORA_DATAPKG;
      wire        FPGA1_AURORA_VALID;
      wire [63:0] FPGA2_AURORA_DATAPKG;
      wire        FPGA2_AURORA_VALID;
      wire [63:0] FPGA3_AURORA_DATAPKG;
      wire        FPGA3_AURORA_VALID;
      wire [63:0] FPGA4_AURORA_DATAPKG;
      wire        FPGA4_AURORA_VALID;
      wire [63:0] FPGA5_AURORA_DATAPKG;
      wire        FPGA5_AURORA_VALID;
      wire [63:0] FPGA6_AURORA_DATAPKG;
      wire        FPGA6_AURORA_VALID;
      wire [63:0] FPGA7_AURORA_DATAPKG;
      wire        FPGA7_AURORA_VALID;
      wire [63:0] FPGA8_AURORA_DATAPKG;
      wire        FPGA8_AURORA_VALID;
      wire [63:0] FPGA9_AURORA_DATAPKG;
      wire        FPGA9_AURORA_VALID;
      wire [63:0] FPGA10_AURORA_DATAPKG;
      wire        FPGA10_AURORA_VALID;
      wire [63:0] FPGA11_AURORA_DATAPKG;
      wire        FPGA11_AURORA_VALID;
      wire [63:0] FPGA12_AURORA_DATAPKG;
      wire        FPGA12_AURORA_VALID;
      wire [63:0] FPGA13_AURORA_DATAPKG;
      wire        FPGA13_AURORA_VALID;
      wire [63:0] FPGA14_AURORA_DATAPKG;
      wire        FPGA14_AURORA_VALID;
      wire [63:0] FPGA15_AURORA_DATAPKG;
      wire        FPGA15_AURORA_VALID;

      wire [63:0]  XGMII_TXD;//万兆网回传数据
      wire         XGMII_TXDV;
      wire         TX_DONE; 

      reg   [31:0]  cnt;
      reg   [63:0]  package_head;
      reg   [63:0]  package_tail; 
      
      initial begin
      	XGMII_RXD <= 0;
        XGMII_RXDV <= 0;
        XGMII_CLK <= 0;
        TRIGGER_CLK <= 0;
        FPGA_READY <= 0;
        FPGA_READY_VALID <= 0;
        ZKBK_TRIGGER <= 0;
        ZKBK_TASK_ID <= 0; 

        package_head <= 64'h18efdc0118efdc01;
        package_tail <= 64'h01dcef1801dcef18;
        cnt <= 0; 
      end

      always #5  XGMII_CLK <= ~XGMII_CLK;
      always #50 TRIGGER_CLK <= ~TRIGGER_CLK;


      always @(posedge XGMII_CLK)
        if (&cnt) begin
        	cnt <= cnt;
        end else begin
        	cnt <= cnt + 1;
        end

       always @(posedge XGMII_CLK)
         /*if (cnt == 1) begin
          	 XGMII_RXDV <= 1;
          	 XGMII_RXD <= package_head;
          end else if (cnt == 2) begin   //系统复位
          	 XGMII_RXD[7:0] <= 0;
          	 XGMII_RXD[15:8] <= 0;
          	 XGMII_RXD[23:16] <= 0;
             XGMII_RXD[55:24] <= 1;
             XGMII_RXD[63:56] <= 0;
          end else if (cnt == 3) begin
          	 XGMII_RXD <= 'd4;//清除机箱
          end else if (cnt == 4) begin
          	 XGMII_RXD <= package_tail;
          end else if (cnt == 5) begin
          	 XGMII_RXDV <= 0;
          end else*/ 
          if (cnt == 150) begin  //////路由数据包下发
          	 XGMII_RXDV <= 1;
          	 XGMII_RXD <= package_head;
          end else if (cnt == 151) begin
          	 XGMII_RXD[7:0] <= 1; //任务ID:1
          	 XGMII_RXD[15:8] <= 0;
          	 XGMII_RXD[23:16] <= 3;//FPGA编号
             XGMII_RXD[55:24] <= 4;//数据长度
             XGMII_RXD[63:56] <= 0;
          end else if (cnt == 152) begin
          	 XGMII_RXD[7:0] <= 8'h01;
          	 XGMII_RXD[15:8] <= 1; //任务ID:1
          	 XGMII_RXD[31:16] <= 16'h1234;//FPGA掩码
          	 XGMII_RXD[39:32] <= 0;
          	 XGMII_RXD[47:40] <= 5;//大循环数量
             XGMII_RXD[63:48] <= 0;
          end else if (cnt == 153) begin
          	 XGMII_RXD[15:0] <= 5;
          	 XGMII_RXD[31:16] <= 1;
          	 XGMII_RXD[47:32] <= 4;
          	 XGMII_RXD[63:48] <= 2;
          end  else if (cnt == 154) begin
          	 XGMII_RXD[15:0] <= 10;
          	 XGMII_RXD[31:16] <= 1;
          	 XGMII_RXD[47:32] <= 3;
          	 XGMII_RXD[63:48] <= 3;
          end else if (cnt == 155) begin
          	 XGMII_RXD[15:0] <= 3;
          	 XGMII_RXD[31:16] <= 3;
          	 XGMII_RXD[63:32] <= 0;
          end else if (cnt == 156) begin
          	 XGMII_RXD <= package_tail;
          end else if (cnt == 157) begin
          	 XGMII_RXDV <= 0;
          end else if (cnt == 200) begin
          	 FPGA_READY <= 15'b100_1000_0100_0010;
          end else if (cnt == 250) begin
          	 ZKBK_TRIGGER <= 1;
          	 ZKBK_TASK_ID <= 1;
          end else if (cnt == 260) begin
          	 ZKBK_TRIGGER <= 0;
          end else if (cnt == 600) begin ///////线程清除
          	 XGMII_RXDV <= 1;
          	 XGMII_RXD <= package_head;
          end else if (cnt == 601) begin
          	 XGMII_RXD[7:0] <= 1;
          	 XGMII_RXD[15:8] <= 0;
          	 XGMII_RXD[23:16] <= 0;
          	 XGMII_RXD[55:24] <= 1;
          	 XGMII_RXD[63:56] <= 0; 
          end else if (cnt == 602) begin
          	 XGMII_RXD[7:0] <= 8'h03;
          	 XGMII_RXD[15:8] <= 1;
          	 XGMII_RXD[31:16] <= 16'h1234;//FPGA掩码
          	 XGMII_RXD[63:32] <= 0; 
          end else if (cnt == 603) begin
          	 XGMII_RXD <= package_tail;
          end else if (cnt == 604) begin
          	 XGMII_RXDV <= 0;
          end else if (cnt == 1000) begin ////////FPGA数据包下发
          	 XGMII_RXDV <= 1;
          	 XGMII_RXD <= package_head;
          end else if (cnt == 1001) begin
          	 XGMII_RXD[7:0] <= 2;
          	 XGMII_RXD[15:8] <= 1;
          	 XGMII_RXD[23:16] <= 5;
          	 XGMII_RXD[55:24] <= 10; 
          	 XGMII_RXD[63:56] <= 0;
          end else if ((cnt >= 1002)&&(cnt <= 1011)) begin
          	 XGMII_RXD <= $random %100;
          end else if (cnt == 1012) begin
          	 XGMII_RXD <= package_tail;
          end else if (cnt == 1013) begin
          	 XGMII_RXDV <= 0;
          end



 lybk_top lybk_top_inst(
       .XGMII_RXD(XGMII_RXD), //万兆网下发数据    
       .XGMII_RXDV(XGMII_RXDV), 
       .XGMII_CLK(XGMII_CLK),
       .TRIGGER_CLK(TRIGGER_CLK),

       .ZKBK_TRIGGER(ZKBK_TRIGGER),
       .ZKBK_TASK_ID(ZKBK_TASK_ID),

       .TO_ZKBK_READY(TO_ZKBK_READY),
       .TO_ZKBK_VALID(TO_ZKBK_VALID),
       .TO_ZKBK_TASK_ID(TO_ZKBK_TASK_ID),       

       .FPGA_READY(FPGA_READY),//FPGA回传的就绪信号
       .FPGA_READY_VALID(FPGA_READY_VALID),//FPGA回传的就绪掩码(5个一组对应触发模块)
       .TRIGGER_OUT(TRIGGER_OUT),//触发信号
       .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID),//触发信号的有效掩码(5个一组对应触发模块)
       .FPGA_RESET(FPGA_RESET),//FPGA的复位信号
       .FPGA_RESET_VALID(FPGA_RESET_VALID),//FPGA复位有效   

       .FROM_FPGA1_AURORA_DATAPKG(FROM_FPGA1_AURORA_DATAPKG),
       .FROM_FPGA1_AURORA_VALID(FROM_FPGA1_AURORA_VALID),
       .FROM_FPGA2_AURORA_DATAPKG(FROM_FPGA2_AURORA_DATAPKG),
       .FROM_FPGA2_AURORA_VALID(FROM_FPGA2_AURORA_VALID),
       .FROM_FPGA3_AURORA_DATAPKG(FROM_FPGA3_AURORA_DATAPKG),
       .FROM_FPGA3_AURORA_VALID(FROM_FPGA3_AURORA_VALID),
       .FROM_FPGA4_AURORA_DATAPKG(FROM_FPGA4_AURORA_DATAPKG),
       .FROM_FPGA4_AURORA_VALID(FROM_FPGA4_AURORA_VALID),
       .FROM_FPGA5_AURORA_DATAPKG(FROM_FPGA5_AURORA_DATAPKG),
       .FROM_FPGA5_AURORA_VALID(FROM_FPGA5_AURORA_VALID),
       .FROM_FPGA6_AURORA_DATAPKG(FROM_FPGA6_AURORA_DATAPKG),
       .FROM_FPGA6_AURORA_VALID(FROM_FPGA6_AURORA_VALID),
       .FROM_FPGA7_AURORA_DATAPKG(FROM_FPGA7_AURORA_DATAPKG),
       .FROM_FPGA7_AURORA_VALID(FROM_FPGA7_AURORA_VALID),
       .FROM_FPGA8_AURORA_DATAPKG(FROM_FPGA8_AURORA_DATAPKG),
       .FROM_FPGA8_AURORA_VALID(FROM_FPGA8_AURORA_VALID),
       .FROM_FPGA9_AURORA_DATAPKG(FROM_FPGA9_AURORA_DATAPKG),
       .FROM_FPGA9_AURORA_VALID(FROM_FPGA9_AURORA_VALID),
       .FROM_FPGA10_AURORA_DATAPKG(FROM_FPGA10_AURORA_DATAPKG),
       .FROM_FPGA10_AURORA_VALID(FROM_FPGA10_AURORA_VALID),
       .FROM_FPGA11_AURORA_DATAPKG(FROM_FPGA11_AURORA_DATAPKG),
       .FROM_FPGA11_AURORA_VALID(FROM_FPGA11_AURORA_VALID),
       .FROM_FPGA12_AURORA_DATAPKG(FROM_FPGA12_AURORA_DATAPKG),
       .FROM_FPGA12_AURORA_VALID(FROM_FPGA12_AURORA_VALID),
       .FROM_FPGA13_AURORA_DATAPKG(FROM_FPGA13_AURORA_DATAPKG),
       .FROM_FPGA13_AURORA_VALID(FROM_FPGA13_AURORA_VALID),
       .FROM_FPGA14_AURORA_DATAPKG(FROM_FPGA14_AURORA_DATAPKG),
       .FROM_FPGA14_AURORA_VALID(FROM_FPGA14_AURORA_VALID),
       .FROM_FPGA15_AURORA_DATAPKG(FROM_FPGA15_AURORA_DATAPKG),
       .FROM_FPGA15_AURORA_VALID(FROM_FPGA15_AURORA_VALID),

       .TO_FPGA1_AURORA_DATAPKG(FPGA1_AURORA_DATAPKG),
       .TO_FPGA1_AURORA_VALID(FPGA1_AURORA_VALID),
       .TO_FPGA2_AURORA_DATAPKG(FPGA2_AURORA_DATAPKG),
       .TO_FPGA2_AURORA_VALID(FPGA2_AURORA_VALID),
       .TO_FPGA3_AURORA_DATAPKG(FPGA3_AURORA_DATAPKG),
       .TO_FPGA3_AURORA_VALID(FPGA3_AURORA_VALID),
       .TO_FPGA4_AURORA_DATAPKG(FPGA4_AURORA_DATAPKG),
       .TO_FPGA4_AURORA_VALID(FPGA4_AURORA_VALID),
       .TO_FPGA5_AURORA_DATAPKG(FPGA5_AURORA_DATAPKG),
       .TO_FPGA5_AURORA_VALID(FPGA5_AURORA_VALID),
       .TO_FPGA6_AURORA_DATAPKG(FPGA6_AURORA_DATAPKG),
       .TO_FPGA6_AURORA_VALID(FPGA6_AURORA_VALID),
       .TO_FPGA7_AURORA_DATAPKG(FPGA7_AURORA_DATAPKG),
       .TO_FPGA7_AURORA_VALID(FPGA7_AURORA_VALID),
       .TO_FPGA8_AURORA_DATAPKG(FPGA8_AURORA_DATAPKG),
       .TO_FPGA8_AURORA_VALID(FPGA8_AURORA_VALID),
       .TO_FPGA9_AURORA_DATAPKG(FPGA9_AURORA_DATAPKG),
       .TO_FPGA9_AURORA_VALID(FPGA9_AURORA_VALID),
       .TO_FPGA10_AURORA_DATAPKG(FPGA10_AURORA_DATAPKG),
       .TO_FPGA10_AURORA_VALID(FPGA10_AURORA_VALID),
       .TO_FPGA11_AURORA_DATAPKG(FPGA11_AURORA_DATAPKG),
       .TO_FPGA11_AURORA_VALID(FPGA11_AURORA_VALID),
       .TO_FPGA12_AURORA_DATAPKG(FPGA12_AURORA_DATAPKG),
       .TO_FPGA12_AURORA_VALID(FPGA12_AURORA_VALID),
       .TO_FPGA13_AURORA_DATAPKG(FPGA13_AURORA_DATAPKG),
       .TO_FPGA13_AURORA_VALID(FPGA13_AURORA_VALID),
       .TO_FPGA14_AURORA_DATAPKG(FPGA14_AURORA_DATAPKG),
       .TO_FPGA14_AURORA_VALID(FPGA14_AURORA_VALID),
       .TO_FPGA15_AURORA_DATAPKG(FPGA15_AURORA_DATAPKG),
       .TO_FPGA15_AURORA_VALID(FPGA15_AURORA_VALID),

       .XGMII_TXD(XGMII_TXD),//万兆网回传数据
       .XGMII_TXDV(XGMII_TXDV),
       .TX_DONE(TX_DONE)             
    );
endmodule
