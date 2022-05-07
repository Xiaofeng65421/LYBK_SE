`timescale 1ns / 1ps
module spi_master(
input clk_200m,
input reset,
input SPI_Exe,               //ISPI触发执行信号
input [23:0]DATA_IN,          // 24位数据输入
inout SDATA,                  //SPI数据线
output reg SCLK,             //SPI时钟线,最大10M
output reg SLEN,             //SPI信号锁存线
output reg SPI_Done         //SPI一次操作完成反馈信号
    );

/*
模式0：CPOL=0，CPHA =0;SCK空闲为低电平，数据在SCK的上升沿被采样(提取数据)
模式1：CPOL=0，CPHA =1;SCK空闲为低电平，数据在SCK的下降沿被采样(提取数据)
模式2：CPOL=1，CPHA =0;SCK空闲为高电平，数据在SCK的下降沿被采样(提取数据)
模式3：CPOL=1，CPHA =1;SCK空闲为高电平，数据在SCK的上升沿被采样(提取数据)
本此设置通信模式为CPOL=0;CPHA=0;SCK空闲为低电平，数据在SCK的下降沿被采样(提取数据)
*/

/*主机三态变量控制*/
reg Master_SDATA_CTRL = 1'd1;           //三态控制信号
reg Master_SDATA_OUT = 1'd1;            //三态做输出的信号
wire Master_SDATA_IN ;                  //三态做输入的信号
assign SDATA = Master_SDATA_CTRL ? Master_SDATA_OUT:1'bz;
assign Master_SDATA_IN = (!Master_SDATA_CTRL) & SDATA;

/*SPI时钟分频单元，产生1M时钟,SPI_CLK时钟产生,产生1MHZ时钟*/

parameter spi_num = 10'd99;
reg [9:0]spi_cnt = 10'd0;
reg cnt_en = 1'b0;
always@(posedge clk_200m)
begin
    if(reset)
        spi_cnt <= 10'd0;
    else if(spi_cnt == spi_num)
        spi_cnt <= 10'd0;
    else if(cnt_en)
        spi_cnt <= spi_cnt + 1'd1;
    else 
        spi_cnt <= 10'd0;
end

parameter delay_num = 10'd199;
reg [31:0]delay_cnt = 32'd0;
always@(posedge clk_200m)
begin
    if(reset)
        delay_cnt <= 32'd0;
    else if(delay_cnt==delay_num)
        delay_cnt <= 32'd0;
    else if(cnt_en)
        delay_cnt <= delay_cnt + 32'd1;
    else
        delay_cnt <= 32'd0;
end

//reg spi_clk = 1'b0;
//reg spi_en = 1'b0;
//always@(posedge clk_200m) begin spi_clk <= (spi_cnt >= spi_num/2) ? 1:0;end
//always@(posedge clk_200m) begin spi_en <= (delay_cnt==delay_num) ? 1:0;end

/*24位数据缓存*/ 
reg RW_Data = 1'b0;                        //1位读/写命令数据缓存器         
reg [1:0]W1_Data = 2'b00;                  //2 位多字节字段缓存器（W1、W0）   
reg [12:0]Addr_Data = 13'b0_0000_0000_0000;//13位地址字段缓存器（A12 至 A0） 
reg [7:0]Eight_Data = 8'b0000_0000;        //8位数据字段缓存器（D7 至 D0）   
reg [7:0]BUFFER = 8'b0000_0000;            //回读8位数据字段缓存器（D7 至 D0） 
reg [5:0]Master_Cnt = 6'd0;               //主机状态标志量 
always@(posedge clk_200m)
begin
    if(reset)
        begin
            SPI_Done <= 1'd0;
            Master_Cnt <= 6'd0;
            SCLK <= 1'd0;
            SLEN <= 1'd1;                  //SLEN为高；SPI非锁存状态
            Master_SDATA_CTRL <= 1'd1;     //SDATA做输出端口
            Master_SDATA_OUT <= 1'd0;      //SDATA起始为未知态
        end
    else
        begin
            case(Master_Cnt)
                6'd0:
                    begin
                        SPI_Done <= 1'd0;   //清除触发信号
                        if(SPI_Exe)begin
                        RW_Data <= DATA_IN[23];
                        W1_Data <= DATA_IN[22:21];
                        Addr_Data <= DATA_IN[20:8];
                        Eight_Data <= DATA_IN[7:0];
                        cnt_en <= 1'b1;
                        Master_SDATA_CTRL <= 1'd1;
                        Master_Cnt <= Master_Cnt + 1'd1;end
                        else
                        Master_Cnt <= Master_Cnt;
                    end
                6'd1:
                    begin
                        SLEN <= 1'd0; 
                        Master_SDATA_OUT <= RW_Data;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1;                        
                    end
                6'd2:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd3:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= W1_Data[1];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd4:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd5:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= W1_Data[0];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd6:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd7:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[12];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd8:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd9:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[11];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd10:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd11:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[10];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd12:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd13:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[9];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd14:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd15:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[8];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd16:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd17:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[7];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd18:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd19:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[6];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd20:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd21:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[5];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd22:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd23:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[4];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd24:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd25:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[3];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd26:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd27:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[2];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd28:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd29:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[1];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd30:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd31:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Addr_Data[0];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd32:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd33:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[7];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd34:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd35:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[6];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd36:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd37:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[5];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd38:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd39:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[4];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd40:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd41:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[3];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd42:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd43:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[2];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd44:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd45:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[1];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd46:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd47:
                    begin
                        SCLK <= 1'd0;
                        if(delay_cnt==32'd10)Master_SDATA_OUT <= Eight_Data[0];
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
                6'd48:
                    begin
                        SCLK <= 1'd1;
                        if(spi_cnt == spi_num)Master_Cnt <= Master_Cnt + 1'd1; 
                    end
               6'd49:
                   begin
                       SCLK <= 1'd0;
                       if(delay_cnt==32'd10)SLEN <= 1'd1;                                                                                      
                       if(spi_cnt == spi_num)begin                        
                       Master_Cnt <= 6'd0;
                       SPI_Done <= 1'd1;
                       cnt_en <= 1'b0;end
                   end
            endcase
        end
end

endmodule
