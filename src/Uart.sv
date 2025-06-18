`default_nettype none

module Uart
#(
    parameter DELAY_FRAMES = 234, // 27,000,000 hz / 115200 baud rate
    parameter INITIAL_CHAR = 8'h41 // Default: 'A' (ASCII 0x41)
)
(
    input wire clock,
    input wire reset,
    input wire [15:0] mmio_addr,
    input wire [7:0] mmio_data,
    input wire mmio_update,
    output wire tx
);
    localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

    typedef enum {
        TX_STATE_IDLE = 0,
        TX_STATE_START_BIT = 1,
        TX_STATE_WRITE = 2,
        TX_STATE_STOP_BIT = 3
    } TX_STATE;

    TX_STATE tx_state = TX_STATE_IDLE;
    reg [24:0] tx_cnt = 0;
    reg [7:0] data_out = 0;
    reg mmio_update_old = 0;
    reg tx_pin_reg = 1;
    reg [2:0] tx_bit_num = 0;

    reg sent_initial_char = 0;

    assign tx = tx_pin_reg;

    // tx
    always @(posedge clock or posedge reset) begin
        if (reset) begin
            tx_state <= TX_STATE_IDLE;
            tx_cnt <= 0;
            data_out <= 0;
            mmio_update_old <= 0;
            tx_pin_reg <= 1;
            tx_bit_num <= 0;
            sent_initial_char <= 0; // Clear flag on reset
        end else begin
            case (tx_state)
                TX_STATE_IDLE: begin
                    // If not sent initial char yet, start sending it
                    if (!sent_initial_char) begin
                        tx_state <= TX_STATE_START_BIT;
                        data_out <= INITIAL_CHAR; // Use parameter for the initial character
                        tx_cnt <= 0;
                        tx_pin_reg <= 0; // Start bit is low
                        tx_bit_num <= 0;
                        sent_initial_char <= 1; // Mark as sent
                    end else if (mmio_update_old != mmio_update && mmio_addr == 16'hf001) begin
                        // If initial char sent, check for MMIO update
                        tx_state <= TX_STATE_START_BIT;
                        data_out <= mmio_data;
                        tx_cnt <= 0;
                        mmio_update_old <= mmio_update;
                        tx_pin_reg <= 0; // Start bit is low
                    end else begin
                        tx_pin_reg <= 1;
                    end
                end
                TX_STATE_START_BIT: begin
                    // tx_pin_reg is already 0 from previous state or initial send logic
                    if ((tx_cnt + 1) == DELAY_FRAMES) begin
                        tx_state <= TX_STATE_WRITE;
                        tx_bit_num <= 0;
                        tx_cnt <= 0;
                    end else begin
                        tx_cnt <= tx_cnt + 1;
                    end
                end
                TX_STATE_WRITE: begin
                    tx_pin_reg <= data_out[tx_bit_num];
                    if ((tx_cnt + 1) == DELAY_FRAMES) begin
                        if (tx_bit_num == 7) begin
                            tx_state <= TX_STATE_STOP_BIT;
                        end else begin
                            tx_state <= tx_state; // Stay in WRITE state
                            tx_bit_num <= tx_bit_num + 1;
                        end
                        tx_cnt <= 0;
                    end else begin
                        tx_cnt <= tx_cnt + 1;
                    end
                end
                TX_STATE_STOP_BIT: begin
                    tx_pin_reg <= 1;
                    if ((tx_cnt + 1) == DELAY_FRAMES) begin
                        tx_state <= TX_STATE_IDLE;
                    end else begin
                        tx_cnt <= tx_cnt + 1;
                    end
                end
            endcase
            // Update mmio_update_old at the end of the clock cycle, outside the case
            mmio_update_old <= mmio_update;
        end
    end

endmodule

`default_nettype wire
