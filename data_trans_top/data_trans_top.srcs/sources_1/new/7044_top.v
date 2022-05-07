
module hmc7044_top(
   input  clk_200m,
   input  reset,
   output HMC_Done,
   inout  SDATA,              //SPI数据线
   output SCLK,             //SPI时钟线,最大10M
   output SLEN              //SPI信号锁存线
    );

wire clk_200m;   
wire SPI_Done;
wire SPI_Exe;
wire [23:0]Data_wire;

hmc7044_register u1(
. clk_200m  (clk_200m),
. reset     (reset   ),
. SPI_Done  (SPI_Done),
. SPI_Exe   (SPI_Exe ),
. HMC_Done  (HMC_Done),
. Reg_Data  (Data_wire)
    );
       
spi_master u2(
. clk_200m     (clk_200m ),
. reset        (reset    ),
. SPI_Done     (SPI_Done ),
. SPI_Exe      (SPI_Exe  ),
. DATA_IN      (Data_wire),
. SDATA        (SDATA    ),  
. SCLK         (SCLK     ),          
. SLEN         (SLEN     )          
    );  

endmodule
