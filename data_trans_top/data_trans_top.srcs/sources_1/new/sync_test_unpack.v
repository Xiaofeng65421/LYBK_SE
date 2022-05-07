`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/09 14:53:47
// Design Name: 
// Module Name: sync_test_unpack
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


module sync_test_unpack(
       input        RST_N,
       input        XGMII_CLK,
       input        TEST_DATA_VALID,//数据有效位
       input [63:0] SYNC_TEST_DATA,//同步测试数据
       input [7:0]  ORDER_TYPE,//指令类型

       output        HMC7044_DP_VALID,
       output [63:0] HMC7044_DP,

       output        DA_DP_VALID,
       output [63:0] DA_DP,

       output [63:0]  AWG_DP,
       output         AWG_DP_VALID       
          
    );

       reg [4:0] cur_state;
       reg [4:0] next_state;
       reg       skip_en = 0;
       reg       rx_done_t = 0;
       reg [7:0] cnt = 0;
                                ///7044
       reg [63:0] hmc7044_dp;       
       reg        hmc7044_dp_valid = 0;
                                ////DA
       reg [63:0] da_dp;
       reg        da_dp_valid = 0;
                               ///AWG
       reg [63:0] awg_dp;
       reg        awg_dp_valid = 0;

       assign HMC7044_DP_VALID = hmc7044_dp_valid;
       assign HMC7044_DP = hmc7044_dp;

       assign DA_DP_VALID = da_dp_valid;
       assign DA_DP = da_dp;

       assign AWG_DP_VALID = awg_dp_valid;
       assign AWG_DP = awg_dp;

       localparam   st_idle   = 5'b00001;
       localparam   hmc7044   = 5'b00010;
       localparam   da_data   = 5'b00100;
       localparam   awg_data  = 5'b01000;
       localparam   st_rx_end = 5'b10000;

       always @(posedge XGMII_CLK or negedge RST_N)
          if (!RST_N) begin
          	  cur_state <= st_idle;
          end else begin
          	  cur_state <= next_state;
          end

        always @(*)begin
          next_state = st_idle;
          case(cur_state)
                st_idle : begin
                  if (skip_en) begin
                    next_state = hmc7044;
                  end else begin
                    next_state = st_idle;
                  end
                end
                hmc7044 : begin
                  if (skip_en) begin
                    next_state = da_data;
                  end else begin
                    next_state = hmc7044;
                  end
                end
                da_data : begin
                  if (skip_en) begin
                    next_state = awg_data;
                  end else begin
                    next_state = da_data;
                  end
                end
                awg_data : begin
                	if (skip_en) begin
                		next_state = st_rx_end;
                	end else begin
                		next_state = awg_data;
                	end
                end
                st_rx_end : begin
                	if (skip_en) begin
                		next_state = st_idle;
                	end else begin
                		next_state = st_rx_end;
                	end
                end
            endcase
          end 

          always @(posedge XGMII_CLK or negedge RST_N )
          	if (!RST_N) begin
          		skip_en <= 0;
          		rx_done_t <= 0;
          		cnt <= 0;
          		hmc7044_dp_valid <= 0;
              da_dp_valid <= 0;
              awg_dp_valid <= 0;
            end else begin
          		  skip_en <= 0;
                rx_done_t <= 0;
                hmc7044_dp_valid <= 0;
                da_dp_valid <= 0;
                awg_dp_valid <= 0;
                case(next_state)
                  st_idle : begin
                  	if (ORDER_TYPE == 8'h05) begin
                  		skip_en <= 1;
                  	end
                  end
                  hmc7044 : begin
                    if (TEST_DATA_VALID) begin
                  		 cnt <= cnt + 1;
                       hmc7044_dp <= SYNC_TEST_DATA;
                       hmc7044_dp_valid <= TEST_DATA_VALID; 
                  		 if (cnt == 29) begin
                  		 	cnt <= 0;
                  		 	skip_en <= 1;
                  		 end
                  	end
                  end	
                  da_data : begin
                  	if (TEST_DATA_VALID) begin
                  		cnt <= cnt + 1;
                      da_dp <= SYNC_TEST_DATA;
                      da_dp_valid <= TEST_DATA_VALID;
                  		if (cnt == 79) begin
                  			cnt <= 0;
                  			skip_en <= 1;
                  		end 
                  	end
                  end
                  awg_data : begin
                  	if (TEST_DATA_VALID) begin
                  		cnt <= cnt + 1;
                      awg_dp <= SYNC_TEST_DATA;
                      awg_dp_valid <= TEST_DATA_VALID;
                  		if (cnt == 29) begin
                  			cnt <= 0;
                  			skip_en <= 1;
                  		end 
                  	end
                  end
                  st_rx_end : begin
                  	if (!TEST_DATA_VALID) begin
                  		skip_en <= 1;
                  	end
                  end
                  default : next_state <= st_idle;
                endcase
             end
 

endmodule

