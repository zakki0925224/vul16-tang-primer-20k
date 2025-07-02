`default_nettype none

module Memory(
    input wire clock,
    input wire reset,

    input wire [15:0] data_addr,
    input wire [7:0] data_in,
    output wire [7:0] data_out,
    input wire data_write,
    input wire data_req, // access request
    output wire data_done,

    input wire [15:0] inst_addr,
    output wire [15:0] inst_out,
    input wire inst_req,
    output wire inst_done
);

    wire [14:0] dpb_addr_data = data_addr[15:1];
    wire [14:0] dpb_addr_inst = inst_addr[15:1];

    reg [15:0] dpb_data_in;
    reg dpb_write_en;

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

    reg [1:0] data_state;
    reg [1:0] inst_state;

    reg data_busy;
    reg inst_busy;

    always @(posedge clock) begin
        if (reset) begin
            dpb_write_en <= 1'b0;
            data_state <= 2'b00;
            inst_state <= 2'b00;
        end else begin
            case (data_state)
                2'b00: begin // idle
                    if (data_req) begin
                        data_state <= 2'b01;
                        if (data_write && data_addr < 16'h8000) begin
                            dpb_write_en <= 1'b1;
                            if (data_addr[0] == 1'b0) begin
                                dpb_data_in <= {dpb_data_out_data[15:8], data_in};
                            end else begin
                                dpb_data_in <= {data_in, dpb_data_out_data[7:0]};
                            end
                        end else begin
                            dpb_write_en <= 1'b0;
                        end
                    end else begin
                        dpb_write_en <= 1'b0;
                    end
                end
                2'b01: begin // wait1
                    data_state <= 2'b10;
                    dpb_write_en <= 1'b0;
                end
                2'b10: begin // done
                    if (!data_req) data_state <= 2'b00;
                end
            endcase

            case (inst_state)
                2'b00: begin
                    if (inst_req) inst_state <= 2'b01;
                end
                2'b01: inst_state <= 2'b10;
                2'b10: begin
                    if (!inst_req) inst_state <= 2'b00;
                end
            endcase
        end
    end

    assign data_done = (data_state == 2'b10);
    assign inst_done = (inst_state == 2'b10);
    assign data_out = (data_addr[0] == 1'b0) ? dpb_data_out_data[7:0] : dpb_data_out_data[15:8];
    assign inst_out = dpb_data_out_inst;

endmodule

`default_nettype wire
