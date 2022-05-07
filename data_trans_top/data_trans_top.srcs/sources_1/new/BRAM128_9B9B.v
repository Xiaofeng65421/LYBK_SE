//----------------------------------------------------------------------//
//
//	Copyright (c) 2018 BeeBeans Technologies All rights reserved
//
//		System		: 
//
//		Module		: RAM128_9B9B
//
//		Description	: BlockMemory Write:9bit/128word Read:9bit/128word
//
//		file		: RAM128_9B9B.v
//
//		Note		:
//
//		history	:
//			180606	------		Created by M.Ishiwata
//
//----------------------------------------------------------------------//
`default_nettype none
module
	BRAM128_9B9B	(
		input	wire			clka,
		input	wire			wea,
		input	wire	[ 6:0]	addra,
		input	wire	[ 8:0]	dina,
		input	wire			clkb,
		input	wire	[ 6:0]	addrb,
		output	wire	[ 8:0]	doutb
	);

	wire	[9:0]	NU;

	RAMB18E1 #(
		.INITP_00		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_01		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_02		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_03		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_04		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_05		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_06		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INITP_07		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_00		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_01		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_02		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_03		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_04		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_05		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_06		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_07		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_08		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_09		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0A		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0B		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0C		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0D		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0E		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_0F		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_10		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_11		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_12		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_13		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_14		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_15		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_16		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_17		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_18		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_19		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1A		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1B		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1C		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1D		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1E		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_1F		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_20		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_21		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_22		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_23		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_24		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_25		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_26		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_27		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_28		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_29		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2A		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2B		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2C		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2D		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2E		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_2F		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_30		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_31		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_32		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_33		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_34		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_35		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_36		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_37		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_38		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_39		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3A		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3B		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3C		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3D		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3E		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.INIT_3F		(256'h0000000000000000000000000000000000000000000000000000000000000000),
		.DOA_REG						(1),
		.DOB_REG						(1),
		.INIT_A							(18'h0),
		.INIT_B							(18'h0),
		.INIT_FILE						("NONE"),
//		parameter			IS_CLKARDCLK_INVERTED		= 1'b0),
//		parameter			IS_CLKBWRCLK_INVERTED		= 1'b0),
//		parameter			IS_ENARDEN_INVERTED			= 1'b0),
//		parameter			IS_ENBWREN_INVERTED			= 1'b0),
//		parameter			IS_RSTRAMARSTRAM_INVERTED	= 1'b0),
//		parameter			IS_RSTRAMB_INVERTED			= 1'b0),
//		parameter			IS_RSTREGARSTREG_INVERTED	= 1'b0),
//		parameter			IS_RSTREGB_INVERTED			= 1'b0),
		.RAM_MODE						("SDP"),
		.RDADDR_COLLISION_HWCONFIG		("PERFORMANCE"),
		.READ_WIDTH_A					(9),
//		.READ_WIDTH_B					(0),
		.RSTREG_PRIORITY_A				("RSTREG"),
//		.RSTREG_PRIORITY_B				("RSTREG"),
		.SIM_COLLISION_CHECK			("GENERATE_X_ONLY"),
		.SIM_DEVICE						("7SERIES"),
		.SRVAL_A						(18'h0),
//		.SRVAL_B						(18'h0),
		.WRITE_MODE_A					("WRITE_FIRST"),
		.WRITE_MODE_B					("WRITE_FIRST"),
//		.WRITE_WIDTH_A					(0),
		.WRITE_WIDTH_B					(9)
	)
	RAMB18E1_i(
		.CLKBWRCLK		(clka),
		.ADDRBWRADDR	({4'b0000,addra[6:0],3'b000}),
		.WEBWE			(1'b1),
		.ENBWREN		(wea),
		.DIADI			(16'h0000),
		.DIPADIP		(2'b00),
		.DIBDI			({8'd0,dina[7:0]}),
		.DIPBDIP		({1'b0,dina[8]}),

		.CLKARDCLK		(clkb),
		.WEA			(1'b0),
		.ENARDEN		(1'b1),
		.REGCEAREGCE	(1'b1),
		.ADDRARDADDR	({4'b0000,addrb[6:0],3'b000}),
		.DOADO			({NU[7:0],doutb[7:0]}),
		.DOPADOP		({NU[8],doutb[8]}),
		.DOBDO			(),
		.DOPBDOP		(),

		.RSTREGARSTREG	(1'b0),
		.RSTREGB		(1'b0),
		.RSTRAMARSTRAM	(1'b0),
		.RSTRAMB		(1'b0),
		.REGCEB			(1'b1)
	);


endmodule
`default_nettype wire
