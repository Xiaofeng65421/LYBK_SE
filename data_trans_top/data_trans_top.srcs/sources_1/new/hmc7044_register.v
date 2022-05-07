`timescale 1ns / 1ps
module hmc7044_register(  
input clk_200m,
input reset,
input SPI_Done,                 //SPIһ�β�����ɷ����ź�
output reg SPI_Exe,           //ISPI����ִ���ź�
output reg HMC_Done,        //HMC7043������ɱ�־
output [23:0]Reg_Data   //HMC7043�Ĵ�������
    );

//*****************************************************
//**                    main code
//*****************************************************

reg [8:0]register_num = 9'd247; 
reg [8:0]register_w = 9'd0;
reg WR_Bit = 1'b0;                      //��23λ���Ͷ���Ϊдʱ��

//����ָʾ
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

/*SPI����ģ��*/
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

/*��Ҫ���õļĴ�������*/
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
                9'd0  :data_w <= {WR_Bit,23'h000001};     //��λ
                9'd1  :data_w <= {WR_Bit,23'h000000};     //�ͷ���λ
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
                9'd12 :data_w <= {WR_Bit,23'h009600};     //����
                9'd13 :data_w <= {WR_Bit,23'h009700};     //����
                9'd14 :data_w <= {WR_Bit,23'h009800};     //����
                9'd15 :data_w <= {WR_Bit,23'h009900};     //����
                9'd16 :data_w <= {WR_Bit,23'h009A00};     //����
                9'd17 :data_w <= {WR_Bit,23'h009BAA};     //����
                9'd18 :data_w <= {WR_Bit,23'h009CAA};     //����
                9'd19 :data_w <= {WR_Bit,23'h009DAA};     //����
                9'd20 :data_w <= {WR_Bit,23'h009EAA};     //����
                9'd21 :data_w <= {WR_Bit,23'h009F4D};     //����
                9'd22 :data_w <= {WR_Bit,23'h00A0DF};     //����
                9'd23 :data_w <= {WR_Bit,23'h00A197};     //����
                9'd24 :data_w <= {WR_Bit,23'h00A203};     //����
                9'd25 :data_w <= {WR_Bit,23'h00A300};     //����
                9'd26 :data_w <= {WR_Bit,23'h00A400};     //����
                9'd27 :data_w <= {WR_Bit,23'h00A506};     //����
                9'd28 :data_w <= {WR_Bit,23'h00A61C};     //����
                9'd29 :data_w <= {WR_Bit,23'h00A700};     //����
                9'd30 :data_w <= {WR_Bit,23'h00A806};     //����
                9'd31 :data_w <= {WR_Bit,23'h00A900};     //����
                9'd32 :data_w <= {WR_Bit,23'h00AB00};     //����
                9'd33 :data_w <= {WR_Bit,23'h00AC20};     //����
                9'd34 :data_w <= {WR_Bit,23'h00AD00};     //����
                9'd35 :data_w <= {WR_Bit,23'h00AE08};     //����
                9'd36 :data_w <= {WR_Bit,23'h00AF50};     //����
                9'd37 :data_w <= {WR_Bit,23'h00B004};     //����
                9'd38 :data_w <= {WR_Bit,23'h00B10D};     //����
                9'd39 :data_w <= {WR_Bit,23'h00B200};     //����
                9'd40 :data_w <= {WR_Bit,23'h00B300};     //����
                9'd41 :data_w <= {WR_Bit,23'h00B500};     //����
                9'd42 :data_w <= {WR_Bit,23'h00B600};     //����
                9'd43 :data_w <= {WR_Bit,23'h00B700};     //����
                9'd44 :data_w <= {WR_Bit,23'h00B800};     //����
                
                9'd45 :data_w <= {WR_Bit,23'h004600};     //GPI1��ֹʹ��                                     
                9'd46 :data_w <= {WR_Bit,23'h004700};     //GPI2��ֹʹ��                                     
                9'd47 :data_w <= {WR_Bit,23'h004800};     //GPI3��ֹʹ��                                     
                9'd48 :data_w <= {WR_Bit,23'h004900};     //GPI4��ֹʹ��                                     
                9'd49 :data_w <= {WR_Bit,23'h00500B};     //GPO1��CLKIN3/CLKIN3 LOS for CLKIN3/CLKIN3 input��  
                9'd50 :data_w <= {WR_Bit,23'h00511F};     //GPO2������PLL1��������źţ�                        
                9'd51 :data_w <= {WR_Bit,23'h00522B};     //GPO3������PLL2��������źţ�     
                9'd52 :data_w <= {WR_Bit,23'h005337};     //GPO4��PLL1 �� PLL2 ������ⱻ������                   
                9'd53 :data_w <= {WR_Bit,23'h005403};     //SDATA���ƣ�COMSģʽ��������ʹ��                         
                9'd54 :data_w <= {WR_Bit,23'h00050F};     //SYNC����,PLL1�ο�·��ΪCLKIN3,//h8F                 
                9'd55 :data_w <= {WR_Bit,23'h000337};     //PLL1��PLL2��SYSREF��ʱ��ʹ��                                  
                9'd56 :data_w <= {WR_Bit,23'h003201};     //h00,ʹ��R2������ǰ�ı�Ƶ����h01,��·��Ƶ��                   
                9'd57 :data_w <= {WR_Bit,23'h003332};     //R2��Ƶ����ֵΪ50��Ƶ                                 
                9'd58 :data_w <= {WR_Bit,23'h003400};                                                    
                9'd59 :data_w <= {WR_Bit,23'h003514};     //N2��Ƶ����ֵΪ1250��Ƶ
                9'd60 :data_w <= {WR_Bit,23'h003605};     //
                9'd61 :data_w <= {WR_Bit,23'h0037ff};     // PLL2 ��ɱÿ��� 
                9'd62 :data_w <= {WR_Bit,23'h003818};     // PLL2 PFD ���� 
                9'd63 :data_w <= {WR_Bit,23'h003900};     //��ֹOSCOUTx���                                  
                9'd64 :data_w <= {WR_Bit,23'h003A20};     //                                             
                9'd65 :data_w <= {WR_Bit,23'h003B20};                                                    
                9'd66 :data_w <= {WR_Bit,23'h003C00};     //����                                           
                9'd67 :data_w <= {WR_Bit,23'h000A0d};     //CLKINx��OSCINʹ�����뻺������ʹ���ڲ�100ŷķ�˽ӣ�ʹ�ܽ����������ģʽ   
                9'd68 :data_w <= {WR_Bit,23'h000B0d};                                                    
                9'd69 :data_w <= {WR_Bit,23'h000C0d};                                                    
                9'd70 :data_w <= {WR_Bit,23'h000D0d};                                                    
                9'd71 :data_w <= {WR_Bit,23'h000E0d};     //OSCINʹ�����뻺������ʹ���ڲ�100ŷķ�˽ӣ�ʹ�ܽ����������ģʽ          
                9'd72 :data_w <= {WR_Bit,23'h0014E1};     //PLL1�ο����ȼ����ƣ�����Ϊ1,0,2,3                      
                9'd73 :data_w <= {WR_Bit,23'h001507};     //PLL1�ź�LOS����                                  
                9'd74 :data_w <= {WR_Bit,23'h00160C};     //PLL1�����˳�����                                   
                9'd75 :data_w <= {WR_Bit,23'h001700};                                                    
                9'd76 :data_w <= {WR_Bit,23'h001804};                                                    
                9'd77 :data_w <= {WR_Bit,23'h001902};                                                    
                9'd78 :data_w <= {WR_Bit,23'h001A0F};     //PLL1��ɱÿ���                                    
                9'd79 :data_w <= {WR_Bit,23'h001B18};     //ʹ��PLL1 PFD�������½�                              
                9'd80 :data_w <= {WR_Bit,23'h001C01};     //CLKINx��OSCIN����Ԥ��ƵΪ1                          
                9'd81 :data_w <= {WR_Bit,23'h001D01};                                                    
                9'd82 :data_w <= {WR_Bit,23'h001E01};////////////////////////////////////////////////////
                9'd83 :data_w <= {WR_Bit,23'h001F01};                                                    
                9'd84 :data_w <= {WR_Bit,23'h002001};                                                    
                9'd85 :data_w <= {WR_Bit,23'h002105};     //R1��Ƶ��Ϊ5                            
                9'd86 :data_w <= {WR_Bit,23'h002200};                                                    
                9'd87 :data_w <= {WR_Bit,23'h002605};     //N1��Ƶ��Ϊ5                         
                9'd88 :data_w <= {WR_Bit,23'h002700};                                                    
                9'd89 :data_w <= {WR_Bit,23'h00282F};     //PLL1����������                                   
                9'd90 :data_w <= {WR_Bit,23'h00290b};     //PLL1�ο��л��ر��Զ��л����ֶ�ѡ��CLKIN0    //h1C           
                9'd91 :data_w <= {WR_Bit,23'h002A00};     //PLL1����ʱ�����                                   
                9'd92 :data_w <= {WR_Bit,23'h005A00};     //���巢��������                                      
                9'd93 :data_w <= {WR_Bit,23'h005B06};                                                    
                9'd94 :data_w <= {WR_Bit,23'h005C00};                                                    
                9'd95 :data_w <= {WR_Bit,23'h005D01};                                                    
                9'd96 :data_w <= {WR_Bit,23'h005E00};     //����                                           
                9'd97 :data_w <= {WR_Bit,23'h006400};                                                    
                9'd98 :data_w <= {WR_Bit,23'h006500};                                                    
                9'd99 :data_w <= {WR_Bit,23'h00C881};     //ͨ��0���ƣ�ͨ��ʹ�ܣ�����ʹ��                              
                9'd100:data_w <= {WR_Bit,23'h00C91A};     //ͨ��0��Ƶϵ��25�����100MHz                           
                9'd101:data_w <= {WR_Bit,23'h00CA00};                                                    
                9'd102:data_w <= {WR_Bit,23'h00CB00};     //ͨ��0΢��ģ���ӳ�                                    
                9'd103:data_w <= {WR_Bit,23'h00CC00};     //ͨ��0�ֵ������ӳ�                                    
                9'd104:data_w <= {WR_Bit,23'h00CD00};     //ͨ��0���������ӳ�                                    
                9'd105:data_w <= {WR_Bit,23'h00CE00};                                                    
                9'd106:data_w <= {WR_Bit,23'h00CF00};     //ͨ��0��Ƶ�����                                     
                9'd107:data_w <= {WR_Bit,23'h00D010};     //ͨ��0 LVDS���ģʽ                                 
                9'd108:data_w <= {WR_Bit,23'h00D100};     //����                                           
                9'd109:data_w <= {WR_Bit,23'h00D200};     //ͨ��1���ƣ�ͨ��ʹ�ܣ�����ʹ��                              
                9'd110:data_w <= {WR_Bit,23'h00D364};     //ͨ��1��Ƶϵ��26�����100MHz                           
                9'd111:data_w <= {WR_Bit,23'h00D400};                                                    
                9'd112:data_w <= {WR_Bit,23'h00D500};     //ͨ��1΢��ģ���ӳ�                                    
                9'd113:data_w <= {WR_Bit,23'h00D600};     //ͨ��1�ֵ������ӳ�                                    
                9'd114:data_w <= {WR_Bit,23'h00D700};     //ͨ��1���������ӳ�                                    
                9'd115:data_w <= {WR_Bit,23'h00D800};                                                    
                9'd116:data_w <= {WR_Bit,23'h00D900};     //ͨ��1��Ƶ�����                                     
                9'd117:data_w <= {WR_Bit,23'h00DA10};     //ͨ��1 LVDS���ģʽ                                 
                9'd118:data_w <= {WR_Bit,23'h00DB00};     //����                                           
                9'd119:data_w <= {WR_Bit,23'h00DC00};     //ͨ��2���ƣ�ͨ��ʹ�ܣ�����ʹ��                              
                9'd120:data_w <= {WR_Bit,23'h00DD14};     //ͨ��2��Ƶϵ��20�����125MHz                           
                9'd121:data_w <= {WR_Bit,23'h00DE00};                                                    
                9'd122:data_w <= {WR_Bit,23'h00DF00};     //ͨ��2΢��ģ���ӳ�                                    
                9'd123:data_w <= {WR_Bit,23'h00E000};     //ͨ��2�ֵ������ӳ�                                    
                9'd124:data_w <= {WR_Bit,23'h00E100};     //ͨ��2���������ӳ�                                    
                9'd125:data_w <= {WR_Bit,23'h00E200};                                                    
                9'd126:data_w <= {WR_Bit,23'h00E300};     //ͨ��2��Ƶ�����                                     
                9'd127:data_w <= {WR_Bit,23'h00E410};     //ͨ��2 LVDS���ģʽ                                 
                9'd128:data_w <= {WR_Bit,23'h00E500};     //����                                           
                9'd129:data_w <= {WR_Bit,23'h00E600};     //ͨ��3���ƣ�ͨ��ʹ�ܣ�����ʹ��                              
                9'd130:data_w <= {WR_Bit,23'h00E764};     //ͨ��3��Ƶϵ��100�����25MHz                           
                9'd131:data_w <= {WR_Bit,23'h00E800};                                                    
                9'd132:data_w <= {WR_Bit,23'h00E900};     //ͨ��3΢��ģ���ӳ�                                    
                9'd133:data_w <= {WR_Bit,23'h00EA00};     //ͨ��3�ֵ������ӳ�                                    
                9'd134:data_w <= {WR_Bit,23'h00EB00};     //ͨ��3���������ӳ�                                    
                9'd135:data_w <= {WR_Bit,23'h00EC00};                                                    
                9'd136:data_w <= {WR_Bit,23'h00ED00};     //ͨ��3��Ƶ�����                                     
                9'd137:data_w <= {WR_Bit,23'h00EE10};     //ͨ��3 LVDS���ģʽ                                 
                9'd138:data_w <= {WR_Bit,23'h00EF00};     //����                                           
                9'd139:data_w <= {WR_Bit,23'h00F081};     //ͨ��4���ƣ�ͨ��ʹ�ܣ�����ʹ��                              
                9'd140:data_w <= {WR_Bit,23'h00F11A};     //ͨ��4��Ƶϵ��26�����100MHz                           
                9'd141:data_w <= {WR_Bit,23'h00F200};                                                    
                9'd142:data_w <= {WR_Bit,23'h00F300};     //ͨ��4΢��ģ���ӳ�                                    
                9'd143:data_w <= {WR_Bit,23'h00F400};     //ͨ��4�ֵ������ӳ�                                    
                9'd144:data_w <= {WR_Bit,23'h00F500};     //ͨ��4���������ӳ�                                    
                9'd145:data_w <= {WR_Bit,23'h00F600};                                                    
                9'd146:data_w <= {WR_Bit,23'h00F700};     //ͨ��4��Ƶ�����                                     
                9'd147:data_w <= {WR_Bit,23'h00F808};     //ͨ��4 LVPECL���ģʽ                               
                9'd148:data_w <= {WR_Bit,23'h00F900};     //����                                           
                9'd149:data_w <= {WR_Bit,23'h00FA81};     //ͨ��5���ƣ�ͨ��ʹ�ܣ�����ʹ��    //h7C                     
                9'd150:data_w <= {WR_Bit,23'h00FB1A};     //ͨ��5��Ƶϵ��26�����100MHz                           
                9'd151:data_w <= {WR_Bit,23'h00FC00};                                                    
                9'd152:data_w <= {WR_Bit,23'h00FD00};     //ͨ��5΢��ģ���ӳ�                                    
                9'd153:data_w <= {WR_Bit,23'h00FE00};     //ͨ��5�ֵ������ӳ�                                    
                9'd154:data_w <= {WR_Bit,23'h00FF00};     //ͨ��5���������ӳ�                                    
                9'd155:data_w <= {WR_Bit,23'h010000};                                                    
                9'd156:data_w <= {WR_Bit,23'h010100};     //ͨ��5��Ƶ�����                                     
                9'd157:data_w <= {WR_Bit,23'h010208};     //ͨ��5 LVPECL���ģʽ                               
                9'd158:data_w <= {WR_Bit,23'h010300};     //����                                           
                9'd159:data_w <= {WR_Bit,23'h010481};     //ͨ��6���ƣ�ͨ��ʹ�ܣ�����ʹ��    //hF2                     
                9'd160:data_w <= {WR_Bit,23'h01051A};     //ͨ��6��Ƶϵ��26�����100MHz                           
                9'd161:data_w <= {WR_Bit,23'h010600};                                                    
                9'd162:data_w <= {WR_Bit,23'h010700};     //ͨ��6΢��ģ���ӳ�                                    
                9'd163:data_w <= {WR_Bit,23'h010800};     //ͨ��6�ֵ������ӳ�                                    
                9'd164:data_w <= {WR_Bit,23'h010900};     //ͨ��6���������ӳ�                                    
                9'd165:data_w <= {WR_Bit,23'h010A00};                                                    
                9'd166:data_w <= {WR_Bit,23'h010B00};     //ͨ��6��Ƶ�����                                     
                9'd167:data_w <= {WR_Bit,23'h010C10};     //ͨ��6 LVDS���ģʽ                                 
                9'd168:data_w <= {WR_Bit,23'h010D00};     //����                                           
                9'd169:data_w <= {WR_Bit,23'h010E81};     //ͨ��7���ƣ�ͨ��ʹ�ܣ�����ʹ��    //h7C                     
                9'd170:data_w <= {WR_Bit,23'h010F1A};     //ͨ��7��Ƶϵ��26�����100MHz                           
                9'd171:data_w <= {WR_Bit,23'h011000};                                                    
                9'd172:data_w <= {WR_Bit,23'h011100};     //ͨ��7΢��ģ���ӳ�                                    
                9'd173:data_w <= {WR_Bit,23'h011200};     //ͨ��7�ֵ������ӳ�                                    
                9'd174:data_w <= {WR_Bit,23'h011300};     //ͨ��7���������ӳ�                                    
                9'd175:data_w <= {WR_Bit,23'h011400};                                                    
                9'd176:data_w <= {WR_Bit,23'h011500};     //ͨ��7��Ƶ�����                                     
                9'd177:data_w <= {WR_Bit,23'h011608};     //ͨ��7 LVPECL���ģʽ                               
                9'd178:data_w <= {WR_Bit,23'h011700};     //����                                           
                9'd179:data_w <= {WR_Bit,23'h011881};     //ͨ��8���ƣ�ͨ��ʹ�ܣ�����ʹ��     //hF2                    
                9'd180:data_w <= {WR_Bit,23'h01191A};     //ͨ��8��Ƶϵ��26�����100MHz                           
                9'd181:data_w <= {WR_Bit,23'h011A00};                                                    
                9'd182:data_w <= {WR_Bit,23'h011B00};     //ͨ��8΢��ģ���ӳ�                                    
                9'd183:data_w <= {WR_Bit,23'h011C00};     //ͨ��8�ֵ������ӳ�                                    
                9'd184:data_w <= {WR_Bit,23'h011D00};     //ͨ��8���������ӳ�                                    
                9'd185:data_w <= {WR_Bit,23'h011E00};                                                    
                9'd186:data_w <= {WR_Bit,23'h011F00};     //ͨ��8��Ƶ�����                                     
                9'd187:data_w <= {WR_Bit,23'h012010};     //ͨ��8 LVDS���ģʽ                                 
                9'd188:data_w <= {WR_Bit,23'h012100};     //����                                           
                9'd189:data_w <= {WR_Bit,23'h012281};     //ͨ��9���ƣ�ͨ��ʹ�ܣ�����ʹ��     //hF2                    
                9'd190:data_w <= {WR_Bit,23'h01231A};     //ͨ��9��Ƶϵ��26�����100MHz                           
                9'd191:data_w <= {WR_Bit,23'h012400};                                                    
                9'd192:data_w <= {WR_Bit,23'h012500};     //ͨ��9΢��ģ���ӳ�                                    
                9'd193:data_w <= {WR_Bit,23'h012600};     //ͨ��9�ֵ������ӳ�                                    
                9'd194:data_w <= {WR_Bit,23'h012700};     //ͨ��9���������ӳ�                                    
                9'd195:data_w <= {WR_Bit,23'h012800};                                                    
                9'd196:data_w <= {WR_Bit,23'h012900};     //ͨ��9��Ƶ�����                                     
                9'd197:data_w <= {WR_Bit,23'h012A10};     //ͨ��9 LVDS���ģʽ                                 
                9'd198:data_w <= {WR_Bit,23'h012B00};     //����                                           
                9'd199:data_w <= {WR_Bit,23'h012C81};     //ͨ��10���ƣ�ͨ��ʹ�ܣ�����ʹ��                             
                9'd200:data_w <= {WR_Bit,23'h012D1A};     //ͨ��10��Ƶϵ��26�����100MHz                          
                9'd201:data_w <= {WR_Bit,23'h012E00};                                                    
                9'd202:data_w <= {WR_Bit,23'h012F00};     //ͨ��10΢��ģ���ӳ�                                   
                9'd203:data_w <= {WR_Bit,23'h013000};     //ͨ��10�ֵ������ӳ�                                   
                9'd204:data_w <= {WR_Bit,23'h013100};     //ͨ��10���������ӳ�                                   
                9'd205:data_w <= {WR_Bit,23'h013200};                                                    
                9'd206:data_w <= {WR_Bit,23'h013300};     //ͨ��10��Ƶ�����                                    
                9'd207:data_w <= {WR_Bit,23'h013410};     //ͨ��10 LVDS���ģʽ                                
                9'd208:data_w <= {WR_Bit,23'h013500};     //����                                           
                9'd209:data_w <= {WR_Bit,23'h013681};     //ͨ��11���ƣ�ͨ��ʹ�ܣ�����ʹ��     //h7C                   
                9'd210:data_w <= {WR_Bit,23'h01371A};     //ͨ��11��Ƶϵ��26�����100MHz                          
                9'd211:data_w <= {WR_Bit,23'h013800};                                                    
                9'd212:data_w <= {WR_Bit,23'h013900};     //ͨ��11΢��ģ���ӳ�                                   
                9'd213:data_w <= {WR_Bit,23'h013A00};     //ͨ��11�ֵ������ӳ�                                   
                9'd214:data_w <= {WR_Bit,23'h013B00};     //ͨ��11���������ӳ�                                   
                9'd215:data_w <= {WR_Bit,23'h013C00};                                                    
                9'd216:data_w <= {WR_Bit,23'h013D00};     //ͨ��11��Ƶ�����                                    
                9'd217:data_w <= {WR_Bit,23'h013E10};     //ͨ��11 LVDS���ģʽ                                
                9'd218:data_w <= {WR_Bit,23'h013F00};     //����                                           
                9'd219:data_w <= {WR_Bit,23'h014000};     //ͨ��12���ƣ�ͨ��ʹ�ܣ�����ʹ��     //hF2                   
                9'd220:data_w <= {WR_Bit,23'h014114};     //ͨ��12��Ƶϵ��25�����100MHz                          
                9'd221:data_w <= {WR_Bit,23'h014200};                                                    
                9'd222:data_w <= {WR_Bit,23'h014200};                                   
                9'd223:data_w <= {WR_Bit,23'h014300};     //ͨ��12΢��ģ���ӳ�      
                9'd224:data_w <= {WR_Bit,23'h014400};     //ͨ��12�ֵ������ӳ�      
                9'd225:data_w <= {WR_Bit,23'h014500};     //ͨ��12���������ӳ�      
                9'd226:data_w <= {WR_Bit,23'h014600};                       
                9'd227:data_w <= {WR_Bit,23'h014700};     //ͨ��12��Ƶ�����       
                9'd228:data_w <= {WR_Bit,23'h014810};     //ͨ��12 LVDS���ģʽ                
                9'd229:data_w <= {WR_Bit,23'h014900};     //����            
                9'd230:data_w <= {WR_Bit,23'h014A00};     //ͨ��13���ƣ�ͨ��ʹ�ܣ�����ʹ��          
                9'd231:data_w <= {WR_Bit,23'h014B19};     //ͨ��13��Ƶϵ��25�����100MHz              
                9'd232:data_w <= {WR_Bit,23'h014C00};                                        
                9'd233:data_w <= {WR_Bit,23'h014D00};     //ͨ��13΢��ģ���ӳ�                       
                9'd234:data_w <= {WR_Bit,23'h014E00};     //ͨ��13�ֵ������ӳ�                       
                9'd235:data_w <= {WR_Bit,23'h014F00};     //ͨ��13���������ӳ�                       
                9'd236:data_w <= {WR_Bit,23'h015000};     //ͨ��13��Ƶ�����                   
                9'd237:data_w <= {WR_Bit,23'h015100};     //ͨ��13 LVDS���ģʽ 
                9'd238:data_w <= {WR_Bit,23'h015210};     //����            
                9'd239:data_w <= {WR_Bit,23'h015300};          
                9'd240:data_w <= {WR_Bit,23'h000102};      //ȫ�������ģʽ����   
                9'd241:data_w <= {WR_Bit,23'h000100};                       
                9'd242:data_w <= {WR_Bit,23'h000180};                       
                9'd243:data_w <= {WR_Bit,23'h0001E0};                                        
                9'd244:data_w <= {WR_Bit,23'h005A04};                              
                9'd245:data_w <= {WR_Bit,23'h000104};                              
                9'd246:data_w <= {WR_Bit,23'h000100};     //���巢��������                          
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

