`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/08/18 16:02:54
// Design Name: 
// Module Name: lybk_trigger_create
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


module lybk_trigger_create#(
    parameter  FPGA_NUM = 16,
    parameter  TRIGGER_L = 10, //100ns
    parameter  FPGA_MASK_init = 16'hC307,
    parameter  TASK_ID_init   = 8'h00  
  )(
       input         DATA_CLK,
       input         TRIGGER_CLK,//7044 100M 
       input         RST_N,
       input         S_CIRCLE_DATA_VALID,
       input  [7:0]  ZKBK_TASK_ID,
       input         ZKBK_TRIGGER,

       input  [7:0]  B_CIRCLE_AMOUNT,
       input  [7:0]  TASK_ID_in,
       input  [FPGA_NUM-1:0] FPGA_ID_in,
       input  [63:0] S_CIRCLE_DATA,

  (* MARK_DEBUG="true" *)    output        IDLE,
       output        TRIGGER,
       output        TRIGGER_VALID,
       output [7:0]  TASK_ID_out,
       output [FPGA_NUM-1:0] FPGA_ID_out,
       output [3:0]  B_CIRCLE_ID,
       output [31:0] PASSBACK_LENGTH,
       output        PASSBACK_LENGTH_VALID,

       output        ZKBK_TRIGGER_RESPOND,
       
       output        TASK_FINIFH,
       output        S_CIRCLE_FINISH 

);

       wire         rst_n;
       reg   [7:0]  task_id_reg = TASK_ID_init;
       reg   [FPGA_NUM-1:0] fpga_id_reg = FPGA_MASK_init;
       reg   [7:0]  b_circle_amount = 8'd10;
       reg          idle = 1;

       reg    [6:0]  wr_addr = 0;
       wire   [6:0]  wr_addr_max;
       reg    [6:0]  rd_addr = 0;
       wire   [6:0]  rd_addr_max;
       reg           rd_en = 0;
       reg           rd_en_pre1 = 0;
       reg           rd_en_pre2 = 0;
       reg           rd_en_pre3 = 0;
       wire   [63:0] rd_data;

       reg          trigger_en = 0;
       reg   [15:0] trigger_delay_cnt = 0; 
       reg   [15:0] trigger_times_cnt = 0;
   (* MARK_DEBUG="true" *)    reg   [15:0] s_circle_times = 16'd100;
   (* MARK_DEBUG="true" *)    reg   [15:0] s_circle_delay = 16'd10;
       reg   [31:0] passback_length = 0;
       reg          s_circle_data_valid_r = 0;
       reg          s_circle_finish = 0;
       reg   [3:0]  b_circle_cnt = 0;
       reg          task_finish = 0; 
       reg          task_finish_pre1;
       wire         fpga_id_switch;
       wire  [15:0] fpga_id_set; 
       reg   [15:0] s_circle_delay_by50;

/*       assign s_circle_delay_by50 = (s_circle_delay%50)? ((s_circle_delay/50)+1)*50 : s_circle_delay;*/
       assign S_CIRCLE_FINISH = s_circle_finish ;
       assign TASK_FINIFH = task_finish ;

       assign TASK_ID_out = task_id_reg;
       assign FPGA_ID_out = fpga_id_reg;//(fpga_id_switch)? fpga_id_set :fpga_id_reg;       
       assign TRIGGER_VALID = trigger_en;
       assign B_CIRCLE_ID = (rd_en)? b_circle_cnt + 1 : 0;
       assign PASSBACK_LENGTH = passback_length;
       assign PASSBACK_LENGTH_VALID = rd_en_pre2 & (~rd_en_pre3);

//////////////////////fpga id vio/////////////////////////////////      
       /*fpga_id_vio fpga_id_vio (
         .clk(DATA_CLK),                // input wire clk
         .probe_out0(fpga_id_switch),  // output wire [0 : 0] probe_out0
         .probe_out1(fpga_id_set)  // output wire [15 : 0] probe_out1
       );*/

///////////////////////////////////////////////////////////////////
       always @(posedge TRIGGER_CLK)
          task_finish_pre1 <= task_finish;

       assign rst_n  =(task_finish_pre1)? 0 : RST_N; //
/////////////////////////////////////////////////////
       assign IDLE = idle;
       always @(posedge TRIGGER_CLK or negedge rst_n)
         if (!rst_n) begin
             idle <= 1;
         end else if (zkbk_trigger_respond) begin
             idle <= 0;
         end  

///////////////////////////////////////////////////////////
       assign wr_addr_max = b_circle_amount; //(b_circle_amount % 2)? b_circle_amount/2 + 1 : b_circle_amount/2 ;
       assign rd_addr_max = b_circle_amount;
///////////////////////////////////////////////
       wire    zkbk_trigger_respond;
       assign  zkbk_trigger_respond = (task_id_reg == ZKBK_TASK_ID)? ZKBK_TRIGGER : 0;
       assign  ZKBK_TRIGGER_RESPOND = zkbk_trigger_respond;
////////////////////////////////////////////////////////////       
       assign TRIGGER =(trigger_en)?(trigger_delay_cnt <= TRIGGER_L - 1)? 1 : 0 : 0;       

//////////////////////////////////////////
       always @(posedge DATA_CLK or negedge RST_N)
              if (!RST_N) begin
                 task_id_reg <= TASK_ID_init;
                 fpga_id_reg <= FPGA_MASK_init;
                 b_circle_amount <= 8'd10;
              end 
              else
              if (S_CIRCLE_DATA_VALID) begin
                task_id_reg <= TASK_ID_in;
                fpga_id_reg <= FPGA_ID_in;
                b_circle_amount <= B_CIRCLE_AMOUNT;
               end 

        always @(posedge DATA_CLK)begin
            s_circle_data_valid_r <= S_CIRCLE_DATA_VALID;
        end       
 ///////////////////////////////////////////////
     always @(posedge DATA_CLK or negedge rst_n)
           if (!rst_n) begin
                wr_addr <= 0;
           end else if (S_CIRCLE_DATA_VALID) begin
                wr_addr <= wr_addr + 1;
            end else begin
                wr_addr <= 0;
            end

    always @(posedge DATA_CLK or negedge rst_n )
          if(!rst_n)begin
              rd_en <= 0;
          end else if ((wr_addr == wr_addr_max)&s_circle_data_valid_r) begin
              rd_en <= 1;
          end  else if (task_finish)begin
              rd_en <= 0;
          end  

    always @(posedge TRIGGER_CLK or negedge rst_n)       
          if (!rst_n) begin
              rd_addr <= 0;
          end else if (task_finish) begin
              rd_addr <= 0;
          end else if (s_circle_finish) begin
              rd_addr <= rd_addr + 1;
              end

lybk_trigger_bram lybk_trigger_bram_inst (
         .clka(DATA_CLK),    // input wire clka
         .ena(S_CIRCLE_DATA_VALID),      // input wire ena
         .wea(1'b1),      // input wire [0 : 0] wea
         .addra(wr_addr),  // input wire [6 : 0] addra
         .dina(S_CIRCLE_DATA),    // input wire [63 : 0] dina
         .clkb(DATA_CLK),    // input wire clkb
         .enb(rd_en),      // input wire enb
         .addrb(rd_addr),  // input wire [6 : 0] addrb
         .doutb(rd_data)  // output wire [63 : 0] doutb 
);


  always @(posedge DATA_CLK)begin
     rd_en_pre1 <= rd_en;
     rd_en_pre2 <= rd_en_pre1;
     rd_en_pre3 <= rd_en_pre2;
  end


  always @(posedge DATA_CLK or negedge rst_n)
    if (!rst_n) begin
         s_circle_times <= 100;
         s_circle_delay <= 10;
         passback_length <= 1000;
    end else if (rd_en_pre1) begin
         s_circle_times <= rd_data[63:48];
         s_circle_delay <= rd_data[47:32];
         passback_length <= rd_data[31:0];
     end

   always @(posedge DATA_CLK)
      if (rd_en_pre2) begin
            if (s_circle_delay % 50) begin
                s_circle_delay_by50 <= ((s_circle_delay/50)+1)*50;
            end else begin
                s_circle_delay_by50 <= s_circle_delay;
            end
        end else begin
            s_circle_delay_by50 <= s_circle_delay_by50;
        end 

/*  always @(posedge DATA_CLK or negedge RST_N) 
    if (!RST_N)begin
        passback_length <= 0;
    end else if(rd_en_pre2)begin
        passback_length <= rd_data[31:0];
    end */
////////////////////////////////////////////////////////////

  always @(posedge TRIGGER_CLK or negedge rst_n)
       if (!rst_n) begin
            trigger_en <= 0;
       end else if (zkbk_trigger_respond) begin
            trigger_en <= 1;
       end else if (s_circle_finish) begin
            trigger_en <= 0;
       end    

  always @(posedge TRIGGER_CLK or negedge rst_n)
        if (!rst_n) begin
            trigger_delay_cnt <= 0;
        end else if (trigger_delay_cnt == s_circle_delay_by50 - 1) begin
            trigger_delay_cnt <= 0;
        end else if (trigger_en) begin
            trigger_delay_cnt <= trigger_delay_cnt + 1;
        end
  
  always @(posedge TRIGGER_CLK or negedge rst_n)
       if (!rst_n) begin
             trigger_times_cnt <= 0;    
            end else if (s_circle_finish) begin
                trigger_times_cnt <= 0;
            end else if (trigger_delay_cnt == s_circle_delay_by50 - 1) begin
                trigger_times_cnt <= trigger_times_cnt + 1;
            end  
////////////////////////////////////////////////////////////////
  always @(posedge TRIGGER_CLK or negedge rst_n)
       if (!rst_n) begin
            s_circle_finish <= 0;       
            end else if ((trigger_times_cnt == s_circle_times - 1)&&(trigger_delay_cnt == s_circle_delay_by50 - 2)) begin
              s_circle_finish <= 1; 
            end else begin
                s_circle_finish <= 0;
            end   

  always @(posedge TRIGGER_CLK or negedge rst_n)
      if (!rst_n) begin
           b_circle_cnt <= 0;             
         end else if (task_finish) begin
           b_circle_cnt <= 0;
         end else if (s_circle_finish) begin
           b_circle_cnt <= b_circle_cnt + 1;
         end

  always @(posedge TRIGGER_CLK or negedge rst_n)
      if (!rst_n) begin
          task_finish <= 0;                           
      end else if ((b_circle_cnt == b_circle_amount - 1)&&(trigger_times_cnt == s_circle_times - 1)&&(trigger_delay_cnt == s_circle_delay_by50 - 2)) begin
          task_finish <= 1;
      end else begin
          task_finish <= 0;
      end                     

endmodule
