`default_nettype none

module Led(
    input wire clock,
    input wire reset,
    input wire [15:0] mmio_addr,
    input wire [7:0] mmio_data,
    output wire [5:0] led
);
    reg [5:0] led_reg;
    assign led = led_reg;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            led_reg <= 6'b101010;
        end else if (mmio_addr == 16'hf000) begin
            led_reg <= mmio_data[5:0];
        end
    end
endmodule

`default_nettype wire
