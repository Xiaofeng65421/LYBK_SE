module XPM_SDP_BRAM # (
    parameter       P_ADDR_WIDTH_A  =   8               ,
    parameter       P_ADDR_WIDTH_B  =   8               ,
    parameter       P_DATA_WIDTH_A  =   32              ,
    parameter       P_DATA_WIDTH_B  =   32              ,
    parameter       P_BYTE_DEPTH    =   4               ,
    parameter       P_CLOCKING_MODE = "common_clock"
) (
    input                           clka                ,
    input     [P_BYTE_DEPTH-1:0]    wea                 ,
    input   [P_ADDR_WIDTH_A-1:0]    addra               ,
    input   [P_DATA_WIDTH_A-1:0]    dina                ,
    input                           clkb                ,
    input   [P_ADDR_WIDTH_B-1:0]    addrb               ,
    output  [P_DATA_WIDTH_B-1:0]    doutb
);

    localparam P_BYTE_SIZE   = P_DATA_WIDTH_A / P_BYTE_DEPTH;
    localparam P_MEMORY_SIZE = (1 << P_ADDR_WIDTH_A) * P_DATA_WIDTH_A;

    // xpm_memory_sdpram: Simple Dual Port RAM
    // Xilinx Parameterized Macro, version 2018.1
    xpm_memory_sdpram #(
        .ADDR_WIDTH_A               ( P_ADDR_WIDTH_A    ), // DECIMAL
        .ADDR_WIDTH_B               ( P_ADDR_WIDTH_B    ), // DECIMAL
        .AUTO_SLEEP_TIME            ( 0                 ), // DECIMAL
        .BYTE_WRITE_WIDTH_A         ( P_BYTE_SIZE       ), // DECIMAL
        .CLOCKING_MODE              ( "common_clock"    ), // String
        .ECC_MODE                   ( "no_ecc"          ), // String
        .MEMORY_INIT_FILE           ( "none"            ), // String
        .MEMORY_INIT_PARAM          ( "0"               ), // String
        .MEMORY_OPTIMIZATION        ( "true"            ), // String
        .MEMORY_PRIMITIVE           ( "auto"            ), // String
        .MEMORY_SIZE                ( P_MEMORY_SIZE     ), // DECIMAL
        .MESSAGE_CONTROL            ( 0                 ), // DECIMAL
        .READ_DATA_WIDTH_B          ( P_DATA_WIDTH_B    ), // DECIMAL
        .READ_LATENCY_B             ( 2                 ), // DECIMAL
        .READ_RESET_VALUE_B         ( "0"               ), // String
        .USE_EMBEDDED_CONSTRAINT    ( 0                 ), // DECIMAL
        .USE_MEM_INIT               ( 0                 ), // DECIMAL
        .WAKEUP_TIME                ( "disable_sleep"   ), // String
        .WRITE_DATA_WIDTH_A         ( P_DATA_WIDTH_A    ), // DECIMAL
        .WRITE_MODE_B               ( "no_change"       )  // String
    )
    xpm_memory_sdpram_inst (
        .dbiterrb                   ( dbiterrb          ), // 1-bit output: Status signal to indicate double bit error occurrence
        // on the data output of port B.
        .doutb                      ( doutb             ), // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
        .sbiterrb                   ( sbiterrb          ), // 1-bit output: Status signal to indicate single bit error occurrence
        // on the data output of port B.
        .addra                      ( addra             ), // ADDR_WIDTH_A-bit input: Address for port A write operations.
        .addrb                      ( addrb             ), // ADDR_WIDTH_B-bit input: Address for port B read operations.
        .clka                       ( clka              ), // 1-bit input: Clock signal for port A. Also clocks port B when
        // parameter CLOCKING_MODE is "common_clock".
        .clkb                       ( clkb              ), // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
        // "independent_clock". Unused when parameter CLOCKING_MODE is
        // "common_clock".
        .dina                       ( dina              ), // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
        .ena                        ( 1'b1              ), // 1-bit input: Memory enable signal for port A. Must be high on clock
        // cycles when write operations are initiated. Pipelined internally.
        .enb                        ( 1'b1              ), // 1-bit input: Memory enable signal for port B. Must be high on clock
        // cycles when read operations are initiated. Pipelined internally.
        .injectdbiterra             ( 1'b0              ), // 1-bit input: Controls double bit error injection on input data when
        // ECC enabled (Error injection capability is not available in
        // "decode_only" mode).
        .injectsbiterra             ( 1'b0              ), // 1-bit input: Controls single bit error injection on input data when
        // ECC enabled (Error injection capability is not available in
        // "decode_only" mode).
        .regceb                     ( 1'b1              ), // 1-bit input: Clock Enable for the last register stage on the output
        // data path.
        .rstb                       ( 1'b0              ), // 1-bit input: Reset signal for the final port B output register stage.
        // Synchronously resets output port doutb to the value specified by
        // parameter READ_RESET_VALUE_B.
        .sleep                      ( 1'b0              ), // 1-bit input: sleep signal to enable the dynamic power saving feature.
        .wea                        ( wea               ) // WRITE_DATA_WIDTH_A-bit input: Write enable vector for port A input
        // data port dina. 1 bit wide when word-wide writes are used. In
        // byte-wide write configurations, each bit controls the writing one
        // byte of dina to address addra. For example, to synchronously write
        // only bits [15-8] of dina when WRITE_DATA_WIDTH_A is 32, wea would be
        // 4'b0010.
    );
    // End of xpm_memory_sdpram_inst instantiation

endmodule