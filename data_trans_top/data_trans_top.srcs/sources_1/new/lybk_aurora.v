`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/22 14:25:35
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


module lybk_aurora(
	     input               XGMII_CLK,//万兆网下发时钟100M
	     input               SYS_RST,
       input               CLK_100M, //init_clk
       input               GTH_CLK,
       input               DDR_CLK, //156.25M
////////user  interface
       input   [63:0]      AURORA_TX_DATA,
       input               AURORA_TX_VALID,
       output  [63:0]      AURORA_RX_DATA,
       output              AURORA_RX_VALID,  
////////
       input               RXP,
       input               RXN,
       output              TXP,
       output              TXN,

       output              FULL,
       output  [31:0]      DATA_CNT,
////////add
       input               qpll1_lock_quad1_out,
       input               gt_qpllclk_quad1_i,
       input               gt_qpllrefclk_quad1_i,
       input               qpll1_refclklost1_out,
       output              gt_to_common_qpllreset_i

    );
wire  user_clk; //133M

wire [0:63] tx_fifo_data;
wire        tx_fifo_valid;
wire [0:63] rx_fifo_data;
wire        rx_fifo_valid;
wire        tx_ready;
wire        channel_up;

wire [63:0]  wr_data ;
wire         wr_en ;
wire         rd_en ;
wire [63:0]  rd_data;
wire        empty;
wire        full;

reg  [31:0] DATA_CNT = 1;

//_______________data_check_________________//
/*(* MARK_DEBUG="true" *)reg [15:0] data_addr = 'd603;
(* MARK_DEBUG="true" *)wire [63:0] douta;
(* MARK_DEBUG="true" *)reg  [63:0] data;
(* MARK_DEBUG="true" *)wire        data_error;

assign data_error = (data != douta)&tx_fifo_valid;

always @(posedge user_clk)
  data <= tx_fifo_data;

always @(posedge user_clk or posedge SYS_RST)
  if (SYS_RST) begin
      data_addr <= 'd603;
  end else if (tx_fifo_valid) begin
      data_addr <= data_addr + 1;
  end


datapackage_test datapackage_test (
  .clka(user_clk),    // input wire clka
  .ena(tx_fifo_valid),      // input wire ena
  .addra(data_addr),  // input wire [15 : 0] addra
  .douta(douta)  // output wire [63 : 0] douta
);
*/

//______________fifo to aurora________________//
assign rd_en           = ~empty & tx_ready & channel_up; 
assign tx_fifo_valid   = rd_en;
assign tx_fifo_data    = rd_data;
assign wr_en           = AURORA_TX_VALID;
assign wr_data         = AURORA_TX_DATA;
assign FULL = full;

fifo_to_aurora fifo_to_aurora_inst (
  .rst(SYS_RST),	
  .wr_clk(XGMII_CLK),            // input wire wr_clk
  .rd_clk(user_clk),            // input wire rd_clk
  .din(wr_data),                   // input wire [63 : 0] din
  .wr_en(wr_en),              // input wire wr_en
  .rd_en(rd_en),              // input wire rd_en
  .dout(rd_data),                // output wire [63 : 0] dout
  .full(full),                // output wire full
  .empty(empty)              // output wire empty
);

always @(posedge user_clk or posedge SYS_RST)
   if (SYS_RST) begin
       DATA_CNT <= 1;
   end else 
   if (tx_fifo_valid) begin
       DATA_CNT <= DATA_CNT + 1;
   end

//_____________________________________________//
//______________aurora to fifo________________//
wire  rd_en_1;
wire  wr_en_1;
wire  full_1;
wire  empty_1;

assign rd_en_1 = ~empty_1;
assign wr_en_1 = channel_up & rx_fifo_valid;

aurora_to_fifo aurora_to_fifo_inst (
  .srst(SYS_RST),	
  .wr_clk(user_clk),            // input wire wr_clk
  .rd_clk(DDR_CLK),            // input wire rd_clk
  .din(rx_fifo_data),                  // input wire [63 : 0] din
  .wr_en(wr_en_1),              // input wire wr_en
  .rd_en(rd_en_1),              // input wire rd_en
  .dout(AURORA_RX_DATA),                // output wire [63 : 0] dout
  .valid(AURORA_RX_VALID),
  .full(full_1),                // output wire full
  .empty(empty_1)              // output wire empty
);
//_____________________________________________//
//______________aurora______________________//
aurora_64b66b_0_exdes trans_aurora(

    .INIT_CLK_i(CLK_100M),
    .USER_CLK(user_clk),

    .TX_DATA(tx_fifo_data),
    .TX_DATA_VALID(tx_fifo_valid),
    .TX_READY(tx_ready),
    .RX_DATA(rx_fifo_data),
    .RX_DATA_VALID(rx_fifo_valid),
    .CHANNEL_UP(channel_up),

    .GTH_CLK(GTH_CLK),

    .RXP(RXP),
    .RXN(RXN),
    .TXP(TXP),
    .TXN(TXN),
         //add
    .qpll1_lock_quad1_out(qpll1_lock_quad1_out),
    .gt_qpllclk_quad1_i(gt_qpllclk_quad1_i),
    .gt_qpllrefclk_quad1_i(gt_qpllrefclk_quad1_i),
    .qpll1_refclklost1_out(qpll1_refclklost1_out),
    .gt_to_common_qpllreset_i(gt_to_common_qpllreset_i)
	);

endmodule
