`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/11/24 09:37:10
// Design Name: 
// Module Name: VPX_signal
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


module VPX_signal(
//---------CLK-------------//
input        SYS_CLK_P,   ///from 7044
input        SYS_CLK_N,	

//----------TRIG-----------//
inout    [11:0]                    TRIGGER0_P,
inout    [11:0]                    TRIGGER0_N,
inout    [3:0]                     TRIGGER1_P,
inout    [3:0]                     TRIGGER1_N,  

//----------DCO-----------//
inout    [11:0]                    DCO0_P,
inout    [11:0]                    DCO0_N,
inout    [3:0]                     DCO1_P,
inout    [3:0]                     DCO1_N,

//---------TASK_ID---------//
inout    [15:0]                    ID_DOWN,
inout    [15:0]                    ID_UP,
inout    [15:0]                    ID_DOWN_VALID,
inout    [15:0]                    ID_UP_VALID,

//---------CMD-------------//
inout    [13:0]                    CMD_0,
inout    [13:0]                    CMD_1,                                                       
inout    [13:0]                    CMD_VALID,
/////adda
inout    [1:0]                     CMD_DOWN_0,
inout    [1:0]                     CMD_DOWN_1,
inout    [1:0]                     CMD_UP_0,
inout    [1:0]                     CMD_UP_1,
inout    [1:0]                     CMD_DOWN_VALID,
inout    [1:0]                     CMD_UP_VALID                         


    );

//---------------signal--------------------//

wire     clk_100m;
wire     start;
reg      start_pre;
reg      start_pre_1;
reg      start_pre_2;
wire     start_signal;
wire     io_control; //默认0输出

always @(posedge clk_100m)begin
	start_pre <= start;
	start_pre_1 <= start_pre;
	start_pre_2 <= start_pre_1;
end

assign start_signal = start_pre & (~start_pre_2);

//----------------trig----------------------//
wire [11:0]  trigger0;
wire [3:0]   trigger1;
wire [11:0]  trigger0_back;
wire [3:0]   trigger1_back;

assign trigger0_back = (io_control)?trigger0 : 0;
assign trigger1_back = (io_control)?trigger1 : 0;
//----------------------------------------//
//---------------dco----------------------//
wire [11:0]  dco0;
wire [3:0]   dco1;
wire [11:0]  dco0_back;
wire [3:0]   dco1_back;

assign dco0_back = (io_control)?dco0 : 0;
assign dco1_back = (io_control)?dco1 : 0;
//---------------------------------------//
//--------------task_id------------------//
wire [15:0]  ID_DOWN_back;
wire [15:0]  ID_UP_back;
wire [15:0]  ID_DOWN_VALID_back;
wire [15:0]  ID_UP_VALID_back;

assign ID_DOWN             = (io_control)? 'dz            : {16{start_signal}};
assign ID_DOWN_back        = (io_control)?ID_DOWN         : 0;
assign ID_UP               = (io_control)? 'dz            : {16{start_signal}};
assign ID_UP_back          = (io_control)?ID_UP           : 0;
assign ID_DOWN_VALID       = (io_control)? 'dz            : {16{start_signal}};
assign ID_DOWN_VALID_back  = (io_control)?ID_DOWN_VALID   : 0;
assign ID_UP_VALID         = (io_control)? 'dz            : {16{start_signal}};
assign ID_UP_VALID_back    = (io_control)?ID_UP_VALID     : 0;
//---------------------------------------//
//---------------cmd--------------------//
wire [13:0]  CMD_0_back;
wire [13:0]  CMD_1_back;
wire [13:0]  CMD_VALID_back;    

assign CMD_0          = (io_control)? 'dz       : {14{start_signal}};
assign CMD_0_back     = (io_control)? CMD_0     : 0;
assign CMD_1          = (io_control)? 'dz       : {14{start_signal}};
assign CMD_1_back     = (io_control)? CMD_1     : 0;
assign CMD_VALID      = (io_control)? 'dz       : {14{start_signal}};
assign CMD_VALID_back = (io_control)? CMD_VALID : 0;

wire [1:0]  CMD_DOWN_0_back;
wire [1:0]  CMD_DOWN_1_back;
wire [1:0]  CMD_UP_0_back;
wire [1:0]  CMD_UP_1_back;
wire [1:0]  CMD_DOWN_VALID_back;
wire [1:0]  CMD_UP_VALID_back;

assign CMD_DOWN_0          = (io_control)? 'dz            : {2{start_signal}};
assign CMD_DOWN_0_back     = (io_control)? CMD_DOWN_0     : 0;
assign CMD_DOWN_1          = (io_control)? 'dz            : {2{start_signal}};
assign CMD_DOWN_1_back     = (io_control)? CMD_DOWN_1     : 0;
assign CMD_UP_0            = (io_control)? 'dz            : {2{start_signal}};
assign CMD_UP_0_back       = (io_control)? CMD_UP_0       : 0;
assign CMD_UP_1            = (io_control)? 'dz            : {2{start_signal}};
assign CMD_UP_1_back       = (io_control)? CMD_UP_1       : 0;
assign CMD_DOWN_VALID      = (io_control)? 'dz            : {2{start_signal}};
assign CMD_DOWN_VALID_back = (io_control)? CMD_DOWN_VALID : 0;
assign CMD_UP_VALID        = (io_control)? 'dz            : {2{start_signal}};
assign CMD_UP_VALID_back   = (io_control)? CMD_UP_VALID   : 0;
//--------------------------------------//
//-----------------clk-----------------//
  IBUFDS #(
      .DIFF_TERM("FALSE"),       // Differential Termination
      .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
      .IOSTANDARD("DEFAULT")     // Specify the input I/O standard
   ) IBUFDS_inst (
      .O(clk_100m),  // Buffer output
      .I(SYS_CLK_P),  // Diff_p buffer input (connect directly to top-level port)
      .IB(SYS_CLK_N) // Diff_n buffer input (connect directly to top-level port)
   );
//-------------------------------------//
//--------------tri_control-----------//
vio_1 vio_1_inst (
  .clk(clk_100m),                // input wire clk
  .probe_out0(start),  // output wire [0 : 0] probe_out0
  .probe_out1(io_control)  // output wire [0 : 0] probe_out1
);

/*ila_2 ila_2_inst (
  .clk(clk_100m), // input wire clk

  .probe0(start_signal), // input wire [0:0]  probe0  
  .probe1(trigger0), // input wire [11:0]  probe1 
  .probe2(trigger1), // input wire [3:0]  probe2 
  .probe3(dco0), // input wire [11:0]  probe3 
  .probe4(dco1), // input wire [3:0]  probe4 
  .probe5(ID_DOWN), // input wire [15:0]  probe5 
  .probe6(ID_UP), // input wire [15:0]  probe6 
  .probe7(ID_DOWN_VALID), // input wire [15:0]  probe7 
  .probe8(ID_UP_VALID), // input wire [15:0]  probe8 
  .probe9(CMD_0), // input wire [13:0]  probe9 
  .probe10(CMD_1), // input wire [13:0]  probe10 
  .probe11(CMD_VALID), // input wire [13:0]  probe11 
  .probe12({CMD_DOWN_0,CMD_DOWN_1,CMD_UP_0,CMD_UP_1,CMD_DOWN_VALID,CMD_UP_VALID}) // input wire [11:0]  probe12
);*/
//------------------------------------//
//-----------lvds------------------//
generate
	genvar i;
	for (i = 0 ; i < 12 ; i = i + 1)begin : trig0
		IOBUFDS trig_inst0 (
          .O  (trigger0[i]),     // 1-bit output: Buffer output
          .I  (start_signal),     // 1-bit input: Buffer input
          .IO (TRIGGER0_P[i]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
          .IOB(TRIGGER0_N[i]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
          .T  (io_control)      // 1-bit input: 3-state enable input
       );

        IOBUFDS dco_inst0(
          .O  (dco0[i]),     // 1-bit output: Buffer output
          .I  (start_signal),     // 1-bit input: Buffer input
          .IO (DCO0_P[i]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
          .IOB(DCO0_N[i]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
          .T  (io_control)      // 1-bit input: 3-state enable input
      	);
	end
endgenerate

generate
	genvar j;
	 for(j = 0 ; j < 4 ; j = j + 1)begin : trig1
	    IOBUFDS trig_inst1 (
             .O  (trigger1[j]),     // 1-bit output: Buffer output
             .I  (start_signal),     // 1-bit input: Buffer input
             .IO (TRIGGER1_P[j]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
             .IOB(TRIGGER1_N[j]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
             .T  (io_control)      // 1-bit input: 3-state enable input
          );

	    IOBUFDS  dco_inst1(
             .O  (dco1[j]),     // 1-bit output: Buffer output
             .I  (start_signal),     // 1-bit input: Buffer input
             .IO (DCO1_P[j]),   // 1-bit inout: Diff_p inout (connect directly to top-level port)
             .IOB(DCO1_N[j]), // 1-bit inout: Diff_n inout (connect directly to top-level port)
             .T  (io_control)      // 1-bit input: 3-state enable input
	      );
	 end
endgenerate


endmodule
