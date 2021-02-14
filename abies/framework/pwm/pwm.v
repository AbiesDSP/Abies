`default_nettype none

module pwm #(
    parameter width = 8
) (
    input wire clk,
    input wire rst,
    input wire [width-1:0] duty,
    output reg q
);

    reg [width-1:0] counter;

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
