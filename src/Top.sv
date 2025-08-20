`default_nettype none

module Top
#(
    parameter ROM_SIZE = 16'hf000 // 61KB
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
    reg [7:0] init_mem_data = 8'h00;
    reg init_data_req;

    wire data_req;
    wire data_done;
    wire inst_req;
    wire inst_done;

    wire mmio_led_done;
    wire mmio_uart_done;
    wire mmio_lcd_done;

    wire [15:0] inst_addr;
    wire [15:0] inst;

    wire [15:0] mem_data_addr;
    wire [7:0] mem_data_in;
    wire [7:0] mem_data_out;
    wire mem_data_write;

    // debounced / synchronized button outputs (active-high when pressed)
    reg [7:0] btn1_sh;
    reg [7:0] btn2_sh;
    reg [7:0] btn3_sh;
    reg [7:0] btn4_sh;
    reg btn1_db;
    reg btn2_db;
    reg btn3_db;
    reg btn4_db;

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
        .data_req(data_req | init_data_req),
        .data_done(data_done),
        .data_write(init_done ? mem_data_write : (init_state == 1)),
        .inst_addr(inst_addr),
        .inst_out(inst),
        .inst_req(inst_req),
        .inst_done(inst_done),
        .mmio_led_done(mmio_led_done),
        .mmio_uart_done(mmio_uart_done),
        .mmio_lcd_done(mmio_lcd_done),
        // debounced button inputs (bit0 = btn_s1, bit1 = btn_s2 ...)
        .tmp_mmio_btn({4'b0000, btn4_db, btn3_db, btn2_db, btn1_db})
    );

    Led _led (
        .clock(clock),
        .reset(~reset | ~init_done),
        .mmio_addr(mem_data_addr),
        .mmio_data(mem_data_in),
        .mmio_req(data_req),
        .mmio_done(mmio_led_done),
        .led(led)
    );

    Uart uart (
        .clock(clock),
        .reset(~reset | ~init_done),
        .mmio_addr(mem_data_addr),
        .mmio_data(mem_data_in),
        .mmio_req(data_req),
        .mmio_done(mmio_uart_done),
        .tx(uart_tx)
    );

    RgbLcd lcd (
        .clock(clock),
        .reset(~reset | ~init_done),
        .mmio_addr(mem_data_addr),
        .mmio_data(mem_data_in),
        .mmio_req(data_req),
        .mmio_done(mmio_lcd_done),
        .dclk(lcd_dclk),
        .de(lcd_de),
        .hs(lcd_hs),
        .vs(lcd_vs),
        .r(lcd_r),
        .g(lcd_g),
        .b(lcd_b)
    );

    always @(posedge clock) begin
        if (~reset) begin
            init_done <= 1'b0;
            init_state <= 0;
            init_mem_addr <= 16'h0000;
            init_mem_data <= 8'h00;
            init_data_req <= 1'b0;
        end else if (~init_done) begin
            case (init_state)
                0: begin
                    if (init_mem_addr < ROM_SIZE) begin
                        init_mem_data <= rom[init_mem_addr];
                        init_data_req <= 1'b1;
                        init_state <= 1;
                    end else begin
                        init_done <= 1'b1;
                        init_data_req <= 1'b0;
                    end
                end
                1: begin
                    init_state <= 2;
                end
                2: begin
                    if (data_done) begin
                        init_data_req <= 1'b0;
                        init_mem_addr <= init_mem_addr + 1;
                        init_state <= 0;
                    end
                end
            endcase
        end else begin
            init_data_req <= 1'b0;
        end
    end

    // button synchronizer + debounce (8-sample shift register)
    always @(posedge clock) begin
        if (~reset) begin
            btn1_sh <= 8'h00;
            btn2_sh <= 8'h00;
            btn3_sh <= 8'h00;
            btn4_sh <= 8'h00;
            btn1_db <= 1'b0;
            btn2_db <= 1'b0;
            btn3_db <= 1'b0;
            btn4_db <= 1'b0;
        end else begin
            // buttons are likely active-low on the board: invert when sampling
            btn1_sh <= {btn1_sh[6:0], ~btn_s1};
            btn2_sh <= {btn2_sh[6:0], ~btn_s2};
            btn3_sh <= {btn3_sh[6:0], ~btn_s3};
            btn4_sh <= {btn4_sh[6:0], ~btn_s4};

            // update debounced outputs only when stable
            if (btn1_sh == 8'hff) btn1_db <= 1'b1;
            else if (btn1_sh == 8'h00) btn1_db <= 1'b0;

            if (btn2_sh == 8'hff) btn2_db <= 1'b1;
            else if (btn2_sh == 8'h00) btn2_db <= 1'b0;

            if (btn3_sh == 8'hff) btn3_db <= 1'b1;
            else if (btn3_sh == 8'h00) btn3_db <= 1'b0;

            if (btn4_sh == 8'hff) btn4_db <= 1'b1;
            else if (btn4_sh == 8'h00) btn4_db <= 1'b0;
        end
    end

    initial begin
        $readmemh("rom.hex", rom);
    end
endmodule

`default_nettype wire
