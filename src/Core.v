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
	reg [15:0] memDataAddrReg;
	reg [7:0] memDataInReg;
	reg memDataWriteReg;
	reg memDataReq;
	reg memInstReq;
	reg [1:0] state;
	reg [1:0] lshState;
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
	wire _GEN_6 = rd == 3'h0;
	wire _GEN_7 = rd == 3'h1;
	wire _GEN_8 = rd == 3'h2;
	wire _GEN_9 = rd == 3'h3;
	wire _GEN_10 = rd == 3'h4;
	wire _GEN_11 = rd == 3'h5;
	wire _GEN_12 = rd == 3'h6;
	wire _GEN_13 = op == 6'h01;
	wire _GEN_14 = op == 6'h02;
	wire _GEN_15 = op == 6'h03;
	wire _GEN_16 = op == 6'h04;
	wire _GEN_17 = op == 6'h05;
	wire _GEN_18 = op == 6'h06;
	wire _GEN_19 = op == 6'h07;
	wire _GEN_20 = op == 6'h08;
	wire _GEN_21 = op == 6'h09;
	wire _GEN_22 = op == 6'h0a;
	wire _GEN_23 = op == 6'h0b;
	wire _GEN_24 = op == 6'h0c;
	wire _GEN_25 = op == 6'h0d;
	wire _GEN_26 = op == 6'h0e;
	wire _GEN_27 = op == 6'h0f;
	wire _GEN_28 = op == 6'h10;
	wire _GEN_29 = op == 6'h11;
	wire _GEN_30 = ((((((((((((((((_GEN_2 | _GEN_13) | _GEN_14) | _GEN_15) | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29;
	wire _GEN_31 = _GEN | _GEN_0;
	wire _GEN_32 = op == 6'h13;
	wire _GEN_33 = op == 6'h14;
	wire _GEN_34 = op == 6'h15;
	wire _GEN_35 = op == 6'h16;
	wire _GEN_36 = op == 6'h17;
	wire _GEN_37 = ((((((((((((((((_GEN_2 | _GEN_13) | _GEN_14) | _GEN_15) | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29;
	wire _GEN_38 = _GEN_35 | _GEN_36;
	wire _GEN_39 = ((_GEN_32 | _GEN_33) | _GEN_34) | _GEN_38;
	wire _GEN_40 = _GEN_32 | _GEN_33;
	wire _GEN_41 = op == 6'h18;
	wire [15:0] _gpRegs_in_T_1 = _pc_io_out + 16'h0002;
	wire _GEN_42 = op == 6'h19;
	wire [15:0] _t_T_1 = _pc_io_out + 16'h0002;
	wire _GEN_43 = (((((((((((((((((_GEN_2 | _GEN_13) | _GEN_14) | _GEN_15) | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | (~_GEN_39 & (_GEN_41 | _GEN_42));
	wire _GEN_44 = op == 6'h1a;
	wire _GEN_45 = _GEN_4 == _GEN_5;
	wire _GEN_46 = op == 6'h1b;
	wire _GEN_47 = op == 6'h1c;
	wire _GEN_48 = op == 6'h1d;
	wire _GEN_49 = op == 6'h1e;
	wire _GEN_50 = op == 6'h1f;
	wire [15:0] _gpRegs_in_T_3 = {{8 {io_memDataOut[7]}}, io_memDataOut};
	wire [15:0] _GEN_51 = {8'h00, io_memDataOut};
	wire _GEN_52 = lshState == 2'h1;
	wire _GEN_53 = _GEN_34 & _GEN_52;
	wire _GEN_54 = &state & io_memDataDone;
	wire _GEN_55 = lshState == 2'h2;
	wire _GEN_56 = _GEN_34 & _GEN_55;
	wire [15:0] result = {io_memDataOut, dataBuf};
	wire _GEN_57 = ~allowStep | _GEN_31;
	wire _GEN_58 = (_GEN_32 | _GEN_33) | (~_GEN_53 & _GEN_56);
	wire _GEN_59 = _GEN_36 & _GEN_52;
	wire _GEN_60 = _GEN_56 | _GEN_35;
	wire _GEN_61 = _GEN_36 & _GEN_55;
	wire _GEN_62 = _GEN_59 | ~_GEN_61;
	always @(posedge clock)
		if (reset) begin
			memDataAddrReg <= 16'h0000;
			memDataInReg <= 8'h00;
			memDataWriteReg <= 1'h0;
			memDataReq <= 1'h0;
			memInstReq <= 1'h0;
			state <= 2'h0;
			lshState <= 2'h0;
			op <= 6'h00;
			rd <= 3'h0;
			rs1 <= 3'h0;
			rs2 <= 3'h0;
			imm <= 16'h0000;
			dataBuf <= 8'h00;
		end
		else begin : sv2v_autoblock_1
			reg _GEN_63;
			_GEN_63 = _GEN_0 & io_memInstDone;
			if (_GEN_57)
				;
			else begin : sv2v_autoblock_2
				reg [15:0] _GEN_64;
				_GEN_64 = _GEN_3[rd * 16+:16];
				if (_GEN_1) begin : sv2v_autoblock_3
					reg _GEN_65;
					_GEN_65 = (_GEN_32 | _GEN_33) | _GEN_34;
					if (~_GEN_37) begin
						if (_GEN_32)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_33)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_34)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_35)
							memDataAddrReg <= _GEN_4 + imm;
						else if (_GEN_36)
							memDataAddrReg <= (_GEN_4 + imm) + 16'h0001;
					end
					if (~((((((((((((((((((_GEN_2 | _GEN_13) | _GEN_14) | _GEN_15) | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_65)) begin
						if (_GEN_35)
							memDataInReg <= _GEN_64[7:0];
						else if (_GEN_36)
							memDataInReg <= _GEN_64[15:8];
					end
					if (~_GEN_37)
						memDataWriteReg <= ~_GEN_65 & (_GEN_38 | memDataWriteReg);
					memDataReq <= (~_GEN_37 & _GEN_39) | memDataReq;
				end
				else if (_GEN_54) begin : sv2v_autoblock_4
					reg _GEN_66;
					_GEN_66 = ((_GEN_32 | _GEN_33) | _GEN_53) | _GEN_60;
					memDataAddrReg <= (_GEN_40 ? 16'h0000 : (_GEN_53 ? (_GEN_4 + imm) + 16'h0001 : (_GEN_60 | ~_GEN_59 ? 16'h0000 : _GEN_4 + imm)));
					memDataInReg <= (_GEN_66 | ~_GEN_59 ? 8'h00 : _GEN_64[7:0]);
					memDataWriteReg <= ~_GEN_66 & _GEN_59;
					memDataReq <= ~_GEN_40 & (_GEN_53 | (~_GEN_60 & _GEN_59));
				end
			end
			if (allowStep) begin : sv2v_autoblock_5
				reg [7:0] _GEN_67;
				_GEN_67 = {(_GEN_54 & (_GEN_40 | ~(_GEN_53 | ~(_GEN_60 | ~_GEN_62))) ? 2'h0 : state), {2 {((_GEN_40 | _GEN_34) | _GEN_35) | _GEN_36}}, (io_memInstDone ? 2'h2 : state), 2'h1};
				memInstReq <= _GEN | (~_GEN_63 & memInstReq);
				state <= _GEN_67[state * 2+:2];
			end
			if (_GEN_57)
				;
			else if (_GEN_1) begin
				if (((((((((((((((((((_GEN_2 | _GEN_13) | _GEN_14) | _GEN_15) | _GEN_16) | _GEN_17) | _GEN_18) | _GEN_19) | _GEN_20) | _GEN_21) | _GEN_22) | _GEN_23) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_40) | ~(_GEN_34 | ~(_GEN_35 | ~_GEN_36)))
					;
				else
					lshState <= 2'h1;
			end
			else if (~_GEN_54 | _GEN_40)
				;
			else if (_GEN_53)
				lshState <= 2'h2;
			else if (_GEN_56)
				lshState <= 2'h0;
			else if (~_GEN_35) begin
				if (_GEN_59)
					lshState <= 2'h2;
				else if (_GEN_61)
					lshState <= 2'h0;
			end
			if ((~allowStep | _GEN) | ~_GEN_63)
				;
			else begin : sv2v_autoblock_6
				reg [191:0] _GEN_68;
				reg [5:0] dOp;
				reg [1:0] fmt;
				reg _GEN_69;
				reg _GEN_70;
				reg _GEN_71;
				reg _GEN_72;
				reg _GEN_73;
				reg _GEN_74;
				reg _GEN_75;
				reg [11:0] _GEN_76;
				reg [63:0] _GEN_77;
				reg [11:0] _GEN_78;
				reg [11:0] _GEN_79;
				reg [11:0] _GEN_80;
				reg [63:0] _GEN_81;
				_GEN_68 = 192'h7de75c6da6585d65544d24503ce34c2ca2481c61440c2040;
				dOp = _GEN_68[io_inst[15:11] * 6+:6];
				fmt = ((((((((((dOp == 6'h00) | (dOp == 6'h02)) | (dOp == 6'h03)) | (dOp == 6'h05)) | (dOp == 6'h07)) | (dOp == 6'h09)) | (dOp == 6'h0b)) | (dOp == 6'h0d)) | (dOp == 6'h0f)) | (dOp == 6'h11) ? 2'h0 : (((((((((((((((dOp == 6'h01) | (dOp == 6'h04)) | (dOp == 6'h06)) | (dOp == 6'h08)) | (dOp == 6'h0a)) | (dOp == 6'h0c)) | (dOp == 6'h0e)) | (dOp == 6'h10)) | (dOp == 6'h12)) | (dOp == 6'h13)) | (dOp == 6'h14)) | (dOp == 6'h15)) | (dOp == 6'h16)) | (dOp == 6'h17)) | (dOp == 6'h19) ? 2'h1 : (dOp == 6'h18 ? 2'h2 : {2 {(((((dOp == 6'h1a) | (dOp == 6'h1b)) | (dOp == 6'h1c)) | (dOp == 6'h1d)) | (dOp == 6'h1e)) | (dOp == 6'h1f)}})));
				_GEN_69 = fmt == 2'h0;
				_GEN_70 = fmt == 2'h1;
				_GEN_71 = fmt == 2'h2;
				_GEN_72 = fmt != 2'h3;
				_GEN_73 = _GEN_71 | _GEN_72;
				_GEN_74 = _GEN_70 | _GEN_71;
				_GEN_75 = _GEN_74 | _GEN_72;
				_GEN_76 = {(_GEN_75 ? 3'h0 : io_inst[7:5]), 6'h00, io_inst[4:2]};
				_GEN_77 = {{11 {io_inst[4]}}, io_inst[4:0], {8 {io_inst[7]}}, io_inst[7:0], {11 {io_inst[4]}}, io_inst[4:0], 16'h0000};
				_GEN_78 = {3'h0, io_inst[10:8], io_inst[10:8], io_inst[10:8]};
				_GEN_79 = {(_GEN_73 ? 3'h0 : io_inst[10:8]), 3'h0, io_inst[7:5], io_inst[7:5]};
				_GEN_80 = {(_GEN_75 ? 3'h0 : _GEN_76[fmt * 3+:3]), 6'h00, _GEN_76[fmt * 3+:3]};
				_GEN_81 = {_GEN_77[fmt * 16+:16], _GEN_77[fmt * 16+:16], _GEN_77[fmt * 16+:16], 16'h0000};
				op <= dOp;
				rd <= (_GEN_69 | _GEN_74 ? _GEN_78[fmt * 3+:3] : 3'h0);
				rs1 <= ((_GEN_69 | _GEN_70) | ~_GEN_73 ? _GEN_79[fmt * 3+:3] : 3'h0);
				rs2 <= _GEN_80[fmt * 3+:3];
				imm <= _GEN_81[fmt * 16+:16];
			end
			if ((((((~allowStep | _GEN) | _GEN_0) | _GEN_1) | ~_GEN_54) | _GEN_40) | ~_GEN_53)
				;
			else
				dataBuf <= io_memDataOut;
		end
	Register Register(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? 16'h0000 : (_GEN_1 ? (_GEN_30 ? (_GEN_6 ? _alu_io_out : 16'h0000) : (_GEN_39 ? 16'h0000 : (_GEN_41 ? (_GEN_6 ? _gpRegs_in_T_1 : 16'h0000) : (_GEN_42 & _GEN_6 ? _t_T_1 : 16'h0000)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_6 ? _gpRegs_in_T_3 : 16'h0000) : (_GEN_33 ? (_GEN_6 ? _GEN_51 : 16'h0000) : (_GEN_53 | ~(_GEN_56 & _GEN_6) ? 16'h0000 : result))) : 16'h0000)))),
		.io_out(_Register_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_6 : (_GEN_54 & _GEN_58) & _GEN_6))
	);
	Register Register_1(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_1_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_7 ? _alu_io_out : _Register_1_io_out) : (_GEN_39 ? _Register_1_io_out : (_GEN_41 ? (_GEN_7 ? _gpRegs_in_T_1 : _Register_1_io_out) : (_GEN_42 & _GEN_7 ? _t_T_1 : _Register_1_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_7 ? _gpRegs_in_T_3 : _Register_1_io_out) : (_GEN_33 ? (_GEN_7 ? _GEN_51 : _Register_1_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_7) ? _Register_1_io_out : result))) : _Register_1_io_out)))),
		.io_out(_Register_1_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_7 : (_GEN_54 & _GEN_58) & _GEN_7))
	);
	Register Register_2(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_2_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_8 ? _alu_io_out : _Register_2_io_out) : (_GEN_39 ? _Register_2_io_out : (_GEN_41 ? (_GEN_8 ? _gpRegs_in_T_1 : _Register_2_io_out) : (_GEN_42 & _GEN_8 ? _t_T_1 : _Register_2_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_8 ? _gpRegs_in_T_3 : _Register_2_io_out) : (_GEN_33 ? (_GEN_8 ? _GEN_51 : _Register_2_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_8) ? _Register_2_io_out : result))) : _Register_2_io_out)))),
		.io_out(_Register_2_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_8 : (_GEN_54 & _GEN_58) & _GEN_8))
	);
	Register Register_3(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_3_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_9 ? _alu_io_out : _Register_3_io_out) : (_GEN_39 ? _Register_3_io_out : (_GEN_41 ? (_GEN_9 ? _gpRegs_in_T_1 : _Register_3_io_out) : (_GEN_42 & _GEN_9 ? _t_T_1 : _Register_3_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_9 ? _gpRegs_in_T_3 : _Register_3_io_out) : (_GEN_33 ? (_GEN_9 ? _GEN_51 : _Register_3_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_9) ? _Register_3_io_out : result))) : _Register_3_io_out)))),
		.io_out(_Register_3_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_9 : (_GEN_54 & _GEN_58) & _GEN_9))
	);
	Register Register_4(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_4_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_10 ? _alu_io_out : _Register_4_io_out) : (_GEN_39 ? _Register_4_io_out : (_GEN_41 ? (_GEN_10 ? _gpRegs_in_T_1 : _Register_4_io_out) : (_GEN_42 & _GEN_10 ? _t_T_1 : _Register_4_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_10 ? _gpRegs_in_T_3 : _Register_4_io_out) : (_GEN_33 ? (_GEN_10 ? _GEN_51 : _Register_4_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_10) ? _Register_4_io_out : result))) : _Register_4_io_out)))),
		.io_out(_Register_4_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_10 : (_GEN_54 & _GEN_58) & _GEN_10))
	);
	Register Register_5(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_5_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_11 ? _alu_io_out : _Register_5_io_out) : (_GEN_39 ? _Register_5_io_out : (_GEN_41 ? (_GEN_11 ? _gpRegs_in_T_1 : _Register_5_io_out) : (_GEN_42 & _GEN_11 ? _t_T_1 : _Register_5_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_11 ? _gpRegs_in_T_3 : _Register_5_io_out) : (_GEN_33 ? (_GEN_11 ? _GEN_51 : _Register_5_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_11) ? _Register_5_io_out : result))) : _Register_5_io_out)))),
		.io_out(_Register_5_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_11 : (_GEN_54 & _GEN_58) & _GEN_11))
	);
	Register Register_6(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_6_io_out : (_GEN_1 ? (_GEN_30 ? (_GEN_12 ? _alu_io_out : _Register_6_io_out) : (_GEN_39 ? _Register_6_io_out : (_GEN_41 ? (_GEN_12 ? _gpRegs_in_T_1 : _Register_6_io_out) : (_GEN_42 & _GEN_12 ? _t_T_1 : _Register_6_io_out)))) : (_GEN_54 ? (_GEN_32 ? (_GEN_12 ? _gpRegs_in_T_3 : _Register_6_io_out) : (_GEN_33 ? (_GEN_12 ? _GEN_51 : _Register_6_io_out) : (_GEN_53 | ~(_GEN_56 & _GEN_12) ? _Register_6_io_out : result))) : _Register_6_io_out)))),
		.io_out(_Register_6_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & _GEN_12 : (_GEN_54 & _GEN_58) & _GEN_12))
	);
	Register Register_7(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _Register_7_io_out : (_GEN_1 ? (_GEN_30 ? (&rd ? _alu_io_out : _Register_7_io_out) : (_GEN_39 ? _Register_7_io_out : (_GEN_41 ? (&rd ? _gpRegs_in_T_1 : _Register_7_io_out) : (_GEN_42 & (&rd) ? _t_T_1 : _Register_7_io_out)))) : (_GEN_54 ? (_GEN_32 ? (&rd ? _gpRegs_in_T_3 : _Register_7_io_out) : (_GEN_33 ? (&rd ? _GEN_51 : _Register_7_io_out) : (_GEN_53 | ~(_GEN_56 & (&rd)) ? _Register_7_io_out : result))) : _Register_7_io_out)))),
		.io_out(_Register_7_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_43 & (&rd) : (_GEN_54 & _GEN_58) & (&rd)))
	);
	Register pc(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_57 ? _pc_io_out : (_GEN_1 ? (_GEN_2 ? _pc_io_out + 16'h0002 : (_GEN_13 ? _pc_io_out + 16'h0002 : (_GEN_14 ? _pc_io_out + 16'h0002 : (_GEN_15 ? _pc_io_out + 16'h0002 : (_GEN_16 ? _pc_io_out + 16'h0002 : (_GEN_17 ? _pc_io_out + 16'h0002 : (_GEN_18 ? _pc_io_out + 16'h0002 : (_GEN_19 ? _pc_io_out + 16'h0002 : (_GEN_20 ? _pc_io_out + 16'h0002 : (_GEN_21 ? _pc_io_out + 16'h0002 : (_GEN_22 ? _pc_io_out + 16'h0002 : (_GEN_23 ? _pc_io_out + 16'h0002 : (_GEN_24 ? _pc_io_out + 16'h0002 : (_GEN_25 ? _pc_io_out + 16'h0002 : (_GEN_26 ? _pc_io_out + 16'h0002 : (_GEN_27 ? _pc_io_out + 16'h0002 : (_GEN_28 ? _pc_io_out + 16'h0002 : (_GEN_29 ? _pc_io_out + 16'h0002 : (_GEN_39 ? _pc_io_out : (_GEN_41 ? _pc_io_out + imm : (_GEN_42 ? 16'h0000 : (_GEN_44 ? (_GEN_45 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_46 ? (_GEN_45 ? _pc_io_out + 16'h0002 : _pc_io_out + imm) : (_GEN_47 ? ($signed(_GEN_4) < $signed(_GEN_5) ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_48 ? ($signed(_GEN_4) >= $signed(_GEN_5) ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_49 ? (_GEN_4 < _GEN_5 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : (_GEN_50 ? (_GEN_4 >= _GEN_5 ? _pc_io_out + imm : _pc_io_out + 16'h0002) : _pc_io_out))))))))))))))))))))))))))) : (_GEN_54 ? (_GEN_32 ? _pc_io_out + 16'h0002 : (_GEN_33 ? _pc_io_out + 16'h0002 : (_GEN_53 ? _pc_io_out : (_GEN_56 ? _pc_io_out + 16'h0002 : (_GEN_35 ? _pc_io_out + 16'h0002 : (_GEN_62 ? _pc_io_out : _pc_io_out + 16'h0002)))))) : _pc_io_out)))),
		.io_out(_pc_io_out),
		.io_write((allowStep & ~_GEN_31) & (_GEN_1 ? _GEN_37 | (~_GEN_39 & (((((((_GEN_41 | _GEN_42) | _GEN_44) | _GEN_46) | _GEN_47) | _GEN_48) | _GEN_49) | _GEN_50)) : _GEN_54 & (_GEN_40 | (~_GEN_53 & (_GEN_60 | (~_GEN_59 & _GEN_61))))))
	);
	Alu alu(
		.io_a(((~allowStep | _GEN_31) | ~(_GEN_1 & _GEN_30) ? 16'h0000 : _GEN_4)),
		.io_b(((~allowStep | _GEN_31) | ~_GEN_1 ? 16'h0000 : (_GEN_2 ? _GEN_5 : (_GEN_13 ? imm : (_GEN_14 | _GEN_15 ? _GEN_5 : (_GEN_16 ? imm : (_GEN_17 ? _GEN_5 : (_GEN_18 ? imm : (_GEN_19 ? _GEN_5 : (_GEN_20 ? imm : (_GEN_21 ? _GEN_5 : (_GEN_22 ? imm : (_GEN_23 ? _GEN_5 : (_GEN_24 ? imm : (_GEN_25 ? _GEN_5 : (_GEN_26 ? imm : (_GEN_27 ? _GEN_5 : (_GEN_28 ? imm : (_GEN_29 ? _GEN_5 : 16'h0000))))))))))))))))))),
		.io_op(((((~allowStep | _GEN_31) | ~_GEN_1) | _GEN_2) | _GEN_13 ? 4'h0 : (_GEN_14 ? 4'h1 : (_GEN_15 | _GEN_16 ? 4'h2 : (_GEN_17 | _GEN_18 ? 4'h3 : (_GEN_19 | _GEN_20 ? 4'h4 : (_GEN_21 | _GEN_22 ? 4'h5 : (_GEN_23 | _GEN_24 ? 4'h6 : (_GEN_25 | _GEN_26 ? 4'h7 : (_GEN_27 | _GEN_28 ? 4'h8 : (_GEN_29 ? 4'h9 : 4'h0))))))))))),
		.io_out(_alu_io_out)
	);
	assign io_memDataAddr = memDataAddrReg;
	assign io_memDataIn = memDataInReg;
	assign io_memDataWrite = memDataWriteReg;
	assign io_memDataReq = memDataReq;
	assign io_memInstReq = memInstReq;
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
