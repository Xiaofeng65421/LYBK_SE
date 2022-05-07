`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/08 11:34:53
// Design Name: 
// Module Name: TrigInFilter
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


module TrigInFilter #(
        parameter   LEGTH = 6'd5
    )(
        input    wire      clk,
        input    wire      rst,
        input    wire      TrigIn,
        output   wire      TrigIn_vald      
    );
    
        reg             TRIG_IN_en = 0;
        reg     [1:0]   TRIG_IN_r = 0;
        reg     [4:0]   cnt_TRIG_IN_r = 0;
        
        
        localparam    [1:0]     IDEL = 2'b00;
        localparam    [1:0]     WORK = 2'b01;
        localparam    [1:0]     INVALID = 2'b10;
        localparam    [1:0]     WAITE = 2'b11;
(*mark_debug = "true"*)        reg     [1:0]   state = IDEL;
        
        assign  TrigIn_vald = TRIG_IN_en;

//--------------------------TRIG_IN delay-----------------

        always @(posedge clk) begin
            if(rst) begin
                 TRIG_IN_r[0] <= 0;
                 TRIG_IN_r[1] <= 0; 
            end
            else begin
                TRIG_IN_r[0] <= TrigIn;
                TRIG_IN_r[1] <= TRIG_IN_r[0];
            end
        end
    
//-----------------------------TRIG_IN filter---------------------------

        always @(posedge clk) begin
            if(rst) begin
                    TRIG_IN_en <= 1'b0;
                    cnt_TRIG_IN_r <= 5'd0;
                    state <= IDEL;
                    end
            else begin
                case(state) 
                    IDEL: begin
                            TRIG_IN_en <= 1'b0;
                            cnt_TRIG_IN_r <= 5'd0;
                            if(TRIG_IN_r[1]) state <= WORK;
                            else state <= IDEL;
                          end
                    WORK: begin
                         if(TRIG_IN_r[1]) begin
                            cnt_TRIG_IN_r <= cnt_TRIG_IN_r + 1'b1;
                            if(cnt_TRIG_IN_r == LEGTH) begin
                                TRIG_IN_en <= 1'b1;
                                state <= WAITE;
                                cnt_TRIG_IN_r <= 5'd0;
                            end
                          end
                          else if(cnt_TRIG_IN_r < LEGTH && ~TRIG_IN_r[1])  begin    // TRiOk 100ns £º >= 80ns valid 
                            state <= INVALID;
                            TRIG_IN_en <= 1'b0;
                          end
                          else state <= INVALID;
                          end
                    INVALID: begin
                                TRIG_IN_en <= 1'b0;
                                cnt_TRIG_IN_r <= 5'd0; 
                                if(TRIG_IN_r[1]) state <= WORK;
                                else state <= INVALID;
                             end
                    WAITE: begin
                            TRIG_IN_en <= 1'b0;
                            cnt_TRIG_IN_r <= 5'd0;
                            if(TRIG_IN_r[1]) state <= WORK;
                            else state <= WAITE;
                          end
                    default: begin
                                TRIG_IN_en <= 1'b0;
                                cnt_TRIG_IN_r <= 5'd0;
                                state <= IDEL;
                             end
                endcase
            end
        end   
endmodule

