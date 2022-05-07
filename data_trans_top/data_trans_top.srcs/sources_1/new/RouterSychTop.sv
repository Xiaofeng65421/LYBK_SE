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


module RouterSychTop#(
   parameter   TRIGGER_P = 50,//触发周期
   parameter   SYNC_L = 15,//同步长度
   parameter   TRIG_SYNC_D = 2//触发同步间隔
  )(
     input            clk,//100M 7044
     input            sync_rst,
     input            TrigIn,
     input            rxd_p,
     input            rxd_n,
     output           txd_p,
     output           txd_n,
     output           TrigOkOut,
     output   [3:0]   state,
//-------------仿真------------------//     
    
/*     input    [7:0]   ready_id,
     input            ready_id_valid,
     input    [7:0]   rx_data,
     input            rx_data_vald,
     output   [7:0]   tx_data,
     output           tx_data_vald */
//--------------------------------//
     input            ready_id_valid,
     input    [7:0]   ready_id,
     output   [7:0]   zk_task_id,
     output           trigout,
     output           trig_pulse_out,
     output           sync    
    );
(*mark_debug = "true"*)     wire           trigin;
(*mark_debug = "true"*)     wire           ready_id_valid;
(*mark_debug = "true"*)     wire   [7:0]   ready_id;         
                            wire   [7:0]   trig_start_point; // 触发脉冲开始点 (小于TRIGGER_P) 
                            wire   [7:0]   trig_sync_delay;//同步触发延迟 
(*mark_debug = "true"*)     wire           rst;
                            wire           vio_reset;

                            wire   [7:0]   vio_trig_start_point;
                            wire   [7:0]   vio_trig_sync_delay;

(*mark_debug = "true"*)     wire           TrigOkOut;
(*mark_debug = "true"*)     reg   [7:0]    trig_task_id = 0;
(*mark_debug = "true"*)     reg            trig_task_valid = 0;
(*mark_debug = "true"*)     reg   [7:0]    zk_task_id_r = 0;
(*mark_debug = "true"*)     wire           trigout;
(*mark_debug = "true"*)     wire           sync;

     wire            ready_start;
     reg             ready_start_r1;
     reg             ready_start_r2;
     reg             TrigIn_pre1;
     reg             TrigIn_pre2;
     wire            vio_ready_id_valid;
     wire   [7:0]    vio_task_id;
    
(*mark_debug = "true"*)     wire   [7:0]    tx_data, rx_data;
(*mark_debug = "true"*)     wire            tx_data_vald, rx_data_vald;
(*mark_debug = "true"*)     wire   [7:0]    config_data;
(*mark_debug = "true"*)    wire            config_data_vald;
(*mark_debug = "true"*)     reg   [7:0]     delay_data = 2;
     wire            tx_fifo_empty;
     wire   [7:0]    instruction;
     wire            inst_vald;
(*mark_debug = "true"*)     wire            TrigOut;
(*mark_debug = "true"*)     reg    [7:0]    Rdy_id = 0;
(*mark_debug = "true"*)     reg             Rdy_id_vald = 0;
(*mark_debug = "true"*)     wire            TRigOk;
     reg             tx_ready_en = 0;
     wire            trig_control_switch;
     wire            trig_start;
     reg             trig_start_r1;
     reg             trig_start_r2;


     assign trigin = TrigIn_pre2;
     assign rst    = /*sync_rst;*/vio_reset | sync_rst;
     assign zk_task_id = /*zk_task_id_r;*/(trig_control_switch)? vio_task_id : zk_task_id_r;
     assign trig_start_point = (trig_control_switch)? vio_trig_start_point : 'd2;
     assign trig_sync_delay  = (trig_control_switch)? vio_trig_sync_delay  : 'd2;

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
     end

     always @(posedge clk or posedge rst)
       if (rst) begin
           zk_task_id_r <= 0;
       end else if (trig_task_valid) begin
           zk_task_id_r <= trig_task_id;
       end


