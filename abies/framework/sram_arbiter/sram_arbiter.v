`default_nettype none

module sram_arbiter #(
    parameter aw = 19,
    parameter dw = 8,
    parameter latency = 1
) (
    input wire clk,             //! clock
    input wire rst,             //! synchronous reset
    input wire en,              //! Chip enable
    // sram user interface. Channel 0
    input wire [aw-1:0] addra,      //! address input
    input wire [dw-1:0] data_wr,    //! data input
    output wire [dw-1:0] data_rd,   //! data output
    input wire ena,                 //! enable
    output wire busya,              //! busy
    input wire wea,                 //! write enable
    output reg valida,              //! read valid
    // sram phy interface
    output wire [aw-1:0] sram_addr,
    output wire sram_ce_n,
    output wire sram_oe_n,
    output wire sram_we_n,
    output reg [dw-1:0] sram_dat_wr, // Combine signals in top module.
    input wire [dw-1:0] sram_dat_rd
);
    // Latency shift register
    // reg [latency-1:0] valida_sr;
    reg [dw-1:0] dat_o;

    assign sram_ce_n = !en;
    assign sram_oe_n = 0; // Output always enabled.
    // No arbitration yet.
    assign data_rd = sram_dat_rd;
    assign busya = 0;
    assign sram_addr = addra;
    assign sram_we_n = !wea;

    always @(posedge clk) begin
        if (rst) begin
            valida <= 0;
            sram_dat_wr <= 0;
        end else begin
            // valida_sr <= {ena, valida_sr[latency-1:1]};
            valida <= ena; // Single cycle latency
            sram_dat_wr <= data_wr;
        end
    end

endmodule
