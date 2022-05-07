`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/29 16:07:00
// Design Name: 
// Module Name: lybk_aurora_top
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


module lybk_aurora_top(
      input        XGMII_CLK,//万兆网下发时钟100M
      input        SYS_RST,     
      input        CLK_100M,//init_clk 
      input        DDR_CLK,//ddr_user_clk
      input        GTH_P_0,
      input        GTH_N_0,
      input [7:0]  RXP_0,
      input [7:0]  RXN_0,
      output[7:0]  TXP_0,
      output[7:0]  TXN_0,

      input [63:0] TO_FPGA1_AURORA_DATAPKG,
      input        TO_FPGA1_AURORA_VALID,
      input [63:0] TO_FPGA2_AURORA_DATAPKG,
      input        TO_FPGA2_AURORA_VALID,
      input [63:0] TO_FPGA3_AURORA_DATAPKG,
      input        TO_FPGA3_AURORA_VALID,
      input [63:0] TO_FPGA4_AURORA_DATAPKG,
      input        TO_FPGA4_AURORA_VALID,
      input [63:0] TO_FPGA5_AURORA_DATAPKG,
      input        TO_FPGA5_AURORA_VALID,
      input [63:0] TO_FPGA6_AURORA_DATAPKG,
      input        TO_FPGA6_AURORA_VALID,
      input [63:0] TO_FPGA7_AURORA_DATAPKG,
      input        TO_FPGA7_AURORA_VALID,
      input [63:0] TO_FPGA8_AURORA_DATAPKG,
      input        TO_FPGA8_AURORA_VALID,
      input [63:0] TO_FPGA9_AURORA_DATAPKG,
      input        TO_FPGA9_AURORA_VALID,
      input [63:0] TO_FPGA10_AURORA_DATAPKG,
      input        TO_FPGA10_AURORA_VALID,
      input [63:0] TO_FPGA11_AURORA_DATAPKG,
      input        TO_FPGA11_AURORA_VALID,
      input [63:0] TO_FPGA12_AURORA_DATAPKG,
      input        TO_FPGA12_AURORA_VALID,
      input [63:0] TO_FPGA13_AURORA_DATAPKG,
      input        TO_FPGA13_AURORA_VALID,
      input [63:0] TO_FPGA14_AURORA_DATAPKG,
      input        TO_FPGA14_AURORA_VALID,
      input [63:0] TO_FPGA15_AURORA_DATAPKG,
      input        TO_FPGA15_AURORA_VALID,
      input [63:0] TO_FPGA16_AURORA_DATAPKG,
      input        TO_FPGA16_AURORA_VALID, 

      output [63:0] FROM_FPGA16_AURORA_DATAPKG,
      output        FROM_FPGA16_AURORA_VALID,
      
      input        GTH_P_1,
      input        GTH_N_1,
      input [7:0]  RXP_1,
      input [7:0]  RXN_1,
      output[7:0]  TXP_1,
      output[7:0]  TXN_1


    );
wire  clk_100m;
wire  gth_clk0;
wire  gth_clk1;
wire [63:0] aurora0_tx_data [7:0];
wire        aurora0_tx_valid[7:0];
wire [63:0] aurora0_rx_data [7:0];
wire        aurora0_rx_valid[7:0];

wire [63:0] aurora1_tx_data [7:0];
wire        aurora1_tx_valid[7:0];
wire [63:0] aurora1_rx_data [7:0];
wire        aurora1_rx_valid[7:0];
wire [7:0]  full;
wire [31:0] data_cnt[7:0];
(* MARK_DEBUG="true" *)wire        AWG1_FULL;
(* MARK_DEBUG="true" *)wire [31:0] AWG1_DATA_CNT;


assign clk_100m = CLK_100M;
assign AWG1_FULL = full[0];
assign AWG1_DATA_CNT = data_cnt[0];

assign aurora0_tx_data[0] = TO_FPGA1_AURORA_DATAPKG;
assign aurora0_tx_data[1] = TO_FPGA2_AURORA_DATAPKG;
assign aurora0_tx_data[2] = TO_FPGA3_AURORA_DATAPKG;
assign aurora0_tx_data[3] = TO_FPGA4_AURORA_DATAPKG;
assign aurora0_tx_data[4] = TO_FPGA5_AURORA_DATAPKG;
assign aurora0_tx_data[5] = TO_FPGA6_AURORA_DATAPKG;
assign aurora0_tx_data[6] = TO_FPGA7_AURORA_DATAPKG;
assign aurora0_tx_data[7] = TO_FPGA8_AURORA_DATAPKG;

assign aurora1_tx_data[0] = TO_FPGA9_AURORA_DATAPKG;
assign aurora1_tx_data[1] = TO_FPGA10_AURORA_DATAPKG;
assign aurora1_tx_data[2] = TO_FPGA11_AURORA_DATAPKG;
assign aurora1_tx_data[3] = TO_FPGA12_AURORA_DATAPKG;
assign aurora1_tx_data[4] = TO_FPGA13_AURORA_DATAPKG;
assign aurora1_tx_data[5] = TO_FPGA14_AURORA_DATAPKG;
assign aurora1_tx_data[6] = TO_FPGA15_AURORA_DATAPKG;
assign aurora1_tx_data[7] = TO_FPGA16_AURORA_DATAPKG;

assign aurora0_tx_valid[0] = TO_FPGA1_AURORA_VALID;
assign aurora0_tx_valid[1] = TO_FPGA2_AURORA_VALID;
assign aurora0_tx_valid[2] = TO_FPGA3_AURORA_VALID;
assign aurora0_tx_valid[3] = TO_FPGA4_AURORA_VALID;
assign aurora0_tx_valid[4] = TO_FPGA5_AURORA_VALID;
assign aurora0_tx_valid[5] = TO_FPGA6_AURORA_VALID;
assign aurora0_tx_valid[6] = TO_FPGA7_AURORA_VALID;
assign aurora0_tx_valid[7] = TO_FPGA8_AURORA_VALID;

assign aurora1_tx_valid[0] = TO_FPGA9_AURORA_VALID;
assign aurora1_tx_valid[1] = TO_FPGA10_AURORA_VALID;
assign aurora1_tx_valid[2] = TO_FPGA11_AURORA_VALID;
assign aurora1_tx_valid[3] = TO_FPGA12_AURORA_VALID;
assign aurora1_tx_valid[4] = TO_FPGA13_AURORA_VALID;
assign aurora1_tx_valid[5] = TO_FPGA14_AURORA_VALID;
assign aurora1_tx_valid[6] = TO_FPGA15_AURORA_VALID;
assign aurora1_tx_valid[7] = TO_FPGA16_AURORA_VALID;

assign FROM_FPGA16_AURORA_DATAPKG = aurora0_rx_data[6];
assign FROM_FPGA16_AURORA_VALID = aurora0_rx_valid[6];

 IBUFDS_GTE3 IBUFDS_GTE3_refclk0 (
    .I     (GTH_P_0),
    .IB    (GTH_N_0),
    .CEB   (1'b0),
    .O     (gth_clk0),
    .ODIV2 ()
  );

 IBUFDS_GTE3 IBUFDS_GTE3_refclk1 (
    .I     (GTH_P_1),
    .IB    (GTH_N_1),
    .CEB   (1'b0),
    .O     (gth_clk1),
    .ODIV2 ()
  );

 //-------------------add------------------------//
wire [7:0]  qpll0_reset;
wire [7:0]  qpll0_lock;
wire [7:0]  qpll0_outclk;
wire [7:0]  qpll0_outrefclk;
wire [7:0]  qpll0_refclklost;

wire [2:0]  qpll0_reset_pre;
wire [2:0]  qpll0_lock_pre;
wire [2:0]  qpll0_outclk_pre;
wire [2:0]  qpll0_outrefclk_pre;
wire [2:0]  qpll0_refclklost_pre;

assign qpll0_reset_pre[0] = qpll0_reset[0];
assign qpll0_reset_pre[1] = qpll0_reset[2];
assign qpll0_reset_pre[2] = qpll0_reset[4];

assign qpll0_lock[1:0] = {2{qpll0_lock_pre[0]}};
assign qpll0_lock[3:2] = {2{qpll0_lock_pre[1]}};
assign qpll0_lock[7:4] = {4{qpll0_lock_pre[2]}};

assign qpll0_outclk[1:0]   = {2{qpll0_outclk_pre[0]}};
assign qpll0_outclk[3:2]   = {2{qpll0_outclk_pre[1]}};
assign qpll0_outclk[7:4]   = {4{qpll0_outclk_pre[2]}};

assign qpll0_outrefclk[1:0]   = {2{qpll0_outrefclk_pre[0]}};
assign qpll0_outrefclk[3:2]   = {2{qpll0_outrefclk_pre[1]}};
assign qpll0_outrefclk[7:4]   = {4{qpll0_outrefclk_pre[2]}};

assign qpll0_refclklost[1:0]   = {2{qpll0_refclklost_pre[0]}};
assign qpll0_refclklost[3:2]   = {2{qpll0_refclklost_pre[1]}};
assign qpll0_refclklost[7:4]   = {4{qpll0_refclklost_pre[2]}};


generate
  genvar k;
  for(k = 0 ; k < 3 ; k = k + 1)begin : gt_common_0
      aurora_64b66b_0_gt_common_wrapper ultrascale_gt_common_0 (
       .qpll1_refclk                (gth_clk0),                   // input  gt_refclk
       .qpll1_reset                 (qpll0_reset_pre[k]),     // input

       .qpll1_lock_detclk           (clk_100m),                     // input  ini_clk

       .qpll1_lock                  (qpll0_lock_pre[k]),         // output
       .qpll1_outclk                (qpll0_outclk_pre[k]),           // output
       .qpll1_outrefclk             (qpll0_outrefclk_pre[k]),        // output
       .qpll1_refclklost            (qpll0_refclklost_pre[k])
      );
  end
endgenerate

generate
	genvar i;
	for(i = 0 ; i < 8 ; i = i + 1)begin : aurora_0
	lybk_aurora lybk_aurora_0(
       .XGMII_CLK(XGMII_CLK),
       .SYS_RST(SYS_RST),
       .CLK_100M(clk_100m),
       .GTH_CLK(gth_clk0),
       .DDR_CLK(DDR_CLK),

       .AURORA_TX_DATA(aurora0_tx_data[i]),
       .AURORA_TX_VALID(aurora0_tx_valid[i]),
       .AURORA_RX_DATA(aurora0_rx_data[i]),
       .AURORA_RX_VALID(aurora0_rx_valid[i]),
       .FULL(full[i]),
       .DATA_CNT(data_cnt[i]),

       .RXP(RXP_0[i]),
       .RXN(RXN_0[i]),
       .TXP(TXP_0[i]),
       .TXN(TXN_0[i]),

       .qpll1_lock_quad1_out(qpll0_lock[i]),
       .gt_qpllclk_quad1_i(qpll0_outclk[i]),
       .gt_qpllrefclk_quad1_i(qpll0_outrefclk[i]),
       .qpll1_refclklost1_out(qpll0_refclklost[i]),
       .gt_to_common_qpllreset_i(qpll0_reset[i])

    );
	end
endgenerate
///////////////////////////////
wire [7:0]  qpll1_reset;
wire [7:0]  qpll1_lock;
wire [7:0]  qpll1_outclk;
wire [7:0]  qpll1_outrefclk;
wire [7:0]  qpll1_refclklost;

wire [2:0]  qpll1_reset_pre;
wire [2:0]  qpll1_lock_pre;
wire [2:0]  qpll1_outclk_pre;
wire [2:0]  qpll1_outrefclk_pre;
wire [2:0]  qpll1_refclklost_pre;

assign qpll1_reset_pre[0] = qpll1_reset[0];
assign qpll1_reset_pre[1] = qpll1_reset[4];
assign qpll1_reset_pre[2] = qpll1_reset[6];

assign qpll1_lock[3:0] = {4{qpll1_lock_pre[0]}};
assign qpll1_lock[5:4] = {2{qpll1_lock_pre[1]}};
assign qpll1_lock[7:6] = {2{qpll1_lock_pre[2]}};

assign qpll1_outclk[3:0]   = {4{qpll1_outclk_pre[0]}};
assign qpll1_outclk[5:4]   = {2{qpll1_outclk_pre[1]}};
assign qpll1_outclk[7:6]   = {2{qpll1_outclk_pre[2]}};

assign qpll1_outrefclk[3:0]   = {4{qpll1_outrefclk_pre[0]}};
assign qpll1_outrefclk[5:4]   = {2{qpll1_outrefclk_pre[1]}};
assign qpll1_outrefclk[7:6]   = {2{qpll1_outrefclk_pre[2]}};

assign qpll1_refclklost[3:0]   = {4{qpll1_refclklost_pre[0]}};
assign qpll1_refclklost[5:4]   = {2{qpll1_refclklost_pre[1]}};
assign qpll1_refclklost[7:6]   = {2{qpll1_refclklost_pre[2]}};


generate
  genvar l;
  for(l = 0 ; l < 3 ; l = l + 1)begin : gt_common_1
      aurora_64b66b_0_gt_common_wrapper ultrascale_gt_common_1 (
       .qpll1_refclk                (gth_clk1),                   // input  gt_refclk
       .qpll1_reset                 (qpll0_reset_pre[l]),     // input

       .qpll1_lock_detclk           (clk_100m),                     // input  ini_clk

       .qpll1_lock                  (qpll1_lock_pre[l]),         // output
       .qpll1_outclk                (qpll1_outclk_pre[l]),           // output
       .qpll1_outrefclk             (qpll1_outrefclk_pre[l]),        // output
       .qpll1_refclklost            (qpll1_refclklost_pre[l])
      );
  end
endgenerate

generate
	genvar j;
    for(j = 0 ; j < 8; j = j + 1)begin : aurora_1
    lybk_aurora lybk_aurora_1(
       .XGMII_CLK(XGMII_CLK),
       .SYS_RST(SYS_RST),
       .CLK_100M(clk_100m),
       .GTH_CLK(gth_clk1),
       .DDR_CLK(DDR_CLK),

       .AURORA_TX_DATA(aurora1_tx_data[j]),
       .AURORA_TX_VALID(aurora1_tx_valid[j]),
       .AURORA_RX_DATA(aurora1_rx_data[j]),
       .AURORA_RX_VALID(aurora1_rx_valid[j]),

       .RXP(RXP_1[j]),
       .RXN(RXN_1[j]),
       .TXP(TXP_1[j]),
       .TXN(TXN_1[j]),

       .qpll1_lock_quad1_out(    qpll1_lock[j]),
       .gt_qpllclk_quad1_i(      qpll1_outclk[j]),
       .gt_qpllrefclk_quad1_i(   qpll1_outrefclk[j]),
       .qpll1_refclklost1_out(   qpll1_refclklost[j]),
       .gt_to_common_qpllreset_i(qpll1_reset[j])
    );
    end	
endgenerate


endmodule
