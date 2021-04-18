`timescale 1ns/1ps

module i2s_clk #(
    // Serial Data Width. This will not pad any data.
    parameter DW = 24,
    // Sampling frequency ratio MCLK/LRCLK. 12.288MHz / 256 = 48kHz. 128: 96kHz
    parameter FS_RATIO = 256,
    parameter PRE_FETCH = 3,
    localparam LR_CTR_SIZE = $clog2(FS_RATIO),
    localparam SCLK_DIV = FS_RATIO / (4*(DW+1)),
    localparam SCLK_CTR_SIZE = $clog2(SCLK_DIV),
    localparam RD_EN_CMP = (FS_RATIO/2) - PRE_FETCH
) (
    input logic clk,
    input logic rst,
    output logic rd_early,
    // I2S Clock
    output logic sclk,
    output logic lrclk
);

/* verilator lint_off WIDTH */
logic [7:0] sclk_ctr = 0;
logic [7:0] lr_ctr = 0;

initial sclk = 0;
initial lrclk = 1;

always @(posedge clk) begin
    rd_early <= 0;
    if (rst) begin
        sclk_ctr <= 0;
        sclk <= 0;
        lr_ctr <= 0;
        lrclk <= 1;

    end else begin
        sclk_ctr <= sclk_ctr + 1;
        lr_ctr <= lr_ctr + 1;
        
        if (sclk_ctr == (SCLK_DIV - 1)) begin
            sclk_ctr <= 0;
            sclk <= !sclk;
        end
        // when lrclk toggles
        if (lr_ctr[6:0] == '1) begin
            sclk_ctr <= 0;
            sclk <= 0;
            lrclk <= !lrclk;
        end
        if (lr_ctr == RD_EN_CMP) begin
            rd_early <= 1;
        end
    end
end

endmodule
