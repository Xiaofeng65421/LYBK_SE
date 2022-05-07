`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/03 15:26:46
// Design Name: 
// Module Name: lybk_top_SE
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


module lybk_top_SE#(
   parameter FPGA_NUM = 16
	)(
	input           SYS_CLK_P, //7044 100M
	input           SYS_CLK_N,
    input           osc_clk_p, //晶振 200M
    input           osc_clk_n,
    input           reset,
//---------hmc7044--------------//
    inout           SDATA,              
    output          SCLK,             
    output          SLEN,                  
//-----------sync--------------//
	input           SMA_TRIG_IN,
    output          SMA_TrigOK_OUT,//trigok
    input           rxd_p,
    input           rxd_n,
    output          txd_p,
    output          txd_n,
//-------------si5338-------------//
    output          SI5338_OCLK,
    inout           SI5338_SCL, 
    inout           SI5338_SDA, 
//------------SiTCP--------------//
    output          SFP_TX_DISABLE,
    input           SFP_RX_N,
    input           SFP_RX_P,
    output          SFP_TX_N,
    output          SFP_TX_P,
    input           SMA_MGT_REF_CLK_P,
    input           SMA_MGT_REF_CLK_N,

    inout           I2C_SDA,
    output          I2C_SCL,

    input           GPIO_SW_S,   // in   : Push Switch
    input   [3:0]   GPIO_DIP_SW,   // in   : SW[3:0]
//-------------VPX signal------------------// 
/*    input  [FPGA_NUM-1 : 0] FPGA_READY_P,
    input  [FPGA_NUM-1 : 0] FPGA_READY_N,*/
    input  [FPGA_NUM-1 : 0] FPGA_READY,
    input  [FPGA_NUM-1 : 0] FPGA_RESET_FINISH,
    output [FPGA_NUM-1 : 0] FPGA_SYS_RST,
    output [FPGA_NUM-1 : 0] TRIGGER_OUT_P,
    output [FPGA_NUM-1 : 0] TRIGGER_OUT_N,  
//---------------AURORA---------------//
    input           GTH_P_0,
    input           GTH_N_0,
    input   [7:0]   RXP_0,
    input   [7:0]   RXN_0,
    output  [7:0]   TXP_0,
    output  [7:0]   TXN_0,
    input           GTH_P_1,
    input           GTH_N_1,
    input   [7:0]   RXP_1,
    input   [7:0]   RXN_1,
    output  [7:0]   TXP_1,
    output  [7:0]   TXN_1,
//---------------DDR--------------//
    input           c0_sys_clk_p,//系统的300MHz差分时钟
    input           c0_sys_clk_n,
    output          c0_ddr4_act_n,//控制A[14:16]的复用 全为高时作为地址，全为0时复用为WE、CAS、RAS；
    output [16:0]   c0_ddr4_adr,//17位地址
    output  [1:0]   c0_ddr4_ba,//DDR 的Bank寻址
    output          c0_ddr4_bg,
    output          c0_ddr4_cke,//DDR的时钟使能
    output          c0_ddr4_odt,//控制片上终端电阻
    output          c0_ddr4_cs_n,//FPGA输出的DDR片选使能
    output          c0_ddr4_ck_t,
    output          c0_ddr4_ck_c,
    output          c0_ddr4_reset_n,

    inout   [7:0]   c0_ddr4_dm_dbi_n,
    inout  [63:0]   c0_ddr4_dq,
    inout   [7:0]   c0_ddr4_dqs_t,
    inout   [7:0]   c0_ddr4_dqs_c,
//------------LED-------------------//
    output  [7:0]   GPIO_LED

 );

//------------clock------------//
  wire  clk_7044_100m;//7044 100M
  wire  clk_200m;//
  wire  clk_100m;
  wire  CLK_10M;
  wire  locked;
  wire  reset;//硬件复位
  wire  sys_rst;//系统复位
  wire  task_rst;//线程复位

  wire  ddr_clk;//ddr时钟
  wire  xgmii_clk;//万兆网回传时钟 156.25M
  wire  SYS_CLK;//7044 100M

  clk_pll clk_pll_inst(
    // Clock out ports
    .clk_10m(CLK_10M),     // output clk_10m
    .clk_25m(SI5338_OCLK),     // output clk_25m
    .clk_100m(clk_100m),     // output clk_100m
    .clk_200m(clk_200m),     // output clk_200m
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1_p(osc_clk_p),    // input clk_in1_p
    .clk_in1_n(osc_clk_n));    // input clk_in1_n

//-------------RESET------------//
 reg   [7:0]  user_rst_r;
 wire         user_rst;
 wire         rst_vio;
 wire  [31:0] passback_data_length;
 wire         unlocked;

 assign user_rst  = user_rst_r[7];//user_rst_r[7] | rst_vio;
 assign unlocked  = ~locked;

 always @ (posedge CLK_10M or posedge unlocked) begin
     if (unlocked) begin
         user_rst_r <= 8'h0F;
     end else begin
         user_rst_r <= {user_rst_r[6:0], 1'b0};
     end
 end

// vio_reset vio_reset(clk_7044_100m, rst_vio, passback_data_length);

//---------------7044------------------//
IBUFDS IBUFDS_inst (
    .O(SYS_CLK),  // Buffer output
    .I(SYS_CLK_P),  // Diff_p buffer input (connect directly to top-level port)
    .IB(SYS_CLK_N) // Diff_n buffer input (connect directly to top-level port)
 );

BUFG BUFG_inst (
    .O(clk_7044_100m), // 1-bit output: Clock output
    .I(SYS_CLK)  // 1-bit input: Clock input
 );

wire   HMC_Done;

hmc7044_top U00_hmc7044_top(
      .clk_200m(clk_200m),
      .reset(reset),
      .HMC_Done(HMC_Done),
      .SDATA(SDATA), 
      .SCLK(SCLK),  
      .SLEN(SLEN)   
  );
//-------------------------------------//
//--------------5338-------------------//
   wire si5338_busy_out;
   wire si5338_done;
   wire si5338_error;
   wire done;
   wire error;

   assign GPIO_LED[7] = HMC_Done;
/*   assign GPIO_LED[6] = error;
   assign GPIO_LED[5] = done;
*/
si5338 # (
    .input_clk(32'd65_000_000),
    .i2c_address(7'b111_0000),
    .bus_clk(32'd400_000)
)
U00_si5338 (
    .clk        (CLK_10M    ),
    .reset      (reset),
    .busy_out   (busy_out   ),
    .done       (done       ),
    .error      (error      ),
    .SCL        (SI5338_SCL ),
    .SDA        (SI5338_SDA )
);
//-----------------------------------//
//----------S2D---------------//
 wire [FPGA_NUM-1 : 0]  sync_out;
 wire [FPGA_NUM-1 : 0]  trig_out;
/* wire [FPGA_NUM-1 : 0]  fpga_ready;*/
 assign sync_out = {FPGA_NUM{sync}};

ready_trigger_port #(.NUM(FPGA_NUM)) U01_ready_trigger(
/*    .fpga_ready(fpga_ready),*/
    .trig_out(trig_out),
    .sync_out(sync_out),
    .TRIGGER_OUT_P(TRIGGER_OUT_P),
    .TRIGGER_OUT_N(TRIGGER_OUT_N)
/*    .FPGA_READY_P(FPGA_READY_P),
    .FPGA_READY_N(FPGA_READY_N)*/ 
    );

//---------------------------------//
//---------SYNC_CALIB----------------//

wire [7:0] zk_task_id;
wire       trig_flag;
wire       trig_pulse;
wire       sync;
wire           to_zk_ready;
wire  [7:0]    to_zk_task_id;
wire  [3:0]    system_state;

lybk_calib U02_lybk_calib(
   .clk_100m(clk_7044_100m),//7044 100M
   .rst(sys_rst),
   
   .SMA_TRIG_IN(SMA_TRIG_IN),
   .SMA_TrigOK_OUT(SMA_TrigOK_OUT),
   .state(system_state),

   .rxd_p(rxd_p),
   .rxd_n(rxd_n),
   .txd_p(txd_p),
   .txd_n(txd_n),

   .ready_id_valid(to_zk_ready),
   .ready_id(to_zk_task_id),

   .zk_task_id(zk_task_id),
   .trig_flag(trig_flag),
   .trig_pulse(trig_pulse),
   .sync(sync)   

	);
//---------------------------------//
/*//rom
reg          data_en;
reg  [15:0]  data_addr;
wire [63:0]  data_out;
wire [63:0]  douta;
reg          data_out_valid = 0;
wire         data_flag;
reg          data_flag_r1;
reg          data_flag_r2;
wire         skip_en;

assign skip_en = data_flag_r1 & (~data_flag_r2);
assign data_out = (data_out_valid)?douta : 0;

always @(posedge clk_7044_100m)
begin
  data_flag_r1 <= data_flag;
  data_flag_r2 <= data_flag_r1;
  data_out_valid <= data_en;  
end


localparam   idle   = 0;
localparam   data_1 = 1;
localparam   data_2 = 2;
localparam   data_3 = 3;
localparam   data_4 = 4;
localparam   data_5 = 5;
localparam   data_6 = 6;

reg  [3:0]   state = idle;

wire       switch;
rom_data_control rom_data_control (
  .clk(clk_7044_100m),                // input wire clk
  .probe_in0(state),    // input wire [3 : 0] probe_in0
  .probe_out0(data_flag),  // output wire [0 : 0] probe_out0
  .probe_out1(switch)
);

datapackage_test datapackage_test (
  .clka(clk_7044_100m),    // input wire clka
  .ena(data_en),      // input wire ena
  .addra(data_addr),  // input wire [15 : 0] addra
  .douta(douta)  // output wire [63 : 0] douta
);

always @(posedge clk_7044_100m)
  case (state)
      idle : if (skip_en) begin
              state <= data_1;
      end
      data_1 : if (skip_en) begin
              state <= data_2;
      end
      data_2 : if (skip_en) begin
              state <= data_3;
      end
      data_3 : if (skip_en) begin
              state <= data_4;
      end
      data_4 : if (skip_en) begin
              state <= data_5;
      end
      data_5 : if (skip_en) begin
              state <= data_6;
      end
      data_6 : if (skip_en) begin
              state <= idle;
      end
 endcase

always @(posedge clk_7044_100m)
  case(state)
    idle : begin
         data_en <= 0;
    end
    data_1 : begin
         if (data_addr >= 4) begin //LY
            data_en <= 0;
         end else begin
            data_en <= 1;
         end
    end
    data_2 : begin
         if (data_addr >= 942 + 938) begin //DAC(u30/u43)
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_3 : begin
         if (data_addr >= 9881 + 938) begin //AWG
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_4 : begin
         if (data_addr >= 9889 + 938) begin//ADDA AD TASK
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_5 : begin
         if (data_addr >= 9903 + 938) begin //ADDA DA TASK
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_6 : begin
         if (data_addr >= 13145 + 938) begin    //ADDA DA DEFAULT
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end

  endcase


always @(posedge clk_7044_100m)
   if (state == idle) begin
      data_addr <= 0;
   end else begin
     if (data_en) begin
         data_addr <= data_addr + 1;
     end else begin
         data_addr <= data_addr;
     end
   end
   */

//-----------------------------------//

(* MARK_DEBUG="true" *)wire  [63:0]   xgmii_rxd;
(* MARK_DEBUG="true" *)wire           xgmii_rxdv;
                       wire  [63:0]   XGMII_RXD;
                       wire           XGMII_RXDV;

(* MARK_DEBUG="true" *)wire  [63:0]  fpga1_aurora,fpga2_aurora,fpga3_aurora,fpga4_aurora,fpga5_aurora,
              fpga6_aurora,fpga7_aurora,fpga8_aurora,fpga9_aurora,fpga10_aurora,
              fpga11_aurora,fpga12_aurora,fpga13_aurora,fpga14_aurora,fpga15_aurora,fpga16_aurora;

(* MARK_DEBUG="true" *)wire          fpga1_valid,fpga2_valid,fpga3_valid,fpga4_valid,fpga5_valid,fpga6_valid,
              fpga7_valid,fpga8_valid,fpga9_valid,fpga10_valid,fpga11_valid,fpga12_valid,
              fpga13_valid,fpga14_valid,fpga15_valid,fpga16_valid;

(* MARK_DEBUG="true" *)wire  [63:0]  xgmii_passback_data;
(* MARK_DEBUG="true" *)wire          xgmii_passback_data_valid;
(* MARK_DEBUG="true" *)wire          DDR_RD_REQ;
wire  [31:0]  PASSBACK_LENGTH;

assign XGMII_RXD  = xgmii_rxd;//(switch)? data_out : xgmii_rxd;
assign XGMII_RXDV = xgmii_rxdv;//(switch)? data_out_valid : xgmii_rxdv;

lybk_function U03_lybk_function(
      .XGMII_RXD(XGMII_RXD),   //万兆网下发有效位 
      .XGMII_RXDV(XGMII_RXDV), //万兆网下发数据
      .XGMII_RX_CLK(clk_7044_100m),//万兆网下发传输时钟 100M
      .XGMII_TX_CLK(xgmii_clk),//万兆网回传时钟 156.25M
      .TRIGGER_CLK(clk_7044_100m),
      .VIO_RST_N(~user_rst),

      .SYNC_PULSE(trig_pulse),
      .ZKBK_TRIGGER(trig_flag),
      .ZKBK_TASK_ID(zk_task_id),
      .DDR_RD_REQ(DDR_RD_REQ & (~DDR_BUSY)),//状态回传到万兆网模块对接fifo的读控制(数据回传优先)

      .FPGA_READY(FPGA_READY),
      .FPGA_RESET_FINISH(FPGA_RESET_FINISH),
      .SYSTEM_STATE(system_state),

      .TO_ZKBK_READY(to_zk_ready),
      .TO_ZKBK_TASK_ID(to_zk_task_id),
      .PASSBACK_LENGTH(PASSBACK_LENGTH),
      .PASSBACK_LENGTH_VALID(PASSBACK_LENGTH_VALID),

      .TRIGGER_OUT(trig_out),
      .FPGA_SYS_RST(FPGA_SYS_RST),//fpga系统复位
      .SYS_RST(sys_rst),//系统复位 : out
      .TASK_RST(task_rst),//线程复位 : out

      .TO_FPGA1_AURORA_DATAPKG(fpga1_aurora),
      .TO_FPGA1_AURORA_VALID  (fpga1_valid),
      .TO_FPGA2_AURORA_DATAPKG(fpga2_aurora),
      .TO_FPGA2_AURORA_VALID  (fpga2_valid),
      .TO_FPGA3_AURORA_DATAPKG(fpga3_aurora),
      .TO_FPGA3_AURORA_VALID  (fpga3_valid),
      .TO_FPGA4_AURORA_DATAPKG(fpga4_aurora),
      .TO_FPGA4_AURORA_VALID  (fpga4_valid),
      .TO_FPGA5_AURORA_DATAPKG(fpga5_aurora),
      .TO_FPGA5_AURORA_VALID  (fpga5_valid),
      .TO_FPGA6_AURORA_DATAPKG(fpga6_aurora),
      .TO_FPGA6_AURORA_VALID  (fpga6_valid),
      .TO_FPGA7_AURORA_DATAPKG(fpga7_aurora),
      .TO_FPGA7_AURORA_VALID  (fpga7_valid),
      .TO_FPGA8_AURORA_DATAPKG(fpga8_aurora),
      .TO_FPGA8_AURORA_VALID  (fpga8_valid),
      .TO_FPGA9_AURORA_DATAPKG(fpga9_aurora),
      .TO_FPGA9_AURORA_VALID  (fpga9_valid),
      .TO_FPGA10_AURORA_DATAPKG(fpga10_aurora),
      .TO_FPGA10_AURORA_VALID  (fpga10_valid),
      .TO_FPGA11_AURORA_DATAPKG(fpga11_aurora),
      .TO_FPGA11_AURORA_VALID  (fpga11_valid),
      .TO_FPGA12_AURORA_DATAPKG(fpga12_aurora),
      .TO_FPGA12_AURORA_VALID  (fpga12_valid),
      .TO_FPGA13_AURORA_DATAPKG(fpga13_aurora),
      .TO_FPGA13_AURORA_VALID  (fpga13_valid),
      .TO_FPGA14_AURORA_DATAPKG(fpga14_aurora),
      .TO_FPGA14_AURORA_VALID  (fpga14_valid),
      .TO_FPGA15_AURORA_DATAPKG(fpga15_aurora),
      .TO_FPGA15_AURORA_VALID  (fpga15_valid),
      .TO_FPGA16_AURORA_DATAPKG(fpga16_aurora),
      .TO_FPGA16_AURORA_VALID  (fpga16_valid),

      .STATE_PASSBACK_DATA(xgmii_passback_data),
      .STATE_PASSBACK_DV(xgmii_passback_data_valid)

	);
//-------------aurora ---------------------//
wire  [63:0] adda_passback_data;
wire         adda_passback_data_valid;

lybk_aurora_top U04_lybk_aurora(
      .XGMII_CLK(clk_7044_100m),
      .SYS_RST(user_rst),
      .CLK_100M(clk_100m),//init_clk 
      .DDR_CLK(ddr_clk),//ddr_user_clk
      .GTH_P_0(GTH_P_0),
      .GTH_N_0(GTH_N_0),
      .RXP_0(RXP_0),
      .RXN_0(RXN_0),
      .TXP_0(TXP_0),
      .TXN_0(TXN_0),

      .TO_FPGA1_AURORA_DATAPKG(fpga1_aurora),
      .TO_FPGA1_AURORA_VALID  (fpga1_valid),
      .TO_FPGA2_AURORA_DATAPKG(fpga2_aurora),
      .TO_FPGA2_AURORA_VALID  (fpga2_valid),
      .TO_FPGA3_AURORA_DATAPKG(fpga3_aurora),
      .TO_FPGA3_AURORA_VALID  (fpga3_valid),
      .TO_FPGA4_AURORA_DATAPKG(fpga4_aurora),
      .TO_FPGA4_AURORA_VALID  (fpga4_valid),
      .TO_FPGA5_AURORA_DATAPKG(fpga5_aurora),
      .TO_FPGA5_AURORA_VALID  (fpga5_valid),
      .TO_FPGA6_AURORA_DATAPKG(fpga6_aurora),
      .TO_FPGA6_AURORA_VALID  (fpga6_valid),
      .TO_FPGA7_AURORA_DATAPKG(fpga7_aurora),
      .TO_FPGA7_AURORA_VALID  (fpga7_valid),
      .TO_FPGA8_AURORA_DATAPKG(fpga8_aurora),
      .TO_FPGA8_AURORA_VALID  (fpga8_valid),
      .TO_FPGA9_AURORA_DATAPKG(fpga9_aurora),
      .TO_FPGA9_AURORA_VALID  (fpga9_valid),
      .TO_FPGA10_AURORA_DATAPKG(fpga10_aurora),
      .TO_FPGA10_AURORA_VALID  (fpga10_valid),
      .TO_FPGA11_AURORA_DATAPKG(fpga11_aurora),
      .TO_FPGA11_AURORA_VALID  (fpga11_valid),
      .TO_FPGA12_AURORA_DATAPKG(fpga12_aurora),
      .TO_FPGA12_AURORA_VALID  (fpga12_valid),
      .TO_FPGA13_AURORA_DATAPKG(fpga13_aurora),
      .TO_FPGA13_AURORA_VALID  (fpga13_valid),
      .TO_FPGA14_AURORA_DATAPKG(fpga14_aurora),
      .TO_FPGA14_AURORA_VALID  (fpga14_valid),
      .TO_FPGA15_AURORA_DATAPKG(fpga15_aurora),
      .TO_FPGA15_AURORA_VALID  (fpga15_valid),
      .TO_FPGA16_AURORA_DATAPKG(fpga16_aurora),
      .TO_FPGA16_AURORA_VALID  (fpga16_valid),

      .FROM_FPGA16_AURORA_DATAPKG(adda_passback_data),
      .FROM_FPGA16_AURORA_VALID(adda_passback_data_valid),
      
      .GTH_P_1(GTH_P_1),
      .GTH_N_1(GTH_N_1),
      .RXP_1(RXP_1),
      .RXN_1(RXN_1),
      .TXP_1(TXP_1),
      .TXN_1(TXN_1)

	);
//---------------------ETH---------------------//
(* MARK_DEBUG="true" *)    wire [63:0] DDR_RD_DATA;
(* MARK_DEBUG="true" *)    wire        DDR_RD_VALID;
    wire        DDR_BUSY;
    wire [63:0] USER_DOUT;
    wire        USER_DOUT_RD_REQ;
    wire        USER_DOUT_VALID;
    wire [63:0] XIGMII_TX_DATA;
    wire        XIGMII_TX_DV;

    assign XIGMII_TX_DATA = (DDR_BUSY)? DDR_RD_DATA : xgmii_passback_data;
    assign XIGMII_TX_DV   = (DDR_BUSY)? DDR_RD_VALID : xgmii_passback_data_valid;

    SiTCPXG_EEPROM_TOP U05_SiTCPXG_EEPROM (
        .USER_CLOCK         (clk_7044_100m      ),  // in   : 100M(万兆网下发fifo 156.25M -> 100M)
        .CPU_RESET          (user_rst_r[7]      ),  // in   : System reset
        .XGMII_CLOCK        (xgmii_clk          ),  // out  : 156.25M
    // SFP+
        .SFP_TX_DISABLE     (SFP_TX_DISABLE     ),
        .SFP_RX_N           (SFP_RX_N           ),
        .SFP_RX_P           (SFP_RX_P           ),
        .SFP_TX_N           (SFP_TX_N           ),
        .SFP_TX_P           (SFP_TX_P           ),
        .SMA_MGT_REF_CLK_P  (SMA_MGT_REF_CLK_P  ),
        .SMA_MGT_REF_CLK_N  (SMA_MGT_REF_CLK_N  ),
    //connect EEPROM
        .I2C_SDA            (I2C_SDA            ),
        .I2C_SCL            (I2C_SCL            ),
    // DDR I/F

        .DDR_RD_DATA        (XIGMII_TX_DATA[63:0]),
        .DDR_RD_REQ         (DDR_RD_REQ         ),
        .DDR_RD_VALID       (XIGMII_TX_DV       ),
    // USER DATA I/F
        .USER_DOUT          (xgmii_rxd          ),
        .USER_DOUT_RD_REQ   (1'b1               ),//一直接收
        .USER_DOUT_VALID    (xgmii_rxdv         ),
    // FIFO_LOOPBACK
        .FIFO_LOOPBACK      (1'b0               ),//默认0   
    // SW, LED
        .GPIO_SW_S          (GPIO_SW_S          ),  // in   : Push Switch
        .GPIO_DIP_SW        (GPIO_DIP_SW[3:0]   )  // in   : SW[3:0]
/*        .GPIO_LED           (GPIO_LED[4:0]      )   // out  : LED[4:0]*/
    );

//-------------------DDR-----------------//

lybk_ddr_top U06_lybk_ddr(
     .ddr_rst(user_rst_r[7]),//异步上电复位ddr
     .sys_rst(sys_rst), //系统复位
     .task_rst(task_rst),//线程复位
     .xgmii_clk(xgmii_clk), //万兆网回传时钟时钟 156.25M
     .ddr_user_clk(ddr_clk),//ddr用户时钟 156.25M
     .trigger_clk(clk_7044_100m),
     .passback_data_length(PASSBACK_LENGTH),//数据回传量(vio可控)
     .passback_data_length_valid(PASSBACK_LENGTH_VALID),

     .aurora_data(adda_passback_data),//aurora回传数据（时钟域为ddr_user_clk,跨时钟处理后的数据）
     .aurora_data_valid(adda_passback_data_valid),
     .DDR_RD_REQ(DDR_RD_REQ), //ddr到万兆网模块对接fifo的读控制
     .DDR_RD_DATA(DDR_RD_DATA),//发送给万兆网模块数据
     .DDR_RD_VALID(DDR_RD_VALID),
     .DDR_BUSY(DDR_BUSY),
     // DDR4 Physical I/F
     .c0_sys_clk_p       (c0_sys_clk_p    ),
     .c0_sys_clk_n       (c0_sys_clk_n    ),
     .c0_ddr4_act_n      (c0_ddr4_act_n   ),
     .c0_ddr4_adr        (c0_ddr4_adr     ),
     .c0_ddr4_ba         (c0_ddr4_ba      ),
     .c0_ddr4_bg         (c0_ddr4_bg      ),
     .c0_ddr4_cke        (c0_ddr4_cke     ),
     .c0_ddr4_odt        (c0_ddr4_odt     ),
     .c0_ddr4_cs_n       (c0_ddr4_cs_n    ),
     .c0_ddr4_ck_t       (c0_ddr4_ck_t    ),
     .c0_ddr4_ck_c       (c0_ddr4_ck_c    ),
     .c0_ddr4_reset_n    (c0_ddr4_reset_n ),
     .c0_ddr4_dm_dbi_n   (c0_ddr4_dm_dbi_n),
     .c0_ddr4_dq         (c0_ddr4_dq      ),
     .c0_ddr4_dqs_t      (c0_ddr4_dqs_t   ),
     .c0_ddr4_dqs_c      (c0_ddr4_dqs_c   )
);
//----------------------------------------------//

endmodule
