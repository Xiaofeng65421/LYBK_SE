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


module sync_test(      
	                                              ////用于仿真
/*         input                               start,
         input                               start_flag,
         input                               stop,
         input                               clk_100M,
         input     [3:0]                     sync_trig_delay,
         input     [3:0]                     trig_length,
         input     [5:0]                     sync_length,*/
         /////////////////////////////////////////
         input                               SYS_CLK_P,       
         input                               SYS_CLK_N, 
         output    [10:0]                    TRIGGER0_P,
         output    [10:0]                    TRIGGER0_N,
         output    [3:0]                     TRIGGER1_P,
         output    [3:0]                     TRIGGER1_N                    
    );
   wire   clk_100M;
   wire   locked;
   wire   start_flag;
   wire   start;
   wire   stop;
   wire [7:0] sync_trig_delay ;
   wire [5:0] sync_length;
   wire [3:0] trig_length;
   wire [7:0] trig_start_point;

  (* MARK_DEBUG="true" *)    wire    sync ;
  (* MARK_DEBUG="true" *)    wire    trigger ;
   wire    trigger_tru;
   wire    trigger_sel;
   (* MARK_DEBUG="true" *)   wire    trigger_flag;
   (* MARK_DEBUG="true" *)   wire    trigger_sync;

   localparam  st_idle  =   4'b0001;
   localparam  st_sync  =   4'b0010;
   localparam  st_trig  =   4'b0100;
   localparam  st_start =   4'b1000;

   reg         sync_pre = 0;
   (* MARK_DEBUG="true" *)   reg         trigger_pre;
   (* MARK_DEBUG="true" *)   reg         sync_end = 0;
   (* MARK_DEBUG="true" *)   reg         trigger_en = 0;
   (* MARK_DEBUG="true" *)   reg  [7:0]  sync_time_cnt = 0;
   (* MARK_DEBUG="true" *)   reg  [7:0]  trigger_time_cnt = 0;
   (* MARK_DEBUG="true" *)   reg  [3:0]  trigger_cnt = 0; 
   (* MARK_DEBUG="true" *)   reg  [3:0]  state = st_idle;   

   assign trigger = (trigger_en)?((trigger_time_cnt >= trig_start_point) &&(trigger_time_cnt <= trig_length + trig_start_point))? 1 : 0 : 0;
   assign sync = (state == st_sync)?(sync_time_cnt <= sync_length -1)? 1 : 0 : 0;
   assign trigger_sel = (start)? trigger : 0;
   assign trigger_flag = (~trigger_pre)&trigger_sel;
   assign trigger_tru = (trigger_cnt == 3)?trigger_pre : 0;
   assign trigger_sync = trigger_tru | sync_pre;

   generate
     genvar i;
     for(i = 0 ; i < 11 ; i = i + 1)begin : obufds_trig0
      OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
     ) OBUFDS_inst (
      .O(TRIGGER0_P[i]),     // Diff_p output (connect directly to top-level port)
      .OB(TRIGGER0_N[i]),   // Diff_n output (connect directly to top-level port)
      .I(trigger_sync)      // Buffer input
   );
     end
     
   endgenerate

   generate
     genvar j;
     for(j = 0 ; j < 4 ; j = j + 1)begin : obufds_trig1
      OBUFDS #(
      .IOSTANDARD("DEFAULT"), // Specify the output I/O standard
      .SLEW("SLOW")           // Specify the output slew rate
     ) OBUFDS_inst (
      .O(TRIGGER1_P[j]),     // Diff_p output (connect directly to top-level port)
      .OB(TRIGGER1_N[j]),   // Diff_n output (connect directly to top-level port)
      .I(trigger_sync)      // Buffer input
   );
     end
   endgenerate

  IBUFDS IBUFDS_inst (
      .O(clk_100M),  // Buffer output
      .I(SYS_CLK_P),  // Diff_p buffer input (connect directly to top-level port)
      .IB(SYS_CLK_N) // Diff_n buffer input (connect directly to top-level port)
   );    

vio_0 vio_inst (
  .clk(clk_100M),                // input wire clk
  .probe_out0(start_flag),  // output wire [0 : 0] probe_out0
  .probe_out1(start),  // output wire [0 : 0] probe_out1
  .probe_out2(stop),  // output wire [0 : 0] probe_out2
  .probe_out3(sync_trig_delay),  // output wire [3 : 0] probe_out3
  .probe_out4(trig_length),
  .probe_out5(sync_length),
  .probe_out6(trig_start_point) 
);
 
/* ila_0 ila_0_inst (
  .clk(clk_100M), // input wire clk


  .probe0({sync,trigger,trigger_sync,trigger_flag,trigger_pre,trigger_en,sync_end}), // input wire [6:0]  probe0  
  .probe1(sync_time_cnt), // input wire [7:0]  probe1 
  .probe2(trigger_time_cnt), // input wire [7:0]  probe2 
  .probe3(trigger_cnt), // input wire [3:0]  probe3 
  .probe4(state) // input wire [3:0]  probe4
);
*/
always @(posedge clk_100M)begin
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
     	end else if (stop) begin
        state <= st_idle;
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

always @(posedge clk_100M or posedge stop)
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

always @(posedge clk_100M)
  if (sync_time_cnt == sync_trig_delay + sync_length - 3) begin
      sync_end <= 1;
  end else begin
      sync_end <= 0;
  end

always @(posedge clk_100M)
  if (stop) begin
  	 trigger_time_cnt <= 0;
  end else if (trigger_time_cnt == 49) begin
  	 trigger_time_cnt <= 0;
  end else if (trigger_en) begin
  	 trigger_time_cnt <= trigger_time_cnt + 1;
  end

always @(posedge clk_100M)begin
  trigger_pre <= trigger_sel;
  sync_pre <= sync;
end


always @(posedge clk_100M or negedge start)
    if (!start) begin
        trigger_cnt <= 0;
    end else if (&trigger_cnt) begin
        trigger_cnt <= trigger_cnt;
    end else if (trigger_flag) begin
        trigger_cnt <= trigger_cnt + 1;
    end

endmodule
