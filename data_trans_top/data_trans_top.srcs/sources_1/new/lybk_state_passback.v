`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/02 11:04:48
// Design Name: 
// Module Name: lybk_state_passback
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 状态回传
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lybk_state_passback#(
     parameter FPGA_AMOUNT = 16
	)(
       input        XGMII_CLK,//万兆网时钟
       input [FPGA_AMOUNT-1:0] READY_STATE,//全任务就绪状态
       input [7:0]  ORDER_TYPE,//指令类型
       input        ORDER_VALID,
////////////////数据加载失败/////////////////////
/*       input        XGMII_DATA_ERROR,
       input        BK_DATA_ERROR,
       input        TASK_SEND_ERROR,    
       input [4:0]  READY_ERROR,//就绪错误(就绪失败)
       input [4:0]  TRIGGER_SUCCESS,//中控触发成功
       input [4:0]  TRIGGER_FAILURE,//中控触发失败*/

       input [7:0]  TASK_ID,//任务ID(路由数据包内)
       input [FPGA_AMOUNT -1:0] FPGA_ID,//FPGA掩码(路由数据包内)
       input [7:0]  B_CIRCLE_AMOUNT,//大循环数量
       input        LYBK_RX_DONE,//路由数据包接收完毕
       input        RESET_DONE,//复位完成    
/////////////////////////////////////////////
       output       XGMII_TXDV,
       output[63:0] XGMII_TXD,
       output       TX_DONE

    );
      reg [63:0]   state_data = 0;//状态数据
      reg [63:0]   order_state_data = 0;//指令状态数据
      reg [63:0]   task_set_state_data = 0;//任务配置状态数据
      
      reg          order_state_valid = 0;
      reg          task_set_state_valid = 0;

      wire [FPGA_AMOUNT-1:0] ready_state;
      
      assign ready_state = READY_STATE; /*>> FPGA_AMOUNT*(TASK_ID-1);*/

      assign XGMII_TXDV = xgmii_txdv;
      assign XGMII_TXD = xgmii_txd;
      assign TX_DONE = tx_done_t;
//////////////////////根据下发指令回传///////////////////////////////////////////
      always @(posedge XGMII_CLK)
         begin
        	case(ORDER_TYPE)                         ////路由参数回传
             8'h01 : 
             begin
               if(LYBK_RX_DONE)begin
        	     order_state_valid <= 1 ;
        	     order_state_data[63:56] <= ORDER_TYPE;
        	     order_state_data[55:48] <= TASK_ID;
        	     order_state_data[47:32] <= FPGA_ID;
        	     order_state_data[31:24] <= B_CIRCLE_AMOUNT;
               order_state_data[23:0] <= 0;
        	   end else begin
               order_state_valid <= 0;
             end               	
            end
             8'h02 :                              ///清空下层FPGA状态回传
             begin
               if (ORDER_VALID) begin
               	  order_state_data[63:56] <= ORDER_TYPE;
                  order_state_data[55:40] <= FPGA_ID;
                  order_state_data[39:0] <= 0;
               end else if(RESET_DONE)begin
             	    order_state_valid <= 1;
             	   end else begin
                   order_state_valid <= 0;
                end
             end
             8'h03 :                              ////清空多线程核状态回传
             begin
               if (ORDER_VALID) begin
               	  order_state_data[63:56] <= ORDER_TYPE;
             	    order_state_data[55:0] <= 0;
                 end else if(RESET_DONE)begin
             	    order_state_valid <= 1;
             	  end else begin
                   order_state_valid <= 0;
                end
             end
             8'h04 :                              ////机柜复位状态回传
             begin
                if (ORDER_VALID) begin
                  order_state_data[63:56] <= ORDER_TYPE;
                  order_state_data[55:0] <= 0;
                end else if (RESET_DONE) begin
             		  order_state_valid <= 1;
              	end else begin
                   order_state_valid <= 0;
                end
             end
            /* 8'h05 :                             ////同步测试
             begin
                if (ORDER_VALID) begin
                  order_state_data[7:0] <= ORDER_TYPE;
                  order_state_data[15:8] <= TASK_ID;
                  order_state_data[31:16] <= READY_STATE;
                  order_state_data[63:32] <= 0;
                  order_state_valid <= 1;
                end else begin
                  order_state_valid <= 0;
                end
             end*/

             default : begin
             	    order_state_valid <= 0;
             end
        	endcase 
        end 
/////////////////////任务首次配置状态回传/////////////////////////////////////
 /*    reg          xgmii_data_error_r;//万兆网下发错误
     reg          bk_data_error_r;//板卡数据错误
     reg          task_send_error_r;//任务下发错误
     
     wire         xgmii_data_error;
     wire         bk_data_error;
     wire         task_send_error;
     wire         data_load_error;//数据加载错误
///////取一个时钟周期有效
     assign xgmii_data_error = (~xgmii_data_error_r)&XGMII_DATA_ERROR ;
     assign bk_data_error = (~bk_data_error_r)&BK_DATA_ERROR;
     assign task_send_error = (~task_send_error_r)&TASK_SEND_ERROR ; 
     
     assign data_load_error = xgmii_data_error | bk_data_error | task_send_error ;//数据加载错误

     always @(posedge XGMII_CLK)begin
        xgmii_data_error_r <= XGMII_DATA_ERROR;
        bk_data_error_r <= BK_DATA_ERROR;
        task_send_error_r <= TASK_SEND_ERROR;
     end
                     ///////////////////加载错误
     always @(posedge XGMII_CLK)   
        if (data_load_error) begin
        	task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= TASK_ID;
        	task_set_state_data[31:16] <= ready_state;
        	task_set_state_data[39:32] <= 8'd3;
        	task_set_state_valid <= 1;
        end
                    ///////////////////状态码
     always @(posedge XGMII_CLK)
        if (!READY_ERROR) begin
        	    task_set_state_data[39:32] <= 8'd2;
        	end else if (!TRIGGER_FAILURE) begin
        		task_set_state_data[39:32] <= 8'd1;
        	end else if (!TRIGGER_SUCCESS) begin
        		task_set_state_data[39:32] <= 8'd0;
        	end   
                    //////////////////就绪触发错误
     always @(posedge XGMII_CLK)begin
     	case(READY_ERROR | TRIGGER_FAILURE | TRIGGER_SUCCESS)
     	5'b00001: begin
     		task_set_state_valid <= 1;
     		task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= 1;
        	task_set_state_data[31:16] <= READY_STATE[14:0];
     	end
     	5'b00010: begin
     		task_set_state_valid <= 1;
     		task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= 2;
        	task_set_state_data[31:16] <= READY_STATE[29:15];
     	end
     	5'b00100: begin
     		task_set_state_valid <= 1;
     		task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= 3;
        	task_set_state_data[31:16] <= READY_STATE[44:30];
     	end
     	5'b01000: begin
     		task_set_state_valid <= 1;
     		task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= 4;
        	task_set_state_data[31:16] <= READY_STATE[59:45];
     	end
     	5'b10000: begin
     		task_set_state_valid <= 1;
     		task_set_state_data[7:0] <= 8'h06;
        	task_set_state_data[15:8] <= 5;
        	task_set_state_data[31:16] <= READY_STATE[74:60];
     	end
     	endcase
     end
*/
///////////////////////回传数据打包////////////////////////////////////
     reg  [63:0]  package_head = 64'h18efdc0118efdc01;
     reg  [63:0]  package_tail = 64'h01dcef1801dcef18;
     reg  [31:0]  datapackge_l = 1;//数据包长度

     parameter IDLE =         6'b000001;
     parameter HEAD =         6'b000010;
     parameter CONFIG =       6'b000100;
     parameter DATA_PACKAGE = 6'b001000;
     parameter TAIL =         6'b010000;
     parameter TX_END =       6'b100000;
    
     reg  [5:0]   cur_state;
     reg  [5:0]   next_state;

     reg          skip_en = 0;
     reg          tx_done_t = 0;
     reg          xgmii_txdv = 0;
     reg  [63:0]  xgmii_txd = 0;
     reg  [5:0]   data_cnt = 0;

     wire [63:0] data_passback;

     reg  [7:0]   machine_id = 1;//机箱编号


     assign data_passback = state_data;

/*     always @(*)begin
       if (ORDER_TYPE == 8'h05) begin
           datapackge_l <= 31;
       end else begin
           datapackge_l <= 1;
       end
     end*/
     

     always @(posedge XGMII_CLK )
         begin
             cur_state <= next_state;
         end
    
     always @(*)begin
        next_state = IDLE;
        case(cur_state)
            IDLE : begin
              if (skip_en) begin
                next_state = HEAD;
              end else begin
                next_state = IDLE;
              end
            end
            HEAD : begin
              if (skip_en) begin
                next_state = CONFIG;
              end else begin
                next_state = HEAD;
              end
            end
            CONFIG : begin
              if (skip_en) begin
                next_state = DATA_PACKAGE;
              end else begin
                next_state = CONFIG;
              end
            end
            DATA_PACKAGE : begin
              if (skip_en) begin
                next_state = TAIL;
              end else begin
                next_state = DATA_PACKAGE;
              end
            end
            TAIL : begin
              if (skip_en) begin
                next_state = TX_END;
              end else begin
                next_state = TAIL;
              end
            end
            TX_END : begin
               if (skip_en) begin
                 next_state = IDLE;
               end else begin
                 next_state = TX_END;
               end
            end

            default : next_state = IDLE;
        endcase
     end

      always @(posedge XGMII_CLK)
        begin
            skip_en <= 0;
            tx_done_t <= 0;
            data_cnt <= 0;
            case(next_state)
             
             IDLE : begin
                  if (order_state_valid) begin
                       skip_en <= 1;
                       state_data <= order_state_data;
                  end  /*else if (task_set_state_valid) begin
                       skip_en <= 1;
                       task_set_state_valid <= 0;
                       state_data <= task_set_state_data;
                  end */
             end
             HEAD : begin
                      xgmii_txd <= package_head;
                      skip_en <= 1;
                      xgmii_txdv <= 1;
                  
             end
             CONFIG : begin
                  if (xgmii_txdv) begin
                     xgmii_txd[63:56] <= order_state_data[55:48];//任务ID
                     xgmii_txd[55:48] <= state_data[63:56];//指令类型
                     xgmii_txd[47:40] <= machine_id;//机箱编号
                     xgmii_txd[39:8] <= datapackge_l + 3;//包含帧头和帧尾
                     xgmii_txd[7:0] <= 'd0;
                     skip_en <= 1;
                  end
             end
             DATA_PACKAGE : begin
                  if (xgmii_txdv) begin
                     data_cnt <= data_cnt + 1;
                     xgmii_txd <= data_passback;
                     if (data_cnt == datapackge_l - 1) begin
                       skip_en <= 1;
                     end
                  end
             end
             TAIL : begin
                 if (xgmii_txdv) begin
                     xgmii_txd <= package_tail;
                     skip_en <= 1;
                 end
             end
             TX_END : begin
                     xgmii_txdv <= 0;
                     xgmii_txd <= 0;
                     tx_done_t <= 1;
                     skip_en <= 1;                
             end
             default : ;
            endcase
        end
/////////////////////////////////////////////////////////


endmodule

