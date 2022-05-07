`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/09 15:08:35
// Design Name: 
// Module Name: sync_test_send
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


module sync_test_send(
       input        XGMII_CLK,
       input [7:0]  WORK_MODE,

       input        HMC7044_DP_VALID,
       input [63:0] HMC7044_DP,

       input        DA_DP_VALID,
       input [63:0] DA_DP,

       input [63:0] AWG_DP,
       input        AWG_DP_VALID,  
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
       reg [63:0] awg_dp_pre1,awg_dp_pre2,awg_dp_pre3;
       reg        awg_valid_pre1,awg_valid_pre2,awg_valid_pre3;
       reg [63:0] da_dp_pre1,da_dp_pre2,da_dp_pre3;
       reg        da_valid_pre1,da_valid_pre2,da_valid_pre3;
       reg [63:0] dp_head = 0;

       always @(*)begin
              dp_head[7:0] <= 8'h05;
              dp_head[15:8] <= WORK_MODE;
       end
                                     //////////////分发
       assign AURORA_AWG_VALID = awg_aurora_valid;
       assign AURORA_FPGA1 = awg_aurora_data[0];
       assign AURORA_FPGA2 = awg_aurora_data[1];
       assign AURORA_FPGA3 = awg_aurora_data[2];
       assign AURORA_FPGA4 = awg_aurora_data[3];
       assign AURORA_FPGA5 = awg_aurora_data[4];
       assign AURORA_FPGA6 = awg_aurora_data[5];
       assign AURORA_FPGA7 = awg_aurora_data[6];
       
       assign AURORA_DA_VALID = da_aurora_valid;
       assign AURORA_FPGA8 = da_aurora_data[0];
       assign AURORA_FPGA9 = da_aurora_data[1];
       assign AURORA_FPGA10 = da_aurora_data[2];
       assign AURORA_FPGA11 = da_aurora_data[3];
       assign AURORA_FPGA12 = da_aurora_data[4];
       assign AURORA_FPGA13 = da_aurora_data[5];
       assign AURORA_FPGA14 = da_aurora_data[6];

       assign AURORA_FPGA15 = ad_aurora_data;
       assign AURORA_AD_VALID = ad_aurora_valid;

                                    ///////////延拍
       always @(posedge XGMII_CLK)begin
              awg_dp_pre1 <= AWG_DP;
              awg_dp_pre2 <= awg_dp_pre1;
              awg_dp_pre3 <= awg_dp_pre2;
              awg_valid_pre1 <= AWG_DP_VALID;
              awg_valid_pre2 <= awg_valid_pre1;
              awg_valid_pre3 <= awg_valid_pre2;

              da_dp_pre1 <= DA_DP;
              da_dp_pre2 <= da_dp_pre1;
              da_dp_pre3 <= da_dp_pre2;
              da_valid_pre1 <= DA_DP_VALID;
              da_valid_pre2 <= da_valid_pre1;
              da_valid_pre3 <= da_valid_pre2;
       end

///////////////////////////////////7044参数获取
       reg [127:0] hmc7044_para [0:14];
       reg [4:0]   delay_cnt = 0;

       always @(posedge XGMII_CLK)
        if (HMC7044_DP_VALID) begin
               delay_cnt <= delay_cnt + 1;
        end else begin
               delay_cnt <= 0;
        end

       generate
               genvar i;
               for(i=0;i<15;i=i+1)
               begin : hmc7044_param
                 always @(posedge XGMII_CLK)
                 if(HMC7044_DP_VALID)
                 begin
                       if (delay_cnt == 2*i) begin
                         hmc7044_para[i][63:0] <= HMC7044_DP;     
                       end else if (delay_cnt == 2*i + 1) begin
                         hmc7044_para[i][127:64] <= HMC7044_DP;     
                       end
                 end          
               end
        endgenerate
///////////////////////////////////////////打包
       reg [63:0]  awg_aurora_data [0:6];
       reg         awg_aurora_valid = 0;
       reg [63:0]  da_aurora_data [0:6];
       reg         da_aurora_valid = 0;
       reg [63:0]  ad_aurora_data = 0; 
       reg         ad_aurora_valid = 0;

       reg [2:0] awg_data_cnt = 0;
       reg [2:0] da_data_cnt = 0;
       reg [2:0] ad_data_cnt = 0;

       wire   awg_valid,da_valid;
       assign awg_valid = AWG_DP_VALID | awg_valid_pre3; 
       assign da_valid = DA_DP_VALID | da_valid_pre3;

       always @(posedge XGMII_CLK)begin
              awg_aurora_valid <= awg_valid;
              da_aurora_valid <=  da_valid;
       end

       always @(posedge XGMII_CLK)
          if (awg_valid) begin
              if (&awg_data_cnt) begin
                    awg_data_cnt <= awg_data_cnt;    
                 end else begin
                    awg_data_cnt <= awg_data_cnt + 1;    
                 end   
          end else begin
              awg_data_cnt <= 0;   
          end
       
       always @(posedge XGMII_CLK)
          if (da_valid) begin
              if (&da_data_cnt) begin
                    da_data_cnt <= da_data_cnt;       
                 end else begin
                    da_data_cnt <= da_data_cnt + 1;    
                 end
          end  else begin
               da_data_cnt <= 0;  
          end

       always @(posedge XGMII_CLK)
          if (da_valid_pre3) begin
              if (&ad_data_cnt) begin
                    ad_data_cnt <= ad_data_cnt;    
                 end  else begin
                    ad_data_cnt <= ad_data_cnt + 1;    
                 end 
          end else begin
                 ad_data_cnt <= 0;
          end

       generate                       
              genvar j;
              for(j=0;j<7;j =j+1)
              begin : dp_data
              always @(posedge XGMII_CLK)    ////awg
                if (awg_valid)
                   begin 
                     if (awg_data_cnt == 0) begin
                         awg_aurora_data[j] <= dp_head;     
                      end else if (awg_data_cnt == 1) begin
                         awg_aurora_data[j] <= hmc7044_para[j][63:0];    
                      end else if (awg_data_cnt == 2) begin
                         awg_aurora_data[j] <= hmc7044_para[j][127:64];    
                      end else begin
                         awg_aurora_data[j] <= awg_dp_pre3;    
                      end
                    end else begin
                         awg_aurora_data[j] <= 0;  
                    end  
                                       

              always @(posedge XGMII_CLK)    ///da
                 if (da_valid)
                   begin
                    if (da_data_cnt == 0) begin
                         da_aurora_data[j] <= dp_head;     
                      end else if (da_data_cnt == 1) begin
                         da_aurora_data[j] <= hmc7044_para[j+7][63:0];    
                      end else if (da_data_cnt == 2) begin
                         da_aurora_data[j] <= hmc7044_para[j+7][127:64];    
                      end else begin
                         da_aurora_data[j] <= da_dp_pre3;    
                      end
                   end else begin
                         da_aurora_data[j] <= 0; 
                   end   
              end

       endgenerate

     
       always @(posedge XGMII_CLK)       ///ad
          if (da_valid_pre3)
            begin
              if (ad_data_cnt == 0) begin
                   ad_aurora_data <= dp_head;
                   ad_aurora_valid <= 1;    
                end else if (ad_data_cnt == 1) begin
                   ad_aurora_data <= hmc7044_para[14][63:0];    
                end else if (ad_data_cnt == 2) begin
                   ad_aurora_data <= hmc7044_para[14][127:64];    
                end else if (ad_data_cnt == 3) begin
                   ad_aurora_valid <= 0; 
                   ad_aurora_data <= 0;   
                end               
           end else begin
                  ad_aurora_data <= 0;
                  ad_aurora_valid <= 0;
           end
endmodule
