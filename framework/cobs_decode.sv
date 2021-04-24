// Outputs a decoded stream
/*  Example
    In: 0x05, 0x01, 0x02, 0x03, 0x04, 0x00
    Out: 0x01, 0x02, 0x03, 0x04

    Decoding doesn't need any lookahead.
 */
module cobs_decode #(
    localparam DW = 8
) (
    input logic clk,
    input logic rst,
    // Encoded input stream.
    input logic [DW-1:0] i_data,
    input logic i_valid,
    output logic o_ready,
    input logic i_last,
    // Decoded output stream.
    output logic [DW-1:0] o_data,
    output logic o_valid,
    input logic i_ready,
    output logic o_last
);

// 0 is IDLE. When in idle, the next byte becomes the code.
logic state = 0;
// Code representing the number of bytes until the next 0
logic [DW-1:0] code = 0, code_lock = 0;
logic code_load = 0;

// Byte should be a 0 at this point, or a new code.
localparam LAST_CODE = 1;

always @(posedge clk) begin
    o_valid <= 0;
    o_last <= 0;
    code_load <= 0;
    if (rst) begin
        state <= 0;
    end else if(i_valid) begin
        // Currently in idle. Reset code.
        if (!state) begin
            state <= 1;
            code <= i_data;
            code_lock <= i_data;
            code_load <= 0;
        end else begin
            if (code_load)
                code <= code_lock;
            else
                code <= code - 1;
            o_valid <= 1;
            o_data <= i_data;
            // Lock in new code
            if (code == LAST_CODE) begin
                code_lock <= i_data;
                code <= i_data;
                o_valid <= i_data == 0;
                o_last <= i_data == 0;
                state <= i_data != 0;
                o_data <= 0;
                code_load <= 1;
            end
        end
    end
end

endmodule
