`default_nettype none

module ${module_name} (
    input wire clk,
    input wire rst,
    input wire stb,
    output reg valid,
    input wire [DW-1:0] u,
    output reg [DW-1:0] y
);

parameter DW = 24;

always @(posedge clk)
    if (rst) begin
        valid <= 0;
        y <= 0;
    end else begin
        valid <= 0;
        if (stb) begin
            valid <= 1;
            y <= u;
        end
    end

endmodule
