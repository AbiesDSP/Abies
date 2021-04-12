`default_nettype none

module abies_top (
    input logic clk,
    input logic rst,
    output logic [1:0] led,
    output logic [2:0] rgb,
    output logic [18:0] sram_addr,
    inout logic [7:0] sram_dq,
    output logic sram_ce_n,
    output logic sram_oe_n,
    output logic sram_we_n
);

logic [5:0] counter;
logic wea;
logic [19:0] addra;
logic [7:0] data_wr;
logic [7:0] data_rd;

logic [7:0] sram_dat_wr;
assign sram_dq = !sram_we_n ? sram_dat_wr : 8'bZ;

// Turn unused leds off.
assign led[1] = 0;
assign rgb[0] = 1;
assign rgb[1] = 1;
assign rgb[2] = 1;

sram_arbiter #(
    .aw(19),
    .dw(8),
    .latency(1)
) sram_arbiter (
    .clk(clk),
    .rst(rst),
    .en(1),
    .addra(addra),
    .data_wr(data_wr),
    .data_rd(data_rd),
    .ena(1),
    // .busya(busya),
    .wea(wea),
    // .valida(valida),
    .sram_addr(sram_addr),
    .sram_ce_n(sram_ce_n),
    .sram_oe_n(sram_oe_n),
    .sram_we_n(sram_we_n),
    .sram_dat_wr(sram_dat_wr),
    .sram_dat_rd(sram_dq)
);

pwm #(
    .width(8)
) pwm_0 (
    .clk(clk),
    .rst(rst),
    .duty(data_rd),
    .q(led[0])
);

// Load SRAM with ramp, then switch to read-only.
always @(posedge clk) begin
    if (rst) begin
        data_wr <= 0;
        addra <= 0;
        wea <= 1;
        counter <= 8'h7f;
    end else begin
        counter <= counter - 1;
        if (counter == 0) begin
            data_wr <= addra[18:11];
            addra <= addra + 1;
            if (addra == 524287) begin
                wea <= 0;
            end
        end
    end
end
endmodule
