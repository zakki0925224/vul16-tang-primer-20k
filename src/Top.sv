`default_nettype none

module Top
#(
    parameter ROM_SIZE = 256
)
(
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
    output wire [4:0] lcd_b,

    input wire btn_s1,
    input wire btn_s2,
    input wire btn_s3,
    input wire btn_s4
);
    reg [7:0] rom [0:ROM_SIZE-1];
    reg init_done = 1'b0;
    reg [1:0] init_state = 0; // 0: idle, 1: writing, 2: next address
    reg [15:0] init_mem_addr = 16'h0000;
    reg [7:0] init_mem_data = 8'h0000;

    wire data_req;
    wire data_done;
    wire inst_req;
    wire inst_done;

    wire [15:0] inst_addr;
    wire [15:0] inst;

    wire [15:0] mem_data_addr;
    wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire mem_data_write;

    Core core (
        .clock(clock),
        .reset(~reset | ~init_done),
        .io_pc(inst_addr),
        .io_inst(),
        .io_gpRegs_0(),
        .io_gpRegs_1(),
        .io_gpRegs_2(),
        .io_gpRegs_3(),
        .io_gpRegs_4(),
        .io_gpRegs_5(),
        .io_gpRegs_6(),
        .io_gpRegs_7(),
        .io_memDataAddr(mem_data_addr),
        .io_memDataIn(mem_data_in),
        .io_memDataOut(mem_data_out),
        .io_memDataWrite(mem_data_write),
        .io_memDataReq(data_req),
        .io_memDataDone(data_done),
        .io_memInst(inst),
        .io_memInstReq(inst_req),
        .io_memInstDone(inst_done),
        .io_debugHalt(),
        .io_debugStep()
    );

    Memory memory (
        .clock(clock),
        .reset(~reset),
        .data_addr(init_done ? mem_data_addr : init_mem_addr),
        .data_in(init_done ? mem_data_in : init_mem_data),
        .data_out(mem_data_out),
        .data_req(data_req),
        .data_done(data_done),
        .data_write(init_done ? mem_data_write : (init_state == 1)),
        .inst_addr(inst_addr),
        .inst_out(inst),
        .inst_req(inst_req),
        .inst_done(inst_done)
    );

    Led _led (
        .clock(clock),
        .reset(~reset | ~init_done),
        .mmio_addr(mem_data_addr),
        .mmio_data(mem_data_in),
        .led(led)
    );

    Uart uart (
        .clock(clock),
        .reset(~reset | ~init_done),
        .mmio_addr(mem_data_addr),
        .mmio_data(mem_data_in),
        .mmio_update(mem_data_write),
        .tx(uart_tx)
    );

    always @(posedge clock) begin
        if (~reset) begin
            init_done <= 1'b0;
            init_state <= 0;
            init_mem_addr <= 16'h0000;
            init_mem_data <= 8'h00;
        end else if (~init_done) begin
            case (init_state)
                0: begin
                    if (init_mem_addr < ROM_SIZE) begin
                        init_mem_data <= rom[init_mem_addr];
                        init_state <= 1;
                    end else begin
                        init_done <= 1'b1;
                    end
                end
                1: begin
                    init_state <= 2;
                end
                2: begin
                    init_mem_addr <= init_mem_addr + 1;
                    init_state <= 0;
                end
            endcase
        end
    end

    initial begin
        $readmemh("rom.hex", rom);
    end
endmodule

`default_nettype wire
