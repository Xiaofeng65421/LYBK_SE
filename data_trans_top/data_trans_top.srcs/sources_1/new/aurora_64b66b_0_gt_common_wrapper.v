//------------------------------------------------------------------------------

// This is GT common file for ultrascale devices

`timescale 1ps / 1ps
(* DowngradeIPIdentifiedWarnings="yes" *)


module aurora_64b66b_0_gt_common_wrapper
    (
     input  qpll1_refclk,        // connect to refclk1_in from example design
     input  qpll1_reset,         // connect to reset out of TX clocking module
     input  qpll1_lock_detclk,

     output qpll1_lock,          // connect to &txpmareset done from multi GT
     output qpll1_outclk,        // connect to single quad input clock of GT channel
     output qpll1_outrefclk,     // connect to single quad input reference clock of GT channel
     output qpll1_refclklost

    );

  // List of signals to connect to GT Common block
  wire    GTHE3_COMMON_GTREFCLK01;
  wire    GTHE3_COMMON_QPLL1RESET;
  wire    GTHE3_COMMON_QPLL1LOCK;
  wire    GTHE3_COMMON_QPLL1OUTCLK;
  wire    GTHE3_COMMON_QPLL1OUTREFCLK;
  wire [2:0]  GTHE3_COMMON_QPLL1REFCLKSEL; // select 3'b001, GTREFCLK1 is the choice as input
  wire    GTHE3_COMMON_QPLL1REFCLKLOST;
  wire    GTHE3_COMMON_QPLL1LOCKDETCLK;

  // Connect only required internal signals to GT Common block
  assign GTHE3_COMMON_QPLL1RESET      = qpll1_reset;
  assign GTHE3_COMMON_GTREFCLK01                          = qpll1_refclk;
  assign GTHE3_COMMON_QPLL1REFCLKSEL  = 3'b001;
  assign GTHE3_COMMON_QPLL1LOCKDETCLK = qpll1_lock_detclk;
  assign qpll1_lock                   = GTHE3_COMMON_QPLL1LOCK;
  assign qpll1_outclk                 = GTHE3_COMMON_QPLL1OUTCLK;
  assign qpll1_outrefclk              = GTHE3_COMMON_QPLL1OUTREFCLK;
  assign qpll1_refclklost             = GTHE3_COMMON_QPLL1REFCLKLOST;

// dynamic call of GT common instance is here
  aurora_64b66b_0_gt_gthe3_common_wrapper aurora_64b66b_0_gt_gthe3_common_wrapper_i
  (
   .GTHE3_COMMON_BGBYPASSB(1'b1),
   .GTHE3_COMMON_BGMONITORENB(1'b1),
   .GTHE3_COMMON_BGPDB(1'b1),
   .GTHE3_COMMON_BGRCALOVRD(5'b11111),
   .GTHE3_COMMON_BGRCALOVRDENB(1'b1),
   .GTHE3_COMMON_DRPADDR(9'b000000000),
   .GTHE3_COMMON_DRPCLK(1'b0),
   .GTHE3_COMMON_DRPDI(16'b0000000000000000),
   .GTHE3_COMMON_DRPDO(),
   .GTHE3_COMMON_DRPEN(1'b0),
   .GTHE3_COMMON_DRPRDY(),
   .GTHE3_COMMON_DRPWE(1'b0),
   .GTHE3_COMMON_GTGREFCLK0(1'b0),
   .GTHE3_COMMON_GTGREFCLK1(1'b0),
   .GTHE3_COMMON_GTNORTHREFCLK00(1'b0),
   .GTHE3_COMMON_GTNORTHREFCLK01(1'b0),
   .GTHE3_COMMON_GTNORTHREFCLK10(1'b0),
   .GTHE3_COMMON_GTNORTHREFCLK11(1'b0),
   .GTHE3_COMMON_GTREFCLK00(1'b0),
   .GTHE3_COMMON_GTREFCLK01(GTHE3_COMMON_GTREFCLK01),
   .GTHE3_COMMON_GTREFCLK10(1'b0),
   .GTHE3_COMMON_GTREFCLK11(1'b0),
   .GTHE3_COMMON_GTSOUTHREFCLK00(1'b0),
   .GTHE3_COMMON_GTSOUTHREFCLK01(1'b0),
   .GTHE3_COMMON_GTSOUTHREFCLK10(1'b0),
   .GTHE3_COMMON_GTSOUTHREFCLK11(1'b0),
   .GTHE3_COMMON_PMARSVD0(8'b00000000),
   .GTHE3_COMMON_PMARSVD1(8'b00000000),
   .GTHE3_COMMON_PMARSVDOUT0(),
   .GTHE3_COMMON_PMARSVDOUT1(),
   .GTHE3_COMMON_QPLL0CLKRSVD0(1'b0),
   .GTHE3_COMMON_QPLL0CLKRSVD1(1'b0),
   .GTHE3_COMMON_QPLL0FBCLKLOST(),
   .GTHE3_COMMON_QPLL0LOCK(),
   .GTHE3_COMMON_QPLL0LOCKDETCLK(1'b0),
   .GTHE3_COMMON_QPLL0LOCKEN(1'b0),
   .GTHE3_COMMON_QPLL0OUTCLK(),
   .GTHE3_COMMON_QPLL0OUTREFCLK(),
   .GTHE3_COMMON_QPLL0PD(1'b1),
   .GTHE3_COMMON_QPLL0REFCLKLOST(),
   .GTHE3_COMMON_QPLL0REFCLKSEL(3'b001),
   .GTHE3_COMMON_QPLL0RESET(1'b1),
   .GTHE3_COMMON_QPLL1CLKRSVD0(1'b0),
   .GTHE3_COMMON_QPLL1CLKRSVD1(1'b0),
   .GTHE3_COMMON_QPLL1FBCLKLOST(),
   .GTHE3_COMMON_QPLL1LOCK(GTHE3_COMMON_QPLL1LOCK),
   .GTHE3_COMMON_QPLL1LOCKDETCLK(GTHE3_COMMON_QPLL1LOCKDETCLK),
   .GTHE3_COMMON_QPLL1LOCKEN(1'b1),
   .GTHE3_COMMON_QPLL1OUTCLK(GTHE3_COMMON_QPLL1OUTCLK),
   .GTHE3_COMMON_QPLL1OUTREFCLK(GTHE3_COMMON_QPLL1OUTREFCLK),
   .GTHE3_COMMON_QPLL1PD(1'b0),
   .GTHE3_COMMON_QPLL1REFCLKLOST(GTHE3_COMMON_QPLL1REFCLKLOST),
   .GTHE3_COMMON_QPLL1REFCLKSEL(GTHE3_COMMON_QPLL1REFCLKSEL),
   .GTHE3_COMMON_QPLL1RESET(GTHE3_COMMON_QPLL1RESET),
   .GTHE3_COMMON_QPLLDMONITOR0(),
   .GTHE3_COMMON_QPLLDMONITOR1(),
   .GTHE3_COMMON_QPLLRSVD1(8'b00000000),
   .GTHE3_COMMON_QPLLRSVD2(5'b00000),
   .GTHE3_COMMON_QPLLRSVD3(5'b00000),
   .GTHE3_COMMON_QPLLRSVD4(8'b00000000),
   .GTHE3_COMMON_RCALENB(1'b1),
   .GTHE3_COMMON_REFCLKOUTMONITOR0(),
   .GTHE3_COMMON_REFCLKOUTMONITOR1(),
   .GTHE3_COMMON_RXRECCLK0_SEL(),
   .GTHE3_COMMON_RXRECCLK1_SEL()
  );


 


endmodule
