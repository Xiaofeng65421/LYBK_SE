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
     parameter RESET_TIME_200  = 19,
     parameter RESET_TIME_300  = 29
	)(
         input       XGMII_CLK,
         input [7:0] ORDER_TYPE,
         input       ORDER_VALID,
        /* input [FPGA_AMOUNT-1:0] FPGA_ID,//本次任务涉及的FPGA掩码*/
         input [FPGA_AMOUNT-1:0] FPGA_RESET_FINISH,
         /*input [7:0] TASK_ID,//本次需清除的任务 */   
         input       TASK_IDLE,

         output      TRIGGER_RESET,//触发模块的复位信号(低电平)
         output [FPGA_AMOUNT-1:0] FPGA_SYS_RST,//FPGA的系统复位信号(高电平)
         output        SYS_RESET,//系统复位(低电平)
         output        RESET_DONE
    );
       /* reg [3:0]              reset_type;//复位类型,0代表全线程复位，1~5代表对应线程复位*/
        reg  [4:0]              trigger_reset = 5'b11111;
        reg                     sys_reset = 1;
        reg                     fpga_sys_reset = 0;//fpga系统复位
        wire                    fpga_reset_finish;
        reg                     fpga_reset_finish_r;
        reg  [FPGA_AMOUNT-1:0]  fpga_reset_state = 0;
       
        reg  [FPGA_AMOUNT-1:0]  fpga_id = 16'hc307; //FPGA掩码           
        reg  [7:0]              reset_time_cnt = 0;
        wire [FPGA_AMOUNT-1:0]  fpga_rst_n;
        reg  [7:0]              task_id = 8'h01;
        wire [FPGA_AMOUNT-1:0]  fpga_reset_valid;

        wire                    reset_fpga_id_switch;
        wire [15:0]             reset_fpga_id;
        wire [FPGA_AMOUNT-1:0]  FPGA_ID;

        assign FPGA_ID = fpga_id;//(reset_fpga_id_switch)? reset_fpga_id : fpga_id;
        assign TRIGGER_RESET = &trigger_reset;
        assign SYS_RESET = sys_reset;  
        assign fpga_reset_finish = ((fpga_reset_state & FPGA_ID) == FPGA_ID)? 1 : 0;
        assign RESET_DONE = fpga_reset_finish & (~fpga_reset_finish_r) & TASK_IDLE; 

        always @(posedge XGMII_CLK)
          fpga_reset_finish_r <= fpga_reset_finish;    
        

        /*vio_fpga_reset_id vio_fpga_reset_id (
              .clk(XGMII_CLK),                // input wire clk
              .probe_out0(reset_fpga_id_switch),  // output wire [0 : 0] probe_out0
              .probe_out1(reset_fpga_id)  // output wire [15 : 0] probe_out1
            );*/


        generate
        	genvar i;
        	for (i = 0 ; i < FPGA_AMOUNT ; i = i + 1)
        	  begin : transport
                assign FPGA_SYS_RST[i] = fpga_sys_reset&FPGA_ID[i];
                always @(posedge XGMII_CLK)
                 if (fpga_sys_reset) begin
                      fpga_reset_state[i] <= 0;
                 end else begin
                    if (RESET_DONE) begin
                      fpga_reset_state[i] <= 0;
                    end 
                    else if (fpga_reset_valid[i]) begin
                        fpga_reset_state[i] <= 1;
                    end 
                 end
                  

                TrigInFilter #(.LEGTH(15)) theTrigInFilter(
                  .clk(XGMII_CLK),
                  /*.rst(FPGA_SYS_RST),*/
                  .TrigIn(FPGA_RESET_FINISH[i]),
                  .TrigIn_vald(fpga_reset_valid[i]));
        	  end
        endgenerate

        always @(posedge XGMII_CLK)begin
        		case(ORDER_TYPE)
                  8'h02 : begin
                       if(ORDER_VALID)begin
                         /* reset_type <= 0;//FPGA任务清除*/
                          /*fpga_id <= FPGA_ID;*/
                          fpga_sys_reset <= 1;
                       end else begin
                          if (reset_time_cnt == RESET_TIME_200) begin
                           fpga_sys_reset <= 0; 
                          end
                       end
                  end
                  8'h03 : begin
                       if (ORDER_VALID) begin
                         /* reset_type <= TASK_ID;*/
                          /*task_id <= TASK_ID;
                          fpga_id <= FPGA_ID;*/
                          fpga_sys_reset <= 1;
                          trigger_reset[task_id-1] <= 0; 
                       end else begin
                          if (reset_time_cnt == RESET_TIME_200 ) begin //多线程清除 200ns
                            trigger_reset[task_id-1] <= 1;
                            fpga_sys_reset <= 0;
                          end
                       end 
                  end
                  8'h04 : begin
                       if (ORDER_VALID) begin
                        /*  reset_type <= 0;   //机箱复位*/ 
                          fpga_id <= 16'hc307;//全部FPGA(SE版) 300ns
                          trigger_reset <= 0;
                          fpga_sys_reset <= 1;
                          sys_reset <= 0;
                       end else begin
                          if (reset_time_cnt == RESET_TIME_300 ) begin
                            trigger_reset <= 5'b11111;
                            sys_reset <= 1;
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
