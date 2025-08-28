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
	io_gpRegs_0,
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
	output wire [15:0] io_gpRegs_0;
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
	reg [15:0] memDataAddrReg;
	reg [7:0] memDataInReg;
	reg memDataWriteReg;
	reg memDataReq;
	reg memInstReq;
	reg [1:0] state;
	reg [1:0] lswState;
	reg [5:0] op;
	reg [2:0] rd;
	reg [2:0] rs1;
	reg [2:0] rs2;
	reg [15:0] imm;
	reg [7:0] dataBuf;
	wire allowStep = ~io_debugHalt | (io_debugHalt & io_debugStep);
	wire _GEN = state == 2'h0;
	wire _GEN_0 = state == 2'h1;
	wire _GEN_1 = state == 2'h2;
	wire _GEN_2 = op == 6'h00;
	wire [127:0] _GEN_3 = {_Register_7_io_out, _Register_6_io_out, _Register_5_io_out, _Register_4_io_out, _Register_3_io_out, _Register_2_io_out, _Register_1_io_out, _Register_io_out};
	wire [15:0] _GEN_4 = _GEN_3[rs1 * 16+:16];
	wire [15:0] _GEN_5 = _GEN_3[rs2 * 16+:16];
	wire _GEN_6 = rd == 3'h1;
	wire _GEN_7 = rd == 3'h2;
	wire _GEN_8 = rd == 3'h3;
	wire _GEN_9 = rd == 3'h4;
	wire _GEN_10 = rd == 3'h5;
	wire _GEN_11 = rd == 3'h6;
	wire [15:0] _GEN_12 = (|rd ? _alu_io_out : 16'h0000);
	wire _GEN_13 = |rd & _GEN_6;
	wire _GEN_14 = |rd & _GEN_7;
	wire _GEN_15 = |rd & _GEN_8;
	wire _GEN_16 = |rd & _GEN_9;
	wire _GEN_17 = |rd & _GEN_10;
	wire _GEN_18 = |rd & _GEN_11;
	wire _GEN_19 = |rd & (&rd);
	wire _GEN_20 = op == 6'h01;
	wire _GEN_21 = op == 6'h02;
	wire _GEN_22 = op == 6'h03;
	wire _GEN_23 = op == 6'h04;
	wire _GEN_24 = op == 6'h05;
	wire _GEN_25 = op == 6'h06;
	wire _GEN_26 = op == 6'h07;
	wire _GEN_27 = op == 6'h08;
	wire _GEN_28 = op == 6'h09;
	wire _GEN_29 = op == 6'h0a;
	wire _GEN_30 = op == 6'h0b;
	wire _GEN_31 = op == 6'h0c;
	wire _GEN_32 = op == 6'h0d;
	wire _GEN_33 = op == 6'h0e;
	wire _GEN_34 = op == 6'h0f;
	wire _GEN_35 = op == 6'h10;
	wire _GEN_36 = op == 6'h11;
	wire _GEN_37 = op == 6'h12;
	wire _GEN_38 = (((((((((((((((((_GEN_2 | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37;
	wire _GEN_39 = _GEN | _GEN_0;
	wire _GEN_40 = _GEN_36 | _GEN_37;
	wire _GEN_41 = op == 6'h13;
	wire _GEN_42 = op == 6'h14;
	wire _GEN_43 = op == 6'h15;
	wire _GEN_44 = op == 6'h16;
	wire _GEN_45 = op == 6'h17;
	wire _GEN_46 = ((((((((((((((((_GEN_2 | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_40;
	wire _GEN_47 = _GEN_44 | _GEN_45;
	wire _GEN_48 = ((_GEN_41 | _GEN_42) | _GEN_43) | _GEN_47;
	wire _GEN_49 = _GEN_41 | _GEN_42;
	wire _GEN_50 = op == 6'h18;
	wire [15:0] _GEN_51 = (|rd ? _pc_io_out + 16'h0002 : 16'h0000);
	wire _GEN_52 = op == 6'h19;
	wire [15:0] _GEN_53 = (|rd ? _pc_io_out + 16'h0002 : 16'h0000);
	wire _GEN_54 = _GEN_52 & |rd;
	wire _GEN_55 = op == 6'h1a;
	wire _GEN_56 = _GEN_4 == _GEN_5;
	wire _GEN_57 = op == 6'h1b;
	wire _GEN_58 = op == 6'h1c;
	wire _GEN_59 = op == 6'h1d;
	wire _GEN_60 = op == 6'h1e;
	wire _GEN_61 = op == 6'h1f;
	wire [15:0] _GEN_62 = (|rd ? {{8 {io_memDataOut[7]}}, io_memDataOut} : 16'h0000);
	wire [15:0] _GEN_63 = (|rd ? {8'h00, io_memDataOut} : 16'h0000);
	wire _GEN_64 = lswState == 2'h1;
	wire _GEN_65 = _GEN_43 & _GEN_64;
	wire _GEN_66 = &state & io_memDataDone;
	wire _GEN_67 = lswState == 2'h2;
	wire _GEN_68 = _GEN_43 & _GEN_67;
	wire [15:0] _GEN_69 = (|rd ? {io_memDataOut, dataBuf} : 16'h0000);
	wire _GEN_70 = ~allowStep | _GEN_39;
	wire _GEN_71 = _GEN_68 & |rd;
	wire _GEN_72 = _GEN_41 | _GEN_42;
	wire _GEN_73 = _GEN_45 & _GEN_64;
	wire _GEN_74 = _GEN_68 | _GEN_44;
	wire _GEN_75 = _GEN_45 & _GEN_67;
	wire _GEN_76 = _GEN_73 | ~_GEN_75;
	always @(posedge clock)
		if (reset) begin
			memDataAddrReg <= 16'h0000;
			memDataInReg <= 8'h00;
			memDataWriteReg <= 1'h0;
			memDataReq <= 1'h0;
			memInstReq <= 1'h0;
			state <= 2'h0;
			lswState <= 2'h0;
			op <= 6'h00;
			rd <= 3'h0;
			rs1 <= 3'h0;
			rs2 <= 3'h0;
			imm <= 16'h0000;
			dataBuf <= 8'h00;
		end
		else begin : sv2v_autoblock_1
			reg _GEN_77;
			_GEN_77 = _GEN_0 & io_memInstDone;
			if (_GEN_70)
				;
			else begin : sv2v_autoblock_2
				reg [15:0] _GEN_78;
				_GEN_78 = _GEN_3[rd * 16+:16];
				if (_GEN_1) begin : sv2v_autoblock_3
					reg _GEN_79;
					_GEN_79 = (_GEN_41 | _GEN_42) | _GEN_43;
					if (~_GEN_46) begin
						if (_GEN_41)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_42)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_43)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_44)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_45)
							memDataAddrReg <= _GEN_4 + imm;
					end
					if (~(((((((((((((((((((_GEN_2 | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_79)) begin
						if (_GEN_44)
							memDataInReg <= _GEN_78[7:0];
						else if (_GEN_45)
							memDataInReg <= _GEN_78[7:0];
					end
					if (~_GEN_46)
						memDataWriteReg <= ~_GEN_79 & (_GEN_47 | memDataWriteReg);
					memDataReq <= (~_GEN_46 & _GEN_48) | memDataReq;
				end
				else if (_GEN_66) begin : sv2v_autoblock_4
					reg _GEN_80;
					_GEN_80 = ((_GEN_41 | _GEN_42) | _GEN_65) | _GEN_74;
					memDataAddrReg <= (_GEN_49 ? 16'h0000 : (_GEN_65 ? (_GEN_4 + imm) + 16'h0001 : (_GEN_74 | ~_GEN_73 ? 16'h0000 : (_GEN_4 + imm) + 16'h0001)));
					memDataInReg <= (_GEN_80 | ~_GEN_73 ? 8'h00 : _GEN_78[15:8]);
					memDataWriteReg <= ~_GEN_80 & _GEN_73;
					memDataReq <= ~_GEN_49 & (_GEN_65 | (~_GEN_74 & _GEN_73));
				end
			end
			if (allowStep) begin : sv2v_autoblock_5
				reg [7:0] _GEN_81;
				_GEN_81 = {(_GEN_66 & (_GEN_49 | ~(_GEN_65 | ~(_GEN_74 | ~_GEN_76))) ? 2'h0 : state), {2 {((_GEN_49 | _GEN_43) | _GEN_44) | _GEN_45}}, (io_memInstDone ? 2'h2 : state), 2'h1};
				memInstReq <= _GEN | (~_GEN_77 & memInstReq);
				state <= _GEN_81[state * 2+:2];
			end
			if (_GEN_70)
				;
			else if (_GEN_1) begin
				if ((((((((((((((((((((_GEN_2 | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_49) | ~(_GEN_43 | ~(_GEN_44 | ~_GEN_45)))
					;
				else
					lswState <= 2'h1;
			end
			else if (~_GEN_66 | _GEN_49)
				;
			else if (_GEN_65)
				lswState <= 2'h2;
			else if (_GEN_68)
				lswState <= 2'h0;
			else if (~_GEN_44) begin
				if (_GEN_73)
					lswState <= 2'h2;
				else if (_GEN_75)
					lswState <= 2'h0;
			end
			if ((~allowStep | _GEN) | ~_GEN_77)
				;
			else begin : sv2v_autoblock_6
				reg [191:0] _GEN_82;
				reg [5:0] dOp;
				reg [1:0] fmt;
				reg _GEN_83;
				reg _GEN_84;
				reg _GEN_85;
				reg _GEN_86;
				reg _GEN_87;
				reg _GEN_88;
				reg _GEN_89;
				reg [11:0] _GEN_90;
				reg [63:0] _GEN_91;
				reg [11:0] _GEN_92;
				reg [11:0] _GEN_93;
				reg [11:0] _GEN_94;
				reg [63:0] _GEN_95;
				_GEN_82 = 192'h7de75c6da6585d65544d24503ce34c2ca2481c61440c2040;
				dOp = _GEN_82[io_inst[15:11] * 6+:6];
				fmt = ((((((((((dOp == 6'h00) | (dOp == 6'h02)) | (dOp == 6'h03)) | (dOp == 6'h05)) | (dOp == 6'h07)) | (dOp == 6'h09)) | (dOp == 6'h0b)) | (dOp == 6'h0d)) | (dOp == 6'h0f)) | (dOp == 6'h11) ? 2'h0 : (((((((((((((((dOp == 6'h01) | (dOp == 6'h04)) | (dOp == 6'h06)) | (dOp == 6'h08)) | (dOp == 6'h0a)) | (dOp == 6'h0c)) | (dOp == 6'h0e)) | (dOp == 6'h10)) | (dOp == 6'h12)) | (dOp == 6'h13)) | (dOp == 6'h14)) | (dOp == 6'h15)) | (dOp == 6'h16)) | (dOp == 6'h17)) | (dOp == 6'h19) ? 2'h1 : (dOp == 6'h18 ? 2'h2 : {2 {(((((dOp == 6'h1a) | (dOp == 6'h1b)) | (dOp == 6'h1c)) | (dOp == 6'h1d)) | (dOp == 6'h1e)) | (dOp == 6'h1f)}})));
				_GEN_83 = fmt == 2'h0;
				_GEN_84 = fmt == 2'h1;
				_GEN_85 = fmt == 2'h2;
				_GEN_86 = fmt != 2'h3;
				_GEN_87 = _GEN_85 | _GEN_86;
				_GEN_88 = _GEN_84 | _GEN_85;
				_GEN_89 = _GEN_88 | _GEN_86;
				_GEN_90 = {(_GEN_89 ? 3'h0 : io_inst[7:5]), 6'h00, io_inst[4:2]};
				_GEN_91 = {{11 {io_inst[4]}}, io_inst[4:0], {8 {io_inst[7]}}, io_inst[7:0], {11 {io_inst[4]}}, io_inst[4:0], 16'h0000};
				_GEN_92 = {3'h0, io_inst[10:8], io_inst[10:8], io_inst[10:8]};
				_GEN_93 = {(_GEN_87 ? 3'h0 : io_inst[10:8]), 3'h0, io_inst[7:5], io_inst[7:5]};
				_GEN_94 = {(_GEN_89 ? 3'h0 : _GEN_90[fmt * 3+:3]), 6'h00, _GEN_90[fmt * 3+:3]};
				_GEN_95 = {_GEN_91[fmt * 16+:16], _GEN_91[fmt * 16+:16], _GEN_91[fmt * 16+:16], 16'h0000};
				op <= dOp;
				rd <= (_GEN_83 | _GEN_88 ? _GEN_92[fmt * 3+:3] : 3'h0);
				rs1 <= ((_GEN_83 | _GEN_84) | ~_GEN_87 ? _GEN_93[fmt * 3+:3] : 3'h0);
				rs2 <= _GEN_94[fmt * 3+:3];
				imm <= _GEN_95[fmt * 16+:16];
			end
			if ((((((~allowStep | _GEN) | _GEN_0) | _GEN_1) | ~_GEN_66) | _GEN_49) | ~_GEN_65)
				;
			else
				dataBuf <= io_memDataOut;
		end
	Register Register(
		.clock(clock),
		.reset(reset),
		.io_in(((~allowStep | _GEN_39) | (_GEN_1 ? (((((((((((((((((((~_GEN_2 & ~_GEN_20) & ~_GEN_21) & ~_GEN_22) & ~_GEN_23) & ~_GEN_24) & ~_GEN_25) & ~_GEN_26) & ~_GEN_27) & ~_GEN_28) & ~_GEN_29) & ~_GEN_30) & ~_GEN_31) & ~_GEN_32) & ~_GEN_33) & ~_GEN_34) & ~_GEN_35) & ~_GEN_36) & ~_GEN_37) & (_GEN_48 | (~_GEN_50 & ~_GEN_52))) | (|rd) : (~_GEN_66 | ((~_GEN_41 & ~_GEN_42) & (_GEN_65 | ~_GEN_68))) | (|rd)) ? _Register_io_out : 16'h0000)),
		.io_out(_Register_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (((((((((((((((((((((~_GEN_2 & ~_GEN_20) & ~_GEN_21) & ~_GEN_22) & ~_GEN_23) & ~_GEN_24) & ~_GEN_25) & ~_GEN_26) & ~_GEN_27) & ~_GEN_28) & ~_GEN_29) & ~_GEN_30) & ~_GEN_31) & ~_GEN_32) & ~_GEN_33) & ~_GEN_34) & ~_GEN_35) & ~_GEN_36) & ~_GEN_37) & ~_GEN_48) & ~_GEN_50) & _GEN_54) & ~(|rd) : ((((_GEN_66 & ~_GEN_41) & ~_GEN_42) & ~_GEN_65) & _GEN_71) & ~(|rd)))
	);
	Register Register_1(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_1_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_6 ? _GEN_12 : _Register_1_io_out) : (_GEN_48 ? _Register_1_io_out : (_GEN_50 ? (_GEN_6 ? _GEN_51 : _Register_1_io_out) : (_GEN_52 & _GEN_6 ? _GEN_53 : _Register_1_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_6 ? _GEN_62 : _Register_1_io_out) : (_GEN_42 ? (_GEN_6 ? _GEN_63 : _Register_1_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_6) ? _Register_1_io_out : _GEN_69))) : _Register_1_io_out)))),
		.io_out(_Register_1_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_13 : ~_GEN_48 & (_GEN_50 ? _GEN_13 : _GEN_54 & _GEN_6)) : _GEN_66 & (_GEN_72 ? _GEN_13 : (~_GEN_65 & _GEN_71) & _GEN_6)))
	);
	Register Register_2(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_2_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_7 ? _GEN_12 : _Register_2_io_out) : (_GEN_48 ? _Register_2_io_out : (_GEN_50 ? (_GEN_7 ? _GEN_51 : _Register_2_io_out) : (_GEN_52 & _GEN_7 ? _GEN_53 : _Register_2_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_7 ? _GEN_62 : _Register_2_io_out) : (_GEN_42 ? (_GEN_7 ? _GEN_63 : _Register_2_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_7) ? _Register_2_io_out : _GEN_69))) : _Register_2_io_out)))),
		.io_out(_Register_2_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_14 : ~_GEN_48 & (_GEN_50 ? _GEN_14 : _GEN_54 & _GEN_7)) : _GEN_66 & (_GEN_72 ? _GEN_14 : (~_GEN_65 & _GEN_71) & _GEN_7)))
	);
	Register Register_3(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_3_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_8 ? _GEN_12 : _Register_3_io_out) : (_GEN_48 ? _Register_3_io_out : (_GEN_50 ? (_GEN_8 ? _GEN_51 : _Register_3_io_out) : (_GEN_52 & _GEN_8 ? _GEN_53 : _Register_3_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_8 ? _GEN_62 : _Register_3_io_out) : (_GEN_42 ? (_GEN_8 ? _GEN_63 : _Register_3_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_8) ? _Register_3_io_out : _GEN_69))) : _Register_3_io_out)))),
		.io_out(_Register_3_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_15 : ~_GEN_48 & (_GEN_50 ? _GEN_15 : _GEN_54 & _GEN_8)) : _GEN_66 & (_GEN_72 ? _GEN_15 : (~_GEN_65 & _GEN_71) & _GEN_8)))
	);
	Register Register_4(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_4_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_9 ? _GEN_12 : _Register_4_io_out) : (_GEN_48 ? _Register_4_io_out : (_GEN_50 ? (_GEN_9 ? _GEN_51 : _Register_4_io_out) : (_GEN_52 & _GEN_9 ? _GEN_53 : _Register_4_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_9 ? _GEN_62 : _Register_4_io_out) : (_GEN_42 ? (_GEN_9 ? _GEN_63 : _Register_4_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_9) ? _Register_4_io_out : _GEN_69))) : _Register_4_io_out)))),
		.io_out(_Register_4_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_16 : ~_GEN_48 & (_GEN_50 ? _GEN_16 : _GEN_54 & _GEN_9)) : _GEN_66 & (_GEN_72 ? _GEN_16 : (~_GEN_65 & _GEN_71) & _GEN_9)))
	);
	Register Register_5(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_5_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_10 ? _GEN_12 : _Register_5_io_out) : (_GEN_48 ? _Register_5_io_out : (_GEN_50 ? (_GEN_10 ? _GEN_51 : _Register_5_io_out) : (_GEN_52 & _GEN_10 ? _GEN_53 : _Register_5_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_10 ? _GEN_62 : _Register_5_io_out) : (_GEN_42 ? (_GEN_10 ? _GEN_63 : _Register_5_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_10) ? _Register_5_io_out : _GEN_69))) : _Register_5_io_out)))),
		.io_out(_Register_5_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_17 : ~_GEN_48 & (_GEN_50 ? _GEN_17 : _GEN_54 & _GEN_10)) : _GEN_66 & (_GEN_72 ? _GEN_17 : (~_GEN_65 & _GEN_71) & _GEN_10)))
	);
	Register Register_6(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_6_io_out : (_GEN_1 ? (_GEN_38 ? (_GEN_11 ? _GEN_12 : _Register_6_io_out) : (_GEN_48 ? _Register_6_io_out : (_GEN_50 ? (_GEN_11 ? _GEN_51 : _Register_6_io_out) : (_GEN_52 & _GEN_11 ? _GEN_53 : _Register_6_io_out)))) : (_GEN_66 ? (_GEN_41 ? (_GEN_11 ? _GEN_62 : _Register_6_io_out) : (_GEN_42 ? (_GEN_11 ? _GEN_63 : _Register_6_io_out) : (_GEN_65 | ~(_GEN_68 & _GEN_11) ? _Register_6_io_out : _GEN_69))) : _Register_6_io_out)))),
		.io_out(_Register_6_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_18 : ~_GEN_48 & (_GEN_50 ? _GEN_18 : _GEN_54 & _GEN_11)) : _GEN_66 & (_GEN_72 ? _GEN_18 : (~_GEN_65 & _GEN_71) & _GEN_11)))
	);
	Register Register_7(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _Register_7_io_out : (_GEN_1 ? (_GEN_38 ? (&rd ? _GEN_12 : _Register_7_io_out) : (_GEN_48 ? _Register_7_io_out : (_GEN_50 ? (&rd ? _GEN_51 : _Register_7_io_out) : (_GEN_52 & (&rd) ? _GEN_53 : _Register_7_io_out)))) : (_GEN_66 ? (_GEN_41 ? (&rd ? _GEN_62 : _Register_7_io_out) : (_GEN_42 ? (&rd ? _GEN_63 : _Register_7_io_out) : (_GEN_65 | ~(_GEN_68 & (&rd)) ? _Register_7_io_out : _GEN_69))) : _Register_7_io_out)))),
		.io_out(_Register_7_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? (_GEN_38 ? _GEN_19 : ~_GEN_48 & (_GEN_50 ? _GEN_19 : _GEN_54 & (&rd))) : _GEN_66 & (_GEN_72 ? _GEN_19 : (~_GEN_65 & _GEN_71) & (&rd))))
	);
	Register pc(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_70 ? _pc_io_out : (_GEN_1 ? (_GEN_2 ? _pc_io_out + 16'h0002 : (_GEN_20 ? _pc_io_out + 16'h0002 : (_GEN_21 ? _pc_io_out + 16'h0002 : (_GEN_22 ? _pc_io_out + 16'h0002 : (_GEN_23 ? _pc_io_out + 16'h0002 : (_GEN_24 ? _pc_io_out + 16'h0002 : (_GEN_25 ? _pc_io_out + 16'h0002 : (_GEN_26 ? _pc_io_out + 16'h0002 : (_GEN_27 ? _pc_io_out + 16'h0002 : (_GEN_28 ? _pc_io_out + 16'h0002 : (_GEN_29 ? _pc_io_out + 16'h0002 : (_GEN_30 ? _pc_io_out + 16'h0002 : (_GEN_31 ? _pc_io_out + 16'h0002 : (_GEN_32 ? _pc_io_out + 16'h0002 : (_GEN_33 ? _pc_io_out + 16'h0002 : (_GEN_34 ? _pc_io_out + 16'h0002 : (_GEN_35 ? _pc_io_out + 16'h0002 : (_GEN_36 ? _pc_io_out + 16'h0002 : (_GEN_37 ? _pc_io_out + 16'h0002 : (_GEN_48 ? _pc_io_out : (_GEN_50 ? _pc_io_out + imm : (_GEN_52 ? (_GEN_4 + imm) & 16'hfffe : (_GEN_55 ? (_GEN_56 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_57 ? (_GEN_56 ? _pc_io_out + 16'h0002 : _pc_io_out + imm) : (_GEN_58 ? ($signed(_GEN_4) < $signed(_GEN_5) ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_59 ? ($signed(_GEN_4) >= $signed(_GEN_5) ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_60 ? (_GEN_4 < _GEN_5 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_61 ? (_GEN_4 >= _GEN_5 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : _pc_io_out)))))))))))))))))))))))))))) : (_GEN_66 ? (_GEN_41 ? _pc_io_out + 16'h0002 : (_GEN_42 ? _pc_io_out + 16'h0002 : (_GEN_65 ? _pc_io_out : (_GEN_68 ? _pc_io_out + 16'h0002 : (_GEN_44 ? _pc_io_out + 16'h0002 : (_GEN_76 ? _pc_io_out : _pc_io_out + 16'h0002)))))) : _pc_io_out)))),
		.io_out(_pc_io_out),
		.io_write((allowStep & ~_GEN_39) & (_GEN_1 ? _GEN_46 | (~_GEN_48 & (((((((_GEN_50 | _GEN_52) | _GEN_55) | _GEN_57) | _GEN_58) | _GEN_59) | _GEN_60) | _GEN_61)) : _GEN_66 & (_GEN_49 | (~_GEN_65 & (_GEN_74 | (~_GEN_73 & _GEN_75))))))
	);
	Alu alu(
		.io_a(((~allowStep | _GEN_39) | ~(_GEN_1 & _GEN_38) ? 16'h0000 : _GEN_4)),
		.io_b(((~allowStep | _GEN_39) | ~_GEN_1 ? 16'h0000 : (_GEN_2 ? _GEN_5 : (_GEN_20 ? imm : (_GEN_21 | _GEN_22 ? _GEN_5 : (_GEN_23 ? imm : (_GEN_24 ? _GEN_5 : (_GEN_25 ? imm : (_GEN_26 ? _GEN_5 : (_GEN_27 ? imm : (_GEN_28 ? _GEN_5 : (_GEN_29 ? imm : (_GEN_30 ? _GEN_5 : (_GEN_31 ? imm : (_GEN_32 ? _GEN_5 : (_GEN_33 ? imm : (_GEN_34 ? _GEN_5 : (_GEN_35 ? imm : (_GEN_36 ? _GEN_5 : (_GEN_37 ? imm : 16'h0000)))))))))))))))))))),
		.io_op(((((~allowStep | _GEN_39) | ~_GEN_1) | _GEN_2) | _GEN_20 ? 4'h0 : (_GEN_21 ? 4'h1 : (_GEN_22 | _GEN_23 ? 4'h2 : (_GEN_24 | _GEN_25 ? 4'h3 : (_GEN_26 | _GEN_27 ? 4'h4 : (_GEN_28 | _GEN_29 ? 4'h5 : (_GEN_30 | _GEN_31 ? 4'h6 : (_GEN_32 | _GEN_33 ? 4'h7 : (_GEN_34 | _GEN_35 ? 4'h8 : (_GEN_40 ? 4'h9 : 4'h0))))))))))),
		.io_out(_alu_io_out)
	);
	assign io_memDataAddr = memDataAddrReg;
	assign io_memDataIn = memDataInReg;
	assign io_memDataWrite = memDataWriteReg;
	assign io_memDataReq = memDataReq;
	assign io_memInstReq = memInstReq;
	assign io_pc = _pc_io_out;
	assign io_gpRegs_0 = _Register_io_out;
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
	io_memInstReq,
	io_memInstDone,
	io_memInst,
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
	output wire io_memInstReq;
	input io_memInstDone;
	input [15:0] io_memInst;
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
		.io_gpRegs_0(io_gpRegs_0),
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
endmodule
