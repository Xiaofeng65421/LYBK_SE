`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/14 14:59:23
// Design Name: 
// Module Name: DDR_TOP
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


module lybk_ddr_top#(
   parameter   READ_DELAY = 500,//读请求等待时间
   parameter   DELAY_MAX = 256 //传输完成判断阈值
  )(
  input                 sys_rst,//系统复位
  input                 task_rst,//线程复位
  input                 ddr_rst,///上电复位
  input                 xgmii_clk, //万兆网端口时钟 156.25M
  input                 trigger_clk,
  output                ddr_user_clk,//ddr用户时钟 156.25M
  output                ddr_reset_finish, //ddr复位完成标志
  input      [31:0]     passback_data_length, 
(* MARK_DEBUG="true" *)  input                 passback_data_length_valid,
//-------数据传输接口----------------//
(* MARK_DEBUG="true" *)  input        [63:0]   aurora_data,//aurora回传数据（时钟域为ddr_user_clk,跨时钟处理后的数据）
(* MARK_DEBUG="true" *)  input                 aurora_data_valid,
(* MARK_DEBUG="true" *)  input                 DDR_RD_REQ, //ddr到万兆网模块对接fifo的读控制
(* MARK_DEBUG="true" *)  output       [63:0]   DDR_RD_DATA,//发送给万兆网模块数据
(* MARK_DEBUG="true" *)  output                DDR_RD_VALID,
                         output                DDR_BUSY,
//--------------------------------//

//--------------------DDR物理接口-------------------------//
  input                 c0_sys_clk_p,//系统的300MHz差分时钟
  input                 c0_sys_clk_n,
  output                c0_ddr4_act_n,//控制A[14:16]的复用 全为高时作为地址，全为0时复用为WE、CAS、RAS；
  output       [16:0]   c0_ddr4_adr,//17位地址
  output       [1:0]    c0_ddr4_ba,//DDR 的Bank寻址
  output                c0_ddr4_bg,
  output                c0_ddr4_cke,//DDR的时钟使能
  output                c0_ddr4_odt,//控制片上终端电阻
  output                c0_ddr4_cs_n,//FPGA输出的DDR片选使能
  output                c0_ddr4_ck_t,
  output                c0_ddr4_ck_c,
  output                c0_ddr4_reset_n,

  inout        [7:0]    c0_ddr4_dm_dbi_n,
  inout        [63:0]   c0_ddr4_dq,
  inout        [7:0]    c0_ddr4_dqs_t,
  inout        [7:0]    c0_ddr4_dqs_c
);

//-------------ddr_param-----------------//
(* MARK_DEBUG="true" *)wire         write_req;
wire         write_req_normal;
wire         write_req_final;
(* MARK_DEBUG="true" *)reg         passback_finish = 0;
reg          passback_finish_r1 = 0;
(* MARK_DEBUG="true" *)reg          passback_finish_r2 = 0;
(* MARK_DEBUG="true" *)wire [31:0]  passback_data_length_debug = passback_data_length;
(* MARK_DEBUG="true" *)reg          trans_finish = 0;
(* MARK_DEBUG="true" *)reg          read_req = 0;
(* MARK_DEBUG="true" *)reg  [11:0]  ddr_length = 'd500;
(* MARK_DEBUG="true" *)wire [511:0] u_wdf_data;//写入ddr的数据 512位 一次长度为12（可设）
(* MARK_DEBUG="true" *)wire [511:0] u_rd_data;//从ddr的读出数据
(* MARK_DEBUG="true" *)wire         u_rd_valid;//读数据有效位
(* MARK_DEBUG="true" *)wire         fifo_rd_en;//读fifo使能
wire         u_rst;//复位(来自mig)
wire         u_clk;//用户时钟 156.25M
wire         c0_init_calib_comple;//ddr初始化完成标志
(* MARK_DEBUG="true" *)wire         write_done;
wire         read_done;
reg          sys_rst_pre=0;
reg          sys_rst_r=0;//延一拍
reg          task_rst_pre=0;
reg          task_rst_r=0;
wire         trans_finish_reset;
reg          trans_finish_en = 0;
reg   [7:0]  reset_cnt = 0;
(* MARK_DEBUG="true" *)wire         sys_rst_tru;

assign ddr_reset_finish = c0_init_calib_comple;
assign ddr_user_clk     = u_clk;
assign write_req = write_req_normal | write_req_final;
///跨时钟
wire [31:0] pdl_ddr;
wire        pdl_ddr_valid;
(* MARK_DEBUG="true" *)reg  [31:0] pdl_ddr_r = 'd1000;

CrossClkData CrossClkData_2_ddrclk(
    .clka(trigger_clk), 
    .clkb(u_clk),
    .read(passback_data_length_valid),
    .data_in(passback_data_length),
    .data_out(pdl_ddr),
    .data_out_veld(pdl_ddr_valid)
    );

always @(posedge u_clk)
  if (pdl_ddr_valid) begin
      pdl_ddr_r <= pdl_ddr;
  end

wire [31:0] pdl_xgmii;
wire        pdl_xgmii_valid;
(* MARK_DEBUG="true" *)reg  [31:0] pdl_xgmii_r = 'd1000;

CrossClkData CrossClkData_2_xgmiiclk(
    .clka(trigger_clk), 
    .clkb(xgmii_clk),
    .read(passback_data_length_valid),
    .data_in(passback_data_length),
    .data_out(pdl_xgmii),
    .data_out_veld(pdl_xgmii_valid)
    );

always @(posedge xgmii_clk)
  if (pdl_xgmii_valid) begin
      pdl_xgmii_r <= pdl_xgmii;
  end

///rst
assign sys_rst_tru = sys_rst_r | trans_finish_reset | task_rst_r;
assign trans_finish_reset = trans_finish_en & (reset_cnt >= 19);

always @(posedge u_clk)
  begin
       sys_rst_pre <= sys_rst;
       sys_rst_r   <= sys_rst_pre;
       task_rst_pre<= task_rst;
       task_rst_r  <= task_rst_pre;
  end

always @(posedge u_clk)
   if (trans_finish) begin
       trans_finish_en <= 1;
   end else if (reset_cnt == 29) begin
       trans_finish_en <= 0;
   end

always @(posedge u_clk)
   if (trans_finish_en) begin
       reset_cnt <= reset_cnt + 1;
   end else begin
       reset_cnt <= 0;
   end

//-------------final_data_judge--------------//
(* MARK_DEBUG="true" *)reg  [31:0]  final_data_length;
reg [3:0]   remain_data_length = 0;
(* MARK_DEBUG="true" *)wire [3:0]   remain;
wire         aurora_exdata_valid;
reg          aurora_exdata_valid_r1;
reg          aurora_exdata_valid_r2;
reg  [3:0]   exdata_valid_cnt = 0;
wire         eight_zero_switch;

/*vio_2 vio_2_inst (
  .clk(u_clk),                // input wire clk
  .probe_out0(eight_zero_switch)  // output wire [0 : 0] probe_out0
);*/

assign remain = remain_data_length;//(eight_zero_switch)? 0 : remain_data_length;
assign aurora_exdata_valid = (|remain_data_length)&(exdata_valid_cnt != (8 - remain))&(state == last_frame);

always @(posedge u_clk)
    if (state == idle) begin
        exdata_valid_cnt <= 0;
    end else
    if (aurora_exdata_valid) begin
        exdata_valid_cnt <= exdata_valid_cnt + 1; 
    end 


always @(posedge u_clk)
begin 
    passback_finish_r1       <= passback_finish;
    passback_finish_r2       <= passback_finish_r1;
    aurora_exdata_valid_r1   <= aurora_exdata_valid;
    aurora_exdata_valid_r2   <= aurora_exdata_valid_r1;  
    final_data_length        <= pdl_ddr_r % 4000;
    remain_data_length       <= final_data_length % 8;
end
//----------aurora to  ddr  fifo ---------------------//
(* MARK_DEBUG="true" *)wire        full;
(* MARK_DEBUG="true" *)wire        empty;
(* MARK_DEBUG="true" *)wire        prog_full;
(* MARK_DEBUG="true" *)wire        p_full;
reg         p_full_pre;

reg  [11:0]  rd_valid_cnt = 0;
(* MARK_DEBUG="true" *)reg         rd_done_flag = 0;
(* MARK_DEBUG="true" *)wire         wr_req_en ;
(* MARK_DEBUG="true" *)reg         wr_start = 1; //写开始
reg          wr_req_en1 = 0;
reg          wr_req_en2 = 0;
reg         aurora_data_valid_r;

reg wr_req_final_en = 0;
reg wr_req_final_en_r1;
reg wr_req_final_en_r2;

(* MARK_DEBUG="true" *)reg [31:0] receive_passback_cnt = 0; 

assign p_full = (full)? 0 : (prog_full & (wr_req_en | wr_start));
assign wr_req_en = wr_req_en1 | wr_req_en2;
assign write_req_normal = p_full & (~p_full_pre);
assign write_req_final = wr_req_final_en_r1 & (~wr_req_final_en_r2)&(~empty);

always @(posedge u_clk)begin
  wr_req_final_en_r1 <= wr_req_final_en;
  wr_req_final_en_r2 <= wr_req_final_en_r1;
end

always @(posedge u_clk) begin
     p_full_pre <= p_full;
     aurora_data_valid_r <= aurora_data_valid; 
end
 
always @(posedge u_clk or posedge sys_rst_tru)
  if (sys_rst_tru) begin
      rd_valid_cnt <= 0;
  end 
  else if (u_rd_valid) begin
     if (rd_valid_cnt == 499) begin
      rd_valid_cnt <= 0;
     end else begin
      rd_valid_cnt <= rd_valid_cnt + 1;    
     end
  end 

always @(posedge u_clk or posedge sys_rst_tru)
   if (sys_rst_tru) begin
       rd_done_flag <= 0;
   end else if (rd_valid_cnt == 499 && u_rd_valid) begin
       rd_done_flag <= 1;
   end else begin
       rd_done_flag <= 0;
   end

   always @(posedge u_clk)
   if (rd_done_flag) begin
      wr_req_en1 <= 1;
   end else if (write_done) begin
      wr_req_en1 <= 0;
   end

always @(posedge u_clk)
   if ((read_delay_cnt == READ_DELAY - 1)&(~read_flag_f)) begin
        wr_req_en2 <= 1;
   end else if (write_done) begin
        wr_req_en2 <= 0;
   end 


always @(posedge u_clk or posedge sys_rst_tru)
   if (sys_rst_tru) begin
       receive_passback_cnt <= 0;
   end else
   if (aurora_data_valid) begin
         receive_passback_cnt <= receive_passback_cnt + 1 ;
   end    

aurora2ddr_fifo aurora2ddr_fifo (
  .clk(u_clk),                // input wire clk
  .rst(sys_rst_tru),             // input wire srst
  .din(aurora_data),          // input wire [63 : 0] din
  .wr_en(aurora_data_valid | aurora_exdata_valid),  // input wire wr_en
  .rd_en(fifo_rd_en),         // input wire rd_en
  .dout(u_wdf_data),          // output wire [511 : 0] dout
  .full(full),                // output wire full
  .empty(empty),              // output wire empty
  .prog_full(prog_full),      // output wire prog_full
  .wr_rst_busy(),             // output wire wr_rst_busy
  .rd_rst_busy()              // output wire rd_rst_busy
);

//--------------------------------------------------//
DDR_NATIVE LYBK_DDR(
    .sys_rst(ddr_rst | sys_rst),//异步复位ddr
    .c0_sys_clk_p(c0_sys_clk_p),//系统的300MHz差分时钟，来自zcu 102 SI570
    .c0_sys_clk_n(c0_sys_clk_n),
    .write_req(write_req),//写请求
    .read_req(read_req),//读请求
    .u_wdf_data(u_wdf_data),//从fifo读出的数据
    .write_done(write_done),
    .read_done(read_done),

    .ddr_length(ddr_length),

    .u_rd_data(u_rd_data),//从ddr的读出数据
    .u_rd_valid(u_rd_valid),//读数据有效位
    .fifo_rd_en(fifo_rd_en),//读fifo使能
    .u_rst(u_rst),//用户接口复位
    .u_clk(u_clk),

    .c0_init_calib_comple(c0_init_calib_comple),
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
//------------------ddr to xgmii fifo -------------------//
wire [511:0] din_0;
wire  wr_en_0;
wire  rd_en_0;
wire [63:0] dout_0;
(* MARK_DEBUG="true" *)wire  full_0;
(* MARK_DEBUG="true" *)wire  empty_0;
(* MARK_DEBUG="true" *)wire  prog_full_0;
wire  prog_empty_0;

wire  p_full_0;
wire  ddr2xgmii_fifo_ready;
reg   ddr2xgmii_fifo_ready_pre; 
wire  p_empty_0;

(* MARK_DEBUG="true" *)reg [31:0] passback_cnt = 0;

assign din_0 = u_rd_data;
assign wr_en_0 = u_rd_valid;
assign rd_en_0 = (empty_0)? 0 : DDR_RD_REQ;
assign DDR_RD_DATA = (DDR_RD_VALID)?dout_0 : 0;
assign DDR_RD_VALID = rd_en_0 & (passback_cnt <= pdl_xgmii_r - 1) ;//& (state != idle);

assign p_full_0 = (full_0)? 0 : prog_full_0;
assign p_empty_0 = (empty_0)? 0 : prog_empty_0;
assign ddr2xgmii_fifo_ready = (~p_full_0)&read_req_en;


always @(posedge xgmii_clk)
  if (passback_cnt >= pdl_xgmii_r) begin
      passback_finish <= 1;
  end else begin
      passback_finish <= 0;
  end

always @(posedge u_clk)
begin
   ddr2xgmii_fifo_ready_pre <= ddr2xgmii_fifo_ready;
end
 
always @(posedge xgmii_clk or posedge sys_rst_tru)
   if (sys_rst_tru) begin
       passback_cnt <= 0;
   end else if (rd_en_0) begin
        passback_cnt <= passback_cnt + 1;
      end   

ddr_2_xgmii_fifo xgmii_fifo_0 (
  .rst(sys_rst_tru),               // input wire rst
  .wr_clk(u_clk),               // input wire wr_clk
  .rd_clk(xgmii_clk),           // input wire rd_clk
  .din(din_0),                  // input wire [511 : 0] din
  .wr_en(wr_en_0),              // input wire wr_en
  .rd_en(rd_en_0),              // input wire rd_en
  .dout(dout_0),                // output wire [63 : 0] dout
  .full(full_0),                // output wire full
  .empty(empty_0),              // output wire empty
  .prog_full(prog_full_0),      // output wire prog_full
  .prog_empty(prog_empty_0),    // output wire prog_empty
  .wr_rst_busy(),               // output wire wr_rst_busy
  .rd_rst_busy()                // output wire rd_rst_busy
);

//------------write_req & read_req  counter-----------//
(* MARK_DEBUG="true" *)reg [15:0]   wr_times_cnt;
(* MARK_DEBUG="true" *)reg [15:0]   rd_times_cnt;
wire         read_flag_f;
reg          read_flag_f1;
reg          read_flag_f2;
reg          read_flag = 0; 
reg          read_req_en = 0;
reg  [31:0]   read_delay_r;
wire [31:0]   read_delay_cnt;

localparam   idle         = 4'd1;
localparam   wr_rd_switch = 4'd2;
localparam   rd_only      = 4'd3;
localparam   last_frame   = 4'd4;


(* MARK_DEBUG="true" *)reg [3:0] state = idle;
assign read_flag_f = ddr2xgmii_fifo_ready & (~ddr2xgmii_fifo_ready_pre);
assign read_delay_cnt =(read_req_en)? read_delay_r  : 0 ;
assign DDR_BUSY = rd_en_0;


always @(posedge u_clk)begin
    read_flag_f1 <= read_flag_f; 
    read_flag_f2 <= read_flag_f1;
    read_flag    <= read_flag_f2;
end


always @(posedge u_clk)
  if (state == idle) begin
      wr_start <= 1;
  end else if (write_done) begin
      wr_start <= 0;
  end

always @(posedge u_clk)
  if (state == idle) begin
      wr_times_cnt <= 0;
  end else if (write_done) begin
      wr_times_cnt <= wr_times_cnt + 1;
  end

always @(posedge u_clk)
  if (state == idle) begin
      rd_times_cnt <= 0;
  end else if (rd_done_flag) begin
      rd_times_cnt <= rd_times_cnt + 1;
  end

 always @(posedge u_clk)
    if (state != idle) begin
        if (write_done) begin
             read_req_en <= 1;
        end else if (read_flag_f | read_delay_cnt == READ_DELAY - 1) begin
             read_req_en <= 0;
        end  
    end else begin
       read_req_en <= 0;
    end   

 always @(posedge u_clk)
    if (read_req_en) begin
        read_delay_r <= read_delay_r + 1;   
    end else begin
        read_delay_r <= 0;
    end  

//--------------ddr_read_control-----------//
wire         rd_only_en ;
wire         rd_only_req ;
reg  [11:0]  rd_only_cnt = 0;
reg  [15:0]  data_delay_cnt = 0;
reg          data_delay_en = 0;
wire         aurora_data_valid_posedge;
wire         aurora_data_valid_negedge;
reg          write_read_valid = 0;
(* MARK_DEBUG="true" *)wire [31:0] ddr_final_length;

assign rd_only_en = (state == rd_only)? 1 : 0;
assign rd_only_req = (rd_only_cnt == 599)? 1 : 0; //周期性产生读请求
assign aurora_data_valid_posedge = aurora_data_valid   & (~aurora_data_valid_r);
assign aurora_data_valid_negedge = (~aurora_data_valid)& aurora_data_valid_r; 
assign ddr_final_length = (|remain_data_length)? final_data_length/8 + 1 : final_data_length/8;

always @(posedge u_clk)
  if (write_req) begin
      write_read_valid <= 1;
  end else if (write_done) begin
      write_read_valid <= 0;
  end

always @(posedge u_clk)
  if (state == wr_rd_switch) begin
      if (aurora_data_valid_negedge) begin
         data_delay_en <= 1;
      end else if (aurora_data_valid_posedge) begin
         data_delay_en <= 0;
      end
  end else begin
      data_delay_en <= 0;
  end

always @(posedge u_clk)
  if (data_delay_en && (~write_read_valid)) begin
      if (data_delay_cnt == DELAY_MAX - 1) begin
          data_delay_cnt <= data_delay_cnt;
      end else begin
          data_delay_cnt <= data_delay_cnt + 1;
      end
  end else begin
      data_delay_cnt <= 0;
  end

always @(posedge u_clk or posedge sys_rst_tru)
  if (sys_rst_tru) begin
      state <= idle;
  end else begin
    case(state)
      idle : begin
           if (aurora_data_valid) begin
               state <= wr_rd_switch;
           end
      end
      wr_rd_switch : begin
           if ((data_delay_cnt == DELAY_MAX - 1)&&(receive_passback_cnt >= pdl_ddr_r - 1)) begin ////数据传输完毕
               state <= rd_only;
           end
      end
      rd_only : begin
           if ((rd_times_cnt == wr_times_cnt)&(~p_full_0)) begin
               if (final_data_length == 0) begin
                state <= idle;  
               end else begin
                state <= last_frame; 
               end
           end else begin
                state <= rd_only;
           end
      end
      last_frame : begin
               if (trans_finish) begin
                   state <= idle;
               end else begin
                   state <= last_frame;
               end
      end
    endcase
  end

always @(posedge u_clk)
begin
   case(state)
      idle : begin
           ddr_length <= 'd500;
           wr_req_final_en <= 0;
           trans_finish <= 0;
      end
      wr_rd_switch : begin
              if (read_flag) begin
                   read_req <= 1;
               end else begin
                   read_req <= 0;
               end
      end
      rd_only : begin  
          if (~p_full_0) begin  ///fifo非满
             read_req <= rd_only_req;
          end else begin
             read_req <= 0;
          end
      end
      last_frame : begin
          ddr_length <= ddr_final_length;
          if (|remain_data_length) begin
              wr_req_final_en <= (~aurora_exdata_valid_r1) & aurora_exdata_valid_r2; 
          end else begin
              wr_req_final_en <= ~empty;
          end
          if (read_flag) begin
             read_req <= 1;
          end else begin
             read_req <= 0;
          end
          if (passback_finish_r2) begin
              trans_finish <= 1;
          end else begin
              trans_finish <= 0;
          end
      end
    endcase
end
  
always @(posedge u_clk)
   if (rd_only_en) begin
       rd_only_cnt <= rd_only_cnt + 1;
   end else begin
       rd_only_cnt <= 0;
   end


endmodule
