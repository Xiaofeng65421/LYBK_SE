`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/06 13:53:37
// Design Name: 
// Module Name: data_rom_test
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


module data_rom_test(
     input   clk_7044_100m,
     input   data_flag,
     output  data_out_valid,
     output [63:0] data_out
    );

//rom
reg          data_en;
reg  [15:0]  data_addr;
wire [63:0]  data_out;
reg          data_out_valid;
wire         data_flag;
reg          data_flag_r1;
reg          data_flag_r2;
wire         skip_en;

assign skip_en = data_flag_r1 & (~data_flag_r2);

always @(posedge clk_7044_100m)
begin
  data_flag_r1 <= data_flag;
  data_flag_r2 <= data_flag_r1;
  data_out_valid <= data_en;  
end


localparam   idle   = 0;
localparam   data_1 = 1;
localparam   data_2 = 2;
localparam   data_3 = 3;
localparam   data_4 = 4;
localparam   data_5 = 5;
localparam   data_6 = 6;

reg  [3:0]   state = idle;


/*rom_data_control rom_data_control (
  .clk(clk_7044_100m),                // input wire clk
  .probe_in0(state),    // input wire [3 : 0] probe_in0
  .probe_out0(data_flag)  // output wire [0 : 0] probe_out0
);*/

datapackage_test datapackage_test (
  .clka(clk_7044_100m),    // input wire clka
  .ena(data_en),      // input wire ena
  .addra(data_addr),  // input wire [15 : 0] addra
  .douta(data_out)  // output wire [63 : 0] douta
);

always @(posedge clk_7044_100m)
  case (state)
      idle : if (skip_en) begin
              state <= data_1;
      end
      data_1 : if (skip_en) begin
              state <= data_2;
      end
      data_2 : if (skip_en) begin
              state <= data_3;
      end
      data_3 : if (skip_en) begin
              state <= data_4;
      end
      data_4 : if (skip_en) begin
              state <= data_5;
      end
      data_5 : if (skip_en) begin
              state <= data_6;
      end
      data_6 : if (skip_en) begin
              state <= idle;
      end

 endcase

always @(posedge clk_7044_100m)
  case(state)
    idle : begin
         data_en <= 0;
    end
    data_1 : begin
         if (data_addr >= 4) begin //LY
            data_en <= 0;
         end else begin
            data_en <= 1;
         end
    end
    data_2 : begin
         if (data_addr >= 942 + 938) begin //DAC(u30/u43)
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_3 : begin
         if (data_addr >= 9881 + 938) begin //AWG
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_4 : begin
         if (data_addr >= 9889 + 938) begin//ADDA AD TASK
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_5 : begin
         if (data_addr >= 9903 + 938) begin //ADDA DA TASK
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end
    data_6 : begin
         if (data_addr >= 13145 + 938) begin    //ADDA DA DEFAULT
             data_en <= 0;
         end else begin
             data_en <= 1;
         end
    end

  endcase


always @(posedge clk_7044_100m)
   if (state == idle) begin
      data_addr <= 0;
   end else begin
     if (data_en) begin
         data_addr <= data_addr + 1;
     end else begin
         data_addr <= data_addr;
     end
   end
   
endmodule
