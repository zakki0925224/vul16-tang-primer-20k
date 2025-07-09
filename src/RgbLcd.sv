`default_nettype none
`include "Constants.vh"

// 480x272, 9MHz
module RgbLcdInner
#(
    parameter H_ACTIVE = 16'd480,
    parameter H_FP = 16'd2,
    parameter H_SYNC = 16'd41,
    parameter H_BP = 16'd2,

    parameter V_ACTIVE = 16'd272,
    parameter V_FP  = 16'd2,
    parameter V_SYNC  = 16'd10,
    parameter V_BP  = 16'd2,

    parameter HS_POL = 1'b0,
    parameter VS_POL = 1'b0,

    parameter H_TOTAL = H_ACTIVE + H_FP + H_SYNC + H_BP, // horizontal pixels
    parameter V_TOTAL = V_ACTIVE + V_FP + V_SYNC + V_BP  // vertical pixels
)
(
    input wire clock,
    input wire reset,

    output wire dclk,        // display clock
    output wire de,          // data enable
    output wire hs,          // horizontal sync
    output wire vs,          // vertical sync
    output wire[9:0] h_pos,  // current horizontal position
    output wire[9:0] v_pos   // current vertical position
);
    reg[11:0] h_cnt;
    reg[11:0] v_cnt;

    reg hs_reg;
    reg vs_reg;

    reg he_reg;
    reg ve_reg;

    reg[9:0] h_pos_reg;
    reg[9:0] v_pos_reg;

    assign hs = hs_reg;
    assign vs = vs_reg;
    assign de = he_reg & ve_reg;
    assign h_pos = h_pos_reg;
    assign v_pos = v_pos_reg;

    // 27MHz to 9 MHz
    Gowin_rPLL pll(
        .clkin(clock),
        .clkout(dclk)
    );

    // h_cnt
    always @(posedge dclk or posedge reset) begin
        if (reset)
            h_cnt <= 0;

        else if ((h_cnt + 1) == H_TOTAL)
            h_cnt <= 0;

        else
            h_cnt <= h_cnt + 1;
    end

    // v_cnt
    always @(posedge dclk or posedge reset) begin
        if (reset)
            v_cnt <= 0;

        else if ((h_cnt + 1) == H_FP) begin
            if ((v_cnt + 1) == V_TOTAL)
                v_cnt <= 0;

            else
                v_cnt <= v_cnt + 1;
        end
        else
            v_cnt <= v_cnt;
    end

    // hs
    always @(posedge dclk or posedge reset) begin
        if (reset)
            hs_reg <= 0;

        else if ((h_cnt + 1) == H_FP)
            hs_reg <= HS_POL;

        else if ((h_cnt + 1) == H_FP + H_SYNC)
            hs_reg <= ~hs_reg;

        else
            hs_reg <= hs_reg;
    end

    // vs
    always @(posedge dclk or posedge reset) begin
        if (reset)
            vs_reg <= 0;

        else if (((v_cnt + 1) == V_FP) && ((h_cnt + 1) == H_FP))
            vs_reg <= VS_POL;

        else if (((v_cnt + 1) == V_FP + V_SYNC) && ((h_cnt + 1) == H_FP))
            vs_reg <= ~vs_reg;

        else
            vs_reg <= vs_reg;
    end

    // he
    always @(posedge dclk or posedge reset) begin
        if (reset)
            he_reg <= 0;

        else if ((h_cnt + 1) == H_FP + H_SYNC + H_BP)
            he_reg <= 1;

        else if ((h_cnt + 1) == H_TOTAL)
            he_reg <= 0;

        else
            he_reg <= he_reg;
    end

    // ve
    always @(posedge dclk or posedge reset) begin
        if (reset)
            ve_reg <= 0;

        else if (((v_cnt + 1) == V_FP + V_SYNC + V_BP) && ((h_cnt + 1) == H_FP))
            ve_reg <= 1;

        else if (((v_cnt + 1) == V_TOTAL) && ((h_cnt + 1) == H_FP))
            ve_reg <= 0;

        else
            ve_reg <= ve_reg;

    end

    // h_pos
    always @(posedge dclk) begin
        if ((h_cnt + 1) >= H_FP + H_SYNC + H_BP)
            h_pos_reg <= (h_cnt - 1) - (H_FP[11:0] + H_SYNC[11:0] + H_BP[11:0]);

        else
            h_pos_reg <= h_pos_reg;
    end

    // v_pos
    always @(posedge dclk) begin
        if ((v_cnt + 1) >= V_FP + V_SYNC + V_BP)
            v_pos_reg <= (v_cnt - 1) - (V_FP[11:0] + V_SYNC[11:0] + V_BP[11:0]);
        else
            v_pos_reg <= v_pos_reg;
    end
endmodule

