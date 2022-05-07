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
   input                ui_clk            ,//MIG�û��ӿ�ʱ��
   input                ui_rst            ,//MIG�û��ӿڸ�λ
   input                write_req         ,
   input                read_req          ,
   input     [511:0]    u_wdf_data        ,
   input                ui_rdy            ,//ָ����ܱ��
   input     [511:0]    ui_rd_data        ,//������
   input                ui_rd_data_valid  ,//��������Ч
   input                ui_wdf_rdy        ,//���ݿ�д��ǣ���ʾMIG�ڲ��������װ���µ�д����
   input                c0_init_calib_complete,

   input     [11:0]     LENGTH,

   output               write_done        ,
   output               read_done         ,
   
   output               rd_fifo_en        ,
   output      [511:0]  u_rd_data         ,
   output               u_rd_valid        ,         
   output  reg [27:0]   ui_addr           ,//��ַ��ÿ����ַ��ӦDDR4�����16λ��������
   output      [2:0]    ui_cmd            ,//дָ��3'b000����ָ��3'b001
   output               ui_en             ,//ָ����Ч���
   output      [511:0]  ui_wdf_data       ,//д�����͸�DDR��д��ӿ�
   output               ui_wdf_end        ,//д���ݽ�������ui_wdf_wren����
   output               ui_wdf_wren        //д������Ч���           
       ); 
   
   localparam      DDR_LENGTH           = 268435440; //2^25 - 1       ÿ�ε�ַ��8��ui_addr >> 3.
/*   localparam      LENGTH               = 12'd500;*/
   localparam      IDLE                 = 2'd0;       
   localparam      WRITE                = 2'd1;     
   localparam      WAIT                 = 2'd2;             
   localparam      READ                 = 2'd3;



 (*keep = "TRUE",mark_debug = "true"*)reg    [24:0]   rd_addr_cnt                ;//�û�����ַ����
 (*keep = "TRUE",mark_debug = "true"*)reg    [24:0]   wr_addr_cnt                ;//�û�д��ַ����                       
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
  //��д״̬MIG IP ������պ����ݽ��ն�׼����,�����ڶ�״̬�������׼���ã���ʱ����ʹ���źţ�
  assign ui_en = ((state == WRITE && (ui_rdy && ui_wdf_rdy))||(state == READ && ui_rdy)) ? 1'b1:1'b0;
  //��д״̬,������պ����ݽ��ն�׼���ã���ʱ����дʹ��
  assign ui_wdf_wren = (state == WRITE && (ui_rdy && ui_wdf_rdy)) ? 1'b1:1'b0;
  //����DDR3оƬʱ�Ӻ��û�ʱ�ӵķ�Ƶѡ��4:1��ͻ������Ϊ8���������ź���ͬ
  assign ui_wdf_end = ui_wdf_wren;
  assign ui_cmd = (state == READ) ? 3'd1 :3'd0;
  

// ��д��һ֡�������ݵ�ַ����
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

//DDR4��д�߼�ʵ��

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
                  if((wr_addr_cnt == (LENGTH - 1)) &&(ui_rdy && ui_wdf_rdy)) begin                     //д���趨�ĳ��������ȴ�״̬  
                    wr_addr_cnt  <= 0;
                    ui_addr_w     <= ui_addr_w;
                    st_ui_addr_w <= ui_addr_w;
                    write_done <= 1'b1;
                    state <= WAIT;
                  end
                   else if(ui_rdy && ui_wdf_rdy && (wr_addr_cnt < (LENGTH - 1))) begin   //д��������
                    wr_addr_cnt  <= wr_addr_cnt + 1'b1;   //д��ַ�Լ�
                    ui_addr_w     <= ui_addr_w + 8;      //DDR3 ��ַ��8
                   end
              end
              else if((~ui_rdy || ~ui_wdf_rdy) && (wr_addr_cnt < (LENGTH - 1))) begin
                    wr_addr_cnt  <= wr_addr_cnt;   //д��ַ�Լ�
                    ui_addr_w    <= ui_addr_w;      //DDR3 ��ַ��8
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
                    wr_addr_cnt  <= wr_addr_cnt;   //д��ַ�Լ�
                    ui_addr_w     <= ui_addr_w;      //DDR3 ��ַ��8
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
               
            READ: begin                                  //�����趨�ĵ�ַ����   
                if(ui_addr_r < DDR_LENGTH && ui_rdy) begin
                  if(rd_addr_cnt == (LENGTH - 1) && ui_rdy) begin                                           
                    rd_addr_cnt <= 0;
                    ui_addr_r <= ui_addr_r;
                    st_ui_addr_r <= ui_addr_r;
                    read_done <= 1'b1; 
                    state <= WAIT;
                  end
                  else if(ui_rdy && (rd_addr_cnt < (LENGTH - 1)))begin                   //��MIG�Ѿ�׼����,��ʼ��
                    rd_addr_cnt <= rd_addr_cnt + 1'b1; //�û���ַÿ�μ�һ
                    ui_addr_r    <= ui_addr_r + 8;         //DDR3��ַ��8
                  end
                end
                else if(~ui_rdy && (rd_addr_cnt < (LENGTH - 1)))begin                   //��MIG�Ѿ�׼����,��ʼ��
                    rd_addr_cnt <= rd_addr_cnt; //�û���ַÿ�μ�һ
                    ui_addr_r    <= ui_addr_r;         //DDR3��ַ��8
                end
                else if(ui_addr_r == DDR_LENGTH && (~ui_rdy))
                    ui_addr_r <= ui_addr_r;
                else if (ui_addr_r == DDR_LENGTH && (ui_rdy) &&  rd_addr_cnt < (LENGTH - 1)) begin
                    rd_addr_cnt <= rd_addr_cnt + 1'b1; //�û���ַÿ�μ�һ
                    ui_addr_r <= 28'd0;
                end
                else if (ui_addr_r == DDR_LENGTH && (ui_rdy) && rd_addr_cnt == (LENGTH - 1)) begin
                    rd_addr_cnt <= 26'd0; //�û���ַÿ�μ�һ
                    ui_addr_r <= 28'd0;
                    read_done <= 1'b1; 
                    st_ui_addr_r <= ui_addr_r;
                    state <= WAIT;
                end

                else begin
                    read_done <= read_done;                   //����������״̬                                                 
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
