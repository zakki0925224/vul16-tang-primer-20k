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
	io_gpRegs_7
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
	wire _GEN_44 = op == 6'h13;
	wire [15:0] _GEN_45 = {8'h00, io_memDataOut};
	wire _GEN_46 = op == 6'h14;
	wire _GEN_47 = op == 6'h15;
	wire _GEN_48 = op == 6'h16;
	wire _GEN_49 = op == 6'h17;
	wire _GEN_50 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_44) | _GEN_46) | _GEN_47;
	wire _GEN_51 = op == 6'h18;
	wire [15:0] _gpRegs_in_T_3 = _pc_io_out + 16'h0002;
	wire _GEN_52 = op == 6'h19;
	wire [15:0] _newPc_T_1 = _pc_io_out + 16'h0002;
	wire _GEN_53 = (_GEN_47 | _GEN_48) | _GEN_49;
	wire _GEN_54 = _GEN_44 | _GEN_46;
	wire _GEN_55 = (((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41;
	wire _GEN_56 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_44) | _GEN_46) | (~_GEN_53 & (_GEN_51 | _GEN_52));
	wire _GEN_57 = op == 6'h1a;
	wire _GEN_58 = op == 6'h1b;
	wire _GEN_59 = op == 6'h1c;
	wire _GEN_60 = op == 6'h1d;
	wire _GEN_61 = op == 6'h1e;
	wire _GEN_62 = op == 6'h1f;
	wire _GEN_63 = ((((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_44) | _GEN_46) | _GEN_53;
	wire _GEN_64 = cycles == 16'h0001;
	wire [15:0] _gpRegs_in_T_7 = {io_memDataOut, lhValue};
	wire _GEN_65 = _GEN_64 & _GEN_47;
	wire _GEN_66 = _GEN_16 & ~(((((((((_GEN_47 | _GEN_49) | _GEN_51) | _GEN_52) | beqResult) | bneResult) | bltResult) | bgeResult) | bltuResult) | bgeuResult);
	always @(posedge clock)
		if (reset) begin
			cycles <= 16'h0000;
			lhValue <= 8'h00;
		end
		else begin : sv2v_autoblock_1
			reg _GEN_67;
			_GEN_67 = (((((((((((((((((((~(|op) | _GEN_24) | _GEN_25) | _GEN_26) | _GEN_27) | _GEN_28) | _GEN_29) | _GEN_30) | _GEN_31) | _GEN_32) | _GEN_33) | _GEN_34) | _GEN_35) | _GEN_36) | _GEN_37) | _GEN_38) | _GEN_39) | _GEN_40) | _GEN_41) | _GEN_44) | _GEN_46;
			if (_GEN_16) begin
				if (_GEN_67 | ~(_GEN_47 | ~(_GEN_48 | ~_GEN_49)))
					;
				else
					cycles <= 16'h0001;
			end
			else if (_GEN_64)
				cycles <= 16'h0000;
			if ((~_GEN_16 | _GEN_67) | ~_GEN_47)
				;
			else
				lhValue <= io_memDataOut;
		end
	Register Register(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_17 ? _alu_io_out : _Register_io_out) : (_GEN_54 ? (_GEN_17 ? _GEN_45 : _Register_io_out) : (_GEN_53 ? _Register_io_out : (_GEN_51 ? (_GEN_17 ? _gpRegs_in_T_3 : _Register_io_out) : (_GEN_52 & _GEN_17 ? _newPc_T_1 : _Register_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_17 ? _gpRegs_in_T_7 : _Register_io_out))),
		.io_out(_Register_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_17 : _GEN_65 & _GEN_17))
	);
	Register Register_1(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_18 ? _alu_io_out : _Register_1_io_out) : (_GEN_54 ? (_GEN_18 ? _GEN_45 : _Register_1_io_out) : (_GEN_53 ? _Register_1_io_out : (_GEN_51 ? (_GEN_18 ? _gpRegs_in_T_3 : _Register_1_io_out) : (_GEN_52 & _GEN_18 ? _newPc_T_1 : _Register_1_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_18 ? _gpRegs_in_T_7 : _Register_1_io_out))),
		.io_out(_Register_1_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_18 : _GEN_65 & _GEN_18))
	);
	Register Register_2(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_19 ? _alu_io_out : _Register_2_io_out) : (_GEN_54 ? (_GEN_19 ? _GEN_45 : _Register_2_io_out) : (_GEN_53 ? _Register_2_io_out : (_GEN_51 ? (_GEN_19 ? _gpRegs_in_T_3 : _Register_2_io_out) : (_GEN_52 & _GEN_19 ? _newPc_T_1 : _Register_2_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_19 ? _gpRegs_in_T_7 : _Register_2_io_out))),
		.io_out(_Register_2_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_19 : _GEN_65 & _GEN_19))
	);
	Register Register_3(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_20 ? _alu_io_out : _Register_3_io_out) : (_GEN_54 ? (_GEN_20 ? _GEN_45 : _Register_3_io_out) : (_GEN_53 ? _Register_3_io_out : (_GEN_51 ? (_GEN_20 ? _gpRegs_in_T_3 : _Register_3_io_out) : (_GEN_52 & _GEN_20 ? _newPc_T_1 : _Register_3_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_20 ? _gpRegs_in_T_7 : _Register_3_io_out))),
		.io_out(_Register_3_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_20 : _GEN_65 & _GEN_20))
	);
	Register Register_4(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_21 ? _alu_io_out : _Register_4_io_out) : (_GEN_54 ? (_GEN_21 ? _GEN_45 : _Register_4_io_out) : (_GEN_53 ? _Register_4_io_out : (_GEN_51 ? (_GEN_21 ? _gpRegs_in_T_3 : _Register_4_io_out) : (_GEN_52 & _GEN_21 ? _newPc_T_1 : _Register_4_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_21 ? _gpRegs_in_T_7 : _Register_4_io_out))),
		.io_out(_Register_4_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_21 : _GEN_65 & _GEN_21))
	);
	Register Register_5(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_22 ? _alu_io_out : _Register_5_io_out) : (_GEN_54 ? (_GEN_22 ? _GEN_45 : _Register_5_io_out) : (_GEN_53 ? _Register_5_io_out : (_GEN_51 ? (_GEN_22 ? _gpRegs_in_T_3 : _Register_5_io_out) : (_GEN_52 & _GEN_22 ? _newPc_T_1 : _Register_5_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_22 ? _gpRegs_in_T_7 : _Register_5_io_out))),
		.io_out(_Register_5_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_22 : _GEN_65 & _GEN_22))
	);
	Register Register_6(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (_GEN_23 ? _alu_io_out : _Register_6_io_out) : (_GEN_54 ? (_GEN_23 ? _GEN_45 : _Register_6_io_out) : (_GEN_53 ? _Register_6_io_out : (_GEN_51 ? (_GEN_23 ? _gpRegs_in_T_3 : _Register_6_io_out) : (_GEN_52 & _GEN_23 ? _newPc_T_1 : _Register_6_io_out))))) : ((_GEN_64 & _GEN_47) & _GEN_23 ? _gpRegs_in_T_7 : _Register_6_io_out))),
		.io_out(_Register_6_io_out),
		.io_write((_GEN_16 ? _GEN_56 & _GEN_23 : _GEN_65 & _GEN_23))
	);
	Register Register_7(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_16 ? (_GEN_55 ? (&rd_1 ? _alu_io_out : _Register_7_io_out) : (_GEN_54 ? (&rd_1 ? _GEN_45 : _Register_7_io_out) : (_GEN_53 ? _Register_7_io_out : (_GEN_51 ? (&rd_1 ? _gpRegs_in_T_3 : _Register_7_io_out) : (_GEN_52 & (&rd_1) ? _newPc_T_1 : _Register_7_io_out))))) : ((_GEN_64 & _GEN_47) & (&rd_1) ? _gpRegs_in_T_7 : _Register_7_io_out))),
		.io_out(_Register_7_io_out),
		.io_write((_GEN_16 ? _GEN_56 & (&rd_1) : _GEN_65 & (&rd_1)))
	);
	Register pc(
		.clock(clock),
		.reset(reset),
		.io_in((_GEN_64 ? _pc_io_out + 16'h0002 : (_GEN_66 ? _pc_io_out + 16'h0002 : (~_GEN_16 | _GEN_63 ? _pc_io_out : (_GEN_51 ? _pc_io_out + _GEN_12[fmt * 16+:16] : (_GEN_52 ? 16'h0000 : (_GEN_57 ? (beqResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_58 ? (bneResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_59 ? (bltResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_60 ? (bgeResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_61 ? (bltuResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out) : (_GEN_62 & bgeuResult ? _pc_io_out + _GEN_12[fmt * 16+:16] : _pc_io_out)))))))))))),
		.io_out(_pc_io_out),
		.io_write((_GEN_64 | _GEN_66) | ((_GEN_16 & ~_GEN_63) & ((_GEN_51 | _GEN_52) | (_GEN_57 ? beqResult : (_GEN_58 ? bneResult : (_GEN_59 ? bltResult : (_GEN_60 ? bgeResult : (_GEN_61 ? bltuResult : _GEN_62 & bgeuResult))))))))
	);
	Alu alu(
		.io_a((_GEN_16 & _GEN_43 ? _GEN_14 : 16'h0000)),
		.io_b((_GEN_16 ? (|op ? (_GEN_24 ? _GEN_12[fmt * 16+:16] : (_GEN_25 | _GEN_26 ? _GEN_15 : (_GEN_27 ? _GEN_12[fmt * 16+:16] : (_GEN_28 ? _GEN_15 : (_GEN_29 ? _GEN_12[fmt * 16+:16] : (_GEN_30 ? _GEN_15 : (_GEN_31 ? _GEN_12[fmt * 16+:16] : (_GEN_32 ? _GEN_15 : (_GEN_33 ? _GEN_12[fmt * 16+:16] : (_GEN_34 ? _GEN_15 : (_GEN_35 ? _GEN_12[fmt * 16+:16] : (_GEN_36 ? _GEN_15 : (_GEN_37 ? _GEN_12[fmt * 16+:16] : (_GEN_38 ? _GEN_15 : (_GEN_39 ? _GEN_12[fmt * 16+:16] : (_GEN_40 ? _GEN_15 : (_GEN_41 ? _GEN_12[fmt * 16+:16] : 16'h0000))))))))))))))))) : _GEN_15) : 16'h0000)),
		.io_op(((~_GEN_16 | ~(|op)) | _GEN_24 ? 4'h0 : (_GEN_25 ? 4'h1 : (_GEN_26 | _GEN_27 ? 4'h2 : (_GEN_28 | _GEN_29 ? 4'h3 : (_GEN_30 | _GEN_31 ? 4'h4 : (_GEN_32 | _GEN_33 ? 4'h5 : (_GEN_34 | _GEN_35 ? 4'h6 : (_GEN_36 | _GEN_37 ? 4'h7 : (_GEN_38 | _GEN_39 ? 4'h8 : (_GEN_42 ? 4'h9 : 4'h0))))))))))),
		.io_out(_alu_io_out)
	);
	assign io_memDataAddr = (_GEN_16 ? (_GEN_43 ? 16'h0000 : (_GEN_44 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_46 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_47 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_48 ? _GEN_14 + _GEN_12[fmt * 16+:16] : (_GEN_49 ? _GEN_14 + _GEN_12[fmt * 16+:16] : 16'h0000)))))) : (_GEN_64 ? (_GEN_47 ? (_GEN_14 + _GEN_12[fmt * 16+:16]) + 16'h0001 : (_GEN_49 ? (_GEN_14 + _GEN_12[fmt * 16+:16]) + 16'h0001 : 16'h0000)) : 16'h0000));
	assign io_memDataIn = (_GEN_16 ? (_GEN_50 ? 8'h00 : (_GEN_48 ? _GEN_13[(rd_1 * 16) + 7-:8] : (_GEN_49 ? _GEN_13[(rd_1 * 16) + 7-:8] : 8'h00))) : ((~_GEN_64 | _GEN_47) | ~_GEN_49 ? 8'h00 : _GEN_13[(rd_1 * 16) + 15-:8]));
	assign io_memDataWrite = (_GEN_16 ? ~_GEN_50 & (_GEN_48 | _GEN_49) : (_GEN_64 & ~_GEN_47) & _GEN_49);
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
module mem_65536x8 (
	R0_addr,
	R0_en,
	R0_clk,
	R0_data,
	R1_addr,
	R1_en,
	R1_clk,
	R1_data,
	R2_addr,
	R2_en,
	R2_clk,
	R2_data,
	W0_addr,
	W0_en,
	W0_clk,
	W0_data,
	W1_addr,
	W1_en,
	W1_clk,
	W1_data
);
	input [15:0] R0_addr;
	input R0_en;
	input R0_clk;
	output wire [7:0] R0_data;
	input [15:0] R1_addr;
	input R1_en;
	input R1_clk;
	output wire [7:0] R1_data;
	input [15:0] R2_addr;
	input R2_en;
	input R2_clk;
	output wire [7:0] R2_data;
	input [15:0] W0_addr;
	input W0_en;
	input W0_clk;
	input [7:0] W0_data;
	input [15:0] W1_addr;
	input W1_en;
	input W1_clk;
	input [7:0] W1_data;
	reg [7:0] Memory [0:65535];
	always @(posedge W0_clk) begin
		if (W0_en & 1'h1)
			Memory[W0_addr] <= W0_data;
		if (W1_en & 1'h1)
			Memory[W1_addr] <= W1_data;
	end
	assign R0_data = (R0_en ? Memory[R0_addr] : 8'bxxxxxxxx);
	assign R1_data = (R1_en ? Memory[R1_addr] : 8'bxxxxxxxx);
	assign R2_data = (R2_en ? Memory[R2_addr] : 8'bxxxxxxxx);
endmodule
module Memory (
	clock,
	io_dataAddr,
	io_dataIn,
	io_dataOut,
	io_dataWrite,
	io_instAddr,
	io_instOut,
	io_mmioInAddr,
	io_mmioIn
);
	input clock;
	input [15:0] io_dataAddr;
	input [7:0] io_dataIn;
	output wire [7:0] io_dataOut;
	input io_dataWrite;
	input [15:0] io_instAddr;
	output wire [15:0] io_instOut;
	input [15:0] io_mmioInAddr;
	input [7:0] io_mmioIn;
	wire [7:0] _mem_ext_R0_data;
	wire [7:0] _mem_ext_R1_data;
	mem_65536x8 mem_ext(
		.R0_addr(io_instAddr),
		.R0_en(1'h1),
		.R0_clk(clock),
		.R0_data(_mem_ext_R0_data),
		.R1_addr(io_instAddr + 16'h0001),
		.R1_en(1'h1),
		.R1_clk(clock),
		.R1_data(_mem_ext_R1_data),
		.R2_addr(io_dataAddr),
		.R2_en(1'h1),
		.R2_clk(clock),
		.R2_data(io_dataOut),
		.W0_addr(io_mmioInAddr),
		.W0_en(io_mmioInAddr > 16'hefff),
		.W0_clk(clock),
		.W0_data(io_mmioIn),
		.W1_addr(io_dataAddr),
		.W1_en(io_dataWrite),
		.W1_clk(clock),
		.W1_data(io_dataIn)
	);
	assign io_instOut = {_mem_ext_R1_data, _mem_ext_R0_data};
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
	io_mmioInAddr,
	io_mmioIn,
	io_mmioOut,
	io_mmioOutAddr
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
	input [15:0] io_mmioInAddr;
	input [7:0] io_mmioIn;
	output wire [7:0] io_mmioOut;
	output wire [15:0] io_mmioOutAddr;
	wire [7:0] _mem_io_dataOut;
	wire [15:0] _mem_io_instOut;
	wire [15:0] _cpu_io_memDataAddr;
	wire [7:0] _cpu_io_memDataIn;
	wire _cpu_io_memDataWrite;
	wire [15:0] _cpu_io_pc;
	wire isMmio = _cpu_io_memDataAddr > 16'hefff;
	Cpu cpu(
		.clock(clock),
		.reset(reset),
		.io_memDataAddr(_cpu_io_memDataAddr),
		.io_memDataIn(_cpu_io_memDataIn),
		.io_memDataOut(_mem_io_dataOut),
		.io_memDataWrite(_cpu_io_memDataWrite),
		.io_inst(_mem_io_instOut),
		.io_pc(_cpu_io_pc),
		.io_gpRegs_0(io_gpRegs_0),
		.io_gpRegs_1(io_gpRegs_1),
		.io_gpRegs_2(io_gpRegs_2),
		.io_gpRegs_3(io_gpRegs_3),
		.io_gpRegs_4(io_gpRegs_4),
		.io_gpRegs_5(io_gpRegs_5),
		.io_gpRegs_6(io_gpRegs_6),
		.io_gpRegs_7(io_gpRegs_7)
	);
	Memory mem(
		.clock(clock),
		.io_dataAddr(_cpu_io_memDataAddr),
		.io_dataIn(_cpu_io_memDataIn),
		.io_dataOut(_mem_io_dataOut),
		.io_dataWrite(~isMmio & _cpu_io_memDataWrite),
		.io_instAddr(_cpu_io_pc),
		.io_instOut(_mem_io_instOut),
		.io_mmioInAddr(io_mmioInAddr),
		.io_mmioIn(io_mmioIn)
	);
	assign io_pc = _cpu_io_pc;
	assign io_inst = _mem_io_instOut;
	assign io_mmioOut = (isMmio ? _cpu_io_memDataIn : 8'h00);
	assign io_mmioOutAddr = (isMmio ? _cpu_io_memDataAddr : 16'h0000);
endmodule
