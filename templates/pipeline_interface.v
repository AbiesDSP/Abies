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
module example(clk, rst, en, valid, ready, sample_i, sample_o);
    // Required interface
    input wire clk, rst, sclk;
    output reg valid, ready;
    input wire [31:0] sample_i;
    output reg [31:0] sample_o;

    initial valid = 0;
    initial ready = 0;
    // Always initialize/reset output to 0.
    initial sample_o = 0;

    always @(posedge clk) begin
        if (rst) begin
            if (en) begin
                // New sample. Do stuff. Need more details.
            end
        end
    end 