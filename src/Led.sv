`default_nettype none
`include "Constants.vh"

module Led(
    input wire clock,
    input wire reset,
    input wire [15:0] mmio_addr,
    input wire [7:0] mmio_data,
    input wire mmio_req,
    output wire mmio_done,
    output wire [5:0] led
);
    reg mmio_done_reg;

    reg [5:0] led_reg;
    assign led = ~led_reg;

    always @(posedge clock) begin
        if (reset) begin
            led_reg <= 6'b00000;
            mmio_done_reg <= 1'b0;
        end else begin
            mmio_done_reg <= 1'b0;
            if (mmio_req && mmio_addr == `MMIO_ADDR_LED) begin
                led_reg <= mmio_data[5:0];
                mmio_done_reg <= 1'b1;
            end
        end
    end

    assign mmio_done = mmio_done_reg;
endmodule

`default_nettype wire
