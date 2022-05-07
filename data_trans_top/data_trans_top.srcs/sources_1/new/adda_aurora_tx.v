`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/07/27 17:52:54
// Design Name: 
// Module Name: awg_aurora_tx
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


module adda_aurora_tx(
      input         ddr_clk,
      input         aurora_clk,
      input         tx_en,//数据回传使能
      input         rst_n,
      input [7:0]   task_id,
      input [15:0]  ddr_adda_data,
      input         ddr_adda_dv,

      output   reg  ddr_rd_en,//读取ddr使能
      output   reg  adda_tx_done,//adda板卡数据包回传一次完成标志

      output [63:0]  aurora_data,
      output         aurora_dv     
    );
     
     reg  [31:0]  package_head = 32'h18efdc01;
     reg  [31:0]  package_tail = 32'h01dcef18;
     reg  [7:0]   order_type = 8'h02; //数据回传

     localparam IDLE =         6'b000_001;
     localparam HEAD =         6'b000_010;
     localparam CONFIG =       6'b000_100;
     localparam DATA_PACKAGE = 6'b001_000;
     localparam CHECK =        6'b010_000;
     localparam TAIL =         6'b100_000;

     reg [5:0] cur_state;
     reg [5:0] next_state;

     reg       skip_en;
     reg       rx_done_t;

     reg        data_package_dv;
     reg [15:0] data_package;
     reg [15:0] check_sum;

     reg [9:0] dp_cnt;//数据包计数器
     
        //(三段式状态机)同步时序描述状态转移
    always @(posedge ddr_clk or negedge rst_n)begin
    	if (!rst_n) begin
    		cur_state <= IDLE;
    	end else begin
    		cur_state <= next_state;
    	end
    end
//组合逻辑判断状态转移条件
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
            		next_state = CHECK;
            	end else begin
            		next_state = DATA_PACKAGE;
            	end
            end
            CHECK : begin
            	if (skip_en) begin
            		next_state = TAIL;
            	end else begin
            		next_state = CHECK;
            	end
            end
            TAIL : begin
            	if (skip_en) begin
            		next_state = IDLE;
            	end else begin
            		next_state = TAIL;
            	end
            end

            default : next_state = IDLE;
       endcase
    end

always @(posedge ddr_clk or negedge rst_n)begin
	if (!rst_n) begin
	    skip_en <= 0;
	    rx_done_t <= 0;
	    data_package <= 0;
        data_package_dv <= 0;
        dp_cnt <= 0;
        ddr_rd_en <= 0;
	end else begin
		skip_en <= 0;
		rx_done_t <= 0;
		data_package <= 0;
		ddr_rd_en <= 0;
        case(next_state)
        
         IDLE : begin
         	    if (tx_en) begin
         	     	skip_en <= 1;
         	     	data_package_dv <= 1;
         	     end 
         end
         HEAD : begin
         	    if (data_package_dv) begin
         	    	dp_cnt <= dp_cnt + 1;
         	    if (dp_cnt == 0) begin
         	    	data_package <= package_head[15:0];
         	    end else if (dp_cnt == 1) begin
         	    	data_package <= package_head[31:16];
         	    	dp_cnt <= 0;
         	    	skip_en <= 1;
         	    end
         	 end    
         end
         CONFIG : begin
         	    if (data_package_dv) begin
         	    	data_package <= {order_type,task_id};
         	    	ddr_rd_en <= 1;
         	    end 
         end
         DATA_PACKAGE : begin
         	    if (data_package_dv) begin
         	    	dp_cnt <= dp_cnt + 1;
         	        if (ddr_adda_dv && (dp_cnt >= 0)) begin
         	        	data_package <= ddr_adda_data;
         	        end else if ((dp_cnt == 729) || (ddr_adda_dv == 0)) begin //最大字节1472
         	        	dp_cnt <= 0;
         	        	skip_en <= 1;
         	        end
         	    end
         end
         CHECK : begin
         	    if (data_package_dv) begin
         	    	data_package <= check_sum;//校验和
         	    	skip_en <= 1;
         	    end
         end
         TAIL : begin
         	    if (data_package_dv) begin
         	    	dp_cnt <= dp_cnt + 1;
         	    	if (dp_cnt == 0) begin
         	    		data_package <= package_tail[15:0];
         	    	end else if (dp_cnt == 1) begin
         	    		data_package <= package_tail[31:16];
         	    		data_package_dv <= 0;
         	    	end
         	    end else begin
         	        dp_cnt <= 0;
         	    	skip_en <= 1;
         	    	rx_done_t <=1;
         	    end
         end
         default : ;
         endcase
	end
end
////////////////////校验和//////////////////////////////
reg [31:0] sum_r = 0;
reg [31:0] sum_t ; 


always @(*)begin
    check_sum <= ~(sum_t[15:0] + sum_t[31:16]);
    sum_t <= sum_r + package_head[15:0] + package_head[31:16] + order_type +
           task_id + package_tail[15:0] + package_tail[31:16];
     if (data_package_dv && next_state == DATA_PACKAGE) begin
     	sum_r <= data_package + sum_r;
     end  else if (rx_done_t) begin
     	sum_r <= 0;
     end
end

///////////////////////////////////////////////////////



always @(posedge ddr_clk or negedge rst_n)begin
	   if (!rst_n) begin
	   	  adda_tx_done <= 0;
	   end else begin
	   	  adda_tx_done <= rx_done_t;
	   end
end

ddr_aurora_fifo ddr_aurora_fifo_inst(
        .ddr_clk(ddr_clk),
        .aurora_clk(aurora_clk),
        .rst(~rst_n),
        .ddr_data(data_package),
        .ddr_dv(data_package_dv),

        .aurora_data(aurora_data),
        .aurora_dv(aurora_dv)
    );
 
endmodule
