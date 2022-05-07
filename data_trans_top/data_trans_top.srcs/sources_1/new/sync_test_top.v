`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/13 14:40:43
// Design Name: 
// Module Name: sync_test_top
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


module sync_test_top(
       input   XGMII_CLK,
       input   RST_N,
       input [7:0] ORDER_TYPE,
       input [7:0] WORK_MODE,

       input [63:0] SYNC_TEST_DATA,
       input        TEST_DATA_VALID,
       input [14:0] FPGA_READY,
       input        ZKBK_TRIGGER,

       input [14:0] FPGA_PASSBACK,
       input [14:0] PASSBACK_VALID,

       output [14:0] TO_FPGA_TRIGGER,
       output        TO_ZKBK_READY,
       output [63:0] HMC7044_PASSBACK,
       output        HMC7044_PASSBACK_VALID,
                                 ///AWG
       output [63:0] AURORA_FPGA1,
       output [63:0] AURORA_FPGA2,
       output [63:0] AURORA_FPGA3,
       output [63:0] AURORA_FPGA4,
       output [63:0] AURORA_FPGA5,
       output [63:0] AURORA_FPGA6,
       output [63:0] AURORA_FPGA7,
       output        AURORA_AWG_VALID,
                                  ///DA
       output [63:0] AURORA_FPGA8,
       output [63:0] AURORA_FPGA9,
       output [63:0] AURORA_FPGA10,
       output [63:0] AURORA_FPGA11,
       output [63:0] AURORA_FPGA12,
       output [63:0] AURORA_FPGA13,
       output [63:0] AURORA_FPGA14,
       output        AURORA_DA_VALID,
                                 ////AD
       output [63:0] AURORA_FPGA15,
       output        AURORA_AD_VALID
    );

  wire [63:0] hmc7044_dp,da_dp,awg_dp;
  wire        hmc7044_dp_valid,da_dp_valid,awg_dp_valid;

sync_test_unpack sync_test_unpack_inst(
       .RST_N(RST_N),
       .XGMII_CLK(XGMII_CLK),
       .TEST_DATA_VALID(TEST_DATA_VALID),//数据有效位
       .SYNC_TEST_DATA(SYNC_TEST_DATA),//同步测试数据
       .ORDER_TYPE(ORDER_TYPE),//指令类型

       .HMC7044_DP_VALID(hmc7044_dp_valid),
       .HMC7044_DP(hmc7044_dp),

       .DA_DP_VALID(da_dp_valid),
       .DA_DP(da_dp),

       .AWG_DP(awg_dp),
       .AWG_DP_VALID(awg_dp_valid)       
          
    );

sync_test_send sync_test_send_inst(
          .XGMII_CLK(XGMII_CLK),
          .WORK_MODE(WORK_MODE),

          .HMC7044_DP_VALID(hmc7044_dp_valid),
          .HMC7044_DP(hmc7044_dp),

          .DA_DP_VALID(da_dp_valid),
          .DA_DP(da_dp),

          .AWG_DP(awg_dp),
          .AWG_DP_VALID(awg_dp_valid),  
                            ///AWG
          .AURORA_FPGA1(AURORA_FPGA1),
          .AURORA_FPGA2(AURORA_FPGA2),
          .AURORA_FPGA3(AURORA_FPGA3),
          .AURORA_FPGA4(AURORA_FPGA4),
          .AURORA_FPGA5(AURORA_FPGA5),
          .AURORA_FPGA6(AURORA_FPGA6),
          .AURORA_FPGA7(AURORA_FPGA7),
          .AURORA_AWG_VALID(AURORA_AWG_VALID),
                            ///DA
          .AURORA_FPGA8(AURORA_FPGA8),
          .AURORA_FPGA9(AURORA_FPGA9),
          .AURORA_FPGA10(AURORA_FPGA10),
          .AURORA_FPGA11(AURORA_FPGA11),
          .AURORA_FPGA12(AURORA_FPGA12),
          .AURORA_FPGA13(AURORA_FPGA13),
          .AURORA_FPGA14(AURORA_FPGA14),
          .AURORA_DA_VALID(AURORA_DA_VALID),
                           ///AD
          .AURORA_FPGA15(AURORA_FPGA15),
          .AURORA_AD_VALID(AURORA_AD_VALID)       

    );

sync_test_trigready_control trigready_control_inst(
       .XGMII_CLK(XGMII_CLK),
       .ORDER_TYPE(ORDER_TYPE),
       .FPGA_READY(FPGA_READY),
       .ZKBK_TRIGGER(ZKBK_TRIGGER),
      
       .TO_FPGA_TRIGGER(TO_FPGA_TRIGGER),
       .TO_ZKBK_READY(TO_ZKBK_READY)        
    );

sync_test_passback sync_test_passback_inst(
       .ORDER_TYPE(ORDER_TYPE),
       .XGMII_CLK(XGMII_CLK),
       .RST_N(RST_N),
      
       .FPGA_PASSBACK(FPGA_PASSBACK),
       .PASSBACK_VALID(PASSBACK_VALID),

       .HMC7044_PASSBACK(HMC7044_PASSBACK),
       .HMC7044_PASSBACK_VALID(HMC7044_PASSBACK_VALID)
    );

endmodule
