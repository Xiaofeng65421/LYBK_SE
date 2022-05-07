module FETCH_USER_DATA (
    //          --- system I/F ---
    input   wire            CLK100M                     ,   // User clock
    input   wire            CLK156M                     ,   // Tx clock
    input   wire            SiTCP_RESET                 ,   // System reset
    input   wire    [7:0]   TX_RATE                     ,   // Transmission data rate in units of 100 Mbps
    input   wire    [63:0]  NUM_OF_DATA                 ,   // Number of bytes of transmitted data
    input   wire            DATA_GEN                    ,   // Data transmission enable
    input   wire            LOOPBACK                    ,   // Loopback mode
    input   wire    [ 2:0]  WORD_LEN                    ,   // Word length of test data
    input   wire            SELECT_SEQ                  ,   // Sequence Data select
    input   wire    [31:0]  SEQ_PATTERN                 ,   // sequence data(The default value is 0x60808040)
    input   wire    [23:0]  BLK_SIZE                    ,   // Transmission block size in bytes
    input   wire            INS_ERROR                   ,   // Data error insertion
    //          --- FIFO I/F ---
    output  wire    [63: 0] RX_FIFO_DOUT                ,
    input   wire            RX_FIFO_RD_REQ              ,
    output  wire            RX_FIFO_VALID               ,
    input   wire            FIFO_LOOPBACK               ,
    //          --- DDR I/F ---
    input   wire    [63: 0] DDR_RD_DATA                    ,
    output  wire            DDR_RD_REQ             ,
    input   wire            DDR_RD_VALID              ,
    //          --- SiTCP-XG I/F ---
    input   wire            USER_SESSION_ESTABLISHED    ,   // Establish of a session
    output  wire    [15:0]  USER_RX_SIZE                ,   // Receive buffer size(byte) caution:Set a value of 4000 or more and (memory size-16) or less
    input   wire            USER_RX_CLR_ENB             ,   // Receive buffer Clear Enable
    output  wire            USER_RX_CLR_REQ             ,   // Receive buffer Clear Request
    output  wire    [15:0]  USER_RX_RADR                ,   // Receive buffer read address in bytes (unused upper bits are set to 0)
    input   wire    [15:0]  USER_RX_WADR                ,   // Receive buffer write address in bytes (lower 3 bits are not connected to memory)
    input   wire    [ 7:0]  USER_RX_WENB                ,   // Receive buffer byte write enable (big endian)
    input   wire    [63:0]  USER_RX_WDAT                ,   // Receive buffer write data (big endian)
    input   wire            USER_TX_AFULL               ,   // TX fifo, almost full
    output  wire    [63:0]  USER_TX_D                   ,   // Tx data[63:0]
    output  wire    [ 3:0]  USER_TX_B                       // Byte length of USER_TX_DATA, one-based(zero means 8 bytes)
);

    reg     [ 7:0]  irTxRate        ;
    reg     [64:0]  irNumOfData     ;
    reg             irDataGen       ;
    reg             irLoopback      ;
    reg     [ 8:0]  sftWordLen      ;
    reg     [ 3:0]  irWordLen       ;
    reg             irSelectSeq     ;
    reg     [31:0]  irSeqPattern    ;
    reg     [24:0]  irBlockSize     ;
    reg     [ 2:0]  sftInsError     ;
    reg             irInsError      ;
    reg             irEstablished   ;
    reg             irTxAlmostFull  ;

    wire    [ 3:0]  MEM_REN         ;
    wire    [63:0]  MEM_RDT         ;

    reg     [ 3:0]  P0_MEM_LEN      ;
    reg     [ 2:0]  P0_MEM_POS      ;
    reg     [ 3:0]  P1_MEM_LEN      ;
    reg     [ 2:0]  P1_MEM_POS      ;
    reg     [63:0]  irRxD           ;
    reg     [ 3:0]  irRxB           ;

    wire            TxEnable        ;
    reg             genEnb          ;
    reg     [24:0]  BlockCount      ;
    reg     [64:0]  TxCount         ;
    reg     [ 5:0]  RateCount       ;
    reg     [ 8:0]  AddToken        ;
    reg     [31:0]  Bucket          ;
    reg     [31:0]  SeqWordLen      ;
    reg     [ 3:0]  prWordLen       ;
    reg     [31:0]  genWordLen      ;
    reg     [ 7:0]  genCntCy        ;
    reg     [ 7:0]  genCntr         ;
    reg     [ 3:0]  muxTxB          ;
    reg     [ 3:0]  LastTxB         ;
    reg     [63:0]  muxTxD          ;
    reg     [63:0]  orTxD           ;
    reg     [ 3:0]  orTxB           ;

    wire            gen_nonblocking ;

    reg     [ 3: 0] srst_r          ;

    reg             P0_MEM_REN3     ;
    reg             P1_MEM_REN3     ;
