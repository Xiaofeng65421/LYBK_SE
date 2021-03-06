 ///////////////////////////////////////////////////////////////////////////////
 //
 // Project:  Aurora 64B/66B
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2008 - 2009 Xilinx, Inc. All rights reserved.
 //
 // This file contains confidential and proprietary information
 // of Xilinx, Inc. and is protected under U.S. and
 // international copyright and other intellectual property
 // laws.
 //
 // DISCLAIMER
 // This disclaimer is not a license and does not grant any
 // rights to the materials distributed herewith. Except as
 // otherwise provided in a valid license issued to you by
 // Xilinx, and to the maximum extent permitted by applicable
 // law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
 // WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
 // AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
 // BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
 // INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
 // (2) Xilinx shall not be liable (whether in contract or tort,
 // including negligence, or under any other theory of
 // liability) for any loss or damage of any kind or nature
 // related to, arising under or in connection with these
 // materials, including for any direct, or any indirect,
 // special, incidental, or consequential loss or damage
 // (including loss of data, profits, goodwill, or any type of
 // loss or damage suffered as a result of any action brought
 // by a third party) even if such damage or loss was
 // reasonably foreseeable or Xilinx had been advised of the
 // possibility of the same.
 //
 // CRITICAL APPLICATIONS
 // Xilinx products are not designed or intended to be fail-
 // safe, or for use in any application requiring fail-safe
 // performance, such as life-support or safety devices or
 // systems, Class III medical devices, nuclear facilities,
 // applications related to the deployment of airbags, or any
 // other applications that could lead to death, personal
 // injury, or severe property or environmental damage
 // (individually and collectively, "Critical
 // Applications"). Customer assumes the sole risk and
 // liability of any use of Xilinx products in Critical
 // Applications, subject only to applicable laws and
 // regulations governing limitations on product liability.
 //
 // THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
 // PART OF THIS FILE AT ALL TIMES.

 //
 ///////////////////////////////////////////////////////////////////////////////
 //
 //  EXAMPLE_DESIGN
 //
 //
 //  Description:  This module instantiates 1 lane Aurora Module.
 //                Used to exhibit functionality in hardware using the example design
 //                The User Interface is connected to Data Generator and Checker.
 ///////////////////////////////////////////////////////////////////////////////

 // aurora sample file, example design

 `timescale 1 ns / 10 ps

   (* core_generation_info = "aurora_64b66b_0,aurora_64b66b_v12_0_3,{c_aurora_lanes=1,c_column_used=left,c_gt_clock_1=GTHQ0,c_gt_clock_2=None,c_gt_loc_1=1,c_gt_loc_10=X,c_gt_loc_11=X,c_gt_loc_12=X,c_gt_loc_13=X,c_gt_loc_14=X,c_gt_loc_15=X,c_gt_loc_16=X,c_gt_loc_17=X,c_gt_loc_18=X,c_gt_loc_19=X,c_gt_loc_2=X,c_gt_loc_20=X,c_gt_loc_21=X,c_gt_loc_22=X,c_gt_loc_23=X,c_gt_loc_24=X,c_gt_loc_25=X,c_gt_loc_26=X,c_gt_loc_27=X,c_gt_loc_28=X,c_gt_loc_29=X,c_gt_loc_3=X,c_gt_loc_30=X,c_gt_loc_31=X,c_gt_loc_32=X,c_gt_loc_33=X,c_gt_loc_34=X,c_gt_loc_35=X,c_gt_loc_36=X,c_gt_loc_37=X,c_gt_loc_38=X,c_gt_loc_39=X,c_gt_loc_4=X,c_gt_loc_40=X,c_gt_loc_41=X,c_gt_loc_42=X,c_gt_loc_43=X,c_gt_loc_44=X,c_gt_loc_45=X,c_gt_loc_46=X,c_gt_loc_47=X,c_gt_loc_48=X,c_gt_loc_5=X,c_gt_loc_6=X,c_gt_loc_7=X,c_gt_loc_8=X,c_gt_loc_9=X,c_lane_width=4,c_line_rate=5.0,c_gt_type=GTHE3,c_qpll=false,c_nfc=false,c_nfc_mode=IMM,c_refclk_frequency=200.0,c_simplex=false,c_simplex_mode=TX,c_stream=true,c_ufc=false,c_user_k=false,flow_mode=None,interface_mode=Streaming,dataflow_config=Duplex}" *)
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_0_exdes  #
 (
     parameter   USE_CORE_TRAFFIC     =   1,
     parameter   USR_CLK_PCOUNT     =  9'd255,
     parameter   EXAMPLE_SIMULATION =   0
      //pragma translate_off
        | 1
      //pragma translate_on
      ,
      parameter   USE_LABTOOLS       =   0
 )
 (
     // System Interface
     INIT_CLK_i,
     USER_CLK,
    //  User  Interface
     TX_DATA,
     TX_DATA_VALID,
     TX_READY,
     RX_DATA,
     RX_DATA_VALID,
     CHANNEL_UP,

     // GTX Reference Clock Interface
     GTH_CLK,

     // GTX Serial I/O
     RXP,
     RXN,
     TXP,
     TXN,
     //add
     qpll1_lock_quad1_out,
     gt_qpllclk_quad1_i,
     gt_qpllrefclk_quad1_i,
     qpll1_refclklost1_out,
     gt_to_common_qpllreset_i

 );
 `define DLY #1


 //***********************************Port Declarations*******************************

