`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/09/08 15:23:24
// Design Name: 
// Module Name: adda_aurora_unpack
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


module adda_aurora_unpack(
          input    AURORA_CLK,
          input    RST_N,
          input         ADDA_AURORA_VALID,
          input  [63:0] ADDA_AURORA_RXD,

          output [7:0]  TASK_ID,//任务ID
          output [23:0] WORK_ID,//工作单元编号
          output [7:0]  WORK_AMOUNT,//工作单元数量          
          
          output [7:0]  B_CIRCLE_AMOUNT,//大循环数量
          output [7:0]  WORK_MODE,//工作模式
          output [15:0] B_CIRCLE_DPL,//大循环数据包长度
          output [159:0] B_CIRCLE_ADDRESS,//大循环首地址
          output        B_CIRCLE_SEARCH_VALID,//大循环检索有效
          output [63:0] B_CIRCLE_PACKAGE,//大循环数据包
          output        B_CIRCLE_PACKAGE_VALID,//大循环数据包有效

          output [7:0]   PARAMETER_AMOUNT,//参数类型数量
          output [63:0]  PARAMETER_PACKAGE,//参数数据包
          output         PARAMETER_PACKAGE_VALID,//参数数据包有效  

          output         ERROR,
          output         RX_DONE
    );

        reg [7:0]  order_type;//指令类型
        reg [7:0]  task_id;//任务ID
        reg [23:0] work_id;//工作单元编号
        reg [7:0]  work_amount;//工作单元数量
        
        reg [7:0]  data_package_amount;//数据包数量
        reg [7:0]  work_mode;
        reg [31:0] data_package_length;//数据包长度 
        reg [159:0] data_head_address;//首地址 
        reg        search_valid = 0;//检索数据有效         
        reg [63:0] data_package;//数据包
        reg        data_package_valid = 0;//数据包有效

        reg        adda_aurora_valid_pre;

        reg [5:0] cnt = 0;
        reg [31:0] data_cnt = 0; 

        localparam   st_config = 4'b0001;
        localparam   st_search = 4'b0010;
        localparam   st_data   = 4'b0100;
        localparam   st_rx_end = 4'b1000;   

        reg  [3:0]  cur_state;
        reg  [3:0]  next_state;

        reg         skip_en = 0;
        reg         error_en = 0;
        reg         rx_done_t = 0; //数据包接收完成标志    
        
        assign TASK_ID = task_id;
        assign WORK_ID = work_id;
        assign WORK_AMOUNT = work_amount;
        assign WORK_MODE = work_mode ;

        assign B_CIRCLE_ADDRESS = data_head_address;
        assign B_CIRCLE_DPL = data_package_length;
        assign B_CIRCLE_SEARCH_VALID = search_valid;
        assign B_CIRCLE_AMOUNT =(order_type == 8'h01)? data_package_amount : 0;        
        assign B_CIRCLE_PACKAGE =(order_type == 8'h01)?data_package : 0;
        assign B_CIRCLE_PACKAGE_VALID =(order_type == 8'h01)?data_package_valid : 0;

        assign PARAMETER_AMOUNT = (order_type == 8'h02)?data_package_amount : 0;
        assign PARAMETER_PACKAGE = (order_type == 8'h02)?data_package : 0;
        assign PARAMETER_PACKAGE_VALID = (order_type == 8'h02)?data_package_valid : 0;

        assign ERROR = error_en;
        assign RX_DONE = rx_done_t;

////////////////////////////////////////////////////////////
    always @(posedge AURORA_CLK)
       adda_aurora_valid_pre <= ADDA_AURORA_VALID;

     
    always @(posedge AURORA_CLK or negedge RST_N)begin
    	if (!RST_N) begin
    		cur_state <= st_config;
    	end else begin
    		cur_state <= next_state;
    	end
    end

    always @(*)begin
    	next_state = st_config;
    	case(cur_state)
    	    st_config : begin
            	if (skip_en) begin
            		next_state = st_search;
            	end else begin
            		next_state = st_config;
            	end
            end
            st_search : begin
                if (order_type == 8'h02) begin  //默认参数配置没有参数索引
                    next_state = st_data;
                end else if (skip_en) begin
                    next_state = st_data;
                end else if (error_en) begin
                    next_state = st_rx_end;
                end else begin
                    next_state = st_search;
                end
            end
            st_data : begin
            	if (skip_en) begin
            		next_state = st_rx_end;
            	end else if (error_en) begin
                    next_state = st_rx_end;
                end else begin
            		next_state = st_data;
            	end
            end
            st_rx_end : begin
            	if (skip_en) begin
            		next_state = st_config;
            	end else begin
            		next_state = st_rx_end;
            	end
            end
            default : next_state = st_config;
       endcase
    end   
    
always @(posedge AURORA_CLK or negedge RST_N)begin
	if (!RST_N) begin
        skip_en <= 0;
        error_en <= 0;
        rx_done_t <= 0;

        search_valid <= 0;//检索数据有效  
        data_head_address <= 0;//大循环数据首地址
        data_package_length <= 0;//大循环数据包长度        
        data_package <= 0;//数据包
        data_package_valid <= 0;//数据包有效
        data_package_amount <= 0;//数据包数量
        
        order_type <= 0;//指令类型
        task_id <= 0;
        work_id <= 0;
        work_amount <= 0;//任务类型

        cnt <= 0;
        data_cnt <= 0;
 
    end else begin
    	skip_en <= 0;
        error_en <= 0;
    	rx_done_t <= 0;
        search_valid <= 0;
        data_package_valid <= 0;
        data_package <= 0;
        cnt <= 0;
        data_cnt <= 0;
        case(next_state) 
        st_config : begin
        	if (ADDA_AURORA_VALID) begin
        		order_type <= ADDA_AURORA_RXD[7:0];
        		task_id <= ADDA_AURORA_RXD[15:8];
        		work_id <= ADDA_AURORA_RXD[39:16];
        		data_package_amount <= ADDA_AURORA_RXD[47:40];
                work_mode <= ADDA_AURORA_RXD[55:48];
                work_amount <= ADDA_AURORA_RXD[63:56];
                skip_en <= 1;
        	end
        end

        st_search : begin
        	if (ADDA_AURORA_VALID) begin
        		cnt <= cnt + 1;
                if (cnt == 0) begin
                data_package_length <= ADDA_AURORA_RXD[15:0];
                data_head_address[47:0] <= ADDA_AURORA_RXD[63:16];
                end else if (cnt == 1) begin
                data_head_address[111:48] <= ADDA_AURORA_RXD[63:0];    
                end else if (cnt == 2) begin
                data_head_address[159:112] <= ADDA_AURORA_RXD[47:0];
                search_valid <= 1;
                skip_en <= 1;
                end
        	end else begin
        		error_en <= 1;
        	end
        end

        st_data : begin
          if(order_type == 8'h01)begin
        		data_package_valid <= 1;
        		data_package <= ADDA_AURORA_RXD;
                data_cnt <= data_cnt + 1;
                if (data_cnt == data_package_length) begin
                    if (adda_aurora_valid_pre) begin
                     skip_en <= 1;
                     data_package_valid <= 0;    
                    end else begin
                        error_en <= 1;
                    end
                end 
          end else if (order_type == 8'h02) begin
                if (ADDA_AURORA_VALID)begin
                data_cnt <= data_cnt + 1; 
                data_package_valid <= 1;
                data_package <= ADDA_AURORA_RXD; 
              end else begin
                skip_en <= 1;
                data_package_valid <= 0;
              end  
           end
        end

        st_rx_end : begin
        	if (ADDA_AURORA_VALID) begin
        		error_en <= 1;
        	end else begin
        		skip_en <= 1;
        		rx_done_t <= 1;
        	end
        end

        default : ;
        endcase
  end 
end

endmodule
