/* Simple counter for testing verilator */

`default_nettype none

module counter (clk, rst, en, period, tc);

    parameter COUNTER_SIZE  = 16;

    input wire clk, rst, en;
    input wire [(COUNTER_SIZE-1):0] period;
    output reg tc;

    // Local definitions
    reg [COUNTER_SIZE-1:0] ctr;

    // Initialization
    initial ctr = 0;

    // Main loop
    always @(posedge clk) begin
        if (rst) begin
            ctr <= period;
        end else if (en) begin
            tc <= 0;
            // Decrement counter
            ctr <= ctr - 1;
            // Set tc for 1 clock cycle and reload period into the counter.
            if (ctr == 0) begin
                tc <= 1;
                ctr <= period;
            end
        end
    end     
endmodule