/*     input               RESET;
       input              PMA_INIT;*/
       input              INIT_CLK_i;
       output             USER_CLK;

     // GTX Reference Clock Interface
       input              GTH_CLK;
     
     // User Interface
       input   [0:63]     TX_DATA;
       input              TX_DATA_VALID;
       output             TX_READY;
       output  [0:63]     RX_DATA;
       output             RX_DATA_VALID;
       output             CHANNEL_UP;

     // GTX Serial I/O
       input              RXP;
       input              RXN;

       output             TXP;
       output             TXN;
    //  add  
       input               qpll1_lock_quad1_out;
       input               gt_qpllclk_quad1_i;
       input               gt_qpllrefclk_quad1_i;
       input               qpll1_refclklost1_out;
       output              gt_to_common_qpllreset_i; 

 //************************External Register Declarations*****************************
       wire                 RESET = 0;
       wire                 PMA_INIT= 0;
     //Error reporting signals
       reg                  HARD_ERR;
       reg                  SOFT_ERR;
       reg       [0:7]      DATA_ERR_COUNT;

     //Global signals
 (* MARK_DEBUG="true" *)      reg                  LANE_UP;
 (* MARK_DEBUG="true" *)      reg                  CHANNEL_UP;

 //********************************Wire Declarations**********************************

     wire    [280:0]          tied_to_ground_vec_i;
     wire                     INIT_CLK_IN;

     //Dut1
     //TX Interface
       wire      [0:63]     tx_tdata_i; 
       wire                 tx_tvalid_i;
       wire                 tx_tready_i;

     //RX Interface
       wire      [0:63]      rx_tdata_i;  
       wire                 rx_tvalid_i;

     //TX Interface
       wire      [0:63]     tx_d_i;
       wire                 tx_src_rdy_n_i;
       wire                 tx_dst_rdy_n_i;             

     //RX Interface
       wire      [0:63]      rx_d_i;
       wire                 rx_src_rdy_n_i;

     //Error Detection Interface
       wire                 hard_err_i;
       wire                 soft_err_i;

     //Status
       wire                 channel_up_i;
       wire                 lane_up_i;


     //System Interface
       wire                 reset_i ;
       wire                 gt_rxcdrovrden_i ;
       wire                 power_down_i;
       wire      [2:0]      loopback_i ;
       wire                 gt_pll_lock_i ;
       wire                 fsm_resetdone_i ;
       wire                 tx_out_clk_i ;

     // Error signals from the frame checker
       wire      [0:7]       data_err_count_o;
     wire                  data_err_init_clk_i;


     // clock
       wire               user_clk_i;
       wire               sync_clk_i;
       wire               INIT_CLK_i  /* synthesis syn_keep = 1 */;

       wire               drp_clk_i = INIT_CLK_i;
       wire               DRP_CLK_i;
       wire    [8:0] drpaddr_in_i;
       wire    [15:0]     drpdi_in_i;
       wire    [15:0]     drpdo_out_i;
       wire               drprdy_out_i;
       wire               drpen_in_i;
       wire               drpwe_in_i;
       wire    [8:0]  gt0_drpaddr_i;
       wire    [15:0]                     gt0_drpdi_i;  
       wire                               gt0_drpen_i;  
       wire                               gt0_drpwe_i;  
       wire    [15:0]                     gt0_drpdo_i;  
       wire    [31:0]     s_axi_awaddr_i;
       wire    [31:0]     s_axi_araddr_i;
       wire    [31:0]     s_axi_wdata_i;
       wire    [3:0]     s_axi_wstrb_i;
       wire    [31:0]     s_axi_rdata_i;
       wire               s_axi_awvalid_i;
       wire               s_axi_arvalid_i;
       wire               s_axi_wvalid_i;
       wire               s_axi_rvalid_i;
       wire               s_axi_bvalid_i;
       wire    [1:0]      s_axi_bresp_i;
       wire    [1:0]      s_axi_rresp_i;
       wire               s_axi_bready_i;
       wire               s_axi_awready_i;
       wire               s_axi_arready_i;
       wire               s_axi_wready_i;
       wire               s_axi_rready_i;
       wire               link_reset_i;
       wire               sysreset_from_vio_i =1'b0 ;
       wire               gtreset_from_vio_i =1'b0 ;
       wire               rx_cdrovrden_i =1'b0 ;
       wire               gt_reset_i;
       wire               gt_reset_i_tmp;
       wire               gt_reset_i_tmp2;
       wire               sysreset_from_vio_r3;
       wire               sysreset_from_vio_r3_initclkdomain;
       wire               gtreset_from_vio_r3;
       wire               tied_to_ground_i;
       wire               tied_to_vcc_i;
       wire               gt_reset_i_eff;
       wire               system_reset_i;
       wire                          pll_not_locked_i;
 
       reg  pma_init_from_fsm = 0;
       reg pma_init_from_fsm_r1 = 0;
       reg lane_up_vio_usrclk_r1 = 0;
       reg data_err_count_o_r1  = 0;
       reg rx_tvalid_r = 1'd0;
       reg [8:0] usr_clk_counter = 9'd0;
       wire usr_clk_count_done;
 

     wire reset2FrameGenCheck;
     assign reset2FrameGenCheck = system_reset_i | !channel_up_i;

 //*********************************Main Body of Code**********************************
     assign USER_CLK = user_clk_i;
     assign RX_DATA =  rx_tdata_i;
     assign RX_DATA_VALID =  rx_tvalid_i;
     assign TX_READY = tx_tready_i;
     assign tx_tvalid_i =(CHANNEL_UP)? TX_DATA_VALID : 0;
     assign tx_tdata_i = (CHANNEL_UP)? TX_DATA : 0;