//----------------vio-------------//
zk_ly_test zk_ly_test (
  .clk(clk),                // input wire clk
  .probe_out0(ready_start),  // output wire [0 : 0] probe_out0
  .probe_out1(vio_reset),  // output wire [0 : 0] probe_out1
  .probe_out2(vio_task_id),  // output wire [7 : 0] probe_out2
  .probe_out3(vio_trig_start_point),  // output wire [7 : 0] probe_out3
  .probe_out4(vio_trig_sync_delay),  // output wire [7 : 0] probe_out4
  .probe_out5(trig_control_switch),
  .probe_out6(trig_start)
);
//------------------------------//    
    TrigOkOut #(.FILTALUE(8),.TRIGLENGTH(15))theTrigOkOut(
        .clk(clk),
        .rst(rst),
        .TrigIn(trigin),
        .TrigOut(TrigOut),
        .TRigOk(TRigOk));
    
     Rs422 theRs422(
        .clk(clk),
        .rst(rst),
        .txd_p(txd_p), 
        .txd_n(txd_n),
        .rxd_p(rxd_p), 
        .rxd_n(rxd_n),
        .tx_data(tx_data), //路由回传
        .tx_data_valid(tx_data_vald),
        .rx_data(rx_data),//中控下发 
        .rx_data_valid(rx_data_vald),
        .tx_fifo_empty(tx_fifo_empty)
        );
     
     CenterDelayValue theCenterDelayValue(
        .clk(clk),
        .rst(rst),
        .rx_data(rx_data),
        .rx_data_vald(rx_data_vald),
        
        
        .instruction(instruction),
        .inst_vald(inst_vald),
        .dely_value(config_data),
        .dely_value_vald(config_data_vald)); 
     
     RouterReadyPackage theRouterReadyPackage(
         .clk(clk),
         .rst(rst),
         .Rdy_id(Rdy_id),
         .Rdy_id_vald(Rdy_id_vald),
         .tx_fifo_data(tx_data),
         .tx_fifo_data_vald(tx_data_vald));
        
     
///////状态机   

localparam  ready            = 4'd1;
localparam  trig_delay_calib = 4'd2;
localparam  sync_calib       = 4'd3;
localparam  work             = 4'd4;
 
reg [3:0]  state = ready;
assign TrigOkOut = (state == trig_delay_calib)? TRigOk : 0;
(*mark_debug = "true",dont_touch = "true"*)wire [3:0] state_debug;
assign state_debug = state;

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
              if (trig_f) begin   //同步校准
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
  end else begin
    Rdy_id_vald <= 0;
    case(state)
     ready : begin
          Rdy_id_vald <= /*ready_id_valid;*/ vio_ready_id_valid;
          Rdy_id <= /*ready_id;*/ vio_task_id;
     end
     trig_delay_calib : begin
       /*if (config_data_vald) begin //触发延时参数
           delay_data <= config_data;
           tx_ready_en <= 1;
       end
       if (tx_fifo_empty & tx_ready_en) begin
           Rdy_id_vald <= 1;
           Rdy_id <= ready_id;//ready_id | vio_task_id;
       end*/
       ////////////////vio/////////////
          Rdy_id_vald <= /*ready_id_valid;*/vio_ready_id_valid;
          Rdy_id <= /*ready_id;*/vio_task_id;
     end
     sync_calib : begin
         tx_ready_en <= 0;
        if (TrigOut_delay) begin
            Trig_create_en <= 1;
        end
     end
     work : begin
         Rdy_id_vald <= /*ready_id_valid;*/vio_ready_id_valid;
         Rdy_id <= /*ready_id;*/vio_task_id;
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
(*mark_debug = "true"*)    wire             trig_f;

     assign TrigOut_delay_f = ((Trig_delay_cnt == delay_data - 1)&Trig_delay_en)? 1 : 0;
     assign TrigOut_delay   = (trig_control_switch)? (trig_start_r1 & (~trig_start_r2)) : ( (delay_data == 0)? TrigOut_sync : TrigOut_delay_f );
     assign TrigOut_sync    = ((state == sync_calib) || (state == work))? TrigOut : 0;
     assign trig_pulse      = (trigger_time_cnt == trig_start_point)? 1 : 0;
     assign trig_pulse_out  = trig_pulse;
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
       end else if ((trig_pulse_cnt == 1)&trig_pulse) begin
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
