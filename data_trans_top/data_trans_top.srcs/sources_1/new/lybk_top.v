`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 15:21:16
// Design Name: 
// Module Name: lybk_top
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


module lybk_top#(
    parameter FPGA_AMOUNT = 15//FPGA数量
	)(
       input  [63:0]   XGMII_RXD, //万兆网下发数据    
       input           XGMII_RXDV, 
       input           XGMII_CLK,
       input           TRIGGER_CLK,

       input           ZKBK_TRIGGER,
       input  [7:0]    ZKBK_TASK_ID,

       output          TO_ZKBK_READY,
       output          TO_ZKBK_VALID,
       output [4:0]    TO_ZKBK_TASK_ID,

       input  [FPGA_AMOUNT-1:0]   FPGA_READY,//FPGA回传的就绪信号
       input  [5*FPGA_AMOUNT-1:0] FPGA_READY_VALID,//FPGA回传的就绪掩码(5个一组对应触发模块)
       output [FPGA_AMOUNT-1:0]   TRIGGER_OUT,//触发信号
       output [5*FPGA_AMOUNT-1:0] FPGA_TRIGGER_VALID,//触发信号的有效掩码(5个一组对应触发模块)
       output [4*FPGA_AMOUNT-1:0] FPGA_RESET,//FPGA的复位信号
       output [FPGA_AMOUNT-1:0]   FPGA_RESET_VALID,//FPGA复位有效   

       input  [63:0]  FROM_FPGA1_AURORA_DATAPKG,
       input          FROM_FPGA1_AURORA_VALID,
       input  [63:0]  FROM_FPGA2_AURORA_DATAPKG,
       input          FROM_FPGA2_AURORA_VALID,
       input  [63:0]  FROM_FPGA3_AURORA_DATAPKG,
       input          FROM_FPGA3_AURORA_VALID,
       input  [63:0]  FROM_FPGA4_AURORA_DATAPKG,
       input          FROM_FPGA4_AURORA_VALID,
       input  [63:0]  FROM_FPGA5_AURORA_DATAPKG,
       input          FROM_FPGA5_AURORA_VALID,
       input  [63:0]  FROM_FPGA6_AURORA_DATAPKG,
       input          FROM_FPGA6_AURORA_VALID,
       input  [63:0]  FROM_FPGA7_AURORA_DATAPKG,
       input          FROM_FPGA7_AURORA_VALID,
       input  [63:0]  FROM_FPGA8_AURORA_DATAPKG,
       input          FROM_FPGA8_AURORA_VALID,
       input  [63:0]  FROM_FPGA9_AURORA_DATAPKG,
       input          FROM_FPGA9_AURORA_VALID,
       input  [63:0]  FROM_FPGA10_AURORA_DATAPKG,
       input          FROM_FPGA10_AURORA_VALID,
       input  [63:0]  FROM_FPGA11_AURORA_DATAPKG,
       input          FROM_FPGA11_AURORA_VALID,
       input  [63:0]  FROM_FPGA12_AURORA_DATAPKG,
       input          FROM_FPGA12_AURORA_VALID,
       input  [63:0]  FROM_FPGA13_AURORA_DATAPKG,
       input          FROM_FPGA13_AURORA_VALID,
       input  [63:0]  FROM_FPGA14_AURORA_DATAPKG,
       input          FROM_FPGA14_AURORA_VALID,
       input  [63:0]  FROM_FPGA15_AURORA_DATAPKG,
       input          FROM_FPGA15_AURORA_VALID,

       output [63:0]  TO_FPGA1_AURORA_DATAPKG,
       output         TO_FPGA1_AURORA_VALID,
       output [63:0]  TO_FPGA2_AURORA_DATAPKG,
       output         TO_FPGA2_AURORA_VALID,
       output [63:0]  TO_FPGA3_AURORA_DATAPKG,
       output         TO_FPGA3_AURORA_VALID,
       output [63:0]  TO_FPGA4_AURORA_DATAPKG,
       output         TO_FPGA4_AURORA_VALID,
       output [63:0]  TO_FPGA5_AURORA_DATAPKG,
       output         TO_FPGA5_AURORA_VALID,
       output [63:0]  TO_FPGA6_AURORA_DATAPKG,
       output         TO_FPGA6_AURORA_VALID,
       output [63:0]  TO_FPGA7_AURORA_DATAPKG,
       output         TO_FPGA7_AURORA_VALID,
       output [63:0]  TO_FPGA8_AURORA_DATAPKG,
       output         TO_FPGA8_AURORA_VALID,
       output [63:0]  TO_FPGA9_AURORA_DATAPKG,
       output         TO_FPGA9_AURORA_VALID,
       output [63:0]  TO_FPGA10_AURORA_DATAPKG,
       output         TO_FPGA10_AURORA_VALID,
       output [63:0]  TO_FPGA11_AURORA_DATAPKG,
       output         TO_FPGA11_AURORA_VALID,
       output [63:0]  TO_FPGA12_AURORA_DATAPKG,
       output         TO_FPGA12_AURORA_VALID,
       output [63:0]  TO_FPGA13_AURORA_DATAPKG,
       output         TO_FPGA13_AURORA_VALID,
       output [63:0]  TO_FPGA14_AURORA_DATAPKG,
       output         TO_FPGA14_AURORA_VALID,
       output [63:0]  TO_FPGA15_AURORA_DATAPKG,
       output         TO_FPGA15_AURORA_VALID,

       output [63:0]  XGMII_TXD,//万兆网回传数据
       output         XGMII_TXDV,
       output         TX_DONE             
    );
    wire        sys_rst_n;//系统低电平复位
    wire  [4:0] trigger_rst_n;//触发模块低电平复位


    wire  [7:0] zkbk_task_id;
    wire        zkbk_trigger;
    wire  [4:0] to_zkbk_task_id;
    wire        to_zkbk_ready;
    wire        to_zkbk_valid; 
////////////////////////////////////////////传输分发
    assign TRIGGER_OUT = (order_type == 8'h05)? to_fpga_trgger : trigger_out;
    
    assign TO_FPGA1_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga1 : fpga1_aurora;
    assign TO_FPGA2_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga2 : fpga2_aurora;
    assign TO_FPGA3_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga3 : fpga3_aurora;
    assign TO_FPGA4_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga4 : fpga4_aurora;
    assign TO_FPGA5_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga5 : fpga5_aurora;
    assign TO_FPGA6_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga6 : fpga6_aurora;
    assign TO_FPGA7_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga7 : fpga7_aurora;
    assign TO_FPGA8_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga8 : fpga8_aurora;
    assign TO_FPGA9_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga9 : fpga9_aurora;
    assign TO_FPGA10_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga10 : fpga10_aurora;
    assign TO_FPGA11_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga11 : fpga11_aurora;
    assign TO_FPGA12_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga12 : fpga12_aurora;
    assign TO_FPGA13_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga13 : fpga13_aurora;
    assign TO_FPGA14_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga14 : fpga14_aurora;
    assign TO_FPGA15_AURORA_DATAPKG = (order_type == 8'h05)? aurora_fpga15 : fpga15_aurora;

    assign TO_FPGA1_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga1_valid;
    assign TO_FPGA2_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga2_valid;
    assign TO_FPGA3_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga3_valid;
    assign TO_FPGA4_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga4_valid;
    assign TO_FPGA5_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga5_valid;
    assign TO_FPGA6_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga6_valid;
    assign TO_FPGA7_AURORA_VALID = (order_type == 8'h05)? aurora_awg_valid : fpga7_valid;
   
    assign TO_FPGA8_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga8_valid;
    assign TO_FPGA9_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga9_valid;
    assign TO_FPGA10_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga10_valid;
    assign TO_FPGA11_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga11_valid;
    assign TO_FPGA12_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga12_valid;
    assign TO_FPGA13_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga13_valid;
    assign TO_FPGA14_AURORA_VALID = (order_type == 8'h05)? aurora_da_valid : fpga14_valid;
    
    assign TO_FPGA15_AURORA_VALID = (order_type == 8'h05)? aurora_ad_valid : fpga15_valid;

///////////////万兆网下发//////////////////////
    wire [7:0]  send_fpga_id;
    wire [63:0] fpga_datapkg;
    wire [63:0] lybk_datapkg;
    wire        fpga_datapkg_valid;
    wire        lybk_datapkg_valid;
    wire        xgmii_send_error;

    wire [64:0] fpga1_aurora,fpga2_aurora,
    fpga3_aurora,fpga4_aurora,fpga5_aurora,
    fpga6_aurora,fpga7_aurora,fpga8_aurora,
    fpga9_aurora,fpga10_aurora,fpga11_aurora,
    fpga12_aurora,fpga13_aurora,fpga14_aurora,fpga15_aurora;
    
    wire   fpga1_valid,fpga2_valid,fpga3_valid,fpga4_valid,
    fpga5_valid,fpga6_valid,fpga7_valid,fpga8_valid,fpga9_valid,
    fpga10_valid,fpga11_valid,fpga12_valid,fpga13_valid,fpga14_valid,fpga15_valid;

    assign zkbk_trigger  =  ZKBK_TRIGGER; 
    assign zkbk_task_id  =  ZKBK_TASK_ID; 
    assign TO_ZKBK_TASK_ID = to_zkbk_task_id;
    assign TO_ZKBK_VALID = to_zkbk_valid ;
    assign TO_ZKBK_READY = to_zkbk_ready | to_zkbk_ready_test;

lybk_xgmii_unpack lybk_xgmii_unpack_inst(
    .XGMII_RXD(XGMII_RXD),
    .XGMII_RXDV(XGMII_RXDV),
    .XGMII_CLK(XGMII_CLK),
    .RST_N(sys_rst_n),

    .ERROR(xgmii_send_error),//错误反馈

    .FPGA_ID(send_fpga_id),//FPGA编号
    .LYBK_DATAPKG(lybk_datapkg),//路由板卡数据包
    .FPGA_DATAPKG(fpga_datapkg),//FPGA数据包 
    .LYBK_DATAPKG_VALID(lybk_datapkg_valid),//路由数据包有效
    .FPGA_DATAPKG_VALID(fpga_datapkg_valid)//FPGA数据包有效

    );

lybk_xgmii_send lybk_xgmii_send_inst(
     .FPGA_DATAPKG(fpga_datapkg),
     .DATAPKG_VALID(fpga_datapkg_valid),
     .FPGA_ID(send_fpga_id),

     .FPGA1_AURORA_DATAPKG(fpga1_aurora),
     .FPGA1_AURORA_VALID(fpga1_valid),
     .FPGA2_AURORA_DATAPKG(fpga2_aurora),
     .FPGA2_AURORA_VALID(fpga2_valid),
     .FPGA3_AURORA_DATAPKG(fpga3_aurora),
     .FPGA3_AURORA_VALID(fpga3_valid),
     .FPGA4_AURORA_DATAPKG(fpga4_aurora),
     .FPGA4_AURORA_VALID(fpga4_valid),
     .FPGA5_AURORA_DATAPKG(fpga5_aurora),
     .FPGA5_AURORA_VALID(fpga5_valid),
     .FPGA6_AURORA_DATAPKG(fpga6_aurora),
     .FPGA6_AURORA_VALID(fpga6_valid),
     .FPGA7_AURORA_DATAPKG(fpga7_aurora),
     .FPGA7_AURORA_VALID(fpga7_valid),
     .FPGA8_AURORA_DATAPKG(fpga8_aurora),
     .FPGA8_AURORA_VALID(fpga8_valid),
     .FPGA9_AURORA_DATAPKG(fpga9_aurora),
     .FPGA9_AURORA_VALID(fpga9_valid),
     .FPGA10_AURORA_DATAPKG(fpga10_aurora),
     .FPGA10_AURORA_VALID(fpga10_valid),
     .FPGA11_AURORA_DATAPKG(fpga11_aurora),
     .FPGA11_AURORA_VALID(fpga11_valid),
     .FPGA12_AURORA_DATAPKG(fpga12_aurora),
     .FPGA12_AURORA_VALID(fpga12_valid),
     .FPGA13_AURORA_DATAPKG(fpga13_aurora),
     .FPGA13_AURORA_VALID(fpga13_valid),
     .FPGA14_AURORA_DATAPKG(fpga14_aurora),
     .FPGA14_AURORA_VALID(fpga14_valid),
     .FPGA15_AURORA_DATAPKG(fpga15_aurora),
     .FPGA15_AURORA_VALID(fpga15_valid)

    );

////////////////////////////////////////////////////////
//////////////////路由解析配置模块////////////////////////////
      wire        send_lybk_error;//下发路由板卡解析错误
      wire        lybk_rx_done;
      
      wire [7:0]  b_circle_amount;
      wire [7:0]  order_type;//指令类型(下发)
      wire        order_valid;//指令有效
      wire [7:0]  task_id;
      wire [15:0] fpga_id;

      wire        s_circle_dv;//小循环数据有效
      wire [63:0] s_circle_data;//小循环数据

      wire [63:0] sync_test_data;
      wire        test_data_valid;
      wire [7:0]  work_mode; 

lybk_config_trans lybk_config_trans_inst(
	  .RST_N(sys_rst_n),
      .XGMII_CLK(XGMII_CLK),
      .XGMII_RXDV(lybk_datapkg_valid),
      .LYBK_DP(lybk_datapkg),
      
      .DATA_VALID(s_circle_dv),//数据有效信号(任务下发有效)
      .B_CIRCLE_AMOUNT(b_circle_amount),//大循环数量
      .ORDER_TYPE(order_type),//指令类型
      .ORDER_VALID(order_valid),//指令有效信号
      .TASK_ID(task_id),//任务ID(指令和数据共用)
      .FPGA_ID(fpga_id),//fpga编号(指令和数据共用)
      .S_CIRCLE_DATA(s_circle_data),//小循环触发数据

      .SYNC_TEST_DATA(sync_test_data),
      .TEST_DATA_VALID(test_data_valid),
      .WORK_MODE(work_mode),

      .RX_DONE(lybk_rx_done),
      .ERROR(send_lybk_error)
);
////////////////////////////////////////////////////////
/////////////////路由复位模块////////////////////////////
       wire     reset_done;//复位完成

lybk_reset_control#(
     .FPGA_AMOUNT(FPGA_AMOUNT)
	)lybk_reset_control_inst(
       .XGMII_CLK(XGMII_CLK),
       .ORDER_TYPE(order_type),
       .ORDER_VALID(order_valid),
       .FPGA_ID(fpga_id),
       .TASK_ID(task_id),                     

       .TRIGGER_RESET(trigger_rst_n),//触发模块的复位信号(低电平)
       .FPGA_RESET(FPGA_RESET),//FPGA的复位信号(低电平)
       .SYS_RESET(sys_rst_n),//系统复位(低电平)
       .FPGA_RESET_VALID(FPGA_RESET_VALID),
       .RESET_DONE(reset_done)
    );
////////////////////////////////////////////////////////
/////////////////路由触发模块////////////////////////////
       wire [5*FPGA_AMOUNT-1:0]  ready_state;
       wire [19:0] b_circle_id;
       wire [4:0]  ready_error;
       wire        task_dpg_error; 
       wire [4:0]  trigger_success;
       wire [4:0]  trigger_failure;
       wire [14:0] trigger_out;

lybk_trigger_top#(
      .FPGA_AMOUNT(FPGA_AMOUNT)//FPGA数量
	)lybk_trigger_top_inst(
       .DATA_CLK(XGMII_CLK),      
       .TRIGGER_CLK(TRIGGER_CLK),
       .RST_N(trigger_rst_n),
       .EN(s_circle_dv),
       .ZKBK_TASK_ID(zkbk_task_id),
       .ZKBK_TRIGGER(zkbk_trigger),
       .B_CIRCLE_AMOUNT(b_circle_amount),
       .TASK_ID(task_id),     
       .FPGA_ID(fpga_id),         
       .S_CIRCLE_DATA(s_circle_data),         
       
       .FPGA_READY(FPGA_READY),
       .FPGA_READY_VALID(FPGA_READY_VALID),
       .TRIGGER_OUT(trigger_out),
       .FPGA_TRIGGER_VALID(FPGA_TRIGGER_VALID),
       .READY_STATE(ready_state),//所有模块的就绪状态
       .B_CIRCLE_ID(b_circle_id),//所有模块的大循环编号

       .SEND_ERROR(task_dpg_error),//任务下发错误反馈 
       .READY_ERROR(ready_error),//就绪错误反馈
       .TRIGGER_SUCCESS(trigger_success),//中控触发成功
       .TRIGGER_FAILURE(trigger_failure),//中控触发失败

       .TO_ZKBK_TASK_ID(to_zkbk_task_id),//触发模块就绪掩码
       .TO_ZKBK_READY(to_zkbk_ready),
       .TO_ZKBK_VALID(to_zkbk_valid) 
    );
/////////////////////////////////////////////////////
////////////////路由回传模块//////////////////////////
      wire [63:0]   hmc7044_passback;
      wire          hmc7044_passback_valid; 
      wire [63:0]   adda_data;
      wire          adda_data_valid;

      assign adda_data = (order_type == 8'h05)? 0 : FROM_FPGA15_AURORA_DATAPKG;
      assign adda_data_valid = (order_type == 8'h05)? 0 : FROM_FPGA15_AURORA_VALID ;

lybk_passback#(
     .FPGA_AMOUNT(FPGA_AMOUNT)
	)lybk_passback_inst(
       .XGMII_CLK(XGMII_CLK),          
       .SYS_RST_N(sys_rst_n),  
       .READY_STATE(ready_state),        
       .B_CIRCLE_ID(b_circle_id),        
       .ORDER_TYPE(order_type),        
       .ORDER_VALID(order_valid), 
       
       .READY_ERROR(ready_error),        
       .TRIGGER_SUCCESS(trigger_success),
       .TRIGGER_FAILURE(trigger_failure),

       .XGMII_DATA_ERROR(xgmii_send_error),
       .BK_DATA_ERROR(send_lybk_error),
       .TASK_SEND_ERROR(task_dpg_error),

       .ADDA_DATA_VALID(adda_data_valid),
       .ADDA_DATA(adda_data),

       .TASK_ID(task_id),       
       .FPGA_ID(fpga_id),       
       .B_CIRCLE_AMOUNT(b_circle_amount),       
       .LYBK_RX_DONE(lybk_rx_done),
       .RESET_DONE(reset_done),

       .HMC7044_PASSBACK(hmc7044_passback),
       .HMC7044_PASSBACK_VALID(hmc7044_passback_valid),

       .XGMII_TXDV(XGMII_TXDV),
       .XGMII_TXD(XGMII_TXD),
       .TX_DONE(TX_DONE)        
);

////////////////////////////////////////////
///////////////同步测试/////////////////////////
wire [64*15 - 1 :0] fpga_passback;
wire [14:0]   passback_valid;
wire [14:0]   to_fpga_trgger;
wire          to_zkbk_ready_test;
wire [63:0]   aurora_fpga1,aurora_fpga2,aurora_fpga3,aurora_fpga4,
aurora_fpga5,aurora_fpga6,aurora_fpga7,aurora_fpga8,aurora_fpga9,
aurora_fpga10,aurora_fpga11,aurora_fpga12,aurora_fpga13,aurora_fpga14,aurora_fpga15;
wire          aurora_awg_valid,aurora_da_valid,aurora_ad_valid;

assign fpga_passback = (order_type == 8'h05)? {FROM_FPGA15_AURORA_DATAPKG,FROM_FPGA14_AURORA_DATAPKG,
      FROM_FPGA13_AURORA_DATAPKG,FROM_FPGA12_AURORA_DATAPKG,FROM_FPGA11_AURORA_DATAPKG,FROM_FPGA10_AURORA_DATAPKG,
      FROM_FPGA9_AURORA_DATAPKG,FROM_FPGA8_AURORA_DATAPKG,FROM_FPGA7_AURORA_DATAPKG,FROM_FPGA6_AURORA_DATAPKG,
      FROM_FPGA5_AURORA_DATAPKG,FROM_FPGA4_AURORA_DATAPKG,FROM_FPGA3_AURORA_DATAPKG,FROM_FPGA2_AURORA_DATAPKG,FROM_FPGA1_AURORA_DATAPKG} : 'd0 ;  

assign passback_valid = (order_type == 8'h05)? {FROM_FPGA15_AURORA_VALID,FROM_FPGA14_AURORA_VALID,FROM_FPGA13_AURORA_VALID,
FROM_FPGA12_AURORA_VALID,FROM_FPGA11_AURORA_VALID,FROM_FPGA10_AURORA_VALID,FROM_FPGA9_AURORA_VALID,FROM_FPGA8_AURORA_VALID,
FROM_FPGA7_AURORA_VALID,FROM_FPGA6_AURORA_VALID,FROM_FPGA5_AURORA_VALID,FROM_FPGA4_AURORA_VALID,FROM_FPGA3_AURORA_VALID,
FROM_FPGA2_AURORA_VALID,FROM_FPGA1_AURORA_VALID} : 0;  



sync_test_top sync_test_top_inst(
       .XGMII_CLK(XGMII_CLK),
       .RST_N(sys_rst_n),
       .ORDER_TYPE(order_type),
       .WORK_MODE(work_mode),

       .SYNC_TEST_DATA(sync_test_data),
       .TEST_DATA_VALID(test_data_valid),
       .FPGA_READY(FPGA_READY),
       .ZKBK_TRIGGER(zkbk_trigger),

       .FPGA_PASSBACK(fpga_passback),
       .PASSBACK_VALID(passback_valid),

       .TO_FPGA_TRIGGER(to_fpga_trgger),
       .TO_ZKBK_READY(to_zkbk_ready_test),
       .HMC7044_PASSBACK(hmc7044_passback),
       .HMC7044_PASSBACK_VALID(hmc7044_passback_valid),
                          ///AWG
       .AURORA_FPGA1(aurora_fpga1),
       .AURORA_FPGA2(aurora_fpga2),
       .AURORA_FPGA3(aurora_fpga3),
       .AURORA_FPGA4(aurora_fpga4),
       .AURORA_FPGA5(aurora_fpga5),
       .AURORA_FPGA6(aurora_fpga6),
       .AURORA_FPGA7(aurora_fpga7),
       .AURORA_AWG_VALID(aurora_awg_valid),
                          ///DA
       .AURORA_FPGA8(aurora_fpga8),
       .AURORA_FPGA9(aurora_fpga9),
       .AURORA_FPGA10(aurora_fpga10),
       .AURORA_FPGA11(aurora_fpga11),
       .AURORA_FPGA12(aurora_fpga12),
       .AURORA_FPGA13(aurora_fpga13),
       .AURORA_FPGA14(aurora_fpga14),
       .AURORA_DA_VALID(aurora_da_valid),
                        ////AD
       .AURORA_FPGA15(aurora_fpga15),
       .AURORA_AD_VALID(aurora_ad_valid)
    );

endmodule