//--- Instance of GT differential buffer ---------//

     //____________________________Register User I/O___________________________________

     // Register User Outputs from core.
     always @(posedge user_clk_i)
     begin
         HARD_ERR         <=  hard_err_i;
         SOFT_ERR         <=  soft_err_i;
         LANE_UP          <=  lane_up_i;
         CHANNEL_UP       <=  channel_up_i;
         DATA_ERR_COUNT   <=  data_err_count_o;
     end


     //____________________________Register User I/O___________________________________

     // System Interface
     assign power_down_i      =   1'b0;
     assign tied_to_ground_i   =   1'b0;
     assign tied_to_ground_vec_i = 281'd0;
     assign tied_to_vcc_i      =   1'b1;

    // AXI4 Lite Interface
     assign  s_axi_awaddr_i    =  32'h0;
     assign  s_axi_wdata_i     =  16'h0;
     assign  s_axi_wstrb_i     =  'h0;
     assign  s_axi_araddr_i    =  32'h0;
     assign  s_axi_awvalid_i   =  1'b0;
     assign  s_axi_wvalid_i    =  1'b0;
     assign  s_axi_arvalid_i   =  1'b0;
     assign  s_axi_rvalid_i    =  1'b0;
     assign  s_axi_rready_i    =  1'b0;
     assign  s_axi_bready_i    =  1'b0;




   reg [127:0]        pma_init_stage = {128{1'b1}};
   reg [23:0]         pma_init_pulse_width_cnt = 24'h0;
   reg pma_init_assertion = 1'b0;
   reg pma_init_assertion_r;
   reg gt_reset_i_delayed_r1;
   reg gt_reset_i_delayed_r2;
   wire gt_reset_i_delayed;



     generate
        always @(posedge INIT_CLK_i)
        begin
            pma_init_stage[127:0] <= {pma_init_stage[126:0], gt_reset_i_tmp};
        end

        assign gt_reset_i_delayed = pma_init_stage[127];

        always @(posedge INIT_CLK_i)
        begin
            gt_reset_i_delayed_r1     <=  gt_reset_i_delayed;
            gt_reset_i_delayed_r2     <=  gt_reset_i_delayed_r1;
            pma_init_assertion_r  <= pma_init_assertion;
            if(~gt_reset_i_delayed_r2 & gt_reset_i_delayed_r1 & ~pma_init_assertion & (pma_init_pulse_width_cnt != 24'hFFFFFF))
                pma_init_assertion <= 1'b1;
            else if (pma_init_assertion & pma_init_pulse_width_cnt == 24'hFFFFFF)
                pma_init_assertion <= 1'b0;

            if(pma_init_assertion)
                pma_init_pulse_width_cnt <= pma_init_pulse_width_cnt + 24'h1;
        end



    if(EXAMPLE_SIMULATION)
    assign gt_reset_i_eff = gt_reset_i_delayed;
    else
    assign gt_reset_i_eff = pma_init_assertion ? 1'b1 : gt_reset_i_delayed;


     if(USE_LABTOOLS)
     begin:chip_reset
     assign  gt_reset_i_tmp = PMA_INIT | gtreset_from_vio_r3 | pma_init_from_fsm_r1;
     assign  reset_i  =  RESET | sysreset_from_vio_r3;
     assign  gt_reset_i = gt_reset_i_eff;
     assign  gt_rxcdrovrden_i  =  rx_cdrovrden_i;
     end
     else
     begin:no_chip_reset
     assign  gt_reset_i_tmp = PMA_INIT;
     assign  reset_i  =   RESET | gt_reset_i_tmp2;
     assign  gt_reset_i = gt_reset_i_eff;
     assign  gt_rxcdrovrden_i  =  1'b0;
     assign  loopback_i  =  3'b000;
     end

     if(!USE_LABTOOLS)
     begin
aurora_64b66b_0_rst_sync_exdes   u_rst_sync_gtrsttmpi
     (
       .prmry_in     (gt_reset_i_tmp),
       .scndry_aclk  (user_clk_i),
       .scndry_out   (gt_reset_i_tmp2)
      );
     end

     endgenerate

     //___________________________Module Instantiations_________________________________

// this is non shared mode, the clock, GT common are part of example design.
    aurora_64b66b_0_support
aurora_64b66b_0_block_i
     (
        // TX AXI4-S Interface
         .s_axi_tx_tdata(tx_tdata_i),
         .s_axi_tx_tvalid(tx_tvalid_i),
         .s_axi_tx_tready(tx_tready_i),


        // RX AXI4-S Interface
         .m_axi_rx_tdata(rx_tdata_i),
         .m_axi_rx_tvalid(rx_tvalid_i),



        // GT Serial I/O
         .rxp(RXP),
         .rxn(RXN),

         .txp(TXP),
         .txn(TXN),


        //GT Reference Clock Interface
         .refclk1_in(GTH_CLK),
        // Error Detection Interface
         .hard_err              (hard_err_i),
         .soft_err              (soft_err_i),

        // Status
         .channel_up            (channel_up_i),
         .lane_up               (lane_up_i),

        // System Interface
         .user_clk_out          (user_clk_i),

         .sync_clk_out(sync_clk_i),
         .reset_pb(reset_i),
         .gt_rxcdrovrden_in(gt_rxcdrovrden_i),
         .power_down(power_down_i),
         .loopback(loopback_i),
         .pma_init(gt_reset_i),
         .gt_pll_lock(gt_pll_lock_i),

     // ---------- AXI4-Lite input signals ---------------
         .s_axi_awaddr(s_axi_awaddr_i),
         .s_axi_awvalid(s_axi_awvalid_i),
         .s_axi_awready(s_axi_awready_i),
         .s_axi_wdata(s_axi_wdata_i),
         .s_axi_wstrb(s_axi_wstrb_i),
         .s_axi_wvalid(s_axi_wvalid_i),
         .s_axi_wready(s_axi_wready_i),
         .s_axi_bvalid(s_axi_bvalid_i),
         .s_axi_bresp(s_axi_bresp_i),
         .s_axi_bready(s_axi_bready_i),
         .s_axi_araddr(s_axi_araddr_i),
         .s_axi_arvalid(s_axi_arvalid_i),
         .s_axi_arready(s_axi_arready_i),
         .s_axi_rdata(s_axi_rdata_i),
         .s_axi_rvalid(s_axi_rvalid_i),
         .s_axi_rresp(s_axi_rresp_i),
         .s_axi_rready(s_axi_rready_i),

         .init_clk                              (INIT_CLK_i),
         .link_reset_out                        (link_reset_i),
         .mmcm_not_locked_out                   (pll_not_locked_i),


           .bufg_gt_clr_out                 (bufg_gt_clr_out),


         .sys_reset_out                            (system_reset_i),
         .tx_out_clk                               (tx_out_clk_i),

         //------------------------add----------------------------//
         .qpll1_lock_quad1_out(qpll1_lock_quad1_out),
         .gt_qpllclk_quad1_i(gt_qpllclk_quad1_i),
         .gt_qpllrefclk_quad1_i(gt_qpllrefclk_quad1_i),
         .qpll1_refclklost1_out(qpll1_refclklost1_out),
         .gt_to_common_qpllreset_i(gt_to_common_qpllreset_i)
     );


generate
 if (USE_CORE_TRAFFIC==1)
 begin : core_traffic

     //_____________________________ TX AXI SHIM _______________________________
/*aurora_64b66b_0_EXAMPLE_LL_TO_AXI #
     (
        .DATA_WIDTH(64),
        .STRB_WIDTH(8),
        .USE_4_NFC (0),
        .REM_WIDTH (3)
     )

     frame_gen_ll_to_axi_data_i
     (
      // LocalLink input Interface
      .LL_IP_DATA(tx_d_i),
      .LL_IP_SOF_N(),
      .LL_IP_EOF_N(),
      .LL_IP_REM(),
      .LL_IP_SRC_RDY_N(tx_src_rdy_n_i),
      .LL_OP_DST_RDY_N(tx_dst_rdy_n_i),

      // AXI4-S output signals
      .AXI4_S_OP_TVALID(tx_tvalid_i),
      .AXI4_S_OP_TDATA(tx_tdata_i),
      .AXI4_S_OP_TKEEP(),
      .AXI4_S_OP_TLAST(),
      .AXI4_S_IP_TREADY(tx_tready_i)
     );





    // Frame Generator to provide with input to TX_Stream
aurora_64b66b_0_FRAME_GEN frame_gen_i
    (
         .TX_D(tx_d_i),
         .TX_SRC_RDY_N(tx_src_rdy_n_i),
         .TX_DST_RDY_N(tx_dst_rdy_n_i),

         .USER_DATA(TX_DATA),
         .USER_DATA_VALID(TX_DATA_VALID),

         .CHANNEL_UP(channel_up_i),
         .USER_CLK(user_clk_i),
         .RESET(reset2FrameGenCheck)
    );*/

     //_____________________________ RX AXI SHIM _______________________________
aurora_64b66b_0_EXAMPLE_AXI_TO_LL #
     (
        .DATA_WIDTH(64),
        .STRB_WIDTH(8),
        .ISUFC(0),
        .REM_WIDTH (3)
     )
     frame_chk_axi_to_ll_data_i
     (
      // AXI4-S input signals
      .AXI4_S_IP_TX_TVALID(rx_tvalid_i),
      .AXI4_S_IP_TX_TREADY(),
      .AXI4_S_IP_TX_TDATA(rx_tdata_i),
      .AXI4_S_IP_TX_TKEEP(8'd0),
      .AXI4_S_IP_TX_TLAST(1'b0),

      // LocalLink output Interface
      .LL_OP_DATA(rx_d_i),
      .LL_OP_SOF_N(),
      .LL_OP_EOF_N() ,
      .LL_OP_REM() ,
      .LL_OP_SRC_RDY_N(rx_src_rdy_n_i),
      .LL_IP_DST_RDY_N(1'b0),

      // System Interface
      .USER_CLK(user_clk_i),
      .RESET(reset2FrameGenCheck),
      .CHANNEL_UP(channel_up_i)
      );



    // Frame Checker to check output from RX_Stream
aurora_64b66b_0_FRAME_CHECK frame_check_i
    (
         .RX_D(rx_d_i),
         .RX_SRC_RDY_N(rx_src_rdy_n_i),
         .DATA_ERR_COUNT(data_err_count_o),



         .CHANNEL_UP(channel_up_i),
         .USER_CLK(user_clk_i),
         .RESET(reset2FrameGenCheck)
    );
    
 end //end USE_CORE_TRAFFIC=1 block
 else
 begin: no_traffic
     //define traffic generation modules here
 end //end USE_CORE_TRAFFIC=0 block

endgenerate //End generate for USE_CORE_TRAFFIC

     always @(posedge user_clk_i)
         if (reset2FrameGenCheck)
             rx_tvalid_r <=  `DLY 1'b0;
         else if (rx_tvalid_i)
         	 rx_tvalid_r <=  `DLY 1'b1;
         else 
         	 rx_tvalid_r <=  `DLY rx_tvalid_r;


     always @(posedge user_clk_i)
         if (reset2FrameGenCheck)
             usr_clk_counter <=  `DLY 'd0;
         else if (usr_clk_counter >= USR_CLK_PCOUNT)
         	 usr_clk_counter <=  `DLY USR_CLK_PCOUNT;
         else 
         	 usr_clk_counter <=  `DLY usr_clk_counter + 1'b1;

     assign usr_clk_count_done = (usr_clk_counter >= USR_CLK_PCOUNT)? 1'b1:1'b0;

    reg usr_clk_count_done_r;
    reg usr_clk_count_done_r2;     

     always @(posedge user_clk_i)
             usr_clk_count_done_r <=  `DLY usr_clk_count_done;

     always @(posedge user_clk_i)
             usr_clk_count_done_r2 <=  `DLY usr_clk_count_done_r;


//------------------------------------------------------------------------------
 endmodule
