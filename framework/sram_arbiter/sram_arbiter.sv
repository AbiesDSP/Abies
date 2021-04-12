`default_nettype none

module sram_arbiter #(
    parameter DW = 8,
    parameter AW = 19,
    parameter RD_LAT = 1
)(
    input logic clk,             //! clock
    input logic rst,             //! synchronous reset
    input logic en,              //! Chip enable
    // sram user interface. Channel 0
    input logic [AW-1:0] addra,      //! address input
    input logic [DW-1:0] data_wr,    //! data input
    output logic [DW-1:0] data_rd,   //! data output
    input logic ena,                 //! enable
    output logic busya,              //! busy
    input logic wea,                 //! write enable
    output logic valida,              //! read valid
    // sram phy interface
    output logic [AW-1:0] sram_addr,
    output logic sram_ce_n,
    output logic sram_we_n,
    output logic sram_oe_n,
    // inout wire [DW-1:0] sram_dq
    output logic [DW-1:0] sram_dq_wr, // Combine signals in top module.
    input logic [DW-1:0] sram_dq_rd
);

reg [DW-1:0] dat_o;
reg [DW-1:0] sram_wr_data;

assign sram_ce_n = !en;
assign sram_oe_n = 0; // Output always enabled.
// No arbitration yet.
assign busya = 0;
assign sram_addr = addra;
assign sram_we_n = !wea;

// assign sram_dq = !sram_we_n ? sram_wr_data : 8'hzz;

always @(posedge clk) begin
    if (rst) begin
        valida <= 0;
    end else begin
        // valida_sr <= {ena, valida_sr[latency-1:1]};
        valida <= ena; // Single cycle latency
        if (wea)
            sram_dq_wr <= data_wr;
    end
end
endmodule
