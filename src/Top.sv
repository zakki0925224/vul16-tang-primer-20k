`default_nettype none

module Top(
    input wire clock,
    input wire reset,

    output wire [5:0] led,

    input wire uart_rx,
    output wire uart_tx,

    output wire lcd_dclk,
    output wire lcd_de,
    output wire lcd_hs,
    output wire lcd_vs,
    output wire [4:0] lcd_r,
    output wire [5:0] lcd_g,
    output wire [4:0] lcd_b
);
    wire [15:0] instAddr;
    wire [15:0] inst;

    wire [15:0] memDataAddr;
    wire [7:0] memDataIn;
    wire [7:0] memDataOut;
    wire memDataWrite;

    Core core (
        .clock(clock),
        .reset(reset),
        .io_pc(instAddr),
        .io_inst(),
        .io_gpRegs_0(),
        .io_gpRegs_1(),
        .io_gpRegs_2(),
        .io_gpRegs_3(),
        .io_gpRegs_4(),
        .io_gpRegs_5(),
        .io_gpRegs_6(),
        .io_gpRegs_7(),
        .io_memDataAddr(memDataAddr),
        .io_memDataIn(memDataIn),
        .io_memDataOut(memDataOut),
        .io_memDataWrite(memDataWrite),
        .io_memInst(inst),
        .io_debug_halt(),
        .io_debug_step()
    );

    Memory memory (
        .clock(clock),
        .reset(reset),
        .data_addr(memDataAddr),
        .data_in(memDataIn),
        .data_out(memDataOut),
        .data_write(memDataWrite),
        .inst_addr(instAddr),
        .inst_out(inst)
    );

    Led _led (
        .clock(clock),
        .reset(reset),
        .mmio_addr(memDataAddr),
        .mmio_data(memDataIn),
        .led(led)
    );

    Uart uart (
        .clock(clock),
        .reset(reset),
        .mmio_addr(memDataAddr),
        .mmio_data(memDataIn),
        .mmio_update(memDataWrite),
        .tx(uart_tx)
    );
endmodule

`default_nettype wire
