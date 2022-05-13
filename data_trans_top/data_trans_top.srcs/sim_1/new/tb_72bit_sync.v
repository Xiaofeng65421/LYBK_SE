`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/13 10:46:42
// Design Name: 
// Module Name: tb_72bit_sync
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 路由从上电到正常工作的综合仿真
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_72bit_sync();
 reg         clk_100m;
 reg         soft_rst;
 reg         TrigIn;
 reg         rx_data_vald;
 reg [7:0]   rx_data;
 wire        tx_data_vald;
 wire        tx_data;
 wire        TrigOkOut;
 wire        sync;

 reg [15:0]  FPGA_READY;
 wire[15:0]  FPGA_SYS_RST;
 wire[15:0]  TRIGGER_OUT;

 reg [10:0] tb_time_cnt;

 reg [63:0] xgmii_rxd;
 reg        xgmii_rxdv;
 reg        xgmii_clk;


initial begin
    clk_100m = 0;
    soft_rst = 0;
    TrigIn = 0;
    rx_data_vald = 0;
    rx_data = 0;
    FPGA_READY = 0;
    tb_time_cnt = 0;
    xgmii_rxd = 0;
    xgmii_rxdv = 0;
    xgmii_clk = 0;
end

always #5 clk_100m = ~clk_100m;
always #5 xgmii_clk = ~xgmii_clk;

always @(posedge clk_100m)
   tb_time_cnt <= tb_time_cnt + 1;

always @(posedge clk_100m)
   if (tb_time_cnt == 5) begin
          soft_rst <= 1;
      end else if (tb_time_cnt == 10) begin
          soft_rst <= 0;
      end else if (tb_time_cnt == 20) begin
          FPGA_READY <= 16'hffff;  //干扰
      end else if (tb_time_cnt == 25) begin
          FPGA_READY <= 0;
          rx_data_vald <= 1;
          rx_data <= 8'hcd;
      end else if (tb_time_cnt == 26) begin
          rx_data <= 8'h05;
      end else if (tb_time_cnt == 27) begin
          rx_data <= 0;
      end else if (tb_time_cnt == 32) begin
          rx_data <= 8'hef;
      end else if (tb_time_cnt == 33) begin
          rx_data_vald <= 0;
      end
      //全局复位
      else if (tb_time_cnt == 40) begin
          FPGA_READY <= 16'hffff;  //干扰
      end else if (tb_time_cnt == 50) begin
          FPGA_READY <= 0;
      end else if (tb_time_cnt == 100) begin
          FPGA_READY <= 16'hffff; //下层板卡就绪
      end else if (tb_time_cnt == 110) begin
          FPGA_READY <= 0;
      end else if (tb_time_cnt == 130) begin
          TrigIn <= 1;
      end else if (tb_time_cnt == 145) begin
          TrigIn <= 0; //中控触发
      end else if (tb_time_cnt == 180) begin
          rx_data_vald <= 1;
          rx_data <= 8'hcd;
      end else if (tb_time_cnt == 181) begin
          rx_data <= 8'h02; 
      end else if (tb_time_cnt == 182) begin
          rx_data <= 8'h05;
      end else if (tb_time_cnt == 183) begin
          rx_data <= 0;
      end else if (tb_time_cnt == 187) begin
          rx_data <= 8'hef;
      end else if (tb_time_cnt == 188) begin
          rx_data_vald <= 0;
      end
      //延迟参数下发
      else if (tb_time_cnt == 250) begin
          TrigIn <= 1;
      end else if (tb_time_cnt == 265) begin
          TrigIn <= 0; //中控的同步信号
      end else if (tb_time_cnt == 400) begin
          FPGA_READY <= 16'hffff;
      end else if (tb_time_cnt == 410) begin
          FPGA_READY <= 0;
      end
      //同步完成，进入工作状态 
      else if (tb_time_cnt == 450) begin
          xgmii_rxdv <= 1;
          xgmii_rxd <= 64'h18efdc0118efdc01;
      end else if (tb_time_cnt == 451) begin
          xgmii_rxd[63:56] <= 8'h02;//任务
          xgmii_rxd[55:48] <= 8'h00;//路由保存
          xgmii_rxd[47:40] <= 8'h00;
          xgmii_rxd[39:8 ] <= 32'd2;
          xgmii_rxd[7 :0 ] <= 8'h00;
      end else if (tb_time_cnt == 452) begin
          xgmii_rxd[63:56] <= 8'h01;
          xgmii_rxd[55:48] <= 8'h02;
          xgmii_rxd[47:32] <= 16'hc307;//fpga掩码
          xgmii_rxd[31:24] <= 8'h00;
          xgmii_rxd[23:16] <= 8'h01;
          xgmii_rxd[15:0]  <= 0;
      end else if (tb_time_cnt == 453) begin
          xgmii_rxd <= $random%1000; 
      end else if (tb_time_cnt == 454) begin
          xgmii_rxd <= 64'h01dcef1801dcef18;
      end else if (tb_time_cnt == 455) begin
          xgmii_rxdv <= 0;
      end else if (tb_time_cnt == 500) begin
          FPGA_READY <= 16'h8307;
      end
      //路由包下发，无就绪
 wire        sys_rst;
 wire [3:0]  system_state;
 wire        to_zk_ready;
 wire [7:0]  to_zk_task_id;
 wire        ready_check_en;
 wire        ready_receive_valid;
 wire [15:0] fpga_ready_state_mask;
 wire [7:0]  resetorder_type;
 wire        resetorder_type_valid;
 wire [15:0] FPGA_ID_local;
 wire [7:0]  TASK_ID_thread;
 wire [7:0]  zk_task_id;
 wire        trigout;
 wire        sync_en; 

RouterSychTop_test RouterSychTop_test(
        .clk(clk_100m),//100M 7044
        .sync_rst(sys_rst),
        .soft_rst(soft_rst),//上电复位
        .TrigIn(TrigIn),

        .tx_fifo_empty(1),
        .rx_data_vald(rx_data_vald),
        .rx_data(rx_data),
        .tx_data_vald(tx_data_vald),
        .tx_data(tx_data), 

        .TrigOkOut(TrigOkOut),
        .state(system_state),
        .ready_id_valid(to_zk_ready),
        .ready_id(to_zk_task_id),

        .READY_CHECK_EN(ready_check_en),
        .READY_RECEIVE_VALID(ready_receive_valid),
        .FPGA_READY_STATE_MASK(fpga_ready_state_mask), 

        .resetorder_type(resetorder_type),
        .resetorder_type_valid(resetorder_type_valid),
        .FPGA_ID_local(FPGA_ID_local),
        .TASK_ID_thread(TASK_ID_thread),
        .zk_task_id(zk_task_id),
        .trigout(trigout),
        .sync(sync),
        
        .sync_en(sync_en)    
    );

wire        bk_order_datapkg_valid;
wire [63:0] bk_order_datapkg;
bk_order_create bk_order_create_inst(
     .clk(clk_100m),
     .rst(sys_rst),
     .sync_en(sync_en),
     .bk_order_datapkg(bk_order_datapkg),
     .bk_order_datapkg_valid(bk_order_datapkg_valid) 
  );

lybk_function lybk_function_inst(
      .XGMII_RXD(xgmii_rxd),   //万兆网下发有效位 
      .XGMII_RXDV(xgmii_rxdv), //万兆网下发数据
      .XGMII_RX_CLK(clk_100m),
      .XGMII_TX_CLK(xgmii_clk),//万兆网回传时钟 156.25M
      .TRIGGER_CLK(clk_100m),
      .RST_N(~soft_rst),
      .ZKBK_TRIGGER(trigout),
      .ZKBK_TASK_ID(zk_task_id),

      .SYSTEM_STATE(system_state),
      .ORDER_TYPE(resetorder_type),
      .ORDER_TYPE_VALID(resetorder_type_valid),
      .FPGA_ID_local(FPGA_ID_local),
      .TASK_ID_thread(TASK_ID_thread),

      .READY_RECEIVE_VALID(ready_receive_valid),
      .READY_CHECK_EN(ready_check_en),
      .BK_ORDER_DATAPKG(bk_order_datapkg),
      .BK_ORDER_DATAPKG_VALID(bk_order_datapkg_valid),

      .FPGA_READY(FPGA_READY),
      .TO_ZKBK_READY(to_zk_ready),
      .TO_ZKBK_TASK_ID(to_zk_task_id),
/*      .PASSBACK_LENGTH(PASSBACK_LENGTH),
      .PASSBACK_LENGTH_VALID(PASSBACK_LENGTH_VALID),*/

      .TRIGGER_OUT(TRIGGER_OUT),
      .FPGA_SYS_RST(FPGA_SYS_RST),//fpga系统复位
      .SYS_RST(sys_rst),//系统复位 : out
      .TASK_RST(task_rst),//线程复位 : out

      .TO_FPGA1_AURORA_DATAPKG(fpga1_aurora),
      .TO_FPGA1_AURORA_VALID  (fpga1_valid),
      .TO_FPGA2_AURORA_DATAPKG(fpga2_aurora),
      .TO_FPGA2_AURORA_VALID  (fpga2_valid),
      .TO_FPGA3_AURORA_DATAPKG(fpga3_aurora),
      .TO_FPGA3_AURORA_VALID  (fpga3_valid),
      .TO_FPGA4_AURORA_DATAPKG(fpga4_aurora),
      .TO_FPGA4_AURORA_VALID  (fpga4_valid),
      .TO_FPGA5_AURORA_DATAPKG(fpga5_aurora),
      .TO_FPGA5_AURORA_VALID  (fpga5_valid),
      .TO_FPGA6_AURORA_DATAPKG(fpga6_aurora),
      .TO_FPGA6_AURORA_VALID  (fpga6_valid),
      .TO_FPGA7_AURORA_DATAPKG(fpga7_aurora),
      .TO_FPGA7_AURORA_VALID  (fpga7_valid),
      .TO_FPGA8_AURORA_DATAPKG(fpga8_aurora),
      .TO_FPGA8_AURORA_VALID  (fpga8_valid),
      .TO_FPGA9_AURORA_DATAPKG(fpga9_aurora),
      .TO_FPGA9_AURORA_VALID  (fpga9_valid),
      .TO_FPGA10_AURORA_DATAPKG(fpga10_aurora),
      .TO_FPGA10_AURORA_VALID  (fpga10_valid),
      .TO_FPGA11_AURORA_DATAPKG(fpga11_aurora),
      .TO_FPGA11_AURORA_VALID  (fpga11_valid),
      .TO_FPGA12_AURORA_DATAPKG(fpga12_aurora),
      .TO_FPGA12_AURORA_VALID  (fpga12_valid),
      .TO_FPGA13_AURORA_DATAPKG(fpga13_aurora),
      .TO_FPGA13_AURORA_VALID  (fpga13_valid),
      .TO_FPGA14_AURORA_DATAPKG(fpga14_aurora),
      .TO_FPGA14_AURORA_VALID  (fpga14_valid),
      .TO_FPGA15_AURORA_DATAPKG(fpga15_aurora),
      .TO_FPGA15_AURORA_VALID  (fpga15_valid),
      .TO_FPGA16_AURORA_DATAPKG(fpga16_aurora),
      .TO_FPGA16_AURORA_VALID  (fpga16_valid),

/*      .STATE_PASSBACK_DATA(xgmii_passback_data),
      .STATE_PASSBACK_DV(xgmii_passback_data_valid),*/
      .FPGA_READY_STATE_MASK(fpga_ready_state_mask)

    );

endmodule
