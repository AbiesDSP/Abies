`default_nettype none

module sram_model #(
    
) (
    input wire clk,             //! clock
    input wire rst,             //! synchronous reset
    input wire [depth-1:0] addr,
    input wire ce_n,
    input wire oe_n,
    input wire we_n,
    inout wire [width-1:0] dq
);

parameter unsigned width = 8;
parameter unsigned depth = 19;
parameter unsigned latency = 1;
parameter sram_init = "";

reg [width-1:0] mem_array [2**depth-1:0];
reg [width-1:0] dat_o;
reg [width-1:0] delay;

// Load memory model
/* verilator lint_off WIDTH */
generate
    if (sram_init != "") begin: use_init_file
        initial
            $readmemh(sram_init, mem_array, 0, 2**depth-1);
    end else begin: init_ram_to_zero
        integer ram_index;
        initial
            for (ram_index = 0; ram_index < 2**depth-1; ram_index = ram_index + 1)
                mem_array[ram_index] = {width{1'b0}};
    end
endgenerate
/* verilator lint_on WIDTH */

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
