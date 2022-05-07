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
    input    wire           sys_rst,//�첽��λddr
    input    wire           c0_sys_clk_p,//ϵͳ��300MHz���ʱ�ӣ�����zcu 102 SI570
    input    wire           c0_sys_clk_n,
    input    wire           write_req,//д����
    input    wire           read_req,//������
    input    wire   [511:0] u_wdf_data,//��fifo����������

    input    wire   [11:0]  ddr_length,

    output   wire           write_done,
    output   wire           read_done,

    output   wire   [511:0] u_rd_data,//��ddr�Ķ�������
    output   wire           u_rd_valid,//��������Чλ
    output   wire           fifo_rd_en,//��fifoʹ��
    output   wire           u_rst,//�û��ӿڸ�λ
    output   wire           u_clk,
    output   wire           c0_init_calib_comple,//��ʼ����־
    output   wire           c0_ddr4_act_n,//����A[14:16]�ĸ��� ȫΪ��ʱ��Ϊ��ַ��ȫΪ0ʱ����ΪWE��CAS��RAS��
    output   wire    [16:0] c0_ddr4_adr,//17λ��ַ
    output   wire     [1:0] c0_ddr4_ba,//DDR ��BankѰַ
    output   wire           c0_ddr4_bg,
    output   wire           c0_ddr4_cke,//DDR��ʱ��ʹ��
    output   wire           c0_ddr4_odt,//����Ƭ���ն˵���
    output   wire           c0_ddr4_cs_n,//FPGA�����DDRƬѡʹ��
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
    wire             app_wdf_rdy;//д����ͨ�������ź�
    wire    [511:0]  app_wdf_data;//д�������
    wire             app_wdf_wren;//д������ʹ��
    wire             app_wdf_end;//��ǰ������DDRһ��ͻ�������һ������
    // wire    [63:0]   app_wdf_mask; //д����������
    wire    [511:0]  app_rd_data;//д�������
    wire             app_rd_data_vld;//д������ʹ��
    wire             app_rdy;
    wire             c0_init_calib_complete;
    wire             ui_clk, rst;

    assign   u_clk = ui_clk;
    assign   u_rst = rst;
    assign   c0_init_calib_comple = c0_init_calib_complete;

    WrDdr  theWrDdr (
    .ui_clk(ui_clk)                                ,//MIG�û��ӿ�ʱ��
    .ui_rst(rst)                                   ,//MIG�û��ӿڸ�λ
    .write_req(write_req)                          ,//д����
    .read_req(read_req)                            ,//������
    .u_wdf_data(u_wdf_data)                        ,//��д��ddr������
    .ui_rdy(app_rdy)                               ,//ָ����ܱ��
    .ui_rd_data(app_rd_data)                       ,//������
    .ui_rd_data_valid(app_rd_data_vld)             ,//��������Ч
    .ui_wdf_rdy(app_wdf_rdy)                       ,//���ݿ�д��ǣ���ʾMIG�ڲ��������װ���µ�д����
    .c0_init_calib_complete(c0_init_calib_complete),

    .LENGTH(ddr_length),

    .write_done(write_done)                         ,
    .read_done(read_done)                          ,   

    .rd_fifo_en(fifo_rd_en)                        ,
    .u_rd_data(u_rd_data)                          ,//��DDR�ж�������
    .u_rd_valid(u_rd_valid)                        , //������������Ч
    .ui_addr(app_addr)                              ,//��ַ��ÿ����ַ��ӦDDR4�����16λ��������
    .ui_cmd(app_cmd)                                ,//дָ��3'b000����ָ��3'b001
    .ui_en(app_en)                                  ,//ָ����Ч���
    .ui_wdf_data(app_wdf_data)                      ,//д�����͸�DDR��д��ӿ�
    .ui_wdf_end(app_wdf_end)                        ,//д���ݽ�������ui_wdf_wren����
    .ui_wdf_wren(app_wdf_wren));                         //д������Ч���
        
    
        
    ddr4_if ddr4_00 (
      .c0_init_calib_complete(c0_init_calib_complete)                    ,// ��ʾPHY�����У׼������IP�ֲ�˵������ʹ��
      .dbg_clk()                                   ,// output  ���÷���ʱ��
      .c0_sys_clk_p(c0_sys_clk_p),                            // input wire c0_sys_clk_p
      .c0_sys_clk_n(c0_sys_clk_n),                            // input wire c0_sys_clk_n
      .dbg_bus()                                   ,// output ���÷�������
      .c0_ddr4_adr(c0_ddr4_adr)                    ,//  FPGA���28λDDR�ĵ�ַ��
      .c0_ddr4_ba(c0_ddr4_ba)                      ,// FPGA�����λ����DDR��bank��Ѱַ
      .c0_ddr4_cke(c0_ddr4_cke)                    ,// FPGA���ʱ��ʹ���ź�
      .c0_ddr4_cs_n(c0_ddr4_cs_n)                  ,// FPGA�����DDRƬѡʹ�ܣ��˴�ֻ��1Ƭ����λ��Ϊ1
      .c0_ddr4_dm_dbi_n(c0_ddr4_dm_dbi_n)          ,// ˫�� �����������������߷�ת��λ�ź�
      .c0_ddr4_dq(c0_ddr4_dq)                      ,// ˫�� 64λ������
      .c0_ddr4_dqs_c(c0_ddr4_dqs_c)                ,// ˫��������ѡͨ�ź�
      .c0_ddr4_dqs_t(c0_ddr4_dqs_t)                ,// ˫��������ѡͨ�ź�
      .c0_ddr4_odt(c0_ddr4_odt)                    ,// FPGA�������Ƭ���ն˵���
      .c0_ddr4_bg(c0_ddr4_bg)                      ,// Bank Group��ַѡ�񣬴˴�ֻ��1λ
      .c0_ddr4_reset_n(c0_ddr4_reset_n)            ,// FPGA���DDR��λ�ź�,�͵�ƽ��Ч
      .c0_ddr4_act_n(c0_ddr4_act_n)                ,// һλ�źſ���A[14:16]�ĸ��ã��ź�Ϊ��ʱ��Ϊ��ַ��Ϊ�͸���ΪWE��CAS��RAS��
      .c0_ddr4_ck_c(c0_ddr4_ck_c)                  ,// DDR�Ĳ��ʱ�����룬���еĵ�ַ�������źŶ���ͨ��CK_t����������CK_c���½��ؽ��в�����
      .c0_ddr4_ck_t(c0_ddr4_ck_t)                  ,// DDR�Ĳ��ʱ�����룬���еĵ�ַ�������źŶ���ͨ��CK_t����������CK_c���½��ؽ��в�����
     
      .c0_ddr4_ui_clk(ui_clk)                      ,// �û��ӿ�ʱ�ӣ���MMCM���ʱ�ӣ�1/4��DDR4�����ӿ�ʱ�ӣ�����IP��Ĭ��������sys_clkһ��
      .c0_ddr4_ui_clk_sync_rst(rst)                ,// �û��ӿ���ͬ����λ
      .c0_ddr4_app_en(app_en)                      ,// input wire c0_ddr4_app_en �û�ָ���
      .c0_ddr4_app_hi_pri(1'b0)                    ,// input wire c0_ddr4_app_hi_pri//����IP�ֲ�̶�Ϊ0ֵ
      .c0_ddr4_app_wdf_end(app_wdf_end)            ,// input wire c0_ddr4_app_wdf_endָʾд����Ϊ��ǰָ������1������
      .c0_ddr4_app_wdf_wren(app_wdf_wren)          ,// input wire c0_ddr4_app_wdf_wren дʹ��
      .c0_ddr4_app_rd_data_end()                   ,// output wire c0_ddr4_app_rd_data_end����IP�ֲ�˵������ʹ�� ָʾ������Ϊ��ǰָ������1������
      .c0_ddr4_app_rd_data_valid(app_rd_data_vld)  ,// output wire c0_ddr4_app_rd_data_valid����������Ч
      .c0_ddr4_app_rdy(app_rdy)                     ,// output wire c0_ddr4_app_rdy//���û�����IP����Ӧ�û������ָ�app_en��app_rdyͬʱΪ1��ʾָ�IP����
      .c0_ddr4_app_wdf_rdy(app_wdf_rdy)             ,// output wire c0_ddr4_app_wdf_rdy���û�����IP����Ӧ�û���дָ�app_en��app_rdyͬʱΪ1��ʾָ�IP����
      .c0_ddr4_app_addr(app_addr)                   ,// input wire [27 : 0] c0_ddr4_app_addr//28λ�û��ӿڵ�ַ����
      .c0_ddr4_app_cmd(app_cmd)                     ,// input wire [2 : 0] c0_ddr4_app_cmd//�û��ӿ�ָ��
      .c0_ddr4_app_wdf_data(app_wdf_data)           ,// input wire [511 : 0] c0_ddr4_app_wdf_data//д����
      .c0_ddr4_app_wdf_mask(64'd0)                  ,// input wire [63: 0] c0_ddr4_app_wdf_mask//д�������룬�̶�ȫ0��ʾ��ʹ��
      .c0_ddr4_app_rd_data(app_rd_data)             ,// output wire [511 : 0] c0_ddr4_app_rd_data//��������=
      .sys_rst(sys_rst)                              // input wire sys_rst//����Ч�첽��λ�����ٱ���5ns
    );        
     
     
endmodule
