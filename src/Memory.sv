`default_nettype none

module Memory(
    input wire clock,
    input wire reset,

    input wire [15:0] data_addr,
    input wire [7:0] data_in,
    output wire [7:0] data_out,
    input wire data_write,

    input wire [15:0] inst_addr,
    output wire [15:0] inst_out
);

    wire [14:0] dpb_addr_data = data_addr[15:1];
    wire [14:0] dpb_addr_inst = inst_addr[15:1];

    reg [15:0] dpb_data_in;
    reg dpb_write_en;

    reg [15:0] dpb_data_out_data_reg;
    wire [15:0] dpb_data_out_data;
    wire [15:0] dpb_data_out_inst;

    Gowin_DPB u_dpb (
        .douta(dpb_data_out_data),
        .doutb(dpb_data_out_inst),
        .clka(clock),
        .ocea(1'b1),
        .cea(1'b1),
        .reseta(reset),
        .wrea(dpb_write_en),
        .clkb(clock),
        .oceb(1'b1),
        .ceb(1'b1),
        .resetb(reset),
        .wreb(1'b0),
        .ada(dpb_addr_data),
        .dina(dpb_data_in),
        .adb(dpb_addr_inst),
        .dinb(16'h0000)
    );

    always @(posedge clock) begin
        dpb_data_out_data_reg <= dpb_data_out_data;
    end

    always @* begin
        dpb_data_in = dpb_data_out_data_reg;
        dpb_write_en = 1'b0;
        if (data_write) begin
            dpb_write_en = 1'b1;
            if (data_addr[0] == 1'b0) begin
                dpb_data_in = {dpb_data_out_data_reg[15:8], data_in};
            end else begin
                dpb_data_in = {data_in, dpb_data_out_data_reg[7:0]};
            end
        end
    end

    assign data_out = (data_addr[0] == 1'b0) ? dpb_data_out_data[7:0] : dpb_data_out_data[15:8];
    assign inst_out = dpb_data_out_inst;

endmodule

`default_nettype wire
