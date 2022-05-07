`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/06 11:34:12
// Design Name: 
// Module Name: DDR_NATIVE
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


module DDR_NATIVE(
    input    wire           sys_rst,//异步复位ddr
    input    wire           c0_sys_clk_p,//系统的300MHz差分时钟，来自zcu 102 SI570
    input    wire           c0_sys_clk_n,
    input    wire           write_req,//写请求
    input    wire           read_req,//读请求
    input    wire   [511:0] u_wdf_data,//从fifo读出的数据

    input    wire   [11:0]  ddr_length,

    output   wire           write_done,
    output   wire           read_done,

    output   wire   [511:0] u_rd_data,//从ddr的读出数据
    output   wire           u_rd_valid,//读数据有效位
    output   wire           fifo_rd_en,//读fifo使能
    output   wire           u_rst,//用户接口复位
    output   wire           u_clk,
    output   wire           c0_init_calib_comple,//初始化标志
    output   wire           c0_ddr4_act_n,//控制A[14:16]的复用 全为高时作为地址，全为0时复用为WE、CAS、RAS；
    output   wire    [16:0] c0_ddr4_adr,//17位地址
    output   wire     [1:0] c0_ddr4_ba,//DDR 的Bank寻址
    output   wire           c0_ddr4_bg,
    output   wire           c0_ddr4_cke,//DDR的时钟使能
    output   wire           c0_ddr4_odt,//控制片上终端电阻
    output   wire           c0_ddr4_cs_n,//FPGA输出的DDR片选使能
    output   wire           c0_ddr4_ck_t,
    output   wire           c0_ddr4_ck_c,
    output   wire           c0_ddr4_reset_n,

    inout   wire      [7:0] c0_ddr4_dm_dbi_n,
    inout   wire     [63:0] c0_ddr4_dq,
    inout   wire      [7:0] c0_ddr4_dqs_t,
    inout   wire      [7:0] c0_ddr4_dqs_c
);

    wire     [2:0]   app_cmd;
    wire     [27:0]  app_addr;
    wire             app_en;
    wire             app_wdf_rdy;//写数据通道空闲信号
    wire    [511:0]  app_wdf_data;//写入的数据
    wire             app_wdf_wren;//写入数据使能
    wire             app_wdf_end;//当前数据是DDR一次突发的最后一个数据
    // wire    [63:0]   app_wdf_mask; //写入数据掩码
    wire    [511:0]  app_rd_data;//写入的数据
    wire             app_rd_data_vld;//写入数据使能
    wire             app_rdy;
    wire             c0_init_calib_complete;
    wire             ui_clk, rst;

    assign   u_clk = ui_clk;
    assign   u_rst = rst;
    assign   c0_init_calib_comple = c0_init_calib_complete;

    WrDdr  theWrDdr (
    .ui_clk(ui_clk)                                ,//MIG用户接口时钟
    .ui_rst(rst)                                   ,//MIG用户接口复位
    .write_req(write_req)                          ,//写请求
    .read_req(read_req)                            ,//读请求
    .u_wdf_data(u_wdf_data)                        ,//被写入ddr的数据
    .ui_rdy(app_rdy)                               ,//指令被接受标记
    .ui_rd_data(app_rd_data)                       ,//读数据
    .ui_rd_data_valid(app_rd_data_vld)             ,//读数据有效
    .ui_wdf_rdy(app_wdf_rdy)                       ,//数据可写标记，表示MIG内部缓冲可以装下新的写数据
    .c0_init_calib_complete(c0_init_calib_complete),

    .LENGTH(ddr_length),

    .write_done(write_done)                         ,
    .read_done(read_done)                          ,   

    .rd_fifo_en(fifo_rd_en)                        ,
    .u_rd_data(u_rd_data)                          ,//从DDR中读出数据
    .u_rd_valid(u_rd_valid)                        , //读出的数据有效
    .ui_addr(app_addr)                              ,//地址，每个地址对应DDR4物理层16位数据总线
    .ui_cmd(app_cmd)                                ,//写指令3'b000，读指令3'b001
    .ui_en(app_en)                                  ,//指令有效标记
    .ui_wdf_data(app_wdf_data)                      ,//写数据送给DDR的写入接口
    .ui_wdf_end(app_wdf_end)                        ,//写数据结束，与ui_wdf_wren对齐
    .ui_wdf_wren(app_wdf_wren));                         //写数据有效标记
        
    
        
    ddr4_if ddr4_00 (
      .c0_init_calib_complete(c0_init_calib_complete)                    ,// 表示PHY层完成校准，根据IP手册说明不需使用
      .dbg_clk()                                   ,// output  不用仿真时钟
      .c0_sys_clk_p(c0_sys_clk_p),                            // input wire c0_sys_clk_p
      .c0_sys_clk_n(c0_sys_clk_n),                            // input wire c0_sys_clk_n
      .dbg_bus()                                   ,// output 不用仿真总线
      .c0_ddr4_adr(c0_ddr4_adr)                    ,//  FPGA输出28位DDR的地址线
      .c0_ddr4_ba(c0_ddr4_ba)                      ,// FPGA输出两位控制DDR的bank组寻址
      .c0_ddr4_cke(c0_ddr4_cke)                    ,// FPGA输出时钟使能信号
      .c0_ddr4_cs_n(c0_ddr4_cs_n)                  ,// FPGA输出的DDR片选使能，此处只有1片所以位宽为1
      .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n)          ,// 双向 数据掩码与数据总线反转两位信号
      .c0_ddr4_dq(c0_ddr4_dq)                      ,// 双向 64位数据线
      .c0_ddr4_dqs_c(c0_ddr4_dqs_c)                ,// 双向差分数据选通信号
      .c0_ddr4_dqs_t(c0_ddr4_dqs_t)                ,// 双向差分数据选通信号
      .c0_ddr4_odt(c0_ddr4_odt)                    ,// FPGA输出控制片上终端电阻
      .c0_ddr4_bg(c0_ddr4_bg)                      ,// Bank Group地址选择，此处只有1位
      .c0_ddr4_reset_n(c0_ddr4_reset_n)            ,// FPGA输出DDR复位信号,低电平有效
      .c0_ddr4_act_n(c0_ddr4_act_n)                ,// 一位信号控制A[14:16]的复用，信号为高时作为地址，为低复用为WE、CAS、RAS；
      .c0_ddr4_ck_c(c0_ddr4_ck_c)                  ,// DDR的差分时钟输入，所有的地址、控制信号都是通过CK_t的上升沿与CK_c的下降沿进行采样的
      .c0_ddr4_ck_t(c0_ddr4_ck_t)                  ,// DDR的差分时钟输入，所有的地址、控制信号都是通过CK_t的上升沿与CK_c的下降沿进行采样的
     
      .c0_ddr4_ui_clk(ui_clk)                      ,// 用户接口时钟，即MMCM输出时钟，1/4的DDR4器件接口时钟，根据IP的默认配置与sys_clk一致
      .c0_ddr4_ui_clk_sync_rst(rst)                ,// 用户接口中同步复位
      .c0_ddr4_app_en(app_en)                      ,// input wire c0_ddr4_app_en 用户指令发起
      .c0_ddr4_app_hi_pri(1'b0)                    ,// input wire c0_ddr4_app_hi_pri//根据IP手册固定为0值
      .c0_ddr4_app_wdf_end(app_wdf_end)            ,// input wire c0_ddr4_app_wdf_end指示写数据为当前指令的最后1个数据
      .c0_ddr4_app_wdf_wren(app_wdf_wren)          ,// input wire c0_ddr4_app_wdf_wren 写使能
      .c0_ddr4_app_rd_data_end()                   ,// output wire c0_ddr4_app_rd_data_end根据IP手册说明不需使用 指示读数据为当前指令的最后1个数据
      .c0_ddr4_app_rd_data_valid(app_rd_data_vld)  ,// output wire c0_ddr4_app_rd_data_valid读出数据有效
      .c0_ddr4_app_rdy(app_rdy)                     ,// output wire c0_ddr4_app_rdy//向用户反馈IP已响应用户发起的指令，app_en和app_rdy同时为1表示指令被IP接受
      .c0_ddr4_app_wdf_rdy(app_wdf_rdy)             ,// output wire c0_ddr4_app_wdf_rdy向用户反馈IP已响应用户的写指令，app_en和app_rdy同时为1表示指令被IP接受
      .c0_ddr4_app_addr(app_addr)                   ,// input wire [27 : 0] c0_ddr4_app_addr//28位用户接口地址总线
      .c0_ddr4_app_cmd(app_cmd)                     ,// input wire [2 : 0] c0_ddr4_app_cmd//用户接口指令
      .c0_ddr4_app_wdf_data(app_wdf_data)           ,// input wire [511 : 0] c0_ddr4_app_wdf_data//写数据
      .c0_ddr4_app_wdf_mask(64'd0)                  ,// input wire [63: 0] c0_ddr4_app_wdf_mask//写数据掩码，固定全0表示不使用
      .c0_ddr4_app_rd_data(app_rd_data)             ,// output wire [511 : 0] c0_ddr4_app_rd_data//读出数据=
      .sys_rst(sys_rst)                              // input wire sys_rst//高有效异步复位，至少保持5ns
    );        
     
     
endmodule
