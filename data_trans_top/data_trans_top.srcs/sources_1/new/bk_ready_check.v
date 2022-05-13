`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/12 14:22:11
// Design Name: 
// Module Name: bk_ready_check
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


module bk_ready_check(
    input          clk,
    input          rst,
    input          ready_signal,//对应板卡就绪信号
    input          ready_check_en,//就绪检测开始
    input          trig_control_switch,//vio控制
    input  [15:0]  fpga_ready_state_mask_in,//fpga就绪状态
    output         ready_passback_en,//就绪回传开始
    output [3:0]   ready_success_state,//就绪成功状态,1代表成功
    output [15:0]  fpga_ready_state_mask_out,
    output         ready_receive_valid//就绪接收有效

    );
    localparam  delay_1s = 1000;//100_000_000;

    reg          ready_check_en_pre;
    wire         ready_check_start;
    reg  [31:0]  ready_delay_cnt = 0;
    reg          ready_delay_en = 0;
    wire         ready_check_finish;
    reg  [3:0]   ready_success_state = 0;

    assign ready_check_start         = ready_check_en & (~ready_check_en_pre);
    assign ready_check_finish        = (ready_delay_cnt == delay_1s -1)||ready_signal;
    assign ready_receive_valid       = ready_delay_en;
    assign ready_passback_en         = ready_check_finish;
    assign fpga_ready_state_mask_out = (trig_control_switch)? 0 : ((ready_success_state == 1)? 'd0 : fpga_ready_state_mask_in);

    always @(posedge clk)begin
        ready_check_en_pre <= ready_check_en;
    end
   
    always @(posedge clk or posedge rst)
      if (rst) begin
         ready_delay_en <= 0;
      end else if (ready_check_start) begin
         ready_delay_en <= 1; 
      end else if (ready_check_finish)begin
         ready_delay_en <= 0; 
      end

    always @(posedge clk)
      if (ready_delay_en) begin
          ready_delay_cnt <= ready_delay_cnt + 1;
      end else begin
          ready_delay_cnt <= 0;
      end  

    always @(posedge clk or posedge rst)
      if (rst) begin
          ready_success_state <= 0;
      end else if (ready_check_finish) begin
          if (ready_delay_cnt == delay_1s -1) begin
              ready_success_state <= 0;
          end else begin
              ready_success_state <= 1;
          end
      end



endmodule
