 //////////////////////////////////////////////////////////////////////////////
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
 //////////////////////////////////////////////////////////////////////////////
 //
 //  FRAME CHECK
 //
 //
 //
 //  Description: This module is a  pattern checker to test the Aurora
 //               designs in hardware. The frames generated by FRAME_GEN
 //               pass through the Aurora channel and arrive at the frame checker 
 //               through the RX User interface. Every time an error is found in
 //               the data recieved, the error count is incremented until it 
 //               reaches its max value.
 //////////////////////////////////////////////////////////////////////////////
 
 `timescale 1 ns / 10 ps
 `define DLY #1
 
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_64b66b_0_FRAME_CHECK
 (
     // User Interface
     RX_D,  
     RX_SRC_RDY_N,  
     DATA_ERR_COUNT,
 
 
 
     // System Interface
     CHANNEL_UP,
     USER_CLK,       
     RESET
   
 );
 //*********************** Parameter Declarations************************
     parameter            AURORA_LANES    = 1;
     parameter            LANE_DATA_WIDTH = (AURORA_LANES*64);
     parameter            REM_BUS         = 3;
     parameter            DATA_WIDTH      = 8;
 
 //***********************************Port Declarations*******************************
     //PDU Interface
     input     [0:LANE_DATA_WIDTH-1]    RX_D;
     input                              RX_SRC_RDY_N; 
     
     //System Interface
     input                              CHANNEL_UP; 
     input                              USER_CLK; 
     input                              RESET;  
     output    [0:DATA_WIDTH-1]         DATA_ERR_COUNT;
 
 //***************************Internal Register Declarations*************************** 
     reg     [0:LANE_DATA_WIDTH-1]    rx_d_reg;
     reg                              rx_src_rdy_n_reg; 
     reg       [0:DATA_WIDTH-1]        data_err_count_r; 
     reg       [0:AURORA_LANES-1]                  data_err_r;
 
     //PDU interface signals
     reg       [0:15]                   pdu_lfsr_r;
     wire      [LANE_DATA_WIDTH-1:0]    pdu_cmp_data_w;
     wire      [0:LANE_DATA_WIDTH-1]    pdu_cmp_data_w_r;
     wire      [0:AURORA_LANES-1]                   data_err_c;
     wire                               reset_i; 
     wire                               RESET_ii; 


 //*********************************Main Body of Code**********************************
 
   assign reset_i = RESET || (!CHANNEL_UP);
   assign resetUFC = reset_i; 

    assign RESET_ii = RESET ; 

  /*****************************PDU Data Genetration & Checking**********************/


     
     always @ (posedge USER_CLK)
       begin
         rx_d_reg <= `DLY RX_D;
         rx_src_rdy_n_reg <= `DLY RX_SRC_RDY_N;
       end

     //Generate the PDU data using LFSR for data comparision
     always @ (posedge USER_CLK)
        if(reset_i)
          pdu_lfsr_r  <=  `DLY  16'hABCD;
        else if(!rx_src_rdy_n_reg)
          pdu_lfsr_r  <=  `DLY  {!{pdu_lfsr_r[3]^pdu_lfsr_r[12]^pdu_lfsr_r[14]^pdu_lfsr_r[15]}, 
                            pdu_lfsr_r[0:14]};
 
     assign pdu_cmp_data_w = {AURORA_LANES*4{pdu_lfsr_r}};

     assign pdu_cmp_data_w_r = {
       pdu_cmp_data_w[63], 
       pdu_cmp_data_w[62], 
       pdu_cmp_data_w[61], 
       pdu_cmp_data_w[60], 
       pdu_cmp_data_w[59], 
       pdu_cmp_data_w[58], 
       pdu_cmp_data_w[57], 
       pdu_cmp_data_w[56], 
       pdu_cmp_data_w[55], 
       pdu_cmp_data_w[54], 
       pdu_cmp_data_w[53], 
       pdu_cmp_data_w[52], 
       pdu_cmp_data_w[51], 
       pdu_cmp_data_w[50], 
       pdu_cmp_data_w[49], 
       pdu_cmp_data_w[48], 
       pdu_cmp_data_w[47], 
       pdu_cmp_data_w[46], 
       pdu_cmp_data_w[45], 
       pdu_cmp_data_w[44], 
       pdu_cmp_data_w[43], 
       pdu_cmp_data_w[42], 
       pdu_cmp_data_w[41], 
       pdu_cmp_data_w[40], 
       pdu_cmp_data_w[39], 
       pdu_cmp_data_w[38], 
       pdu_cmp_data_w[37], 
       pdu_cmp_data_w[36], 
       pdu_cmp_data_w[35], 
       pdu_cmp_data_w[34], 
       pdu_cmp_data_w[33], 
       pdu_cmp_data_w[32], 
       pdu_cmp_data_w[31], 
       pdu_cmp_data_w[30], 
       pdu_cmp_data_w[29], 
       pdu_cmp_data_w[28], 
       pdu_cmp_data_w[27], 
       pdu_cmp_data_w[26], 
       pdu_cmp_data_w[25], 
       pdu_cmp_data_w[24], 
       pdu_cmp_data_w[23], 
       pdu_cmp_data_w[22], 
       pdu_cmp_data_w[21], 
       pdu_cmp_data_w[20], 
       pdu_cmp_data_w[19], 
       pdu_cmp_data_w[18], 
       pdu_cmp_data_w[17], 
       pdu_cmp_data_w[16], 
       pdu_cmp_data_w[15], 
       pdu_cmp_data_w[14], 
       pdu_cmp_data_w[13], 
       pdu_cmp_data_w[12], 
       pdu_cmp_data_w[11], 
       pdu_cmp_data_w[10], 
       pdu_cmp_data_w[9], 
       pdu_cmp_data_w[8], 
       pdu_cmp_data_w[7], 
       pdu_cmp_data_w[6], 
       pdu_cmp_data_w[5], 
       pdu_cmp_data_w[4], 
       pdu_cmp_data_w[3], 
       pdu_cmp_data_w[2], 
       pdu_cmp_data_w[1], 
       pdu_cmp_data_w[0] 
     };

  assign data_err_c[0] = (!rx_src_rdy_n_reg && (rx_d_reg[0:63] != pdu_cmp_data_w_r[0:63]));      

   always @(posedge USER_CLK)
     data_err_r    <=  `DLY    data_err_c; 

     always @ (posedge USER_CLK)
     begin	       
       if(reset_i)
         data_err_count_r <= `DLY 8'b0;
       else if(&data_err_count_r)
         data_err_count_r <= `DLY data_err_count_r;
       else if (|data_err_r)
         data_err_count_r <= `DLY (data_err_count_r + 1);   	 
     end

   assign  DATA_ERR_COUNT =   data_err_count_r;

 
 endmodule           
