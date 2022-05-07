`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/06 15:54:08
// Design Name: 
// Module Name: tb_lybk_ddr_top
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


module tb_lybk_ddr_top();

reg              sys_rst;//异步复位
reg              sys_clk;
reg              xgmii_clk;
wire             ddr_user_clk;
reg     [63:0]   aurora_data;
reg              aurora_data_valid;
reg              ddr2xgmii_en;
wire    [63:0]   xgmii_data;
wire             xgmii_data_valid;

wire    [511:0]  u_wdf_data;//从fifo读出的数据
wire    [511:0]  u_rd_data;//从ddr的读出数据
wire             c0_ddr4_act_n;//控制A[14:16]的复用 全
wire    [16:0]   c0_ddr4_adr;//17位地址
wire    [1:0]    c0_ddr4_ba;//DDR 的Bank寻址
wire             c0_ddr4_bg;
wire             c0_ddr4_cke;//DDR的时钟使能
wire             c0_ddr4_odt;//控制片上终端电阻
wire             c0_ddr4_cs_n;//FPGA输出的DDR片选使能
wire             c0_ddr4_ck_t;
wire             c0_ddr4_ck_c;     
wire             c0_ddr4_reset_n; 

wire   [7:0]     c0_ddr4_dm_dbi_n;
wire   [63:0]    c0_ddr4_dq;      
wire   [7:0]     c0_ddr4_dqs_t;   
wire   [7:0]     c0_ddr4_dqs_c;

wire   ddr_reset_finish;
wire   u_rst;
reg    aurora_valid_r;
reg    ddr2xgmii_en_r;
initial begin
	sys_rst <= 0;
	sys_clk <= 0;
	xgmii_clk <= 0;
	aurora_data_valid <= 0;
    #200;
    sys_rst <= 1;
    #100;
    sys_rst <= 0;
    #8000;
    aurora_data_valid <= 1;
    #10000;
    aurora_data_valid <= 0;
end

initial begin
  ddr2xgmii_en <= 0; 
  #11000;
	ddr2xgmii_en <= 0;
	#1000;
	ddr2xgmii_en <= 1;
	#1000;
	ddr2xgmii_en <= 0;
	#200;
	ddr2xgmii_en <= 1;
	#2000;
	ddr2xgmii_en <= 0;
    #100;
    ddr2xgmii_en <= 1;
end

always #1.659 sys_clk = ~sys_clk;
always #5     xgmii_clk = ~xgmii_clk;

always @(posedge ddr_user_clk)
    if (ddr_reset_finish) begin
        aurora_valid_r <= aurora_data_valid; 	
    end else begin
    	aurora_valid_r <= 0;
    end
   
always @(posedge xgmii_clk)
    if (ddr_reset_finish) begin
        ddr2xgmii_en_r <= ddr2xgmii_en;
    end else begin
    	ddr2xgmii_en_r <= 0;
    end

always @(posedge ddr_user_clk)
    if (aurora_valid_r) begin
       aurora_data <= aurora_data + 1;
    end else begin
       aurora_data <= 0;	
    end

lybk_ddr_top lybk_ddr_top_inst(
      .sys_rst(sys_rst),//异步复位ddr
      .c0_sys_clk_p(sys_clk),//系统的300MHz差分时钟，来自zcu 102 SI570
      .c0_sys_clk_n(~sys_clk),
      .xgmii_clk(xgmii_clk), //万兆网端口时钟 100M
      .ddr_user_clk(ddr_user_clk),
      .u_rst(u_rst),
      .ddr_reset_finish(ddr_reset_finish),
//---------//
      .aurora_data(aurora_data),
      .aurora_data_valid(aurora_valid_r),
      .ddr2xgmii_en(ddr2xgmii_en_r),
      .xgmii_data(xgmii_data),
      .xgmii_data_valid(xgmii_data_valid),
//-------//

      .c0_ddr4_act_n(c0_ddr4_act_n),//控制A[14:16]的复用 全为高时作为地址，全为0时复用为WE、CAS、RAS；
      .c0_ddr4_adr(c0_ddr4_adr),//17位地址
      .c0_ddr4_ba(c0_ddr4_ba),//DDR 的Bank寻址
      .c0_ddr4_bg(c0_ddr4_bg),
      .c0_ddr4_cke(c0_ddr4_cke),//DDR的时钟使能
      .c0_ddr4_odt(c0_ddr4_odt),//控制片上终端电阻
      .c0_ddr4_cs_n(c0_ddr4_cs_n),//FPGA输出的DDR片选使能
      .c0_ddr4_ck_t(c0_ddr4_ck_t),
      .c0_ddr4_ck_c(c0_ddr4_ck_c),     
      .c0_ddr4_reset_n(c0_ddr4_reset_n), 
       
      .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n),   
      .c0_ddr4_dq(c0_ddr4_dq),        
      .c0_ddr4_dqs_t(c0_ddr4_dqs_t),     
      .c0_ddr4_dqs_c(c0_ddr4_dqs_c) 
    );
endmodule
