`default_nettype none

module Led(
    input wire clock,
    input wire reset,
    input wire [15:0] mmio_out_addr,
    input wire [7:0] mmio_out,
    output wire [5:0] led
);
    reg [5:0] led_reg;
    assign led = led_reg;

    always @(posedge clock) begin
        if (reset) begin
            led_reg <= 6'b101010;
        end else if (mmio_out_addr == 16'hf000) begin
            led_reg <= mmio_out[5:0];
        end
    end
endmodule

`default_nettype wire
