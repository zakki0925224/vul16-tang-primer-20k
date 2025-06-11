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
    wire [15:0] inst;

    Core core (
        .clock(clock),
        .reset(reset),
        .io_pc(),
        .io_inst(),
        .io_gpRegs_0(),
        .io_gpRegs_1(),
        .io_gpRegs_2(),
        .io_gpRegs_3(),
        .io_gpRegs_4(),
        .io_gpRegs_5(),
        .io_gpRegs_6(),
        .io_gpRegs_7(),
        .io_memInst(inst),
        .io_debug_halt(),
        .io_debug_step()
    );

    Memory memory (
        .clock(clock),
        .reset(reset),
        .data_addr(core.io_memDataAddr),
        .data_in(core.io_memDataIn),
        .data_out(core.io_memDataOut),
        .data_write(core.io_memDataWrite),
        .inst_addr(core.io_memInst),
        .inst_out(inst)
    );

    Led _led (
        .clock(clock),
        .reset(reset),
        .mmio_addr(core.io_memDataAddr),
        .mmio_data(core.io_memDataIn),
        .led(led)
    );
endmodule

`default_nettype wire
