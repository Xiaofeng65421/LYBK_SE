`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/30 16:15:37
// Design Name: 
// Module Name: lybk_xgmii_unpack
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


module lybk_xgmii_unpack(
   (* MARK_DEBUG="true" *) input  [63:0]   XGMII_RXD,
   (* MARK_DEBUG="true" *) input           XGMII_RXDV,
    input           XGMII_CLK,
    input           RST_N,

    output          ERROR,//错误反馈
    output          RX_DONE,//接收完成

    output [7:0]    FPGA_ID,//FPGA编号
    output [63:0]   LYBK_DATAPKG,//路由板卡数据包
    output [63:0]   FPGA_DATAPKG,//FPGA数据包
    output          LYBK_DATAPKG_VALID,//路由数据包有效
    output          FPGA_DATAPKG_VALID//FPGA数据包有效

    );
    
    localparam   st_idle    = 4'b0001;
    localparam   st_config  = 4'b0010;
    localparam   st_datapkg = 4'b0100;
    localparam   st_rx_end  = 4'b1000;

(* MARK_DEBUG="true" *)    reg    [3:0]  cur_state;
(* MARK_DEBUG="true" *)    reg    [3:0]  next_state;
(* MARK_DEBUG="true" *)    reg    [31:0]  data_cnt = 0;
(* MARK_DEBUG="true" *)    reg           skip_en = 0;
(* MARK_DEBUG="true" *)    reg           error_en = 0;
(* MARK_DEBUG="true" *)    reg           rx_done_t = 0;

    reg   [7:0]  task_id;
 (* MARK_DEBUG="true" *)   reg   [7:0]  order_type = 0;
    reg   [7:0]  fpga_id;
(* MARK_DEBUG="true" *)    reg   [31:0] dpkg_l = 10;//数据包长度
    reg   [63:0] datapkg;//数据包数据
 (* MARK_DEBUG="true" *)   reg          data_valid;

   assign LYBK_DATAPKG = (data_valid)?(order_type == 8'h00)? datapkg : 0 : 0;
   assign FPGA_DATAPKG = (data_valid)?(order_type == 8'h01)? datapkg : 0 : 0;
   assign LYBK_DATAPKG_VALID =(order_type == 8'h00)? data_valid : 0;
   assign FPGA_DATAPKG_VALID =(order_type == 8'h01)? data_valid : 0;
   assign RX_DONE = rx_done_t;
   assign ERROR = error_en;
   assign FPGA_ID = (order_type == 8'h01)? fpga_id : 0;

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
      begin
        case(cur_state)
            st_idle : begin
                if (skip_en) begin
                    next_state = st_config;
                end else begin
                    next_state = st_idle;
                end
            end
            st_config : begin
                if (skip_en) begin
                    next_state = st_datapkg;
                end else if (error_en) begin
                    next_state = st_rx_end;
                end else begin
                    next_state = st_config;
                end
            end
            st_datapkg : begin
                if (skip_en) begin
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

    end
always @(posedge XGMII_CLK or negedge RST_N)begin
    if (!RST_N) begin
        skip_en <= 0;
        error_en <= 0;
        rx_done_t <= 0;
        data_cnt <= 0;
        task_id <= 0;
        fpga_id <= 0;
        order_type <= 0;
        dpkg_l <= 10;
        datapkg <= 0;
        data_valid <= 0;

    end else begin
        skip_en <= 0;
        rx_done_t <= 0;
        datapkg <= 0;
        data_valid <= 0;
        case(next_state)
        st_idle :  begin
            data_cnt <= 0;
            if (XGMII_RXDV) 
                if (XGMII_RXD == 64'h18efdc0118efdc01)begin 
                    skip_en <= 1;
                    error_en <= 0;
                end else begin 
                    error_en <= 1;
                end    
        end 
        st_config : 
            if (XGMII_RXDV) begin
                task_id <= XGMII_RXD[63:56];
                order_type <= XGMII_RXD[55:48];
                fpga_id <= XGMII_RXD[47:40];
                dpkg_l <=  XGMII_RXD[39:8];
                skip_en <= 1;
                error_en <= 0;
            end else 
                error_en <= 1;

        st_datapkg : begin
              datapkg <= XGMII_RXD;
              data_valid <= XGMII_RXDV;
            if (XGMII_RXDV) begin
                data_cnt <= data_cnt + 1;
                 if (data_cnt == dpkg_l - 1) begin
                    skip_en <= 1;
                 end
               end  
            end
        st_rx_end : 
            if (error_en) begin
                if (XGMII_RXDV && (XGMII_RXD == 64'h01dcef1801dcef18)) begin
                    skip_en <= 1;
                    error_en <= 0;
                end
            end else begin
                if (XGMII_RXDV) begin
                  if (XGMII_RXD == 64'h01dcef1801dcef18) begin
                      skip_en <= 1;
                      error_en <= 0;
                      rx_done_t <= 1;
                  end else begin
                      error_en <= 1;
                  end
                    
                end 
            end
        default : ;          
        endcase
    end  
  end
   
 ////////////////////////////////////////////////////////////


endmodule