module RgbLcd #(
    parameter LCD_HEIGHT = 272,
    parameter LCD_WIDTH = 480,
    parameter LCD_TEXT_HEIGHT = 16,
    parameter LCD_TEXT_WIDTH = 8
)(
    input wire clock,
    input wire reset,
    input wire [15:0] mmio_addr,
    input wire [7:0] mmio_data,
    input wire mmio_req,
    output wire mmio_done,

    output wire dclk,
    output wire de,
    output wire hs,
    output wire vs,
    output wire[4:0] r,
    output wire[5:0] g,
    output wire[4:0] b
);
    reg mmio_done_reg;

    // text vram
    reg [15:0] lcd_text_vram[0:((LCD_HEIGHT / LCD_TEXT_HEIGHT) * (LCD_WIDTH / LCD_TEXT_WIDTH)) - 1];
    wire [9:0] lcd_text_vram_pos;
    wire [15:0] lcd_text_vram_data;
    wire [3:0] fg_color_code, bg_color_code;
    wire [7:0] ascii_code;
    wire [9:0] lcd_x, lcd_y;

    // mmio write
    always @(posedge clock) begin
        if (reset) begin
            mmio_done_reg <= 1'b0;
        end else begin
            mmio_done_reg <= 1'b0;
            if (mmio_req && mmio_addr >= `MMIO_ADDR_LCD && mmio_addr < `MMIO_ADDR_LCD + ((LCD_HEIGHT / LCD_TEXT_HEIGHT) * (LCD_WIDTH / LCD_TEXT_WIDTH)) * 2) begin
                integer vram_index;
                vram_index = (mmio_addr - `MMIO_ADDR_LCD) >> 1;
                if ((mmio_addr & 1'b1) == 1'b0) begin
                    // low byte (ascii code)
                    lcd_text_vram[vram_index][7:0] <= mmio_data;
                end else begin
                    // high byte (bg/fg color code)
                    lcd_text_vram[vram_index][15:8] <= mmio_data;
                end
                mmio_done_reg <= 1'b1;
            end
        end
    end

    assign mmio_done = mmio_done_reg;

    assign lcd_text_vram_pos = ((LCD_WIDTH / LCD_TEXT_WIDTH) * (lcd_y / LCD_TEXT_HEIGHT)) + (lcd_x / LCD_TEXT_WIDTH);
    assign lcd_text_vram_data = lcd_text_vram[lcd_text_vram_pos];
    assign bg_color_code = lcd_text_vram_data[15:12];
    assign fg_color_code = lcd_text_vram_data[11:8];
    assign ascii_code    = lcd_text_vram_data[7:0];

    // font
    wire [15:0] ascii_font_data;
    wire [10:0] ascii_font_data_index;
    assign ascii_font_data_index = (ascii_code * LCD_TEXT_WIDTH) + (LCD_TEXT_WIDTH - (lcd_x % LCD_TEXT_WIDTH) - 1);

    AsciiFont ascii_font(
        .ascii_font_index(ascii_font_data_index),
        .out(ascii_font_data)
    );

    function [15:0] color_code_to_rgb(input [3:0] code);
        case (code)
            4'h0: color_code_to_rgb = 16'h0000; // black
            4'h1: color_code_to_rgb = 16'h0014; // blue
            4'h2: color_code_to_rgb = 16'h0540; // green
            4'h3: color_code_to_rgb = 16'h0554; // cyan
            4'h4: color_code_to_rgb = 16'ha000; // red
            4'h5: color_code_to_rgb = 16'ha014; // magenta
            4'h6: color_code_to_rgb = 16'ha2a0; // brown
            4'h7: color_code_to_rgb = 16'ha554; // light gray
            4'h8: color_code_to_rgb = 16'h52aa; // dark gray
            4'h9: color_code_to_rgb = 16'h52b0; // light blue
            4'ha: color_code_to_rgb = 16'h57ea; // light green
            4'hb: color_code_to_rgb = 16'h57ff; // light cyan
            4'hc: color_code_to_rgb = 16'hfaaa; // light red
            4'hd: color_code_to_rgb = 16'hfabf; // light magenta
            4'he: color_code_to_rgb = 16'hffe0; // yellow
            4'hf: color_code_to_rgb = 16'hffff; // white
            default: color_code_to_rgb = 16'h0000;
        endcase
    endfunction

    wire [15:0] lcd_fg_rgb = color_code_to_rgb(fg_color_code);
    wire [15:0] lcd_bg_rgb = color_code_to_rgb(bg_color_code);
    wire [15:0] lcd_rgb_data = ((ascii_font_data >> (lcd_y % LCD_TEXT_HEIGHT)) & 16'h1) ? lcd_fg_rgb : lcd_bg_rgb;

    assign r = lcd_rgb_data[15:11];
    assign g = lcd_rgb_data[10:5];
    assign b = lcd_rgb_data[4:0];

    RgbLcdInner lcd(
        .clock(clock),
        .reset(reset),
        .dclk(dclk),
        .de(de),
        .hs(hs),
        .vs(vs),
        .h_pos(lcd_x),
        .v_pos(lcd_y)
    );
endmodule

`default_nettype wire
