`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/11 14:50:37
// Design Name: 
// Module Name: native_ddr
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


   module WrDdr(
   input                ui_clk            ,//MIG用户接口时钟
   input                ui_rst            ,//MIG用户接口复位
   input                write_req         ,
   input                read_req          ,
   input     [511:0]    u_wdf_data        ,
   input                ui_rdy            ,//指令被接受标记
   input     [511:0]    ui_rd_data        ,//读数据
   input                ui_rd_data_valid  ,//读数据有效
   input                ui_wdf_rdy        ,//数据可写标记，表示MIG内部缓冲可以装下新的写数据
   input                c0_init_calib_complete,

   input     [11:0]     LENGTH,

   output               write_done        ,
   output               read_done         ,
   
   output               rd_fifo_en        ,
   output      [511:0]  u_rd_data         ,
   output               u_rd_valid        ,         
   output  reg [27:0]   ui_addr           ,//地址，每个地址对应DDR4物理层16位数据总线
   output      [2:0]    ui_cmd            ,//写指令3'b000，读指令3'b001
   output               ui_en             ,//指令有效标记
   output      [511:0]  ui_wdf_data       ,//写数据送给DDR的写入接口
   output               ui_wdf_end        ,//写数据结束，与ui_wdf_wren对齐
   output               ui_wdf_wren        //写数据有效标记           
       ); 
   
   localparam      DDR_LENGTH           = 268435440; //2^25 - 1       每次地址加8，ui_addr >> 3.
/*   localparam      LENGTH               = 12'd500;*/
   localparam      IDLE                 = 2'd0;       
   localparam      WRITE                = 2'd1;     
   localparam      WAIT                 = 2'd2;             
   localparam      READ                 = 2'd3;



 (*keep = "TRUE",mark_debug = "true"*)reg    [24:0]   rd_addr_cnt                ;//用户读地址计数
 (*keep = "TRUE",mark_debug = "true"*)reg    [24:0]   wr_addr_cnt                ;//用户写地址计数                       
 (*keep = "TRUE",mark_debug = "true"*)reg    [27:0]   ui_addr_w, ui_addr_r;
 (*keep = "TRUE",mark_debug = "true"*)reg    [1:0]    state;
// (*keep = "TRUE",mark_debug = "true"*)reg             write_req, read_req;
 (*keep = "TRUE",mark_debug = "true"*)reg             write_done, read_done;  
 (*keep = "TRUE",mark_debug = "true"*)reg             write_done_r,write_done_r1;
 (*keep = "TRUE",mark_debug = "true"*)reg             read_done_r,read_done_r1;
 (*keep = "TRUE",mark_debug = "true"*)wire            neg_write_done, neg_read_done;
                                      reg   [27:0]        st_ui_addr_w;
                                      reg   [27:0]        st_ui_addr_r;
         
 
                                
 
  assign ui_wdf_data = u_wdf_data;
  assign u_rd_data = ui_rd_data;
  assign u_rd_valid = ui_rd_data_valid;
 
// (*keep = "TRUE",mark_debug = "true"*)reg  [11:0]     LENGTH;
       
  assign rd_fifo_en = ui_wdf_wren;
  //在写状态MIG IP 命令接收和数据接收都准备好,或者在读状态命令接收准备好，此时拉高使能信号，
  assign ui_en = ((state == WRITE && (ui_rdy && ui_wdf_rdy))||(state == READ && ui_rdy)) ? 1'b1:1'b0;
  //在写状态,命令接收和数据接收都准备好，此时拉高写使能
  assign ui_wdf_wren = (state == WRITE && (ui_rdy && ui_wdf_rdy)) ? 1'b1:1'b0;
  //由于DDR3芯片时钟和用户时钟的分频选择4:1，突发长度为8，故两个信号相同
  assign ui_wdf_end = ui_wdf_wren;
  assign ui_cmd = (state == READ) ? 3'd1 :3'd0;
  

// 读写下一帧数据数据地址矫正
    always @(posedge ui_clk) begin
        if(ui_rst |~c0_init_calib_complete) begin
            write_done_r <= 0; 
            write_done_r1 <= 0;
        end
        else begin
            write_done_r <= write_done; 
            write_done_r1 <= write_done_r;
        end
    end 

    assign neg_write_done = (~write_done_r) & write_done_r1;

    always @(posedge ui_clk) begin
        if(ui_rst |~c0_init_calib_complete) begin
            read_done_r <= 0; 
            read_done_r1 <= 0;
        end
        else begin
            read_done_r <= read_done; 
            read_done_r1 <= read_done_r;
        end
    end 

    assign neg_read_done = (~read_done_r) & read_done_r1;

//DDR4读写逻辑实现

   always@(posedge ui_clk)
   begin  
     if(ui_rst |~c0_init_calib_complete)
       begin    
         wr_addr_cnt  <= 26'd0;      
         rd_addr_cnt  <= 26'd0;      
         ui_addr_w     <= 28'd0; 
         ui_addr_r  <= 28'd0;
         write_done <= 1'b0;
         read_done <= 1'b0;
         st_ui_addr_w <= 28'd0;
         st_ui_addr_r <= 28'd0;
         state <= IDLE;
       end
       else begin
            case(state)
            IDLE:begin 
                wr_addr_cnt  <= 26'd0;     
                rd_addr_cnt  <= 26'd0;      
                ui_addr_w    <= 28'd0;
                ui_addr_r    <= 28'd0;
                write_done <= 1'b0;
                read_done <= 1'b0;
                st_ui_addr_w <= 28'd0;
                st_ui_addr_r <= 28'd0;
                if(write_req) state <= WRITE;
                else if(read_req) state <= READ;
                else state <= IDLE;      
             end
             
            WRITE:begin
              if(ui_addr_w < DDR_LENGTH && (ui_rdy && ui_wdf_rdy)) begin
                  if((wr_addr_cnt == (LENGTH - 1)) &&(ui_rdy && ui_wdf_rdy)) begin                     //写到设定的长度跳到等待状态  
                    wr_addr_cnt  <= 0;
                    ui_addr_w     <= ui_addr_w;
                    st_ui_addr_w <= ui_addr_w;
                    write_done <= 1'b1;
                    state <= WAIT;
                  end
                   else if(ui_rdy && ui_wdf_rdy && (wr_addr_cnt < (LENGTH - 1))) begin   //写条件满足
                    wr_addr_cnt  <= wr_addr_cnt + 1'b1;   //写地址自加
                    ui_addr_w     <= ui_addr_w + 8;      //DDR3 地址加8
                   end
              end
              else if((~ui_rdy || ~ui_wdf_rdy) && (wr_addr_cnt < (LENGTH - 1))) begin
                    wr_addr_cnt  <= wr_addr_cnt;   //写地址自加
                    ui_addr_w    <= ui_addr_w;      //DDR3 地址加8
              end
              else if(ui_addr_w == DDR_LENGTH && (ui_rdy && ui_wdf_rdy) && (wr_addr_cnt < (LENGTH - 1))) begin
                    ui_addr_w <= 28'd0;
                    wr_addr_cnt  <= wr_addr_cnt + 1'b1;
              end  
              else if(ui_addr_w == DDR_LENGTH && (ui_rdy && ui_wdf_rdy) && (wr_addr_cnt == (LENGTH - 1))) begin
                    ui_addr_w <= 28'd0;
                    st_ui_addr_w <= ui_addr_w;
                    wr_addr_cnt  <= 0;
                    write_done <= 1'b1;
                    state <= WAIT;
              end
              else begin
                    wr_addr_cnt  <= wr_addr_cnt;   //写地址自加
                    ui_addr_w     <= ui_addr_w;      //DDR3 地址加8
                    st_ui_addr_w <= st_ui_addr_w;
              end
           end
             
          WAIT:begin                                                  
                wr_addr_cnt  <= 0;
                rd_addr_cnt <= 0;
                write_done <= 1'b0;
                read_done <= 1'b0;
                if(neg_write_done) begin
                    if(ui_addr_w == 28'd0 && st_ui_addr_w == DDR_LENGTH) begin ui_addr_w <= ui_addr_w; end
                    else begin ui_addr_w <= ui_addr_w + 8;end
                end
                else begin ui_addr_w <= ui_addr_w; end 
                
                if(neg_read_done) begin
                    if(ui_addr_r == 28'd0 && st_ui_addr_r == DDR_LENGTH) ui_addr_r <= ui_addr_r;
                    else  ui_addr_r <= ui_addr_r + 8; 
                end
                else ui_addr_r <= ui_addr_r;
//                if(neg_write_done && ui_addr_w == 28'd0) begin ui_addr_w <= ui_addr_w;end
//                else if(neg_write_done) begin ui_addr_w <= ui_addr_w + 8; end
//                if(neg_read_done && ui_addr_r == 28'd0) ui_addr_r <= ui_addr_r;
//                else if(neg_read_done) ui_addr_r <= ui_addr_r + 8;

                if(read_req) state <= READ;
                else if(write_req)  state <= WRITE;
                else state <= WAIT;
               end
               
            READ: begin                                  //读到设定的地址长度   
                if(ui_addr_r < DDR_LENGTH && ui_rdy) begin
                  if(rd_addr_cnt == (LENGTH - 1) && ui_rdy) begin                                           
                    rd_addr_cnt <= 0;
                    ui_addr_r <= ui_addr_r;
                    st_ui_addr_r <= ui_addr_r;
                    read_done <= 1'b1; 
                    state <= WAIT;
                  end
                  else if(ui_rdy && (rd_addr_cnt < (LENGTH - 1)))begin                   //若MIG已经准备好,则开始读
                    rd_addr_cnt <= rd_addr_cnt + 1'b1; //用户地址每次加一
                    ui_addr_r    <= ui_addr_r + 8;         //DDR3地址加8
                  end
                end
                else if(~ui_rdy && (rd_addr_cnt < (LENGTH - 1)))begin                   //若MIG已经准备好,则开始读
                    rd_addr_cnt <= rd_addr_cnt; //用户地址每次加一
                    ui_addr_r    <= ui_addr_r;         //DDR3地址加8
                end
                else if(ui_addr_r == DDR_LENGTH && (~ui_rdy))
                    ui_addr_r <= ui_addr_r;
                else if (ui_addr_r == DDR_LENGTH && (ui_rdy) &&  rd_addr_cnt < (LENGTH - 1)) begin
                    rd_addr_cnt <= rd_addr_cnt + 1'b1; //用户地址每次加一
                    ui_addr_r <= 28'd0;
                end
                else if (ui_addr_r == DDR_LENGTH && (ui_rdy) && rd_addr_cnt == (LENGTH - 1)) begin
                    rd_addr_cnt <= 26'd0; //用户地址每次加一
                    ui_addr_r <= 28'd0;
                    read_done <= 1'b1; 
                    st_ui_addr_r <= ui_addr_r;
                    state <= WAIT;
                end

                else begin
                    read_done <= read_done;                   //则跳到空闲状态                                                 
                    rd_addr_cnt <= rd_addr_cnt;
                    ui_addr_r <= ui_addr_r; 
                    st_ui_addr_r <= st_ui_addr_r;                   
                end
            end  
             
            default:begin
                    wr_addr_cnt  <= 26'd0;
                    rd_addr_cnt  <= 26'd0;
                    ui_addr_w    <= 28'd0;
                    ui_addr_r    <= 28'd0; 
                    st_ui_addr_w <= 28'd0;
                    st_ui_addr_r <= 28'd0;
                    write_done <= 1'b0;
                    read_done <= 1'b0;
            end         
         endcase
       end
    end 
       
     always @(*) begin
        if(ui_rst |~c0_init_calib_complete) 
            ui_addr = 0;
        else if(state ==  WRITE) 
            ui_addr = ui_addr_w;
        else if(state ==  READ)
            ui_addr = ui_addr_r;  
        else ui_addr = 0;    
     end 
        
endmodule
