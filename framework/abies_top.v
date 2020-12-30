`default_nettype none

module abies_top (
    input wire clk,
    input wire rst,
    output wire [1:0] led,
    output wire [2:0] rgb,
    output wire [18:0] sram_addr,
    inout wire [7:0] sram_dq,
    output wire sram_ce_n,
    output wire sram_oe_n,
    output wire sram_we_n
);
    reg [5:0] counter;
    reg wea;
    reg [19:0] addra;
    reg [7:0] data_wr;
    wire [7:0] data_rd;

    wire [7:0] sram_dat_wr;
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
