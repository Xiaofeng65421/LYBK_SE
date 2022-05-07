`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/12 13:35:42
// Design Name: 
// Module Name: sync_test_passback
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


module sync_test_passback(
       input  [7:0]  ORDER_TYPE,
       input         XGMII_CLK,
       input         RST_N,
      
       input [64*15 -1 :0] FPGA_PASSBACK,
       input [14:0]        PASSBACK_VALID,

       output [63:0] HMC7044_PASSBACK,
       output        HMC7044_PASSBACK_VALID
    );
      reg [14:0]  passback_valid;
      reg [64*15 -1 :0] fpga_passback = 0;
      reg [127:0]  hmc7044_para [0:14];
      reg          passback_start = 0;
      reg          passback_en =0;
      reg [14:0]  passback_success = 0;
      reg [7:0]    dp_cnt = 0;

      reg [63:0]  hmc7044_passback = 0;
      reg         hmc7044_passback_valid = 0;

      assign HMC7044_PASSBACK = (hmc7044_passback_valid) ? hmc7044_passback : 0;
      assign HMC7044_PASSBACK_VALID = hmc7044_passback_valid;

      always @(posedge XGMII_CLK)
         hmc7044_passback_valid <= passback_en;

      always @(posedge XGMII_CLK)
         if (!RST_N) begin
         	passback_valid <= 0;
         	fpga_passback <= 0;
         end else begin
         if (ORDER_TYPE == 8'h05) begin
            passback_valid <= PASSBACK_VALID;
      	    fpga_passback <= FPGA_PASSBACK;
         end else begin
         	passback_valid <= 0;
         	fpga_passback <= 0;
         end
      	end

      always @(posedge XGMII_CLK)
       if (&passback_success) begin
       	    passback_start <= 1;
       end else begin
       	    passback_start <= 0;
       end

       always @(posedge XGMII_CLK)
        if (passback_start) begin
        	passback_success <= 0;
        end

      generate
      	genvar i;
      	for(i=0;i<15;i=i+1)
      	begin : passback
      		always @(posedge XGMII_CLK)
      		 if (passback_valid[i]) begin
      		 	hmc7044_para[i] <= {fpga_passback[64*(i+1)-1 : 64*i],hmc7044_para[i][127:64]};
      		 	passback_success[i] <= 1;
      		 end
            
            always @(posedge XGMII_CLK)
             if (dp_cnt == 2*i + 1) begin
             	hmc7044_passback <= hmc7044_para[i][63:0];
             end else if (dp_cnt == 2*i + 2) begin
             	hmc7044_passback <= hmc7044_para[i][127:64];
             end
      	end
      endgenerate


      always @(posedge XGMII_CLK)
          if (passback_start) begin
            	passback_en <= 1;
            end else if (dp_cnt == 30) begin
            	passback_en <= 0;
            end 

      always @(posedge XGMII_CLK)
        if (passback_en) begin
              	dp_cnt <= dp_cnt + 1;
              	if (dp_cnt == 0) begin
              		hmc7044_passback <= 64'd5;
              	end
        end else begin
        	dp_cnt <= 0;
        end      

       
endmodule
