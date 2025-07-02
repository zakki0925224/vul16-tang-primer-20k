module Register (
	clock,
	reset,
	io_in,
	io_out,
	io_write
);
	input clock;
	input reset;
	input [15:0] io_in;
	output wire [15:0] io_out;
	input io_write;
	reg [15:0] reg_0;
	always @(posedge clock)
		if (reset)
			reg_0 <= 16'h0000;
		else if (io_write)
			reg_0 <= io_in;
	assign io_out = reg_0;
endmodule
module Alu (
	io_a,
	io_b,
	io_op,
	io_out
);
	input [15:0] io_a;
	input [15:0] io_b;
	input [3:0] io_op;
	output wire [15:0] io_out;
	wire [46:0] _io_out_T_16 = {31'h00000000, io_a} << io_b[4:0];
	wire [255:0] _GEN = {111'h0000000000000000000000000000, io_a < io_b, 15'h0000, $signed(io_a) < $signed(io_b), $signed($signed(io_a) >>> io_b[4:0]), io_a >> io_b[4:0], _io_out_T_16[15:0], io_a ^ io_b, io_a | io_b, io_a & io_b, io_a - io_b, io_a + io_b};
	assign io_out = _GEN[io_op * 16+:16];
endmodule
module Cpu (
	clock,
	reset,
	io_memDataAddr,
	io_memDataIn,
	io_memDataOut,
	io_memDataWrite,
	io_memDataReq,
	io_memDataDone,
	io_memInstReq,
	io_memInstDone,
	io_inst,
	io_pc,
	io_gpRegs_1,
	io_gpRegs_2,
	io_gpRegs_3,
	io_gpRegs_4,
	io_gpRegs_5,
	io_gpRegs_6,
	io_gpRegs_7,
	io_debugHalt,
	io_debugStep
);
	input clock;
	input reset;
	output wire [15:0] io_memDataAddr;
	output wire [7:0] io_memDataIn;
	input [7:0] io_memDataOut;
	output wire io_memDataWrite;
	output wire io_memDataReq;
	input io_memDataDone;
	output wire io_memInstReq;
	input io_memInstDone;
	input [15:0] io_inst;
	output wire [15:0] io_pc;
	output wire [15:0] io_gpRegs_1;
	output wire [15:0] io_gpRegs_2;
	output wire [15:0] io_gpRegs_3;
	output wire [15:0] io_gpRegs_4;
	output wire [15:0] io_gpRegs_5;
	output wire [15:0] io_gpRegs_6;
	output wire [15:0] io_gpRegs_7;
	input io_debugHalt;
	input io_debugStep;
	wire [15:0] _alu_io_out;
	wire [15:0] _pc_io_out;
	wire [15:0] _Register_7_io_out;
	wire [15:0] _Register_6_io_out;
	wire [15:0] _Register_5_io_out;
	wire [15:0] _Register_4_io_out;
	wire [15:0] _Register_3_io_out;
	wire [15:0] _Register_2_io_out;
	wire [15:0] _Register_1_io_out;
	wire [15:0] _Register_io_out;
	wire [191:0] _GEN = 192'h7de75c6da6585d65544d24503ce34c2ca2481c61440c2040;
	reg memInstReqActive;
	reg memDataReqActive;
	reg [15:0] cycles;
	reg [7:0] lhValue;
	wire [5:0] op = _GEN[io_inst[15:11] * 6+:6];
	wire [1:0] fmt = (((((((((~(|op) | (op == 6'h02)) | (op == 6'h03)) | (op == 6'h05)) | (op == 6'h07)) | (op == 6'h09)) | (op == 6'h0b)) | (op == 6'h0d)) | (op == 6'h0f)) | (op == 6'h11) ? 2'h0 : (((((((((((((((op == 6'h01) | (op == 6'h04)) | (op == 6'h06)) | (op == 6'h08)) | (op == 6'h0a)) | (op == 6'h0c)) | (op == 6'h0e)) | (op == 6'h10)) | (op == 6'h12)) | (op == 6'h13)) | (op == 6'h14)) | (op == 6'h15)) | (op == 6'h16)) | (op == 6'h17)) | (op == 6'h19) ? 2'h1 : (op == 6'h18 ? 2'h2 : {2 {(((((op == 6'h1a) | (op == 6'h1b)) | (op == 6'h1c)) | (op == 6'h1d)) | (op == 6'h1e)) | (op == 6'h1f)}})));
	wire _GEN_0 = fmt == 2'h0;
	wire _GEN_1 = fmt == 2'h1;
	wire [10:0] _GEN_2 = {11 {io_inst[4]}};
	wire _GEN_3 = fmt == 2'h2;
	wire [11:0] _GEN_4 = {3'h0, io_inst[10:8], io_inst[10:8], io_inst[10:8]};
	wire _GEN_5 = fmt != 2'h3;
	wire _GEN_6 = _GEN_3 | _GEN_5;
	wire [11:0] _GEN_7 = {(_GEN_6 ? 3'h0 : io_inst[10:8]), 3'h0, io_inst[7:5], io_inst[7:5]};
	wire _GEN_8 = _GEN_1 | _GEN_3;
	wire _GEN_9 = _GEN_8 | _GEN_5;
	wire [11:0] _GEN_10 = {(_GEN_9 ? 3'h0 : io_inst[7:5]), 6'h00, io_inst[4:2]};
	wire [63:0] _GEN_11 = {_GEN_2, io_inst[4:0], {8 {io_inst[7]}}, io_inst[7:0], _GEN_2, io_inst[4:0], 16'h0000};
	wire [2:0] rd_1 = (_GEN_0 | _GEN_8 ? _GEN_4[fmt * 3+:3] : 3'h0);
	wire [11:0] _GEN_12 = {(_GEN_9 ? 3'h0 : _GEN_10[fmt * 3+:3]), 6'h00, _GEN_10[fmt * 3+:3]};
	wire [63:0] _GEN_13 = {_GEN_11[fmt * 16+:16], _GEN_11[fmt * 16+:16], _GEN_11[fmt * 16+:16], 16'h0000};
	wire [127:0] _GEN_14 = {_Register_7_io_out, _Register_6_io_out, _Register_5_io_out, _Register_4_io_out, _Register_3_io_out, _Register_2_io_out, _Register_1_io_out, _Register_io_out};
	wire [15:0] alu_a = _GEN_14[((_GEN_0 | _GEN_1) | ~_GEN_6 ? _GEN_7[fmt * 3+:3] : 3'h0) * 16+:16];
	wire cpuAllowProgress = ((~io_debugHalt | (io_debugHalt & io_debugStep)) & (~memInstReqActive | io_memInstDone)) & (~memDataReqActive | io_memDataDone);
	wire _GEN_15 = cycles == 16'h0000;
	wire _GEN_16 = op == 6'h02;
	wire _GEN_17 = op == 6'h03;
	wire _GEN_18 = op == 6'h04;
	wire _GEN_19 = op == 6'h05;
	wire _GEN_20 = op == 6'h06;
	wire _GEN_21 = op == 6'h07;
	wire _GEN_22 = op == 6'h08;
	wire _GEN_23 = op == 6'h09;
	wire _GEN_24 = op == 6'h0a;
	wire _GEN_25 = op == 6'h0b;
	wire _GEN_26 = op == 6'h0c;
	wire _GEN_27 = op == 6'h0d;
	wire _GEN_28 = op == 6'h0e;
	wire _GEN_29 = op == 6'h0f;
	wire _GEN_30 = op == 6'h10;
	wire _GEN_31 = op == 6'h11;
	wire _GEN_32 = op == 6'h12;
	wire _GEN_33 = ~(|op) | (op == 6'h01);
	wire _GEN_34 = ((((((((((((((((_GEN_33 | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32;
	wire _GEN_35 = (cpuAllowProgress & _GEN_15) & _GEN_34;
	wire _GEN_36 = rd_1 == 3'h0;
	wire _GEN_37 = rd_1 == 3'h1;
	wire _GEN_38 = rd_1 == 3'h2;
	wire _GEN_39 = rd_1 == 3'h3;
	wire _GEN_40 = rd_1 == 3'h4;
	wire _GEN_41 = rd_1 == 3'h5;
	wire _GEN_42 = rd_1 == 3'h6;
	wire _GEN_43 = (op == 6'h13) | (op == 6'h14);
	wire _GEN_44 = io_memDataDone & _GEN_36;
	wire _GEN_45 = io_memDataDone & _GEN_37;
	wire _GEN_46 = io_memDataDone & _GEN_38;
	wire _GEN_47 = io_memDataDone & _GEN_39;
	wire _GEN_48 = io_memDataDone & _GEN_40;
	wire _GEN_49 = io_memDataDone & _GEN_41;
	wire _GEN_50 = io_memDataDone & _GEN_42;
	wire _GEN_51 = io_memDataDone & (&rd_1);
	wire [15:0] _GEN_52 = {8'h00, io_memDataOut};
	wire _GEN_53 = op == 6'h15;
	wire _GEN_54 = _GEN_53 & io_memDataDone;
	wire _GEN_55 = _GEN_34 | _GEN_43;
	wire _GEN_56 = op == 6'h16;
	wire _GEN_57 = op == 6'h17;
	wire _GEN_58 = (_GEN_34 | _GEN_43) | _GEN_53;
	wire _GEN_59 = _GEN_57 & io_memDataDone;
	wire _GEN_60 = op == 6'h18;
	wire [15:0] _gpRegs_in_T_3 = _pc_io_out + 16'h0002;
	wire _GEN_61 = op == 6'h19;
	wire [15:0] _newPc_T_1 = _pc_io_out + 16'h0002;
	wire _GEN_62 = (_GEN_53 | _GEN_56) | _GEN_57;
	wire _GEN_63 = _GEN_60 | _GEN_61;
	wire _GEN_64 = (((((op == 6'h1a) | (op == 6'h1b)) | (op == 6'h1c)) | (op == 6'h1d)) | (op == 6'h1e)) | (op == 6'h1f);
	wire _GEN_65 = cycles == 16'h0001;
	wire [15:0] _gpRegs_in_T_7 = {io_memDataOut, lhValue};
	wire _GEN_66 = _GEN_65 & _GEN_54;
	always @(posedge clock)
		if (reset) begin
			memInstReqActive <= 1'h0;
			memDataReqActive <= 1'h0;
			cycles <= 16'h0000;
			lhValue <= 8'h00;
		end
		else begin
			memInstReqActive <= ~io_memInstDone & ((cpuAllowProgress & (~memDataReqActive | io_memDataDone)) | memInstReqActive);
			memDataReqActive <= ~io_memDataDone & (cpuAllowProgress ? (_GEN_15 ? ~_GEN_34 & (((_GEN_43 | _GEN_53) | _GEN_56) | _GEN_57) : _GEN_65 | memDataReqActive) : memDataReqActive);
			if (cpuAllowProgress) begin
				if (_GEN_15) begin
					if (~_GEN_55) begin
						if (_GEN_53) begin
							if (io_memDataDone)
								cycles <= 16'h0001;
						end
						else if (_GEN_56 | ~_GEN_59)
							;
						else
							cycles <= 16'h0001;
					end
				end
				else if ((_GEN_65 & (_GEN_53 | _GEN_57)) & io_memDataDone)
					cycles <= 16'h0000;
			end
			if ((~(cpuAllowProgress & _GEN_15) | _GEN_55) | ~_GEN_54)
				;
			else
				lhValue <= io_memDataOut;
		end
	Register Register(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_36 ? _alu_io_out : 16'h0000) : (_GEN_43 ? (_GEN_44 ? _GEN_52 : 16'h0000) : (_GEN_62 ? 16'h0000 : (_GEN_60 ? (_GEN_36 ? _gpRegs_in_T_3 : 16'h0000) : (_GEN_61 & _GEN_36 ? _newPc_T_1 : 16'h0000))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_36 ? _gpRegs_in_T_7 : 16'h0000)) : 16'h0000)),
		.io_out(_Register_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_36 : (_GEN_43 ? _GEN_44 : (~_GEN_62 & _GEN_63) & _GEN_36)) : _GEN_66 & _GEN_36))
	);
	Register Register_1(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_37 ? _alu_io_out : _Register_1_io_out) : (_GEN_43 ? (_GEN_45 ? _GEN_52 : _Register_1_io_out) : (_GEN_62 ? _Register_1_io_out : (_GEN_60 ? (_GEN_37 ? _gpRegs_in_T_3 : _Register_1_io_out) : (_GEN_61 & _GEN_37 ? _newPc_T_1 : _Register_1_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_37 ? _gpRegs_in_T_7 : _Register_1_io_out)) : _Register_1_io_out)),
		.io_out(_Register_1_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_37 : (_GEN_43 ? _GEN_45 : (~_GEN_62 & _GEN_63) & _GEN_37)) : _GEN_66 & _GEN_37))
	);
	Register Register_2(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_38 ? _alu_io_out : _Register_2_io_out) : (_GEN_43 ? (_GEN_46 ? _GEN_52 : _Register_2_io_out) : (_GEN_62 ? _Register_2_io_out : (_GEN_60 ? (_GEN_38 ? _gpRegs_in_T_3 : _Register_2_io_out) : (_GEN_61 & _GEN_38 ? _newPc_T_1 : _Register_2_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_38 ? _gpRegs_in_T_7 : _Register_2_io_out)) : _Register_2_io_out)),
		.io_out(_Register_2_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_38 : (_GEN_43 ? _GEN_46 : (~_GEN_62 & _GEN_63) & _GEN_38)) : _GEN_66 & _GEN_38))
	);
	Register Register_3(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_39 ? _alu_io_out : _Register_3_io_out) : (_GEN_43 ? (_GEN_47 ? _GEN_52 : _Register_3_io_out) : (_GEN_62 ? _Register_3_io_out : (_GEN_60 ? (_GEN_39 ? _gpRegs_in_T_3 : _Register_3_io_out) : (_GEN_61 & _GEN_39 ? _newPc_T_1 : _Register_3_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_39 ? _gpRegs_in_T_7 : _Register_3_io_out)) : _Register_3_io_out)),
		.io_out(_Register_3_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_39 : (_GEN_43 ? _GEN_47 : (~_GEN_62 & _GEN_63) & _GEN_39)) : _GEN_66 & _GEN_39))
	);
	Register Register_4(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_40 ? _alu_io_out : _Register_4_io_out) : (_GEN_43 ? (_GEN_48 ? _GEN_52 : _Register_4_io_out) : (_GEN_62 ? _Register_4_io_out : (_GEN_60 ? (_GEN_40 ? _gpRegs_in_T_3 : _Register_4_io_out) : (_GEN_61 & _GEN_40 ? _newPc_T_1 : _Register_4_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_40 ? _gpRegs_in_T_7 : _Register_4_io_out)) : _Register_4_io_out)),
		.io_out(_Register_4_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_40 : (_GEN_43 ? _GEN_48 : (~_GEN_62 & _GEN_63) & _GEN_40)) : _GEN_66 & _GEN_40))
	);
	Register Register_5(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_41 ? _alu_io_out : _Register_5_io_out) : (_GEN_43 ? (_GEN_49 ? _GEN_52 : _Register_5_io_out) : (_GEN_62 ? _Register_5_io_out : (_GEN_60 ? (_GEN_41 ? _gpRegs_in_T_3 : _Register_5_io_out) : (_GEN_61 & _GEN_41 ? _newPc_T_1 : _Register_5_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_41 ? _gpRegs_in_T_7 : _Register_5_io_out)) : _Register_5_io_out)),
		.io_out(_Register_5_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_41 : (_GEN_43 ? _GEN_49 : (~_GEN_62 & _GEN_63) & _GEN_41)) : _GEN_66 & _GEN_41))
	);
	Register Register_6(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (_GEN_42 ? _alu_io_out : _Register_6_io_out) : (_GEN_43 ? (_GEN_50 ? _GEN_52 : _Register_6_io_out) : (_GEN_62 ? _Register_6_io_out : (_GEN_60 ? (_GEN_42 ? _gpRegs_in_T_3 : _Register_6_io_out) : (_GEN_61 & _GEN_42 ? _newPc_T_1 : _Register_6_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & _GEN_42 ? _gpRegs_in_T_7 : _Register_6_io_out)) : _Register_6_io_out)),
		.io_out(_Register_6_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? _GEN_42 : (_GEN_43 ? _GEN_50 : (~_GEN_62 & _GEN_63) & _GEN_42)) : _GEN_66 & _GEN_42))
	);
	Register Register_7(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? (&rd_1 ? _alu_io_out : _Register_7_io_out) : (_GEN_43 ? (_GEN_51 ? _GEN_52 : _Register_7_io_out) : (_GEN_62 ? _Register_7_io_out : (_GEN_60 ? (&rd_1 ? _gpRegs_in_T_3 : _Register_7_io_out) : (_GEN_61 & (&rd_1) ? _newPc_T_1 : _Register_7_io_out))))) : (((_GEN_65 & _GEN_53) & io_memDataDone) & (&rd_1) ? _gpRegs_in_T_7 : _Register_7_io_out)) : _Register_7_io_out)),
		.io_out(_Register_7_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? (_GEN_34 ? &rd_1 : (_GEN_43 ? _GEN_51 : (~_GEN_62 & _GEN_63) & (&rd_1))) : _GEN_66 & (&rd_1)))
	);
	Register pc(
		.clock(clock),
		.reset(reset),
		.io_in((cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? _pc_io_out + 16'h0002 : (_GEN_43 ? _pc_io_out + 16'h0002 : (_GEN_53 ? _pc_io_out : (_GEN_56 ? _pc_io_out + 16'h0002 : (_GEN_57 ? _pc_io_out : (_GEN_60 ? _pc_io_out + _GEN_13[fmt * 16+:16] : (_GEN_61 ? 16'h0000 : (_GEN_64 ? _pc_io_out + 16'h0002 : _pc_io_out)))))))) : (_GEN_65 ? (_GEN_53 ? (io_memDataDone ? _pc_io_out + 16'h0002 : _pc_io_out) : (_GEN_59 ? _pc_io_out + 16'h0002 : _pc_io_out)) : _pc_io_out)) : _pc_io_out)),
		.io_out(_pc_io_out),
		.io_write(cpuAllowProgress & (_GEN_15 ? _GEN_55 | (~_GEN_53 & (_GEN_56 | (~_GEN_57 & ((_GEN_60 | _GEN_61) | _GEN_64)))) : (_GEN_65 & (_GEN_53 | _GEN_57)) & io_memDataDone))
	);
	Alu alu(
		.io_a((_GEN_35 ? alu_a : 16'h0000)),
		.io_b((_GEN_35 ? (((((((((~(|op) | _GEN_16) | _GEN_17) | _GEN_19) | _GEN_21) | _GEN_23) | _GEN_25) | _GEN_27) | _GEN_29) | _GEN_31 ? _GEN_14[_GEN_12[fmt * 3+:3] * 16+:16] : _GEN_13[fmt * 16+:16]) : 16'h0000)),
		.io_op((~_GEN_35 | _GEN_33 ? 4'h0 : (_GEN_16 ? 4'h1 : (_GEN_17 | _GEN_18 ? 4'h2 : (_GEN_19 | _GEN_20 ? 4'h3 : (_GEN_21 | _GEN_22 ? 4'h4 : (_GEN_23 | _GEN_24 ? 4'h5 : (_GEN_25 | _GEN_26 ? 4'h6 : (_GEN_27 | _GEN_28 ? 4'h7 : (_GEN_29 | _GEN_30 ? 4'h8 : (_GEN_31 | _GEN_32 ? 4'h9 : 4'h0))))))))))),
		.io_out(_alu_io_out)
	);
	assign io_memDataAddr = (cpuAllowProgress ? (_GEN_15 ? (_GEN_34 ? 16'h0000 : (_GEN_43 ? alu_a + _GEN_13[fmt * 16+:16] : (_GEN_53 ? alu_a + _GEN_13[fmt * 16+:16] : (_GEN_56 ? alu_a + _GEN_13[fmt * 16+:16] : (_GEN_57 ? alu_a + _GEN_13[fmt * 16+:16] : 16'h0000))))) : (_GEN_65 ? (_GEN_53 ? (alu_a + _GEN_13[fmt * 16+:16]) + 16'h0001 : (_GEN_57 ? (alu_a + _GEN_13[fmt * 16+:16]) + 16'h0001 : 16'h0000)) : 16'h0000)) : 16'h0000);
	assign io_memDataIn = (cpuAllowProgress ? (_GEN_15 ? (_GEN_58 ? 8'h00 : (_GEN_56 ? _GEN_14[(rd_1 * 16) + 7-:8] : (_GEN_57 ? _GEN_14[(rd_1 * 16) + 7-:8] : 8'h00))) : ((~_GEN_65 | _GEN_53) | ~_GEN_57 ? 8'h00 : _GEN_14[(rd_1 * 16) + 15-:8])) : 8'h00);
	assign io_memDataWrite = cpuAllowProgress & (_GEN_15 ? ~_GEN_58 & (_GEN_56 | _GEN_57) : (_GEN_65 & ~_GEN_53) & _GEN_57);
	assign io_memDataReq = memDataReqActive;
	assign io_memInstReq = memInstReqActive;
	assign io_pc = _pc_io_out;
	assign io_gpRegs_1 = _Register_1_io_out;
	assign io_gpRegs_2 = _Register_2_io_out;
	assign io_gpRegs_3 = _Register_3_io_out;
	assign io_gpRegs_4 = _Register_4_io_out;
	assign io_gpRegs_5 = _Register_5_io_out;
	assign io_gpRegs_6 = _Register_6_io_out;
	assign io_gpRegs_7 = _Register_7_io_out;
endmodule
module Core (
	clock,
	reset,
	io_pc,
	io_inst,
	io_gpRegs_0,
	io_gpRegs_1,
	io_gpRegs_2,
	io_gpRegs_3,
	io_gpRegs_4,
	io_gpRegs_5,
	io_gpRegs_6,
	io_gpRegs_7,
	io_memDataAddr,
	io_memDataIn,
	io_memDataOut,
	io_memDataWrite,
	io_memDataReq,
	io_memDataDone,
	io_memInst,
	io_memInstReq,
	io_memInstDone,
	io_debugHalt,
	io_debugStep
);
	input clock;
	input reset;
	output wire [15:0] io_pc;
	output wire [15:0] io_inst;
	output wire [15:0] io_gpRegs_0;
	output wire [15:0] io_gpRegs_1;
	output wire [15:0] io_gpRegs_2;
	output wire [15:0] io_gpRegs_3;
	output wire [15:0] io_gpRegs_4;
	output wire [15:0] io_gpRegs_5;
	output wire [15:0] io_gpRegs_6;
	output wire [15:0] io_gpRegs_7;
	output wire [15:0] io_memDataAddr;
	output wire [7:0] io_memDataIn;
	input [7:0] io_memDataOut;
	output wire io_memDataWrite;
	output wire io_memDataReq;
	input io_memDataDone;
	input [15:0] io_memInst;
	output wire io_memInstReq;
	input io_memInstDone;
	input io_debugHalt;
	input io_debugStep;
	Cpu cpu(
		.clock(clock),
		.reset(reset),
		.io_memDataAddr(io_memDataAddr),
		.io_memDataIn(io_memDataIn),
		.io_memDataOut(io_memDataOut),
		.io_memDataWrite(io_memDataWrite),
		.io_memDataReq(io_memDataReq),
		.io_memDataDone(io_memDataDone),
		.io_memInstReq(io_memInstReq),
		.io_memInstDone(io_memInstDone),
		.io_inst(io_memInst),
		.io_pc(io_pc),
		.io_gpRegs_1(io_gpRegs_1),
		.io_gpRegs_2(io_gpRegs_2),
		.io_gpRegs_3(io_gpRegs_3),
		.io_gpRegs_4(io_gpRegs_4),
		.io_gpRegs_5(io_gpRegs_5),
		.io_gpRegs_6(io_gpRegs_6),
		.io_gpRegs_7(io_gpRegs_7),
		.io_debugHalt(io_debugHalt),
		.io_debugStep(io_debugStep)
	);
	assign io_inst = io_memInst;
	assign io_gpRegs_0 = 16'h0000;
endmodule
