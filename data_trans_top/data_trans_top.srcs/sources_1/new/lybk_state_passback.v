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
       input [7:0]  ORDER_TYPE,//指令类型
       input        ORDER_VALID,

       input [7:0]  TASK_ID,//任务ID(路由数据包内)
       input [FPGA_AMOUNT -1:0] FPGA_ID,//FPGA掩码(路由数据包内)
       input [7:0]  B_CIRCLE_AMOUNT,//大循环数量
       input        LYBK_RX_DONE,//路由数据包接收完毕
/*       input        RESET_DONE,//复位完成 */   
/////////////////////////////////////////////
       output       XGMII_TXDV,
       output[63:0] XGMII_TXD

    );
      reg [63:0]   state_data = 0;//状态数据
      reg [63:0]   order_state_data = 0;//指令状态数据
      reg [63:0]   task_set_state_data = 0;//任务配置状态数据
      
      reg          order_state_valid = 0;
      reg          task_set_state_valid = 0;

      assign XGMII_TXDV = xgmii_txdv;
      assign XGMII_TXD = xgmii_txd;
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
             default : begin
                    order_state_valid <= 0;
             end
            endcase 
        end 

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
                  end 
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
                     xgmii_txd[39:8] <= datapackge_l + 3;//包含帧头、参数和帧尾
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

