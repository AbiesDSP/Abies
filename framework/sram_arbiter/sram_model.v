`default_nettype none

module sram_model #(
    parameter unsigned aw = 19,
    parameter unsigned dw = 8,
    parameter unsigned latency = 1,
    parameter integer model = 0
) (
    input wire clk,             //! clock
    input wire rst,             //! synchronous reset
    input wire [aw-1:0] addr,
    input wire ce_n,
    input wire oe_n,
    input wire we_n,
    inout wire [dw-1:0] dq
);
    reg [dw-1:0] mem_array [2**aw-1:0];
    reg [dw-1:0] dat_o;
    reg [dw-1:0] delay;

    // Load memory model
    initial begin
        case(model)
            0: $readmemh("../mem/inc_w8_d19.coe", mem_array);
            1: $readmemh("../mem/ramp_w8_d19.coe", mem_array);
            2: $readmemh("../mem/sin_w8_d19.coe", mem_array);
        endcase
    end
    
    assign dq = we_n ? dat_o : 8'bZ;

    always @(posedge clk) begin
        if (rst) begin
            dat_o <= 0;
            delay <= 0;
        end else begin
            if (we_n) begin
                //Read operation
                delay <= mem_array[addr];
                dat_o <= delay;
            end else begin
                // Write operation
                mem_array[addr] <= dq;
            end
        end
    end
endmodule
