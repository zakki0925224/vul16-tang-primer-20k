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
    wire [7:0] mmio_out;
    wire [15:0] mmio_out_addr;

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
        .io_mmioInAddr(16'h0),
        .io_mmioIn(8'h0),
        .io_mmioOut(mmio_out),
        .io_mmioOutAddr(mmio_out_addr)
    );

    Led led_ (
        .clock(clock),
        .reset(reset),
        .mmio_out_addr(mmio_out_addr),
        .mmio_out(mmio_out),
        .led(led)
    );
endmodule

`default_nettype wire
