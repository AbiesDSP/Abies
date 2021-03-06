`default_nettype none

// Wrapper with memory model
module sram_arbiter_tb(
    input wire clk,
    input wire rst,
    input wire en,
    // sram user interface. Channel 0
    input wire [aw-1:0] addra,      //! address input
    input wire [dw-1:0] data_wr,    //! data input
    output wire [dw-1:0] data_rd,   //! data output
    input wire ena,                 //! enable
    output reg busya,               //! busy
    input wire wea,                 //! write enable
    output reg valida               //! read vali
);

parameter unsigned aw = 19;
parameter unsigned dw = 8;
parameter unsigned latency = 1;
parameter sram_init = ""; // Select from memory initialization options

wire [aw-1:0] sram_addr;
wire [dw-1:0] sram_dat_wr;

wire sram_ce_n;
wire sram_oe_n;
wire sram_we_n;
wire [dw-1:0] sram_dq;

assign sram_dq = !sram_we_n ? sram_dat_wr : 8'bZ;

sram_arbiter #(
    .aw(19),
    .dw(8),
    .latency(1)
) sram_arbiter (
    .clk(clk),
    .rst(rst),
    .en(en),
    .addra(addra),
    .data_wr(data_wr),
    .data_rd(data_rd),
    .ena(ena),
    .busya(busya),
    .wea(wea),
    .valida(valida),
    .sram_addr(sram_addr),
    .sram_ce_n(sram_ce_n),
    .sram_oe_n(sram_oe_n),
    .sram_we_n(sram_we_n),
    .sram_dat_wr(sram_dat_wr),
    .sram_dat_rd(sram_dq)
);

sram_model #(
    .width(8),
    .depth(19),
    .latency(1),
    .sram_init(sram_init)
) sram_model (
    .clk(clk),
    .rst(rst),
    .addr(sram_addr),
    .ce_n(sram_ce_n),
    .oe_n(sram_oe_n),
    .we_n(sram_we_n),
    .dq(sram_dq)
);
endmodule
