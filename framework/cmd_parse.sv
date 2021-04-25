module cmd_parse #(
    parameter AW = 8,
    parameter DW = 24,
    parameter FRAME_BYTES = 5, // Module is expecting this many bytes each frame. Includes the delimiter
    localparam IW = 8
) (
    input  logic clk,
    input  logic rst,
    input  logic [IW-1:0] i_data,
    input  logic i_valid,
    output logic o_ready,
    input  logic i_last,
    // Register Write Interface
    output logic [AW-1:0] o_addr,
    output logic [DW-1:0] o_data,
    output logic o_valid

);

localparam FS = FRAME_BYTES*8;
localparam CTR_SIZE = $clog2(FRAME_BYTES);

logic [CTR_SIZE:0] in_ctr = 0;// Needs an extra bit
logic [FS-1:0] frame = 0;
logic [AW-1:0] addr_r = 0;
logic [DW-1:0] data_r = 0;
logic valid_r = 0;

assign o_ready = 1;
assign o_addr = addr_r;
assign o_data = data_r;

always @(posedge clk) begin
    o_valid <= valid_r;
    valid_r <= 0;
    if (rst) begin
        in_ctr <= 0;
    end else if (i_valid & o_ready) begin
        in_ctr <= in_ctr + 1;
        // Saturate counter.
        if (in_ctr == '1)
            in_ctr <= '1;

        frame <= {frame[FS-IW-1:0], i_data};
        // Reset on last byte.
        if (i_last) begin
            in_ctr <= 0;
            // Valid frame size
            if (in_ctr == (FRAME_BYTES-1))
                valid_r <= 1;
        end
        // If it receives too many bytes, the delimeter will never trigger
        // a valid message. It resets on the delimeter, so the next frame will be
        // valid if it is the write size.
    end
    // 
    if (valid_r) begin
        addr_r <= frame[FS-1:FS-AW];
        data_r <= frame[FS-AW-1:8];
    end
end

endmodule
