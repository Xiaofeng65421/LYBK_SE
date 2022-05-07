`timescale 1ns / 1ps
module hmc7044_register(  
input clk_200m,
input reset,
input SPI_Done,                 //SPI一次操作完成反馈信号
output reg SPI_Exe,           //ISPI触发执行信号
output reg HMC_Done,        //HMC7043配置完成标志
output [23:0]Reg_Data   //HMC7043寄存器数据
    );

//*****************************************************
//**                    main code
//*****************************************************

reg [8:0]register_num = 9'd247; 
reg [8:0]register_w = 9'd0;
reg WR_Bit = 1'b0;                      //第23位拉低定义为写时序

//按键指示
//parameter hmc_num = 32'd599_999_999;
parameter hmc_num = 32'd999;
reg [31:0] hmc_cnt = 32'd0;
always@(posedge clk_200m)
begin
    if(reset)
        hmc_cnt <= 32'd0;
    else if(hmc_cnt==hmc_num)
        hmc_cnt <= 32'd0;
    else if(!HMC_Done)
        hmc_cnt <= hmc_cnt + 32'd1;
    else
        hmc_cnt <= 32'd0;
end

/*SPI触发模块*/
always@(posedge clk_200m)
begin
    if(reset)
        SPI_Exe <= 1'd0;
    else if(hmc_cnt==hmc_num && register_w == 9'd0)//1111
        SPI_Exe <= 1'd1;
    else if(SPI_Done && register_w <= register_num)
        SPI_Exe <= 1'd1;
    else
        SPI_Exe <= 1'd0;
end

/*需要配置的寄存器计数*/
always@(posedge clk_200m)
begin
    if(reset)
        register_w <= 9'd0;
    else if(!HMC_Done)
        begin
            if(SPI_Exe)
                register_w <= register_w + 1'd1;
            else
                register_w <= register_w;
        end
    else
        register_w <= register_w;
    end

reg [23:0]data_w = 24'b0000_0000_0000_0000_0000_0000;
always@(posedge clk_200m)
begin
    if(reset)
        begin
        data_w <= 24'b0000_0000_0000_0000_0000_0000;
        HMC_Done <= 1'b0;
        end
    else if(!HMC_Done)
        begin
            case(register_w)
////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                9'd0  :data_w <= {WR_Bit,23'h000001};     //软复位
                9'd1  :data_w <= {WR_Bit,23'h000000};     //释放软复位
                9'd2  :data_w <= {WR_Bit,23'h000000};     
                9'd3  :data_w <= {WR_Bit,23'h000000};     
                9'd4  :data_w <= {WR_Bit,23'h000000};     
                9'd5  :data_w <= {WR_Bit,23'h000000};     
                9'd6  :data_w <= {WR_Bit,23'h000000};     
                9'd7  :data_w <= {WR_Bit,23'h000000};     
                9'd8  :data_w <= {WR_Bit,23'h000000};     
                9'd9  :data_w <= {WR_Bit,23'h000000};     
                9'd10 :data_w <= {WR_Bit,23'h000000};     
                9'd11 :data_w <= {WR_Bit,23'h000000};                  
                9'd12 :data_w <= {WR_Bit,23'h009600};     //保留
                9'd13 :data_w <= {WR_Bit,23'h009700};     //保留
                9'd14 :data_w <= {WR_Bit,23'h009800};     //保留
                9'd15 :data_w <= {WR_Bit,23'h009900};     //保留
                9'd16 :data_w <= {WR_Bit,23'h009A00};     //保留
                9'd17 :data_w <= {WR_Bit,23'h009BAA};     //保留
                9'd18 :data_w <= {WR_Bit,23'h009CAA};     //保留
                9'd19 :data_w <= {WR_Bit,23'h009DAA};     //保留
                9'd20 :data_w <= {WR_Bit,23'h009EAA};     //保留
                9'd21 :data_w <= {WR_Bit,23'h009F4D};     //保留
                9'd22 :data_w <= {WR_Bit,23'h00A0DF};     //保留
                9'd23 :data_w <= {WR_Bit,23'h00A197};     //保留
                9'd24 :data_w <= {WR_Bit,23'h00A203};     //保留
                9'd25 :data_w <= {WR_Bit,23'h00A300};     //保留
                9'd26 :data_w <= {WR_Bit,23'h00A400};     //保留
                9'd27 :data_w <= {WR_Bit,23'h00A506};     //保留
                9'd28 :data_w <= {WR_Bit,23'h00A61C};     //保留
                9'd29 :data_w <= {WR_Bit,23'h00A700};     //保留
                9'd30 :data_w <= {WR_Bit,23'h00A806};     //保留
                9'd31 :data_w <= {WR_Bit,23'h00A900};     //保留
                9'd32 :data_w <= {WR_Bit,23'h00AB00};     //保留
                9'd33 :data_w <= {WR_Bit,23'h00AC20};     //保留
                9'd34 :data_w <= {WR_Bit,23'h00AD00};     //保留
                9'd35 :data_w <= {WR_Bit,23'h00AE08};     //保留
                9'd36 :data_w <= {WR_Bit,23'h00AF50};     //保留
                9'd37 :data_w <= {WR_Bit,23'h00B004};     //保留
                9'd38 :data_w <= {WR_Bit,23'h00B10D};     //保留
                9'd39 :data_w <= {WR_Bit,23'h00B200};     //保留
                9'd40 :data_w <= {WR_Bit,23'h00B300};     //保留
                9'd41 :data_w <= {WR_Bit,23'h00B500};     //保留
                9'd42 :data_w <= {WR_Bit,23'h00B600};     //保留
                9'd43 :data_w <= {WR_Bit,23'h00B700};     //保留
                9'd44 :data_w <= {WR_Bit,23'h00B800};     //保留
                
                9'd45 :data_w <= {WR_Bit,23'h004600};     //GPI1禁止使用                                     
                9'd46 :data_w <= {WR_Bit,23'h004700};     //GPI2禁止使用                                     
                9'd47 :data_w <= {WR_Bit,23'h004800};     //GPI3禁止使用                                     
                9'd48 :data_w <= {WR_Bit,23'h004900};     //GPI4禁止使用                                     
                9'd49 :data_w <= {WR_Bit,23'h00500B};     //GPO1（CLKIN3/CLKIN3 LOS for CLKIN3/CLKIN3 input）  
                9'd50 :data_w <= {WR_Bit,23'h00511F};     //GPO2（来自PLL1锁定检测信号）                        
                9'd51 :data_w <= {WR_Bit,23'h00522B};     //GPO3（来自PLL2锁定检测信号）     
                9'd52 :data_w <= {WR_Bit,23'h005337};     //GPO4（PLL1 和 PLL2 锁定检测被锁定）                   
                9'd53 :data_w <= {WR_Bit,23'h005403};     //SDATA控制：COMS模式，驱动器使能                         
                9'd54 :data_w <= {WR_Bit,23'h00050F};     //SYNC禁用,PLL1参考路径为CLKIN3,//h8F                 
                9'd55 :data_w <= {WR_Bit,23'h000337};     //PLL1、PLL2与SYSREF定时器使能                                  
                9'd56 :data_w <= {WR_Bit,23'h003201};     //h00,使能R2分配器前的倍频器，h01,旁路倍频器                   
                9'd57 :data_w <= {WR_Bit,23'h003332};     //R2分频器数值为50分频                                 
                9'd58 :data_w <= {WR_Bit,23'h003400};                                                    
                9'd59 :data_w <= {WR_Bit,23'h003514};     //N2分频器数值为1250分频
                9'd60 :data_w <= {WR_Bit,23'h003605};     //
                9'd61 :data_w <= {WR_Bit,23'h0037ff};     // PLL2 电荷泵控制 
                9'd62 :data_w <= {WR_Bit,23'h003818};     // PLL2 PFD 控制 
                9'd63 :data_w <= {WR_Bit,23'h003900};     //禁止OSCOUTx输出                                  
                9'd64 :data_w <= {WR_Bit,23'h003A20};     //                                             
                9'd65 :data_w <= {WR_Bit,23'h003B20};                                                    
                9'd66 :data_w <= {WR_Bit,23'h003C00};     //保留                                           
                9'd67 :data_w <= {WR_Bit,23'h000A0d};     //CLKINx和OSCIN使能输入缓存器，使能内部100欧姆端接，使能交流耦合输入模式   
                9'd68 :data_w <= {WR_Bit,23'h000B0d};                                                    
                9'd69 :data_w <= {WR_Bit,23'h000C0d};                                                    
                9'd70 :data_w <= {WR_Bit,23'h000D0d};                                                    
                9'd71 :data_w <= {WR_Bit,23'h000E0d};     //OSCIN使能输入缓存器，使能内部100欧姆端接，使能交流耦合输入模式          
                9'd72 :data_w <= {WR_Bit,23'h0014E1};     //PLL1参考优先级控制，依次为1,0,2,3                      
                9'd73 :data_w <= {WR_Bit,23'h001507};     //PLL1信号LOS控制                                  
                9'd74 :data_w <= {WR_Bit,23'h00160C};     //PLL1保持退出控制                                   
                9'd75 :data_w <= {WR_Bit,23'h001700};                                                    
                9'd76 :data_w <= {WR_Bit,23'h001804};                                                    
                9'd77 :data_w <= {WR_Bit,23'h001902};                                                    
                9'd78 :data_w <= {WR_Bit,23'h001A0F};     //PLL1电荷泵控制                                    
                9'd79 :data_w <= {WR_Bit,23'h001B18};     //使能PLL1 PFD上升和下降                              
                9'd80 :data_w <= {WR_Bit,23'h001C01};     //CLKINx和OSCIN输入预分频为1                          
                9'd81 :data_w <= {WR_Bit,23'h001D01};                                                    
                9'd82 :data_w <= {WR_Bit,23'h001E01};////////////////////////////////////////////////////
                9'd83 :data_w <= {WR_Bit,23'h001F01};                                                    
                9'd84 :data_w <= {WR_Bit,23'h002001};                                                    
                9'd85 :data_w <= {WR_Bit,23'h002105};     //R1分频器为5                            
                9'd86 :data_w <= {WR_Bit,23'h002200};                                                    
                9'd87 :data_w <= {WR_Bit,23'h002605};     //N1分频器为5                         
                9'd88 :data_w <= {WR_Bit,23'h002700};                                                    
                9'd89 :data_w <= {WR_Bit,23'h00282F};     //PLL1锁定检测控制                                   
                9'd90 :data_w <= {WR_Bit,23'h00290b};     //PLL1参考切换关闭自动切换，手动选择CLKIN0    //h1C           
                9'd91 :data_w <= {WR_Bit,23'h002A00};     //PLL1释抑时间控制                                   
                9'd92 :data_w <= {WR_Bit,23'h005A00};     //脉冲发生器控制                                      
                9'd93 :data_w <= {WR_Bit,23'h005B06};                                                    
                9'd94 :data_w <= {WR_Bit,23'h005C00};                                                    
                9'd95 :data_w <= {WR_Bit,23'h005D01};                                                    
                9'd96 :data_w <= {WR_Bit,23'h005E00};     //保留                                           
                9'd97 :data_w <= {WR_Bit,23'h006400};                                                    
                9'd98 :data_w <= {WR_Bit,23'h006500};                                                    
                9'd99 :data_w <= {WR_Bit,23'h00C881};     //通道0控制，通道使能，多跳使能                              
                9'd100:data_w <= {WR_Bit,23'h00C91A};     //通道0分频系数25，输出100MHz                           
                9'd101:data_w <= {WR_Bit,23'h00CA00};                                                    
                9'd102:data_w <= {WR_Bit,23'h00CB00};     //通道0微调模拟延迟                                    
                9'd103:data_w <= {WR_Bit,23'h00CC00};     //通道0粗调数字延迟                                    
                9'd104:data_w <= {WR_Bit,23'h00CD00};     //通道0多跳数字延迟                                    
                9'd105:data_w <= {WR_Bit,23'h00CE00};                                                    
                9'd106:data_w <= {WR_Bit,23'h00CF00};     //通道0分频器输出                                     
                9'd107:data_w <= {WR_Bit,23'h00D010};     //通道0 LVDS输出模式                                 
                9'd108:data_w <= {WR_Bit,23'h00D100};     //保留                                           
                9'd109:data_w <= {WR_Bit,23'h00D200};     //通道1控制，通道使能，多跳使能                              
                9'd110:data_w <= {WR_Bit,23'h00D364};     //通道1分频系数26，输出100MHz                           
                9'd111:data_w <= {WR_Bit,23'h00D400};                                                    
                9'd112:data_w <= {WR_Bit,23'h00D500};     //通道1微调模拟延迟                                    
                9'd113:data_w <= {WR_Bit,23'h00D600};     //通道1粗调数字延迟                                    
                9'd114:data_w <= {WR_Bit,23'h00D700};     //通道1多跳数字延迟                                    
                9'd115:data_w <= {WR_Bit,23'h00D800};                                                    
                9'd116:data_w <= {WR_Bit,23'h00D900};     //通道1分频器输出                                     
                9'd117:data_w <= {WR_Bit,23'h00DA10};     //通道1 LVDS输出模式                                 
                9'd118:data_w <= {WR_Bit,23'h00DB00};     //保留                                           
                9'd119:data_w <= {WR_Bit,23'h00DC00};     //通道2控制，通道使能，多跳使能                              
                9'd120:data_w <= {WR_Bit,23'h00DD14};     //通道2分频系数20，输出125MHz                           
                9'd121:data_w <= {WR_Bit,23'h00DE00};                                                    
                9'd122:data_w <= {WR_Bit,23'h00DF00};     //通道2微调模拟延迟                                    
                9'd123:data_w <= {WR_Bit,23'h00E000};     //通道2粗调数字延迟                                    
                9'd124:data_w <= {WR_Bit,23'h00E100};     //通道2多跳数字延迟                                    
                9'd125:data_w <= {WR_Bit,23'h00E200};                                                    
                9'd126:data_w <= {WR_Bit,23'h00E300};     //通道2分频器输出                                     
                9'd127:data_w <= {WR_Bit,23'h00E410};     //通道2 LVDS输出模式                                 
                9'd128:data_w <= {WR_Bit,23'h00E500};     //保留                                           
                9'd129:data_w <= {WR_Bit,23'h00E600};     //通道3控制，通道使能，多跳使能                              
                9'd130:data_w <= {WR_Bit,23'h00E764};     //通道3分频系数100，输出25MHz                           
                9'd131:data_w <= {WR_Bit,23'h00E800};                                                    
                9'd132:data_w <= {WR_Bit,23'h00E900};     //通道3微调模拟延迟                                    
                9'd133:data_w <= {WR_Bit,23'h00EA00};     //通道3粗调数字延迟                                    
                9'd134:data_w <= {WR_Bit,23'h00EB00};     //通道3多跳数字延迟                                    
                9'd135:data_w <= {WR_Bit,23'h00EC00};                                                    
                9'd136:data_w <= {WR_Bit,23'h00ED00};     //通道3分频器输出                                     
                9'd137:data_w <= {WR_Bit,23'h00EE10};     //通道3 LVDS输出模式                                 
                9'd138:data_w <= {WR_Bit,23'h00EF00};     //保留                                           
                9'd139:data_w <= {WR_Bit,23'h00F081};     //通道4控制，通道使能，多跳使能                              
                9'd140:data_w <= {WR_Bit,23'h00F11A};     //通道4分频系数26，输出100MHz                           
                9'd141:data_w <= {WR_Bit,23'h00F200};                                                    
                9'd142:data_w <= {WR_Bit,23'h00F300};     //通道4微调模拟延迟                                    
                9'd143:data_w <= {WR_Bit,23'h00F400};     //通道4粗调数字延迟                                    
                9'd144:data_w <= {WR_Bit,23'h00F500};     //通道4多跳数字延迟                                    
                9'd145:data_w <= {WR_Bit,23'h00F600};                                                    
                9'd146:data_w <= {WR_Bit,23'h00F700};     //通道4分频器输出                                     
                9'd147:data_w <= {WR_Bit,23'h00F808};     //通道4 LVPECL输出模式                               
                9'd148:data_w <= {WR_Bit,23'h00F900};     //保留                                           
                9'd149:data_w <= {WR_Bit,23'h00FA81};     //通道5控制，通道使能，多跳使能    //h7C                     
                9'd150:data_w <= {WR_Bit,23'h00FB1A};     //通道5分频系数26，输出100MHz                           
                9'd151:data_w <= {WR_Bit,23'h00FC00};                                                    
                9'd152:data_w <= {WR_Bit,23'h00FD00};     //通道5微调模拟延迟                                    
                9'd153:data_w <= {WR_Bit,23'h00FE00};     //通道5粗调数字延迟                                    
                9'd154:data_w <= {WR_Bit,23'h00FF00};     //通道5多跳数字延迟                                    
                9'd155:data_w <= {WR_Bit,23'h010000};                                                    
                9'd156:data_w <= {WR_Bit,23'h010100};     //通道5分频器输出                                     
                9'd157:data_w <= {WR_Bit,23'h010208};     //通道5 LVPECL输出模式                               
                9'd158:data_w <= {WR_Bit,23'h010300};     //保留                                           
                9'd159:data_w <= {WR_Bit,23'h010481};     //通道6控制，通道使能，多跳使能    //hF2                     
                9'd160:data_w <= {WR_Bit,23'h01051A};     //通道6分频系数26，输出100MHz                           
                9'd161:data_w <= {WR_Bit,23'h010600};                                                    
                9'd162:data_w <= {WR_Bit,23'h010700};     //通道6微调模拟延迟                                    
                9'd163:data_w <= {WR_Bit,23'h010800};     //通道6粗调数字延迟                                    
                9'd164:data_w <= {WR_Bit,23'h010900};     //通道6多跳数字延迟                                    
                9'd165:data_w <= {WR_Bit,23'h010A00};                                                    
                9'd166:data_w <= {WR_Bit,23'h010B00};     //通道6分频器输出                                     
                9'd167:data_w <= {WR_Bit,23'h010C10};     //通道6 LVDS输出模式                                 
                9'd168:data_w <= {WR_Bit,23'h010D00};     //保留                                           
                9'd169:data_w <= {WR_Bit,23'h010E81};     //通道7控制，通道使能，多跳使能    //h7C                     
                9'd170:data_w <= {WR_Bit,23'h010F1A};     //通道7分频系数26，输出100MHz                           
                9'd171:data_w <= {WR_Bit,23'h011000};                                                    
                9'd172:data_w <= {WR_Bit,23'h011100};     //通道7微调模拟延迟                                    
                9'd173:data_w <= {WR_Bit,23'h011200};     //通道7粗调数字延迟                                    
                9'd174:data_w <= {WR_Bit,23'h011300};     //通道7多跳数字延迟                                    
                9'd175:data_w <= {WR_Bit,23'h011400};                                                    
                9'd176:data_w <= {WR_Bit,23'h011500};     //通道7分频器输出                                     
                9'd177:data_w <= {WR_Bit,23'h011608};     //通道7 LVPECL输出模式                               
                9'd178:data_w <= {WR_Bit,23'h011700};     //保留                                           
                9'd179:data_w <= {WR_Bit,23'h011881};     //通道8控制，通道使能，多跳使能     //hF2                    
                9'd180:data_w <= {WR_Bit,23'h01191A};     //通道8分频系数26，输出100MHz                           
                9'd181:data_w <= {WR_Bit,23'h011A00};                                                    
                9'd182:data_w <= {WR_Bit,23'h011B00};     //通道8微调模拟延迟                                    
                9'd183:data_w <= {WR_Bit,23'h011C00};     //通道8粗调数字延迟                                    
                9'd184:data_w <= {WR_Bit,23'h011D00};     //通道8多跳数字延迟                                    
                9'd185:data_w <= {WR_Bit,23'h011E00};                                                    
                9'd186:data_w <= {WR_Bit,23'h011F00};     //通道8分频器输出                                     
                9'd187:data_w <= {WR_Bit,23'h012010};     //通道8 LVDS输出模式                                 
                9'd188:data_w <= {WR_Bit,23'h012100};     //保留                                           
                9'd189:data_w <= {WR_Bit,23'h012281};     //通道9控制，通道使能，多跳使能     //hF2                    
                9'd190:data_w <= {WR_Bit,23'h01231A};     //通道9分频系数26，输出100MHz                           
                9'd191:data_w <= {WR_Bit,23'h012400};                                                    
                9'd192:data_w <= {WR_Bit,23'h012500};     //通道9微调模拟延迟                                    
                9'd193:data_w <= {WR_Bit,23'h012600};     //通道9粗调数字延迟                                    
                9'd194:data_w <= {WR_Bit,23'h012700};     //通道9多跳数字延迟                                    
                9'd195:data_w <= {WR_Bit,23'h012800};                                                    
                9'd196:data_w <= {WR_Bit,23'h012900};     //通道9分频器输出                                     
                9'd197:data_w <= {WR_Bit,23'h012A10};     //通道9 LVDS输出模式                                 
                9'd198:data_w <= {WR_Bit,23'h012B00};     //保留                                           
                9'd199:data_w <= {WR_Bit,23'h012C81};     //通道10控制，通道使能，多跳使能                             
                9'd200:data_w <= {WR_Bit,23'h012D1A};     //通道10分频系数26，输出100MHz                          
                9'd201:data_w <= {WR_Bit,23'h012E00};                                                    
                9'd202:data_w <= {WR_Bit,23'h012F00};     //通道10微调模拟延迟                                   
                9'd203:data_w <= {WR_Bit,23'h013000};     //通道10粗调数字延迟                                   
                9'd204:data_w <= {WR_Bit,23'h013100};     //通道10多跳数字延迟                                   
                9'd205:data_w <= {WR_Bit,23'h013200};                                                    
                9'd206:data_w <= {WR_Bit,23'h013300};     //通道10分频器输出                                    
                9'd207:data_w <= {WR_Bit,23'h013410};     //通道10 LVDS输出模式                                
                9'd208:data_w <= {WR_Bit,23'h013500};     //保留                                           
                9'd209:data_w <= {WR_Bit,23'h013681};     //通道11控制，通道使能，多跳使能     //h7C                   
                9'd210:data_w <= {WR_Bit,23'h01371A};     //通道11分频系数26，输出100MHz                          
                9'd211:data_w <= {WR_Bit,23'h013800};                                                    
                9'd212:data_w <= {WR_Bit,23'h013900};     //通道11微调模拟延迟                                   
                9'd213:data_w <= {WR_Bit,23'h013A00};     //通道11粗调数字延迟                                   
                9'd214:data_w <= {WR_Bit,23'h013B00};     //通道11多跳数字延迟                                   
                9'd215:data_w <= {WR_Bit,23'h013C00};                                                    
                9'd216:data_w <= {WR_Bit,23'h013D00};     //通道11分频器输出                                    
                9'd217:data_w <= {WR_Bit,23'h013E10};     //通道11 LVDS输出模式                                
                9'd218:data_w <= {WR_Bit,23'h013F00};     //保留                                           
                9'd219:data_w <= {WR_Bit,23'h014000};     //通道12控制，通道使能，多跳使能     //hF2                   
                9'd220:data_w <= {WR_Bit,23'h014114};     //通道12分频系数25，输出100MHz                          
                9'd221:data_w <= {WR_Bit,23'h014200};                                                    
                9'd222:data_w <= {WR_Bit,23'h014200};                                   
                9'd223:data_w <= {WR_Bit,23'h014300};     //通道12微调模拟延迟      
                9'd224:data_w <= {WR_Bit,23'h014400};     //通道12粗调数字延迟      
                9'd225:data_w <= {WR_Bit,23'h014500};     //通道12多跳数字延迟      
                9'd226:data_w <= {WR_Bit,23'h014600};                       
                9'd227:data_w <= {WR_Bit,23'h014700};     //通道12分频器输出       
                9'd228:data_w <= {WR_Bit,23'h014810};     //通道12 LVDS输出模式                
                9'd229:data_w <= {WR_Bit,23'h014900};     //保留            
                9'd230:data_w <= {WR_Bit,23'h014A00};     //通道13控制，通道使能，多跳使能          
                9'd231:data_w <= {WR_Bit,23'h014B19};     //通道13分频系数25，输出100MHz              
                9'd232:data_w <= {WR_Bit,23'h014C00};                                        
                9'd233:data_w <= {WR_Bit,23'h014D00};     //通道13微调模拟延迟                       
                9'd234:data_w <= {WR_Bit,23'h014E00};     //通道13粗调数字延迟                       
                9'd235:data_w <= {WR_Bit,23'h014F00};     //通道13多跳数字延迟                       
                9'd236:data_w <= {WR_Bit,23'h015000};     //通道13分频器输出                   
                9'd237:data_w <= {WR_Bit,23'h015100};     //通道13 LVDS输出模式 
                9'd238:data_w <= {WR_Bit,23'h015210};     //保留            
                9'd239:data_w <= {WR_Bit,23'h015300};          
                9'd240:data_w <= {WR_Bit,23'h000102};      //全局请求和模式控制   
                9'd241:data_w <= {WR_Bit,23'h000100};                       
                9'd242:data_w <= {WR_Bit,23'h000180};                       
                9'd243:data_w <= {WR_Bit,23'h0001E0};                                        
                9'd244:data_w <= {WR_Bit,23'h005A04};                              
                9'd245:data_w <= {WR_Bit,23'h000104};                              
                9'd246:data_w <= {WR_Bit,23'h000100};     //脉冲发生器控制                          
                9'd247:
                    begin
                    data_w <= {WR_Bit,23'h000100}; 
                    HMC_Done <= 1'b1;
                    end

            default:;
        endcase  
    end
  else
    data_w <= data_w;
end

assign Reg_Data = data_w;
endmodule

