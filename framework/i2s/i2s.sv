`ifndef __I2S_H__
`define __I2S_H__

interface i2s #(parameter DW = 24) (input logic clk);

    logic sclk;
    logic lrclk;
    logic sdo;
    logic sdi;

    modport clkgen(
        input clk,
        output sclk, lrclk
    );

    modport tx(
        input clk, sclk, lrclk,
        output sdo
    );

    modport rx(
        input clk, sclk, lrclk, sdi
    );

    modport bi(
        input clk, sclk, lrclk, sdi,
        output sdo
    );

endinterface

`endif
