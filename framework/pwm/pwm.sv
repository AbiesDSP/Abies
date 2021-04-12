`default_nettype none

module pwm #(
    parameter DW = 8
) (
    input logic clk,
    input logic rst,
    input logic [DW-1:0] duty,
    output logic q
);

reg [DW-1:0] counter;

always @(posedge clk) begin
    if (rst) begin
        counter <= 0;
        q <= 0;
    end else begin
        counter <= counter + 1;
        q <= counter < duty;
    end
end
endmodule
