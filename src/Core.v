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
	io_debug_halt,
	io_debug_step
);
	input clock;
	input reset;
	output wire [15:0] io_memDataAddr;
	output wire [7:0] io_memDataIn;
	input [7:0] io_memDataOut;
	output wire io_memDataWrite;
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
	input io_debug_halt;
	input io_debug_step;
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
	reg [15:0] cycles;
	reg [7:0] lhValue;
	wire [5:0] op = _GEN[io_inst[15:11] * 6+:6];
	wire [1:0] fmt = (((((((((~(|op) | (op == 6'h02)) | (op == 6'h03)) | (op == 6'h05)) | (op == 6'h07)) | (op == 6'h09)) | (op == 6'h0b)) | (op == 6'h0d)) | (op == 6'h0f)) | (op == 6'h11) ? 2'h0 : (((((((((((((((op == 6'h01) | (op == 6'h04)) | (op == 6'h06)) | (op == 6'h08)) | (op == 6'h0a)) | (op == 6'h0c)) | (op == 6'h0e)) | (op == 6'h10)) | (op == 6'h12)) | (op == 6'h13)) | (op == 6'h14)) | (op == 6'h15)) | (op == 6'h16)) | (op == 6'h17)) | (op == 6'h19) ? 2'h1 : (op == 6'h18 ? 2'h2 : {2 {(((((op == 6'h1a) | (op == 6'h1b)) | (op == 6'h1c)) | (op == 6'h1d)) | (op == 6'h1e)) | (op == 6'h1f)}})));
	wire _GEN_0 = fmt == 2'h0;
	wire _GEN_1 = fmt == 2'h1;
	wire _GEN_2 = fmt == 2'h2;
	wire [11:0] _GEN_3 = {3'h0, io_inst[10:8], io_inst[10:8], io_inst[10:8]};
	wire _GEN_4 = fmt != 2'h3;
	wire _GEN_5 = _GEN_2 | _GEN_4;
	wire [11:0] _GEN_6 = {(_GEN_5 ? 3'h0 : io_inst[10:8]), 3'h0, io_inst[7:5], io_inst[7:5]};
	wire _GEN_7 = _GEN_1 | _GEN_2;
	wire _GEN_8 = _GEN_7 | _GEN_4;
	wire [11:0] _GEN_9 = {(_GEN_8 ? 3'h0 : io_inst[7:5]), 6'h00, io_inst[4:2]};
	wire [63:0] _GEN_10 = {11'h000, io_inst[4:0], 8'h00, io_inst[7:0], 11'h000, io_inst[4:0], 16'h0000};
	wire [2:0] rd_1 = (_GEN_0 | _GEN_7 ? _GEN_3[fmt * 3+:3] : 3'h0);
	wire [11:0] _GEN_11 = {(_GEN_8 ? 3'h0 : _GEN_9[fmt * 3+:3]), 6'h00, _GEN_9[fmt * 3+:3]};
	wire [63:0] _GEN_12 = {_GEN_10[fmt * 16+:16], _GEN_10[fmt * 16+:16], _GEN_10[fmt * 16+:16], 16'h0000};
	wire [127:0] _GEN_13 = {_Register_7_io_out, _Register_6_io_out, _Register_5_io_out, _Register_4_io_out, _Register_3_io_out, _Register_2_io_out, _Register_1_io_out, _Register_io_out};
	wire [15:0] _GEN_14 = _GEN_13[((_GEN_0 | _GEN_1) | ~_GEN_5 ? _GEN_6[fmt * 3+:3] : 3'h0) * 16+:16];
	wire [15:0] _GEN_15 = _GEN_13[_GEN_11[fmt * 3+:3] * 16+:16];
	wire beqResult = (op == 6'h1a) & (_GEN_14 == _GEN_15);
	wire bneResult = (op == 6'h1b) & (_GEN_14 != _GEN_15);
	wire bltResult = (op == 6'h1c) & ($signed(_GEN_14) < $signed(_GEN_15));
	wire bgeResult = (op == 6'h1d) & ($signed(_GEN_14) >= $signed(_GEN_15));
	wire bltuResult = (op == 6'h1e) & (_GEN_14 < _GEN_15);
	wire bgeuResult = (op == 6'h1f) & (_GEN_14 >= _GEN_15);
	wire allowStep = ~io_debug_halt | (io_debug_halt & io_debug_step);
	wire _GEN_16 = cycles == 16'h0000;
	wire _GEN_17 = rd_1 == 3'h0;
	wire _GEN_18 = rd_1 == 3'h1;
	wire _GEN_19 = rd_1 == 3'h2;
	wire _GEN_20 = rd_1 == 3'h3;
	wire _GEN_21 = rd_1 == 3'h4;
	wire _GEN_22 = rd_1 == 3'h5;
	wire _GEN_23 = rd_1 == 3'h6;
	wire _GEN_24 = op == 6'h01;
	wire _GEN_25 = op == 6'h02;
	wire _GEN_26 = op == 6'h03;
	wire _GEN_27 = op == 6'h04;
	wire _GEN_28 = op == 6'h05;
	wire _GEN_29 = op == 6'h06;
	wire _GEN_30 = op == 6'h07;
	wire _GEN_31 = op == 6'h08;
	wire _GEN_32 = op == 6'h09;
	wire _GEN_33 = op == 6'h0a;
	wire _GEN_34 = op == 6'h0b;
	wire _GEN_35 = op == 6'h0c;
	wire _GEN_36 = op == 6'h0d;
	wire _GEN_37 = op == 6'h0e;
	wire _GEN_38 = op == 6'h0f;
	wire _GEN_39 = op == 6'h10;
	wire _GEN_40 = op == 6'h11;
	wire _GEN_41 = op == 6'h12;
	wire _GEN_42 = _GEN_40 | _GEN_41;
	wire _GEN_43 = ((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_42;
	wire _GEN_44 = _GEN_16 & allowStep;
	wire _GEN_45 = op == 6'h13;
	wire [15:0] _GEN_46 = {8'h00, io_memDataOut};
	wire _GEN_47 = op == 6'h14;
	wire _GEN_48 = op == 6'h15;
	wire _GEN_49 = op == 6'h16;
	wire _GEN_50 = op == 6'h17;
	wire _GEN_51 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_45) | _GEN_47) | _GEN_48;
	wire _GEN_52 = op == 6'h18;
	wire [15:0] _gpRegs_in_T_3 = _pc_io_out + 16'h0002;
	wire _GEN_53 = op == 6'h19;
	wire [15:0] _newPc_T_1 = _pc_io_out + 16'h0002;
	wire _GEN_54 = (_GEN_48 | _GEN_49) | _GEN_50;
	wire _GEN_55 = _GEN_45 | _GEN_47;
	wire _GEN_56 = (((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41;
	wire _GEN_57 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_45) | _GEN_47) | (~_GEN_54 & (_GEN_52 | _GEN_53));
	wire _GEN_58 = op == 6'h1a;
	wire _GEN_59 = op == 6'h1b;
	wire _GEN_60 = op == 6'h1c;
	wire _GEN_61 = op == 6'h1d;
	wire _GEN_62 = op == 6'h1e;
	wire _GEN_63 = op == 6'h1f;
	wire _GEN_64 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_45) | _GEN_47) | _GEN_54;
	wire _GEN_65 = (_GEN_44 & ~_GEN_64) & ((_GEN_52 | _GEN_53) | (_GEN_58 ? beqResult : (_GEN_59 ? bneResult : (_GEN_60 ? bltResult : (_GEN_61 ? bgeResult : (_GEN_62 ? bltuResult : _GEN_63 & bgeuResult))))));
	wire _GEN_66 = cycles == 16'h0001;
	wire [15:0] _gpRegs_in_T_7 = {io_memDataOut, lhValue};
	wire _GEN_67 = (_GEN_66 & allowStep) & _GEN_48;
	wire _GEN_68 = _GEN_66 & allowStep;
	wire _GEN_69 = (_GEN_16 & allowStep) & ~(((((((((_GEN_48 | _GEN_50) | _GEN_52) | _GEN_53) | beqResult) | bneResult) | bltResult) | bgeResult) | bltuResult) | bgeuResult);
	always @(posedge clock)
		if (reset) begin
			cycles <= 16'h0000;
			lhValue <= 8'h00;
		end
		else begin : sv2v_autoblock_1
			reg _GEN_70;
			_GEN_70 = (((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_45) | _GEN_47;
			if (_GEN_16) begin
				if ((~allowStep | _GEN_70) | ~(_GEN_48 | ~(_GEN_49 | ~_GEN_50)))
					;
				else
					cycles <= 16'h0001;
			end
			else if (_GEN_68)
				cycles <= 16'h0000;
			if ((~_GEN_44 | _GEN_70) | ~_GEN_48)
				;
			else
				lhValue <= io_memDataOut;
		end
	Register Register(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_17 ? _alu_io_out : _Register_io_out) : (_GEN_55 ? (_GEN_17 ? _GEN_46 : _Register_io_out) : (_GEN_54 ? _Register_io_out : (_GEN_52 ? (_GEN_17 ? _gpRegs_in_T_3 : _Register_io_out) : (_GEN_53 & _GEN_17 ? _newPc_T_1 : _Register_io_out))))) : _Register_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_17 ? _gpRegs_in_T_7 : _Register_io_out))),
		.io_out(_Register_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_17 : _GEN_67 & _GEN_17))
	);
	Register Register_1(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_18 ? _alu_io_out : _Register_1_io_out) : (_GEN_55 ? (_GEN_18 ? _GEN_46 : _Register_1_io_out) : (_GEN_54 ? _Register_1_io_out : (_GEN_52 ? (_GEN_18 ? _gpRegs_in_T_3 : _Register_1_io_out) : (_GEN_53 & _GEN_18 ? _newPc_T_1 : _Register_1_io_out))))) : _Register_1_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_18 ? _gpRegs_in_T_7 : _Register_1_io_out))),
		.io_out(_Register_1_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_18 : _GEN_67 & _GEN_18))
	);
	Register Register_2(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_19 ? _alu_io_out : _Register_2_io_out) : (_GEN_55 ? (_GEN_19 ? _GEN_46 : _Register_2_io_out) : (_GEN_54 ? _Register_2_io_out : (_GEN_52 ? (_GEN_19 ? _gpRegs_in_T_3 : _Register_2_io_out) : (_GEN_53 & _GEN_19 ? _newPc_T_1 : _Register_2_io_out))))) : _Register_2_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_19 ? _gpRegs_in_T_7 : _Register_2_io_out))),
		.io_out(_Register_2_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_19 : _GEN_67 & _GEN_19))
	);
	Register Register_3(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_20 ? _alu_io_out : _Register_3_io_out) : (_GEN_55 ? (_GEN_20 ? _GEN_46 : _Register_3_io_out) : (_GEN_54 ? _Register_3_io_out : (_GEN_52 ? (_GEN_20 ? _gpRegs_in_T_3 : _Register_3_io_out) : (_GEN_53 & _GEN_20 ? _newPc_T_1 : _Register_3_io_out))))) : _Register_3_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_20 ? _gpRegs_in_T_7 : _Register_3_io_out))),
		.io_out(_Register_3_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_20 : _GEN_67 & _GEN_20))
	);
	Register Register_4(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_21 ? _alu_io_out : _Register_4_io_out) : (_GEN_55 ? (_GEN_21 ? _GEN_46 : _Register_4_io_out) : (_GEN_54 ? _Register_4_io_out : (_GEN_52 ? (_GEN_21 ? _gpRegs_in_T_3 : _Register_4_io_out) : (_GEN_53 & _GEN_21 ? _newPc_T_1 : _Register_4_io_out))))) : _Register_4_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_21 ? _gpRegs_in_T_7 : _Register_4_io_out))),
		.io_out(_Register_4_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_21 : _GEN_67 & _GEN_21))
	);
	Register Register_5(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_22 ? _alu_io_out : _Register_5_io_out) : (_GEN_55 ? (_GEN_22 ? _GEN_46 : _Register_5_io_out) : (_GEN_54 ? _Register_5_io_out : (_GEN_52 ? (_GEN_22 ? _gpRegs_in_T_3 : _Register_5_io_out) : (_GEN_53 & _GEN_22 ? _newPc_T_1 : _Register_5_io_out))))) : _Register_5_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_22 ? _gpRegs_in_T_7 : _Register_5_io_out))),
		.io_out(_Register_5_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_22 : _GEN_67 & _GEN_22))
	);
	Register Register_6(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (_GEN_23 ? _alu_io_out : _Register_6_io_out) : (_GEN_55 ? (_GEN_23 ? _GEN_46 : _Register_6_io_out) : (_GEN_54 ? _Register_6_io_out : (_GEN_52 ? (_GEN_23 ? _gpRegs_in_T_3 : _Register_6_io_out) : (_GEN_53 & _GEN_23 ? _newPc_T_1 : _Register_6_io_out))))) : _Register_6_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & _GEN_23 ? _gpRegs_in_T_7 : _Register_6_io_out))),
		.io_out(_Register_6_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & _GEN_23 : _GEN_67 & _GEN_23))
	);
	Register Register_7(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (allowStep ? (_GEN_56 ? (&rd_1 ? _alu_io_out : _Register_7_io_out) : (_GEN_55 ? (&rd_1 ? _GEN_46 : _Register_7_io_out) : (_GEN_54 ? _Register_7_io_out : (_GEN_52 ? (&rd_1 ? _gpRegs_in_T_3 : _Register_7_io_out) : (_GEN_53 & (&rd_1) ? _newPc_T_1 : _Register_7_io_out))))) : _Register_7_io_out) : (((_GEN_66 & allowStep) & _GEN_48) & (&rd_1) ? _gpRegs_in_T_7 : _Register_7_io_out))),
		.io_out(_Register_7_io_out),
		.io_write((_GEN_16 ? (allowStep & _GEN_57) & (&rd_1) : _GEN_67 & (&rd_1)))
	);
	Register pc(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_68 ? _pc_io_out + 16'h0002 : (_GEN_69 ? _pc_io_out + 16'h0002 : (~_GEN_44 | _GEN_64 ? _pc_io_out : (_GEN_52 ? _pc_io_out + _GEN_12[fmt * 16+:16] : (_GEN_53 ? 16'h0000 : (_GEN_58 ? (beqResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_59 ? (bneResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_60 ? (bltResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_61 ? (bgeResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_62 ? (bltuResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_63 & bgeuResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out)))))))))))),
		.io_out(_pc_io_out),
		.io_write((_GEN_66 ? (allowStep | _GEN_69) | _GEN_65 : _GEN_69 | _GEN_65))
	);
	Alu alu(
		.io_a(((_GEN_16 & allowStep) & _GEN_43 ? _GEN_14 : 16'h0000)),
		.io_b((_GEN_44 ? (|op ? (_GEN_24 ? _GEN_12[fmt * 16+:16] : (_GEN_25 | _GEN_26 ? _GEN_15 : (_GEN_27 ? _GEN_12[fmt * 16+:16] : (_GEN_28 ? _GEN_15 : (_GEN_29 ? _GEN_12[fmt * 16+:16] : (_GEN_30 ? _GEN_15 : (_GEN_31 ? _GEN_12[fmt * 16+:16] : (_GEN_32 ? _GEN_15 : (_GEN_33 ? _GEN_12[fmt * 16+:16] : (_GEN_34 ? _GEN_15 : (_GEN_35 ? _GEN_12[fmt * 16+:16] : (_GEN_36 ? _GEN_15 : (_GEN_37 ? _GEN_12[fmt * 16+:16] : (_GEN_38 ? _GEN_15 : (_GEN_39 ? _GEN_12[fmt * 16+:16] : (_GEN_40 ? _GEN_15 : (_GEN_41 ? _GEN_12[fmt * 16+:16] : 16'h0000))))))))))))))))) : _GEN_15) : 16'h0000)),
		.io_op(((~_GEN_44 | ~(|op)) | _GEN_24 ? 4'h0 : (_GEN_25 ? 4'h1 : (_GEN_26 | _GEN_27 ? 4'h2 : (_GEN_28 | _GEN_29 ? 4'h3 : (_GEN_30 | _GEN_31 ? 4'h4 : (_GEN_32 | _GEN_33 ? 4'h5 : (_GEN_34 | _GEN_35 ? 4'h6 : (_GEN_36 | _GEN_37 ? 4'h7 : (_GEN_38 | _GEN_39 ? 4'h8 : (_GEN_42 ? 4'h9 : 4'h0))))))))))),
		.io_out(_alu_io_out)
	);
	assign io_memDataAddr = (_GEN_16 ? (~allowStep | _GEN_43 ? 16'h0000 : (_GEN_45 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_47 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_48 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_49 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_50 ? _GEN_14 + _GEN_12[fmt * 16+:16] : 16'h0000)))))) : (_GEN_68 ? (_GEN_48 ? (_GEN_14 + _GEN_12[fmt * 16+:16]) + 16'h0001 : (_GEN_50 ? (_GEN_14 + _GEN_12[fmt * 16+:16]) + 16'h0001 : 16'h0000)) : 16'h0000));
	assign io_memDataIn = (_GEN_16 ? (~allowStep | _GEN_51 ? 8'h00 : (_GEN_49 ? _GEN_13[(rd_1 * 16) + 7-:8] : (_GEN_50 ? _GEN_13[(rd_1 * 16) + 7-:8] : 8'h00))) : ((~_GEN_68 | _GEN_48) | ~_GEN_50 ? 8'h00 : _GEN_13[(rd_1 * 16) + 15-:8]));
	assign io_memDataWrite = (_GEN_16 ? (allowStep & ~_GEN_51) & (_GEN_49 | _GEN_50) : (_GEN_68 & ~_GEN_48) & _GEN_50);
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
	io_memInst,
	io_debug_halt,
	io_debug_step
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
	input [15:0] io_memInst;
	input io_debug_halt;
	input io_debug_step;
	Cpu cpu(
		.clock(clock),
		.reset(reset),
		.io_memDataAddr(io_memDataAddr),
		.io_memDataIn(io_memDataIn),
		.io_memDataOut(io_memDataOut),
		.io_memDataWrite(io_memDataWrite),
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
		.io_debug_halt(io_debug_halt),
		.io_debug_step(io_debug_step)
	);
	assign io_inst = io_memInst;
endmodule
