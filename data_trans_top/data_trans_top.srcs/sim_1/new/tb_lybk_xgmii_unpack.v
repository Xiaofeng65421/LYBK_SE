`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/31 17:30:36
// Design Name: 
// Module Name: tb_lybk_xgmii_unpack
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


module tb_lybk_xgmii_unpack();

  reg   XGMII_CLK;
  wire [63:0]  XGMII_RXD;
  wire   XGMII_RXDV;
  reg   RST_N;

  wire ERROR;
  wire RX_DONE;
  wire [7:0] FPGA_ID;
  wire [63:0] LYBK_DATAPKG;
  wire [63:0] FPGA_DATAPKG;
  wire        LYBK_DATAPKG_VALID;
  wire        FPGA_DATAPKG_VALID;

  reg [10:0] cnt;
  reg [2:0] add;
  reg       add1;
  reg       data_flag;

/*  initial begin
  	XGMII_CLK  <= 0;
  	XGMII_RXD <= 0;
  	XGMII_RXDV <= 0;
  	RST_N <= 1;

    cnt <= 0;
    add <= 0;
    add1 <= 0;
  end*/

  initial begin
  XGMII_CLK = 0;
  data_flag = 0;
  #1500000;
  data_flag = 1;
  #50;
  data_flag = 0;
  #1500000;
  data_flag = 1;
  #50;
  data_flag = 0;
  #1500000;
  data_flag = 1;
  #50;
  data_flag = 0;
  #1500000;
  data_flag = 1;
  #50;
  data_flag = 0;
  #1500000;
    data_flag <=1;
    #50;
    data_flag <= 0;
    #1500000;
    data_flag <=1;
    #50;
    data_flag <= 0;
    #1500000;
    data_flag <= 1;
    #50;
    data_flag <= 0;
end
  
  always #5 XGMII_CLK = ~ XGMII_CLK;

/*  always @(posedge XGMII_CLK)
    cnt <= cnt + 1;

   always @(posedge XGMII_CLK)  
     if (cnt == 5) begin
         RST_N <= 0;
     end else if (cnt == 15) begin
         RST_N <= 1;
     end else if (cnt == 25) begin
         XGMII_RXDV <= 1;
         XGMII_RXD <= 64'h18ef_dc01_18ef_dc01;
     end else if (cnt == 26) begin
     //    XGMII_RXD <= {8'd0 , 32'd100 - add1 , 8'h0a + add , 8'h00 + add1 ,8'h01 + add};
         XGMII_RXD <= {8'h01 + add,8'h00 + add1,8'h0a + add,32'd100 - add1,8'd0};
     end else if ((cnt >= 27)&&(cnt <= 126) ) begin
         XGMII_RXD <= $random%1000;
     end  else if (cnt == 127) begin
         XGMII_RXD <= 64'h01dc_ef18_01dc_ef18;
     end else if (cnt == 128) begin
         XGMII_RXD <= 64'h18ef_dc01_18ef_dc01;
     end else if (cnt == 129) begin
//         XGMII_RXD <= {8'd0 , 32'd100, 8'h0a + add , 8'h01 - add1 ,8'h02 + add};
         XGMII_RXD <= {8'h02 + add,8'h01 - add1,8'h0a + add,32'd100,8'd0};
     end else if ((cnt >= 130)&&(cnt <= 229)) begin
         XGMII_RXD <= $random%1000;
     end else if (cnt == 230) begin
         XGMII_RXD <= 64'h01dc_ef18_01dc_ef18;
     end else if (cnt == 231) begin
         XGMII_RXDV <= 0;
     end
 
always @(posedge XGMII_CLK)
   if (&cnt) begin
       add <= add + 1;
       add1 <= add1 + 1;
   end*/

data_rom_test data_rom_test(
      .clk_7044_100m(XGMII_CLK),
      .data_flag(data_flag),
      .data_out_valid(XGMII_RXDV),
      .data_out(XGMII_RXD)
  );


 lybk_xgmii_unpack lybk_xgmii_unpack_inst(
    .XGMII_RXD(XGMII_RXD),
    .XGMII_RXDV(XGMII_RXDV),
    .XGMII_CLK(XGMII_CLK),
/*    .RST_N(RST_N),*/

    .ERROR(ERROR),//错误反馈
    .RX_DONE(RX_DONE),

    .FPGA_ID(FPGA_ID),//FPGA编号
    .LYBK_DATAPKG(LYBK_DATAPKG),//路由板卡数据包
    .FPGA_DATAPKG(FPGA_DATAPKG),//FPGA数据包
    .LYBK_DATAPKG_VALID(LYBK_DATAPKG_VALID),//数据包有效
    .FPGA_DATAPKG_VALID(FPGA_DATAPKG_VALID)

    );

    

endmodule
