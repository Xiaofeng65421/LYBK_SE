`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/10/11 13:48:14
// Design Name: 
// Module Name: UartRx
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


module UartRx #(
        parameter   BR_DIV = 1736,  // 115200 @ 200M
        parameter   PARITY = 0    // parity: 0 - none£¬1 - even, 2 - odd
    )(
        input   wire    clk, rst,
        input   wire    rxd,
        output  logic   [7:0]   dout,
(*mark_debug = "true"*)     output  logic   dout_valid,
(*mark_debug = "true"*)     output  logic   par_err, busy
    );  
        logic   rxd_falling, rxd_reg;
        Falling2En #(2) theFallingDet(clk, rxd, rxd_falling, rxd_reg);
        //bitrate counter & bit counter
        localparam   [3:0]   BC_MAX = PARITY? 4'd9: 4'd8;
(*mark_debug = "true"*)         logic   br_en, bit_co;
        logic   [$clog2(BR_DIV) - 1:0]  br_cnt;
        Counter #(BR_DIV) theBrCnt (clk, rst | (rxd_falling & ~busy), busy, br_cnt, br_en);
        Counter #(BC_MAX + 1)theBitCnt(clk, rst, br_en, , bit_co);
        // busy driven
        always_ff@(posedge clk) begin
            if(rst) busy <= 1'b0;
            else if(bit_co) busy <= 1'b0;
            else if(rxd_falling) busy <= 1'b1;
        end
        // data sampling
//        logic [8:0]  shift_reg;
//        always_ff@(posedge clk) begin
//            if(rst) shift_reg <= '0;
//            //sampling  at middle of data bit
//            else if(br_cnt == BR_DIV/2)
//                shift_reg <= {rxd_reg, shift_reg[8:1]};
//        end
       
       logic  [6:0]  st_rxd_reg;
       logic   filt_rxd_reg;
       always_ff@(posedge clk) begin
            if(rst) st_rxd_reg <= '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
            //sampling  at middle of data bit
            else if(br_cnt == 1 * BR_DIV/16)
                st_rxd_reg[0] <= rxd_reg;
            else if(br_cnt == 2 * BR_DIV/16)
                st_rxd_reg[1] <= rxd_reg;
            else if(br_cnt == 3 * BR_DIV/16)
                st_rxd_reg[2] <= rxd_reg;
            else if(br_cnt == 4 * BR_DIV/16)
                st_rxd_reg[3] <= rxd_reg;
            else if(br_cnt == 5 * BR_DIV/16)
                st_rxd_reg[4] <= rxd_reg;
            else if(br_cnt == 6 * BR_DIV/16)
                st_rxd_reg[5] <= rxd_reg;
            else if(br_cnt == 7 * BR_DIV/16)
                st_rxd_reg[6] <= rxd_reg;  
            else if(br_cnt == 9 * BR_DIV/16) st_rxd_reg <= '{1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        end
        
        always_ff@(posedge clk) begin
            if(rst) filt_rxd_reg <= 1'b0;
            //sampling  at middle of data bit
            else if(br_cnt == BR_DIV/2 - 2)
                filt_rxd_reg <= ((FiltData(st_rxd_reg) > 3'd7)? 1'b1: 1'b0);
            else if(br_cnt == 9 * BR_DIV/16) filt_rxd_reg <= 1'b0;
        end
        
        integer i;
        
        function  automatic [3:0]  FiltData (input [6:0]   data); 
                   FiltData = 7;
                   for(i = 0; i < 7 ; i = i + 1) begin
                       if(data[i] == 1)  FiltData = FiltData + 1;
                       else if(data[i] == 0) FiltData = FiltData - 1;
                   end           
        endfunction 
         
        logic [8:0]  shift_reg;
        always_ff@(posedge clk) begin
            if(rst) shift_reg <= '0;
            //sampling  at middle of data bit
            else if(br_cnt == BR_DIV/2)
                shift_reg <= {filt_rxd_reg, shift_reg[8:1]};
        end
        
        
        //output    
        always_ff@(posedge clk) begin
            if(rst) begin
                dout <= 8'd0; dout_valid <= 1'b0; par_err <= 1'b0;
            end
            else if(bit_co) begin
                dout_valid <= 1'b1;
                case(PARITY) 
                    1: {par_err,dout} <= {^shift_reg, shift_reg[7:0]};
                    2: {par_err,dout} <= {~^shift_reg, shift_reg[7:0]};
                    default: {par_err,dout} <= {1'b0, shift_reg[8:1]};
               endcase
            end
            else dout_valid <= 1'b0;
      end
      
endmodule
