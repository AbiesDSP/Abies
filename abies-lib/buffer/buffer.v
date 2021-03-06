`default_nettype none

/* clk: 100MHz bus clock
 * rst: synchronous reset.
 * en: Enable signal. sample_i is valid when this goes high. Connect the sample clock to 'en' of the first module in the chain.
 * valid: sample_o is valid when this signal goes high. The next stage in the pipeline can start.
 * ready: ready must be high when en goes high. necessary for more complex pipelining. Not used for now.
 * sample_i: input sample
 * sample_o: output sample
 *
 * Register outputs. Inputs don't need to be registered.
 */
module buffer(
    input wire clk,
    input wire rst,
    input wire en,
    output reg valid,
    output reg ready,
    input wire [31:0] sample_i,
    output reg [31:0] sample_o
);
// Introduced delay to demonstrate pipeline signals
parameter DELAY = 8;

// Shift register to implement delay
reg [31:0] sample_shift [0:DELAY-1];
reg valid_shift [0:DELAY-1];
integer i;

initial valid = 0;
initial ready = 0;
// Always initialize/reset output to 0.
initial sample_o = 0;

always @(posedge clk) begin
    if (rst) begin
        sample_o <= 0;
        valid <= 0;
        ready <= 0;
    end else begin
        ready <= 1;
        valid_shift[0] <= en;
        sample_shift[0] <= sample_i;
        for (i = 1; i < DELAY; i++) begin
            sample_shift[i] <= sample_shift[i-1];
            valid_shift[i] <= valid_shift[i-1];
        end
        sample_o <= sample_shift[DELAY-1];
        valid <= valid_shift[DELAY-1];
    end
end
endmodule
