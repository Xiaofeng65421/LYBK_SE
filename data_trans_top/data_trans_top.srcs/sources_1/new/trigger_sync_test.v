`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/09 16:09:07
// Design Name: 
// Module Name: sync_test
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


module trigger_sync_test(      
/*	                                              ////用于仿真
         input                               start,
         input                               start_flag,
         input                               stop,
         input                               clk_300M,*/
         /////////////////////////////////////////
         input                               SYS_CLK_P,       
         input                               SYS_CLK_N, 
         inout    [10:0]                    TRIGGER0_P,
         inout    [10:0]                    TRIGGER0_N,
         inout    [3:0]                     TRIGGER1_P,
         inout    [3:0]                     TRIGGER1_N                    
    );
   wire   clk_300M;
   wire   locked;
   wire   start_flag;
   wire   start;
   reg    start_pre;
   wire   start_negedge;
   wire   stop;

   wire    sync ;
   wire    trigger ;
   wire    trigger_tru;
   wire    trigger_sel;
   wire    trigger_flag;
   (* MARK_DEBUG="true" *)   wire    trigger_sync;

   localparam  st_idle  =   4'b0001;
   localparam  st_sync  =   4'b0010;
   localparam  st_trig  =   4'b0100;
   localparam  st_start =   4'b1000;

   reg         sync_pre;
   reg         trigger_pre;
   reg         sync_end = 0;
   reg         trigger_en = 0;
   reg  [3:0]  sync_time_cnt = 0;
   reg  [5:0]  trigger_time_cnt = 0;
   reg  [14:0]  trigger_cnt = 0; 
   reg  [3:0]  state = st_idle;  

   reg     trig_control = 0; // 默认触发接口为输出状态 
   wire [10:0]   trigger0;
   (* MARK_DEBUG="true" *)   wire [10:0]   trigger0_back;
   wire [3:0]    trigger1;
   (* MARK_DEBUG="true" *)   wire [3:0]    trigger1_back;
   wire [31:0]   delay0_cnt [10:0];
   wire [31:0]   delay1_cnt [10:0];
   (* MARK_DEBUG="true" *)   wire [31:0]   delay0_cnt_0,delay0_cnt_1,delay0_cnt_2,delay0_cnt_3,delay0_cnt_4,
   delay0_cnt_5,delay0_cnt_6,delay0_cnt_7,delay0_cnt_8,delay0_cnt_9,delay0_cnt_10;
   (* MARK_DEBUG="true" *)   wire [31:0]   delay1_cnt_0,delay1_cnt_1,delay1_cnt_2,delay1_cnt_3;

   assign trigger = (trigger_en)?(trigger_time_cnt <= 14)? 1 : 0 : 0;
   assign sync = (state == st_sync)?(sync_time_cnt <= 3)? 1 : 0 : 0;
   assign trigger_sel = (start)? trigger : 0;
   assign trigger_flag = (~trigger_pre)&trigger_sel;
   assign trigger_tru = (trigger_cnt == 2)?trigger_pre : 0;
   assign trigger_sync = trigger_tru;///////////

   assign trigger0_back = (trig_control)? trigger0 : 0;
   assign trigger1_back = (trig_control)? trigger1 : 0;

   assign delay0_cnt_0 =  delay0_cnt[0];
   assign delay0_cnt_1 =  delay0_cnt[1];
   assign delay0_cnt_2 =  delay0_cnt[2];
   assign delay0_cnt_3 =  delay0_cnt[3];
   assign delay0_cnt_4 =  delay0_cnt[4];
   assign delay0_cnt_5 =  delay0_cnt[5];
   assign delay0_cnt_6 =  delay0_cnt[6];
   assign delay0_cnt_7 =  delay0_cnt[7];
   assign delay0_cnt_8 =  delay0_cnt[8];
   assign delay0_cnt_9 =  delay0_cnt[9];
   assign delay0_cnt_10 = delay0_cnt[10];

   assign delay1_cnt_0 =  delay1_cnt[0];
   assign delay1_cnt_1 =  delay1_cnt[1];
   assign delay1_cnt_2 =  delay1_cnt[2];
   assign delay1_cnt_3 =  delay1_cnt[3];

   assign start_negedge = ~start & start_pre;


   always @(posedge clk_300M)
      start_pre <= state;


   always @(posedge clk_300M)
    if (trigger_cnt == 300) begin
      	   trig_control <= 1;
      end else if (start_negedge) begin
      	   trig_control <= 0;
      end
       

   generate
   	 genvar i;
   	 for(i = 0 ; i < 11 ; i = i + 1)begin : obufds_trig0
   	 IOBUFDS IOBUFDS_inst0 (
          .O(trigger0[i]),     // 1-bit output: Buffer output
          .I(trigger_sync),     // 1-bit input: Buffer input
          .IO(TRIGGER0_P[i]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
          .IOB(TRIGGER0_N[i]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
          .T(trig_control)      // 1-bit input: 3-state enable input
       );
    trigger_delay trigger0_delay(
          .CLK_300M(clk_300M),
          .RST(start_flag),
          .TRIGGER_SEND(trigger_sync),
          .TRIGGER_BACK(trigger0_back[i]),
          .DELAY_CNT(delay0_cnt[i])
    	);
   	end
   endgenerate

   generate
     genvar j;
     for(j = 0 ; j < 4 ; j = j + 1)begin : obufds_trig1
     IOBUFDS IOBUFDS_inst1 (
         .O(trigger1[j]),     // 1-bit output: Buffer output
         .I(trigger_sync),     // 1-bit input: Buffer input
         .IO(TRIGGER1_P[j]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
         .IOB(TRIGGER1_N[j]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
         .T(trig_control)      // 1-bit input: 3-state enable input
      );
     trigger_delay trigger1_delay(
          .CLK_300M(clk_300M),
          .RST(start_flag),
          .TRIGGER_SEND(trigger_sync),
          .TRIGGER_BACK(trigger1_back[j]),
          .DELAY_CNT(delay1_cnt[j])
    	);
     end
   endgenerate

 clk_wiz_1 clk_wiz_1_inst(
    // Clock out ports
    .clk_out1(clk_300M),     // output clk_out1
    // Status and control signals
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1_p(SYS_CLK_P),    // input clk_in1_p
    .clk_in1_n(SYS_CLK_N));    // input clk_in1_n

vio_0 vio_inst (
  .clk(clk_300M),                // input wire clk
  .probe_out0(start_flag),  // output wire [0 : 0] probe_out0
  .probe_out1(start),  // output wire [0 : 0] probe_out1
  .probe_out2(stop)  // output wire [0 : 0] probe_out2
);
 
/* ila_1 ila_inst(
	.clk(clk_300M), // input wire clk


	.probe0(delay0_cnt_0), // input wire [31:0]  probe0  
	.probe1(delay0_cnt_1), // input wire [31:0]  probe1 
	.probe2(delay0_cnt_2), // input wire [31:0]  probe2 
	.probe3(delay0_cnt_3), // input wire [31:0]  probe3 
	.probe4(delay0_cnt_4), // input wire [31:0]  probe4 
	.probe5(delay0_cnt_5), // input wire [31:0]  probe5 
	.probe6(delay0_cnt_6), // input wire [31:0]  probe6 
	.probe7(delay0_cnt_7), // input wire [31:0]  probe7 
	.probe8(delay0_cnt_8), // input wire [31:0]  probe8 
	.probe9(delay0_cnt_9), // input wire [31:0]  probe9 
	.probe10(delay0_cnt_10), // input wire [31:0]  probe10 
	.probe11(delay1_cnt_0), // input wire [31:0]  probe11 
	.probe12(delay1_cnt_1), // input wire [31:0]  probe12 
	.probe13(delay1_cnt_2), // input wire [31:0]  probe13 
	.probe14(delay1_cnt_3), // input wire [31:0]  probe14 
	.probe15(trigger_sync), // input wire [0:0]  probe15
    .probe16(trigger0_back), // input wire [10:0]  probe16 
	.probe17(trigger1_back), // input wire [3:0]  probe17
	.probe18(trig_control) // input wire [0:0]  probe18
 	);*/

always @(posedge clk_300M)begin
	case(state)
     st_idle : begin
     	if (start_flag) begin
     		state <= st_sync;
     	end
     end
     st_sync : begin
     	if (sync_end) begin
     		state <= st_trig;
     	end
     end
     st_trig : begin
     	if (start) begin
     		state <= st_start;
     	end
     end
     st_start : begin
     	if (stop) begin
     		state <= st_idle;
     	end
     end
     default : state <= st_idle;
	endcase
end

always @(posedge clk_300M or posedge stop)
  if (stop) begin
      	sync_time_cnt <= 0;
      	trigger_en <= 0;
      end else begin
      	case(state)
            st_sync : begin
            	if (&sync_time_cnt) begin
            		sync_time_cnt <= sync_time_cnt;
            	end else begin
            		sync_time_cnt <= sync_time_cnt + 1;
            	end
            end
            st_trig : begin
            	trigger_en <= 1;

            end
      	endcase
      end   

always @(posedge clk_300M)
   if (sync_time_cnt == 5) begin
   	   sync_end <= 1;
   end else begin
   	   sync_end <= 0;
   end
//////////////////触发周期100ns
always @(posedge clk_300M)
  if (stop) begin
  	 trigger_time_cnt <= 0;
  end else if (trigger_time_cnt == 29) begin
  	 trigger_time_cnt <= 0;
  end else if (trigger_en) begin
  	 trigger_time_cnt <= trigger_time_cnt + 1;
  end

always @(posedge clk_300M)begin
  trigger_pre <= trigger_sel;
  sync_pre <= sync;
end


always @(posedge clk_300M or negedge start)
    if (!start) begin
        trigger_cnt <= 0;
    end else if (&trigger_cnt) begin
        trigger_cnt <= trigger_cnt;
    end else if (trigger_flag) begin
        trigger_cnt <= trigger_cnt + 1;
    end

endmodule
