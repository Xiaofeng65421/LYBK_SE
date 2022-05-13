`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 14:32:48
// Design Name: 
// Module Name: RouterSychTop
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


module RouterSychTop_test#(
   parameter   TRIGGER_P = 50,//触发周期
   parameter   SYNC_L = 15,//同步长度
   parameter   TRIG_SYNC_D = 2//触发同步间隔
  )(
     input            clk,//100M 7044
     input            sync_rst,
     input            soft_rst,//上电复位
     input            TrigIn,
/*     input            rxd_p,
     input            rxd_n,
     output           txd_p,
     output           txd_n,*/
     input            tx_fifo_empty,
     input            rx_data_vald,
     input  [7:0]     rx_data,
     output           tx_data_vald,
     output [7:0]     tx_data,          

     output           TrigOkOut,
     output   [3:0]   state,

     input            ready_id_valid,
     input    [7:0]   ready_id,

     input            READY_CHECK_EN,
     output           READY_RECEIVE_VALID,
     input    [15:0]  FPGA_READY_STATE_MASK,
/*     input            reset_done,*/
     output   [7:0]   resetorder_type,
     output           resetorder_type_valid,
     output   [15:0]  FPGA_ID_local,
     output   [7:0]   TASK_ID_thread,
     output   [7:0]   zk_task_id,
     output           trigout,
     output           sync,

     output           sync_en    
    );
(*mark_debug = "true"*)     wire           trigin;
(*mark_debug = "true"*)     wire           ready_id_valid;
(*mark_debug = "true"*)     wire   [7:0]   ready_id;         
(*mark_debug = "true"*)     wire   [7:0]   trig_start_point; // 触发脉冲开始点 (小于TRIGGER_P) vio
(*mark_debug = "true"*)     wire   [7:0]   trig_sync_delay;//同步触发延迟 vio
(*mark_debug = "true"*)     wire           rst;
                            wire           vio_reset;
(*mark_debug = "true"*)     wire           TrigOkOut;
(*mark_debug = "true"*)     reg    [7:0]   trig_task_id = 0;
(*mark_debug = "true"*)     reg            trig_task_valid = 0;
(*mark_debug = "true"*)     reg    [7:0]   zk_task_id_r = 0;
(*mark_debug = "true"*)     wire           trigout;
(*mark_debug = "true"*)     wire           sync;
(*mark_debug = "true"*)     wire   [7:0]   resetorder_type;
(*mark_debug = "true"*)     wire           resetorder_type_valid;
(*mark_debug = "true"*)     wire   [15:0]  FPGA_ID_local;
(*mark_debug = "true"*)     wire   [7:0]   TASK_ID_thread;
     wire   [7:0]    vio_trig_start_point;
     wire   [7:0]    vio_trig_sync_delay;

     wire            ready_start = 0;
     reg             ready_start_r1;
     reg             ready_start_r2;
     reg             TrigIn_pre1;
     reg             TrigIn_pre2;
     wire            vio_ready_id_valid = 0;
     wire   [7:0]    vio_task_id = 'd0;
    
(*mark_debug = "true"*)     wire   [7:0]    tx_data, rx_data;
(*mark_debug = "true"*)     wire            tx_data_vald, rx_data_vald;
(*mark_debug = "true"*)     wire   [7:0]    config_data;
(*mark_debug = "true"*)    wire            config_data_vald;
(*mark_debug = "true"*)     reg   [7:0]     delay_data = 2;
     wire            tx_fifo_empty;
     wire   [7:0]    order_type;
     wire            order_type_valid;
(*mark_debug = "true"*)     wire            TrigOut;
(*mark_debug = "true"*)     reg    [7:0]    Rdy_id = 0;
(*mark_debug = "true"*)     reg             Rdy_id_vald = 0;
(*mark_debug = "true"*)     wire            TRigOk;
     reg             tx_ready_en = 0;
     wire            trig_control_switch = 0;
     wire            trig_start = 0;
     reg             trig_start_r1;
     reg             trig_start_r2;
     wire            receive_finish;
     wire   [15:0]   fpga_mask; 

     reg             sync_en = 0; //同步使能 
     reg             ready_check_en = 0;
     wire            ready_passback_en;
     wire   [3:0]    ready_success_state;
     wire   [15:0]   fpga_ready_state_mask;
     reg             sync_rst_r;

     assign trigin                = TrigIn_pre2;
     assign rst                   =  sync_rst;
     assign zk_task_id            = /*zk_task_id_r;*/(trig_control_switch)? vio_task_id : zk_task_id_r;
     assign TASK_ID_thread        = config_data;
     assign FPGA_ID_local         = fpga_mask;
     assign resetorder_type       = order_type;
     assign resetorder_type_valid = order_type_valid;
     assign trig_start_point      = (trig_control_switch)?vio_trig_start_point : 'd2;
     assign trig_sync_delay       = (trig_control_switch)?vio_trig_sync_delay  : 'd2;

     assign vio_ready_id_valid = ready_start_r1 &(~ready_start_r2);  

     always @(posedge clk)begin
        TrigIn_pre1 <= TrigIn;
        TrigIn_pre2 <= TrigIn_pre1;
     end

     always @(posedge clk)begin
        ready_start_r1 <= ready_start;
        ready_start_r2 <= ready_start_r1;
        trig_start_r1  <= trig_start;
        trig_start_r2  <= trig_start_r1;
        sync_rst_r     <= sync_rst; 
     end

     always @(posedge clk or posedge rst)
       if (rst) begin
           zk_task_id_r <= 0;
       end else if (trig_task_valid) begin
           zk_task_id_r <= trig_task_id;
       end
//----------------vio-------------//
/*zk_ly_test zk_ly_test (
  .clk(clk),                // input wire clk
  .probe_out0(ready_start),  // output wire [0 : 0] probe_out0
  .probe_out1(vio_reset),  // output wire [0 : 0] probe_out1
  .probe_out2(vio_task_id),  // output wire [7 : 0] probe_out2
  .probe_out3(vio_trig_start_point),  // output wire [7 : 0] probe_out3
  .probe_out4(vio_trig_sync_delay),  // output wire [7 : 0] probe_out4
  .probe_out5(trig_control_switch),
  .probe_out6(trig_start)
);*/
//------------------------------//    
    TrigOkOut #(.FILTALUE(8),.TRIGLENGTH(15))theTrigOkOut(
        .clk(clk),
        .rst(soft_rst),
        .TrigIn(trigin),
        .TrigOut(TrigOut),
        .TRigOk(TRigOk));
    
 /*    Rs422 theRs422(
        .clk(clk),
        .rst(soft_rst),
        .txd_p(txd_p), 
        .txd_n(txd_n),
        .rxd_p(rxd_p), 
        .rxd_n(rxd_n),
        .tx_data(tx_data), //路由回传
        .tx_data_valid(tx_data_vald),
        .rx_data(rx_data),//中控下发 
        .rx_data_valid(rx_data_vald),
        .tx_fifo_empty(tx_fifo_empty)
        );*/
     
     CenterDelayValue theCenterDelayValue(
        .clk(clk),
        .rst(soft_rst),
        .rx_data(rx_data),
        .rx_data_vald(rx_data_vald),
        .receive_finish(receive_finish),
        
        .fpga_mask(fpga_mask),
        .order_type(order_type),
        .order_type_valid(order_type_valid),
        .config_data(config_data),
        .config_data_valid(config_data_vald)); 
     
     RouterReadyPackage theRouterReadyPackage(
         .clk(clk),
         .rst(soft_rst),
/*         .reset_done(reset_done),*/
         .order_type_valid(order_type_valid),
         .order_type(order_type),
         .config_data(config_data),
         .fpga_mask(fpga_mask),
         .Rdy_id(Rdy_id),
         .Rdy_id_vald(ready_passback_en),
         .sys_state(state_r),
         .fpga_ready_state_mask(fpga_ready_state_mask),
         .ready_success_state(ready_success_state),
         .tx_fifo_data(tx_data),
         .tx_fifo_data_vald(tx_data_vald));

     bk_ready_check bk_ready_check_inst(
         .clk(clk),
         .rst(rst),
         .ready_signal(Rdy_id_vald),//对应板卡就绪信号
         .ready_check_en(READY_CHECK_EN|ready_check_en),//就绪检测开始
         .trig_control_switch(trig_control_switch),
         .fpga_ready_state_mask_in(FPGA_READY_STATE_MASK),//fpga就绪状态
         .ready_passback_en(ready_passback_en),//就绪回传开始
         .ready_success_state(ready_success_state),//就绪成功状态,1代表成功
         .fpga_ready_state_mask_out(fpga_ready_state_mask),
         .ready_receive_valid(READY_RECEIVE_VALID)//就绪接收有效
        );
        
     
///////状态机   

localparam  ready            = 4'd1;
localparam  trig_delay_calib = 4'd2;
localparam  sync_calib       = 4'd3;
localparam  work             = 4'd4;
 
reg [3:0]  state   = ready;
reg [3:0]  state_r = ready;
assign TrigOkOut   = (state == trig_delay_calib)? TRigOk : 0;
(*mark_debug = "true",dont_touch = "true"*)wire [3:0] state_debug;
assign state_debug = state;
reg  Rdy_id_vald_reg = 0 ;//就绪信号寄存 

always @(posedge clk)
   if (ready_passback_en) begin
        state_r <= state;
    end 
    
always @(posedge clk or posedge rst)
  if (rst) begin
      state <= ready;         
    end else begin
        case(state)
          ready : begin
              if (Rdy_id_vald) begin //准备阶段
                  state <= trig_delay_calib;
              end
          end
          trig_delay_calib : begin
              if (Rdy_id_vald) begin //延时校准
                  state <= sync_calib;
              end
          end
          sync_calib : begin
              if (Rdy_id_vald) begin   //同步校准
                  state <= work;
              end
          end
          work : begin
                          //工作阶段
          end
          default : begin
               state <= ready;
          end
        endcase
    end        
    
always @(posedge clk or posedge rst)
  if (rst) begin
    Rdy_id_vald <= 0;
    Rdy_id <= 0;
    delay_data <= 10;
    trig_task_id <= 0;
    trig_task_valid <= 0;
    Trig_create_en <= 0;
    tx_ready_en <= 0;
    Rdy_id_vald_reg <= 0;
    ready_check_en <= 0;
    sync_en <= 0;
  end else begin
    Rdy_id_vald <= 0;
    Rdy_id_vald_reg <= 0;
    sync_en <= 0;
    ready_check_en <= 0;
    tx_ready_en <= 0;    
    case(state)
     ready : begin
          if (trig_control_switch) begin
              Rdy_id_vald_reg <= vio_ready_id_valid;
          end else begin
              Rdy_id_vald_reg <= ready_id_valid;
          end
          if (Rdy_id_vald_reg & tx_fifo_empty) begin
              Rdy_id_vald <= 1;
          end
          Rdy_id <= ready_id | vio_task_id;
          if ((~sync_rst) & sync_rst_r) begin
                 ready_check_en <= 1;
          end
     end
     trig_delay_calib : begin
       if (config_data_vald & (order_type == 8'h02)) begin //触发延时参数
           delay_data <= config_data;
           ready_check_en <= 1;
           tx_ready_en <= 1;
       end
       if (tx_fifo_empty & tx_ready_en) begin
           Rdy_id_vald <= 1;
           Rdy_id <= 8'h00;
       end
     end
     sync_calib : begin
       if (TrigOut_delay) begin
            Trig_create_en <= 1;
            sync_en <= 1;
       end
       if (sync) begin
           ready_check_en <= 1;
       end
       if (trig_control_switch) begin
           Rdy_id_vald_reg <= vio_ready_id_valid;
       end else begin
           Rdy_id_vald_reg <= ready_id_valid;
       end
       if (tx_fifo_empty & Rdy_id_vald_reg) begin
           Rdy_id_vald <= 1;
       end
       Rdy_id <= ready_id | vio_task_id;
     end
     work : begin
        if (trig_control_switch) begin
              Rdy_id_vald <= vio_ready_id_valid;
          end else begin
              Rdy_id_vald <= ready_id_valid;
          end
         Rdy_id <= ready_id | vio_task_id;
         trig_task_id <= config_data;
         trig_task_valid <= config_data_vald;
     end    
    endcase
  end


//--------------同步校准----------------//
(*mark_debug = "true"*)     wire            TrigOut_sync;
(*mark_debug = "true"*)     wire            TrigOut_delay;//延时后的中控触发 
(*mark_debug = "true"*)     wire            TrigOut_delay_f;
(*mark_debug = "true"*)     reg    [7:0]    Trig_delay_cnt = 0;//延时计数
(*mark_debug = "true"*)     reg             Trig_delay_en = 0;
(*mark_debug = "true"*)     reg             Trig_create_en = 0;

(*mark_debug = "true"*)     reg    [7:0]    trigger_time_cnt = 0;
(*mark_debug = "true"*)     wire            trig_pulse;//触发脉冲
(*mark_debug = "true"*)     reg    [3:0]    trig_pulse_cnt = 0;//触发脉冲计数

(*mark_debug = "true"*)     reg             sync_create_en = 0;//同步产生
(*mark_debug = "true"*)     reg    [7:0]    sync_create_cnt = 0;
(*mark_debug = "true"*)     wire            sync_f;
(*mark_debug = "true"*)     wire            trig_f;
(*mark_debug = "true"*)     wire            trig_flag;

     assign TrigOut_delay_f = ((Trig_delay_cnt == delay_data - 1)&Trig_delay_en)? 1 : 0;
     assign TrigOut_delay   = (delay_data == 0)? TrigOut_sync : TrigOut_delay_f;
     assign TrigOut_sync    = ((state == sync_calib) || (state == work))? TrigOut : 0;
     assign trig_pulse      = (trigger_time_cnt == trig_start_point)? 1 : 0;
     assign sync_f          = ((sync_create_cnt >= TRIG_SYNC_D ) && (sync_create_cnt <= TRIG_SYNC_D + SYNC_L - 1))? 1 : 0;
     assign trig_f          = (sync_create_cnt == SYNC_L + TRIG_SYNC_D + trig_sync_delay - 1 )? 1 : 0;
     assign sync            = (state == sync_calib)? sync_f : 0;
     assign trig_flag       = (state == work)? trig_f : 0;
     assign trigout         = trig_flag;//(trig_control_switch)? (trig_start_r1 & (~trig_start_r2)) : trig_flag;

     always @(posedge clk or posedge rst)
       if (rst) begin
          Trig_delay_en <= 0;
       end else if (TrigOut_sync) begin
           Trig_delay_en <= 1;
       end else if (Trig_delay_cnt == delay_data ) begin
           Trig_delay_en <= 0;
       end

     always @(posedge clk or posedge rst)
       if (rst) begin
          Trig_delay_cnt <= 0;
       end else if (Trig_delay_en) begin
          Trig_delay_cnt <= Trig_delay_cnt + 1; 
       end else begin
          Trig_delay_cnt <= 0;
       end

     always @(posedge clk)
       if (Trig_create_en) begin
           if (trigger_time_cnt == TRIGGER_P -1) begin
               trigger_time_cnt <= 0;
           end else begin
               trigger_time_cnt <= trigger_time_cnt + 1;     
           end
       end else begin
           trigger_time_cnt <= 0;
       end

     always @(posedge clk)
       if (TrigOut_delay | rst) begin   ///脉冲次数
           trig_pulse_cnt <= 0;
       end else if (&trig_pulse_cnt) begin
           trig_pulse_cnt <= trig_pulse_cnt;  
       end else if (trig_pulse) begin
           trig_pulse_cnt <= trig_pulse_cnt + 1;
       end
      
    always @(posedge clk or posedge rst)
       if (rst) begin
            sync_create_en <= 0;
       end else if ((trig_pulse_cnt == 2)&trig_pulse) begin
            sync_create_en <= 1;
       end else if (sync_create_cnt == SYNC_L + TRIG_SYNC_D + trig_sync_delay ) begin
            sync_create_en <= 0;
       end 

     always @(posedge clk)
       if (sync_create_en) begin
           sync_create_cnt <= sync_create_cnt + 1;
         end else begin
           sync_create_cnt <= 0;
         end  
  

endmodule
