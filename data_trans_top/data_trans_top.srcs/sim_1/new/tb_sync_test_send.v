`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/09 17:09:33
// Design Name: 
// Module Name: tb_sync_test_send
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


module tb_sync_test_send();

  reg  XGMII_CLK;
  reg [7:0] WORK_MODE;
  reg  HMC7044_DP_VALID,DA_DP_VALID,AWG_DP_VALID;      
  reg  [63:0] HMC7044_DP,DA_DP,AWG_DP;
  wire [63:0] AURORA_FPGA1,AURORA_FPGA2,AURORA_FPGA3,AURORA_FPGA4,
  AURORA_FPGA5,AURORA_FPGA6,AURORA_FPGA7,AURORA_FPGA8,AURORA_FPGA9,
  AURORA_FPGA10,AURORA_FPGA11,AURORA_FPGA12,AURORA_FPGA13,AURORA_FPGA14,
  AURORA_FPGA15;
  wire AURORA_AWG_VALID,AURORA_DA_VALID,AURORA_AD_VALID;

  reg [7:0] cnt;
  initial begin
  	XGMII_CLK <= 0;
  	WORK_MODE <= 8'b0011_1111;
  	HMC7044_DP_VALID <= 0;
  	DA_DP_VALID <= 0;
  	AWG_DP_VALID <= 0;

  	cnt <= 0;
  end

  always #5 XGMII_CLK = ~XGMII_CLK;

  always @(posedge XGMII_CLK)
     if (&cnt) begin
     	cnt <= cnt;
     end else begin
     	cnt <= cnt + 1;
     end

   always @(posedge XGMII_CLK)
    if ((cnt >= 2) && (cnt <= 31)) begin
      	HMC7044_DP_VALID <= 1;
        HMC7044_DP <= $random %5000;
      end else if (cnt == 32) begin
      	HMC7044_DP_VALID <= 0;
      	DA_DP_VALID <= 1;
      	DA_DP <= $random %2000;
      end else if ((cnt >= 33) && (cnt <= 111)) begin
      	DA_DP <= $random %3000;
      end  else if (cnt == 112) begin
      	DA_DP_VALID <= 0;
      	AWG_DP_VALID <= 1;
      	AWG_DP <= $random %4000;
      end else if ((cnt >= 113) && (cnt <= 141)) begin
      	AWG_DP <= $random %4500;
      end else if (cnt == 142) begin
      	AWG_DP_VALID <= 0;
      end



sync_test_send sync_test_send_inst(
        .XGMII_CLK(XGMII_CLK),
        .WORK_MODE(WORK_MODE),

        .HMC7044_DP_VALID(HMC7044_DP_VALID),
        .HMC7044_DP(HMC7044_DP),

        .DA_DP_VALID(DA_DP_VALID),
        .DA_DP(DA_DP),

        .AWG_DP(AWG_DP),
        .AWG_DP_VALID(AWG_DP_VALID),  
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
                    ////AD
        .AURORA_FPGA15(AURORA_FPGA15),
        .AURORA_AD_VALID(AURORA_AD_VALID)       

    );

endmodule
