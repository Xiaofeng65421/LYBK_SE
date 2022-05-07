`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/17 14:00:01
// Design Name: 
// Module Name: lybk_config_trans
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


module lybk_config_trans(
	     input        RST_N,
       input        XGMII_CLK,
       input        LYBK_DP_VALID,
       input [63:0] LYBK_DP,
        
       output         S_CIRCLE_DATA_VALID,//数据有效信号(任务下发有效)
       output  [7:0]  B_CIRCLE_AMOUNT,//大循环数量
       output  [7:0]  ORDER_TYPE,//指令类型
       output         ORDER_VALID,//指令有效信号
       output  [7:0]  TASK_ID,//任务ID(指令和数据共用)
       output  [15:0] FPGA_ID,//fpga掩码号(指令和数据共用)
       output  [63:0] S_CIRCLE_DATA,//小循环触发数据
       output         THREAD_RESET_EN,

/*       output  [63:0] SYNC_TEST_DATA,//同步测试数据
       output         TEST_DATA_VALID,//测试数据有效
       output  [7:0]  WORK_MODE,//工作模式*/

       output         RX_DONE,
       output         ERROR
        
);


     reg [7:0] order_type = 0;//指令类型
     reg [55:0] config_data;//配置数据
     reg [7:0]  task_id = 8'h01;
     reg [15:0] fpga_id = 16'hc307;
     reg [7:0] b_circle_amount = 0;
     reg [63:0] s_circle_data = 0;
     reg        s_circle_data_valid ; 
     reg        order_valid;
     reg        thread_reset_en = 0;
     /*reg        order_valid_pre; */ 

/*     reg  [63:0] sync_test_data; 
     reg         test_data_valid; 
     reg  [7:0]  work_mode;  */

     reg  [7:0] cnt = 0;
     wire [3:0] data_amount;
     reg  [2:0]  cur_state;
     reg  [2:0]  next_state;
     reg         skip_en = 0;
     reg         error_en = 0;
     reg         rx_done_t = 0;

    localparam   st_idle    = 3'b001;
    localparam   st_datapkg = 3'b010;
    localparam   st_rx_end  = 3'b100;
/////////////////////////////////////////////////////////////////
    assign S_CIRCLE_DATA_VALID = s_circle_data_valid ;
    assign B_CIRCLE_AMOUNT = b_circle_amount ;
    assign ORDER_TYPE = order_type;
    assign ORDER_VALID = order_valid; 
    assign TASK_ID = task_id ;
    assign FPGA_ID = fpga_id ;
    assign S_CIRCLE_DATA = s_circle_data ; 
    assign THREAD_RESET_EN = thread_reset_en;

/*    assign SYNC_TEST_DATA = sync_test_data;
    assign TEST_DATA_VALID = test_data_valid;
    assign WORK_MODE = work_mode;*/
    
    assign ERROR = error_en;
    assign RX_DONE = rx_done_t;

////////////////////////大循环数据量（64bit）///////////////////////////
assign data_amount = config_data[23:16]; //(config_data[39:32]%2)?config_data[39:32]/2 +1 : config_data[39:32]/2;
//////////////////////////线程复位使能/////////////////////////////////
always @(posedge XGMII_CLK or negedge RST_N)
 if (!RST_N) begin
     thread_reset_en <= 0;
 end else begin
   if (order_type == 8'h03) begin
       thread_reset_en <= 1;
   end else if (order_type == 8'h01) begin
       thread_reset_en <= 0;
   end
 end

//(三段式状态机)同步时序描述状态转移
    always @(posedge XGMII_CLK or negedge RST_N)begin
      if (!RST_N) begin
        cur_state <= st_idle;
      end else begin
        cur_state <= next_state;
      end
    end    
//组合逻辑判断状态转移条件
    always @(*)begin
      next_state = st_idle;
      case(cur_state)
            st_idle : begin
              if (skip_en) begin
                next_state = st_datapkg;
              end else begin
                next_state = st_idle;
              end
            end
            st_datapkg : begin
              if (skip_en) begin
                next_state = st_rx_end;
              end else if (error_en) begin
                next_state = st_rx_end;
              end else begin
                next_state = st_datapkg;
              end
            end
            st_rx_end : begin
              if (skip_en) begin
                next_state = st_idle;
              end else begin
                next_state = st_rx_end;
              end
            end
            default : next_state = st_idle;

        endcase
      end
    
always @(posedge XGMII_CLK or negedge RST_N)begin
  if (!RST_N) begin
    skip_en <= 0;
    error_en <= 0;
    rx_done_t <= 0;
    cnt <= 0;
    s_circle_data <= 0;
    s_circle_data_valid <= 0;
    order_valid <= 0;
    task_id <= 8'h01;
    fpga_id <= 16'hc307;
    b_circle_amount <= 0;
    config_data <= 0;

  end else begin
    skip_en <= 0;
    error_en <= 0;
    rx_done_t <= 0;
    s_circle_data <= 0;
    s_circle_data_valid <= 0;
    order_valid <= 0;
    case(next_state)
      st_idle : begin
        cnt <= 0;
        if (LYBK_DP_VALID) begin
          order_type <= LYBK_DP[63:56];
          config_data <= LYBK_DP[55:0];
          skip_en <= 1;
        end
       end 
      st_datapkg : 
        if (order_type == 8'h01) begin   ////路由任务参数下发
            s_circle_data_valid <= LYBK_DP_VALID;
            s_circle_data <= LYBK_DP;
            task_id <= config_data[55:48];
            fpga_id <= config_data[47:32];
            b_circle_amount <= config_data[23:16];
            if (LYBK_DP_VALID) begin
                cnt <= cnt + 1;
                if (cnt == data_amount - 1) begin
                    skip_en <= 1;
                end 
            end else begin
                error_en <= 1;
            end 
        end else if (order_type == 8'h02) begin ///FPGA任务清除
             fpga_id <= config_data[55:40];
             skip_en <= 1;
             order_valid <= 1;
        end else if (order_type == 8'h03) begin ///清空多线程核
             skip_en <= 1;
             order_valid <= 1;
        end else if (order_type == 8'h04) begin ////机柜复位
             skip_en <= 1;
             order_valid <= 1;
        end else if (order_type == 8'h05) begin //状态查询
             skip_en <= 1;
             order_valid <= 1;
        end else begin
             error_en <= 1;
        end

        /*else if (order_type == 8'h06) begin ///同步测试          
            if (LYBK_DP_VALID) begin
                test_data_valid <= 1;
                work_mode <= config_data[7:0];
                cnt <= cnt + 1;
                sync_test_data <= LYBK_DP;
                if (cnt == 139) begin
                    skip_en <= 1;
                end
            end else begin
                error_en <= 1;
            end
        end */
       st_rx_end : 
         if (error_en) begin
           if (!LYBK_DP_VALID) begin
              error_en <= 0;
              skip_en <= 1;
           end
         end else begin
           if (LYBK_DP_VALID) begin
              error_en <= 1;
           end else begin
              error_en <= 0;
              skip_en <= 1;
              rx_done_t <= 1;
           end
         end

       
       default : ;
     endcase

    end
  end  

endmodule