(* MARK_DEBUG="true" *)    reg     [63: 0] rRX_FIFO_DIN    ;
(* MARK_DEBUG="true" *)    reg             rRX_FIFO_WR_EN  ;
    wire            RX_FIFO_RD_EN   ;
    wire            RX_FIFO_EMPTY   ;
(* MARK_DEBUG="true" *)    wire            RX_FIFO_PFULL   ;
    reg             RX_FIFO_PFULL_r ;

(* MARK_DEBUG="true" *)    reg     [63: 0] rTX_FIFO_DIN    ;
(* MARK_DEBUG="true" *)    reg             rTX_FIFO_WR_EN  ;
    wire    [63: 0] TX_FIFO_DOUT    ;
    wire            TX_FIFO_VALID   ;
    wire            TX_FIFO_AFULL   ;

//------------------------------------------------------------------------------
//  Input buffer
//------------------------------------------------------------------------------
    always @(posedge CLK156M) begin
        irTxRate[7:0]       <= TX_RATE[7:0];
        irNumOfData[64:0]   <= {1'b1,NUM_OF_DATA[63:0]} - 65'd1;
        irDataGen           <= DATA_GEN;
        irLoopback          <= LOOPBACK;
        sftWordLen[2:0]     <= WORD_LEN[2:0];
        sftWordLen[5:3]     <= sftWordLen[2:0];
        sftWordLen[8:6]     <= sftWordLen[5:3];
        irWordLen[3:0]      <= {1'b0,sftWordLen[8:6]} + 4'd1;
        irSelectSeq         <= SELECT_SEQ;
        irSeqPattern[31:0]  <= SEQ_PATTERN[31:0];
        irBlockSize[24:0]   <= {1'b1,BLK_SIZE[23:0]} - 25'd1;
        sftInsError[2:0]    <= {sftInsError[1:0],INS_ERROR};
        irInsError          <= sftInsError[2];
        irEstablished       <= USER_SESSION_ESTABLISHED;
        irTxAlmostFull      <= USER_TX_AFULL;
    end
//------------------------------------------------------------------------------
    always @(posedge CLK100M) begin
        srst_r[3:0]  <= {srst_r[2:0], SiTCP_RESET};
    end

    assign srst = srst_r[3];

//------------------------------------------------------------------------------
//  Controller
//------------------------------------------------------------------------------
    localparam BUF_ADDR_WIDTH = 16; // 11~16
    localparam BUF_DATA_SIZE  = (1 << BUF_ADDR_WIDTH); // Byte
    reg [BUF_ADDR_WIDTH-1:0]  MEM_RAD = {BUF_ADDR_WIDTH{1'b0}};

    vio_SiTCP vio_SiTCP (
        .clk        (CLK156M                            ),
        .probe_in0  (USER_SESSION_ESTABLISHED           ),
        .probe_out0 (USER_RX_SIZE[BUF_ADDR_WIDTH-1:0]   ),
        .probe_out1 (gen_nonblocking                    )
    );

    // assign      USER_RX_SIZE[15:0]   = DATA_SIZE - 16;   // Byte
    assign      USER_RX_CLR_REQ      = USER_RX_CLR_ENB;
    assign      USER_RX_RADR[BUF_ADDR_WIDTH-1:0]   = MEM_RAD[BUF_ADDR_WIDTH-1:0];
    assign      MEM_REN[3]      = ((irTxAlmostFull | RX_FIFO_PFULL_r) & irEstablished)? 1'b0:           (MEM_RAD[BUF_ADDR_WIDTH-1:3] != USER_RX_WADR[BUF_ADDR_WIDTH-1:3]);
    assign      MEM_REN[2:0]    = ((irTxAlmostFull | RX_FIFO_PFULL_r) & irEstablished)? MEM_RAD[2:0]:   USER_RX_WADR[2:0];

    always @(posedge CLK156M) begin
        MEM_RAD[ 2:0]   <= USER_RX_CLR_REQ?      USER_RX_WADR[2:0]:       (MEM_REN[3]?    3'b000:     MEM_REN[2:0]);
        MEM_RAD[BUF_ADDR_WIDTH-1:3]   <= USER_RX_CLR_REQ?      USER_RX_WADR[BUF_ADDR_WIDTH-1:3]:      (MEM_RAD[BUF_ADDR_WIDTH-1:3] + {8'd0,MEM_REN[3]});
        P0_MEM_LEN[3]   <= MEM_REN[3] & (MEM_RAD[2:0] == 3'd0);
        P0_MEM_LEN[2:0] <= (MEM_REN[3]?     3'd0:   MEM_REN[2:0]) - MEM_RAD[2:0];
        P0_MEM_POS[2:0] <= MEM_RAD[2:0];
        P1_MEM_LEN[3:0] <= P0_MEM_LEN[3:0];
        P1_MEM_POS[2:0] <= P0_MEM_POS[2:0];
    end

    XPM_SDP_BRAM # (
        .P_ADDR_WIDTH_A     ( BUF_ADDR_WIDTH-3                  ),
        .P_ADDR_WIDTH_B     ( BUF_ADDR_WIDTH-3                  ),
        .P_DATA_WIDTH_A     ( 64                                ),
        .P_DATA_WIDTH_B     ( 64                                ),
        .P_BYTE_DEPTH       ( 8                                 ),
        .P_CLOCKING_MODE    ("common_clock"                     )
    )
    RX_BUF (
        .clka               ( CLK156M                           ),
        .wea                ( USER_RX_WENB[7:0]                 ),
        .addra              ( USER_RX_WADR[BUF_ADDR_WIDTH-1:3]  ),
        .dina               ( USER_RX_WDAT[63:0]                ),
        .clkb               (                                   ),
        .addrb              ( MEM_RAD[BUF_ADDR_WIDTH-1:3]       ),
        .doutb              ( MEM_RDT[63:0]                     )
    );

    always @(posedge CLK156M) begin
        irRxD[63:0]     <= (
            ((P1_MEM_POS[2:0] == 3'd0)?     MEM_RDT[63:0]:                      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd1)?     {MEM_RDT[55:0],MEM_RDT[ 7:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd2)?     {MEM_RDT[47:0],MEM_RDT[15:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd3)?     {MEM_RDT[39:0],MEM_RDT[23:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd4)?     {MEM_RDT[31:0],MEM_RDT[31:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd5)?     {MEM_RDT[23:0],MEM_RDT[39:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd6)?     {MEM_RDT[15:0],MEM_RDT[47:0]}:      64'd0)|
            ((P1_MEM_POS[2:0] == 3'd7)?     {MEM_RDT[ 7:0],MEM_RDT[55:0]}:      64'd0)
        );
        irRxB[3:0]      <= P1_MEM_LEN[3:0];
    end

    always @(posedge CLK156M) begin
        orTxD[63:0] <=  irLoopback  ?   irRxD[63:0]:
                        irDataGen   ?   muxTxD[63:0]:
                        FIFO_LOOPBACK ? TX_FIFO_DOUT[63:0]:
                        DDR_RD_DATA[63:0];
        orTxB[3:0]  <=  irLoopback  ?   irRxB[3:0]:
                        irDataGen   ?   muxTxB[3:0]:
                        FIFO_LOOPBACK ? {TX_FIFO_VALID,3'b000}:
                        {DDR_RD_VALID,3'b000};
    end

    assign  USER_TX_D[63:0] = orTxD[63:0];
    assign  USER_TX_B[3:0]  = orTxB[3:0];
    assign  DDR_RD_REQ      = irEstablished & ~irTxAlmostFull;

//------------------------------------------------------------------------------
//  Data Generator
//------------------------------------------------------------------------------
    assign  TxEnable    = genEnb & BlockCount[24] & TxCount[64];
    always @(posedge CLK156M) begin
        genEnb                  <= irEstablished & (~irTxAlmostFull | gen_nonblocking) & irDataGen;
        BlockCount[24:0]        <= (irEstablished & (Bucket[31]|BlockCount[24]))?       (BlockCount[24:0] - {21'd0,(TxEnable?   genWordLen[31:28]:  4'd0)}):    irBlockSize[24:0];
        if(!irEstablished)begin
            TxCount[64:0]       <= irNumOfData[64:0];
            RateCount[5:0]      <= 6'd0;
            AddToken[8:0]       <= 9'd0;
            Bucket[31:0]        <= 32'd0;
        end else begin
            TxCount[64:0]       <= TxCount[64:0] - {61'd0,(TxEnable?    genWordLen[31:28]:  4'd0)};
            RateCount[5:0]      <= RateCount[5:0] - (RateCount[5]?  6'd23:      6'b11_1110);
            AddToken[8:0]       <= {1'b0,((RateCount[5] & (Bucket[31:30] != 2'b01))?    irTxRate[7:0]:  8'd0)} - {5'd0,(TxEnable?   genWordLen[31:28]:  4'd0)};
            Bucket[31:0]        <= Bucket[31:0] + {{24{AddToken[8]}},AddToken[7:0]};
        end
    end

    always @(posedge CLK156M) begin
        if(!irEstablished)begin
            SeqWordLen[31:0]    <= irSeqPattern[31:0];
            prWordLen[3:0]      <= 4'h0;
            genWordLen[31:0]    <= 32'h0000_0000;
            genCntCy[7:0]       <= 8'b0000_0000;
            genCntr[7:0]        <= 8'd1;
        end else begin
            if(TxEnable)begin
                SeqWordLen[31:0]            <= irSelectSeq?     {SeqWordLen[27:0],SeqWordLen[31:28]}:       SeqWordLen[31:0];
                prWordLen[ 3:0]             <= irSelectSeq?     SeqWordLen[31:28]:      irWordLen[3:0];
                genWordLen[31:28]           <= prWordLen[3:0];
                genWordLen[27:24]           <= prWordLen[3:0] + 4'd1;
                genWordLen[23:20]           <= prWordLen[3:0] + 4'd2;
                genWordLen[19:16]           <= prWordLen[3:0] + 4'd3;
                genWordLen[15:12]           <= prWordLen[3:0] + 4'd4;
                genWordLen[11: 8]           <= prWordLen[3:0] + 4'd5;
                genWordLen[ 7: 4]           <= prWordLen[3:0] + 4'd6;
                genWordLen[ 3: 0]           <= prWordLen[3:0] + 4'd7;
                {genCntCy[7],genCntr[7:0]}  <= {1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[31:28]} + {8'b0_0000_000,genCntCy[7]};
                genCntCy[6]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[27:24]}) > 9'h0ff;
                genCntCy[5]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[23:20]}) > 9'h0ff;
                genCntCy[4]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[19:16]}) > 9'h0ff;
                genCntCy[3]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[15:12]}) > 9'h0ff;
                genCntCy[2]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[11: 8]}) > 9'h0ff;
                genCntCy[1]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[ 7: 4]}) > 9'h0ff;
                genCntCy[0]                 <= ({1'b0,genCntr[7:0]} + {5'b0_0000,genWordLen[ 3: 0]}) > 9'h0ff;
            end
        end
    end

    always @(posedge CLK156M) begin
        muxTxB[3:0]     <= TxEnable?    genWordLen[31:28]:      4'd0;
        LastTxB[3:0]    <= TxEnable?    (TxCount[3:0] + 1'b1):  4'd0;
        if(TxEnable)begin
            muxTxD[63:56]   <= (genCntr[7:0] + ((genCntCy[7]            )?  8'd1:   8'd0)) ^ (irInsError?   8'd1:   8'd0);
            muxTxD[55:48]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[6])?  8'd2:   8'd1));
            muxTxD[47:40]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[5])?  8'd3:   8'd2));
            muxTxD[39:32]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[4])?  8'd4:   8'd3));
            muxTxD[31:24]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[3])?  8'd5:   8'd4));
            muxTxD[23:16]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[2])?  8'd6:   8'd5));
            muxTxD[15: 8]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[1])?  8'd7:   8'd6));
            muxTxD[ 7: 0]   <= (genCntr[7:0] + ((genCntCy[7]|genCntCy[0])?  8'd8:   8'd7));
        end
    end

