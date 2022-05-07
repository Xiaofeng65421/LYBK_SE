`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/21 14:04:02
// Design Name: 
// Module Name: tb_RouterSychTop
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


module tb_RouterSychTop();
reg       clk;
reg       rst;
reg       TrigIn;
reg [7:0] ready_id;
reg       ready_id_valid;
wire      TrigOkOut;

reg [7:0]  rx_data;
reg        rx_data_valid;
wire [7:0] tx_data;
wire       tx_data_valid;

wire [7:0] trig_task_id;
wire       trig_task_valid;
wire       trig_flag;
wire       sync;

reg [31:0] cnt;

initial begin
  clk = 0;
  rst = 0;
  TrigIn = 0;
  ready_id_valid = 0;
  ready_id = 0;

  cnt = 0;
end

always #5 clk = ~clk;

always @(posedge clk)
  if (&cnt) begin
      cnt <= cnt;
  end else begin
      cnt <= cnt + 1;
  end

 always @(posedge clk)
   if (cnt == 1) begin
       rst <= 1;   
    end else if (cnt == 10) begin
       rst <= 0;  
    end else if (cnt == 15) begin
       ready_id_valid <= 1;  //下层板卡发送的就绪信号
       ready_id <= 8'h01; 
    end else if (cnt == 16) begin
       ready_id_valid <= 0;
       ready_id <= 0; 
    end else if (cnt == 40) begin
       TrigIn <= 1;        //中控发送触发
    end else if (cnt == 55) begin
       TrigIn <= 0; 
    end else if (cnt == 80) begin
       rx_data_valid <= 1;
       rx_data <=  8'h01; //指令类型  
    end else if (cnt == 81) begin
       rx_data <= 8'h01; //延时参数 
    end else if (cnt == 82) begin
       rx_data <= 8'h00;//  
    end else if (cnt == 83) begin
       rx_data_valid <= 0;  
    end else if (cnt == 100) begin
       TrigIn <= 1; 
    end else if (cnt == 115) begin
       TrigIn <= 0; 
    end else if (cnt == 150) begin
       ready_id_valid <= 1;
       ready_id <= 8'h01; 
    end else if (cnt == 151) begin
       ready_id_valid <= 0;
       ready_id <= 0; 
    end else if (cnt == 200) begin
       rx_data_valid <= 1;
       rx_data <= 8'h01;  
    end else if (cnt == 201) begin
       rx_data <= 8'h01;
    end else if (cnt == 202) begin
       rx_data <= 8'h00;  
    end else if (cnt == 203) begin
       rx_data <= 0;   
    end else if (cnt == 204) begin
       rx_data_valid <= 0;  
    end  else if (cnt ==240) begin
       TrigIn <= 1; 
    end  else if (cnt == 255) begin
       TrigIn <= 0; 
    end else if (cnt == 300) begin
       ready_id_valid <= 1;
       ready_id <= 8'h01;
    end else if (cnt == 301) begin
       ready_id_valid <= 0;
       ready_id <= 0; 
    end else if (cnt == 400) begin
       rx_data_valid <= 1;
       rx_data <= 8'hcd;  
    end else if (cnt == 401) begin
       rx_data <= 8'h01;
    end else if (cnt == 402) begin
       rx_data <= 8'h01;  
    end else if (cnt == 403) begin
       rx_data <= 0;   
    end else if (cnt == 408) begin
       rx_data_valid <= 0;  
    end  else if (cnt ==440) begin
       TrigIn <= 1; 
    end  else if (cnt == 455) begin
       TrigIn <= 0; 
    end else if (cnt == 1327) begin
       TrigIn <= 1;
    end else if (cnt == 1342) begin
       TrigIn <= 0;
    end




RouterSychTop_test RouterSychTop_inst(
     .clk(clk),//100M 7044
     .rst(rst),
     .TrigIn(TrigIn),
     .ready_id(ready_id),
     .ready_id_valid(ready_id_valid),
    
     .TrigOkOut(TrigOkOut),
     .rx_data(rx_data),
     .rx_data_vald(rx_data_valid),
     .tx_data(tx_data),
     .tx_data_vald(tx_data_valid)
  );


endmodule
