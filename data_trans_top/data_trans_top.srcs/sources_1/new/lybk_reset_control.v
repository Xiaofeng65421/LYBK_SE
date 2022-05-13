`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/02 16:22:09
// Design Name: 
// Module Name: lybk_reset_control
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 低电平复位
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lybk_reset_control#(
     parameter FPGA_AMOUNT = 16,
     parameter FPGA_MASK_init = 16'hffff
    )(
         input       XGMII_CLK,
         input [7:0] ORDER_TYPE,
         input       ORDER_VALID,
         input [FPGA_AMOUNT-1:0] FPGA_ID_local,//局部复位涉及的FPGA掩码
         input [FPGA_AMOUNT-1:0] FPGA_ID_thread,//线程复位涉及的FPGA掩码

         input [7:0] TASK_ID_thread,//多线程复位需要清除的任务    
/*         input       TASK_IDLE,*/
         output      TRIGGER_RESET_N,//触发模块的复位信号(低电平)
         output [FPGA_AMOUNT-1:0] FPGA_SYS_RST,//FPGA的系统复位信号(高电平)
         output        SYS_RESET_N//系统复位(低电平)
    );
        localparam RESET_TIME_100  = 9;
        localparam RESET_TIME_200  = 19;
        localparam RESET_TIME_300  = 29;
    
        reg  [4:0]              trigger_reset_n = 5'b11111;//位宽对应线程数
        reg                     sys_reset_n = 1;
        reg                     fpga_sys_reset = 0;//fpga系统复位
       

        reg  [FPGA_AMOUNT-1:0]  fpga_id = FPGA_MASK_init; //FPGA掩码           
        reg  [7:0]              reset_time_cnt = 0;

        assign TRIGGER_RESET_N = &trigger_reset_n; //单线程复位
        assign SYS_RESET_N     = sys_reset_n;  

        generate
            genvar i;
            for (i = 0 ; i < FPGA_AMOUNT ; i = i + 1)
              begin : transport
                assign FPGA_SYS_RST[i] = fpga_sys_reset&fpga_id[i];                  
              end
        endgenerate


        always @(posedge XGMII_CLK)begin
                case(ORDER_TYPE)
                  8'h03 : begin
                       if(ORDER_VALID)begin
                          fpga_id        <= FPGA_ID_thread;
                          fpga_sys_reset <= 1;
                          trigger_reset_n[TASK_ID_thread-1] <= 0;
                       end else begin
                          if (reset_time_cnt == RESET_TIME_100) begin //清空多线程 100ns
                          fpga_sys_reset <= 0; 
                          trigger_reset_n[TASK_ID_thread-1] <= 1;
                          end
                       end
                  end
                  8'h04 : begin
                       if (ORDER_VALID) begin
                          fpga_id        <= FPGA_ID_local;
                          fpga_sys_reset <= 1;
                          trigger_reset_n <= 0; 
                       end else begin
                          if (reset_time_cnt == RESET_TIME_200 ) begin //局部复位 200ns
                            trigger_reset_n<= 5'b11111;
                            fpga_sys_reset <= 0;
                          end
                       end 
                  end
                  8'h05 : begin
                       if (ORDER_VALID) begin
                          fpga_id <= FPGA_MASK_init;
                          trigger_reset_n <= 0;
                          fpga_sys_reset <= 1;
                          sys_reset_n <= 0;
                       end else begin
                          if (reset_time_cnt == RESET_TIME_300 ) begin //全局复位 300ns
                            trigger_reset_n <= 5'b11111;
                            sys_reset_n <= 1;
                            fpga_sys_reset <= 0;
                          end
                        end
                  end
                  
                endcase
        end
       
       always @(posedge XGMII_CLK)    ///复位时长计数
           if (ORDER_VALID) begin
               reset_time_cnt <= 0;               
           end else if (&reset_time_cnt) begin
               reset_time_cnt <= reset_time_cnt;
           end else begin
               reset_time_cnt <= reset_time_cnt + 1;
           end             

endmodule