//------------------------------------------------------------------------------
//  RX FIFO 64bit
//------------------------------------------------------------------------------
    always @(posedge CLK156M) begin
        P0_MEM_REN3         <= MEM_REN[3];
        P1_MEM_REN3         <= P0_MEM_REN3;
        rRX_FIFO_DIN[63:0]  <= MEM_RDT[63:0];
        rRX_FIFO_WR_EN      <= P1_MEM_REN3;
        RX_FIFO_PFULL_r     <= RX_FIFO_PFULL;
    end

    localparam RD_DELAY = 52;   // 183*(6.4-5)/5
    reg      [RD_DELAY-1:0] RX_FIFO_EMPTY_DELAY;

    always @(posedge CLK100M) begin
        if (RX_FIFO_EMPTY)
            RX_FIFO_EMPTY_DELAY[RD_DELAY-1:0] <= {RD_DELAY{1'b1}};
        else
            RX_FIFO_EMPTY_DELAY[RD_DELAY-1:0] <= {RX_FIFO_EMPTY_DELAY[RD_DELAY-2:0], RX_FIFO_EMPTY};
    end

    assign RX_FIFO_RD_EN = RX_FIFO_EMPTY ? 1'b0 : RX_FIFO_RD_REQ & ~(FIFO_LOOPBACK & TX_FIFO_AFULL) & ~RX_FIFO_EMPTY_DELAY[RD_DELAY-1];

    // XPM_ASYNC_FIFO # (
    //     .P_ADDR_WIDTH           ( 13                    ),
    //     .P_DATA_WIDTH           ( 64                    ),
    //     .P_PROG_EMPTY_THRESH    ( 3                     ),
    //     .P_PROG_FULL_THRESH     ( 8176                  )
    // )
    // RX_FIFO (
    //     .rst                    (SiTCP_RESET            ),
    //     .wr_clk                 (CLK156M                ),
    //     .rd_clk                 (CLK100M                ),
    //     .din                    (rRX_FIFO_DIN[63:0]     ),
    //     .wr_en                  (rRX_FIFO_WR_EN         ),
    //     .rd_en                  (RX_FIFO_RD_EN          ),
    //     .dout                   (RX_FIFO_DOUT[63:0]     ),
    //     .valid                  (RX_FIFO_VALID          ),
    //     .full                   (                       ),
    //     .empty                  (RX_FIFO_EMPTY          ),
    //     .prog_full              (                       ),
    //     .prog_empty             (                       )
    // );

    async_fifo_rx RX_FIFO (
/*        .srst           (SiTCP_RESET        ),      // input wire srst*/
        .wr_clk         (CLK156M            ),      // input wire wr_clk
        .rd_clk         (CLK100M            ),      // input wire rd_clk
        .din            (rRX_FIFO_DIN[63:0] ),      // input wire [63 : 0] din
        .wr_en          (rRX_FIFO_WR_EN     ),      // input wire wr_en
        .rd_en          (RX_FIFO_RD_EN      ),      // input wire rd_en
        .dout           (RX_FIFO_DOUT[63:0] ),      // output wire [63 : 0] dout
        .full           (                   ),      // output wire full
        .empty          (RX_FIFO_EMPTY      ),      // output wire empty
        .valid          (RX_FIFO_VALID      ),
        .prog_full      (RX_FIFO_PFULL      )      // output wire prog_full
    );

//------------------------------------------------------------------------------
//  TX FIFO 64bit
//------------------------------------------------------------------------------
    always @(posedge CLK100M) begin
        rTX_FIFO_DIN[63:0] <= RX_FIFO_DOUT[63:0];
        rTX_FIFO_WR_EN     <= RX_FIFO_VALID;
    end

    // XPM_ASYNC_FIFO # (
    //     .P_ADDR_WIDTH           ( 13                    ),
    //     .P_DATA_WIDTH           ( 64                    ),
    //     .P_PROG_EMPTY_THRESH    ( 3                     ),
    //     .P_PROG_FULL_THRESH     ( 8176                  )
    // )
    // TX_FIFO (
    //     .rst                    (srst                   ),
    //     .wr_clk                 (CLK100M                ),
    //     .rd_clk                 (CLK156M                ),
    //     .din                    (rTX_FIFO_DIN[63:0]     ),
    //     .wr_en                  (rTX_FIFO_WR_EN         ),
    //     .rd_en                  (~irTxAlmostFull        ),
    //     .dout                   (TX_FIFO_DOUT[63:0]     ),
    //     .valid                  (TX_FIFO_VALID          ),
    //     .full                   (                       ),
    //     .empty                  (                       ),
    //     .prog_full              (TX_FIFO_AFULL          ),
    //     .prog_empty             (                       )
    // );

    async_fifo_tx TX_FIFO (
        .srst           (srst                   ),      // input wire srst
        .wr_clk         (CLK100M                ),      // input wire wr_clk
        .rd_clk         (CLK156M                ),      // input wire rd_clk
        .din            (rTX_FIFO_DIN[63:0]     ),      // input wire [63 : 0] din
        .wr_en          (rTX_FIFO_WR_EN         ),      // input wire wr_en
        .rd_en          (~irTxAlmostFull        ),      // input wire rd_en
        .dout           (TX_FIFO_DOUT[63:0]     ),      // output wire [63 : 0] dout
        .full           (                       ),      // output wire full
        .empty          (                       ),      // output wire empty
        .valid          (TX_FIFO_VALID          ),      // output wire valid
        .prog_full      (TX_FIFO_AFULL          ),      // output wire prog_full
        .wr_rst_busy    (                       ),      // output wire wr_rst_busy
        .rd_rst_busy    (                       )       // output wire rd_rst_busy
    );

endmodule
