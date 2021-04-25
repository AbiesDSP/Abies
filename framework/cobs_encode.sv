// Input: 0x01, 0x02, 0x03, 0x04
// Output: 0x05, 0x01, 0x02, 0x03, 0x04, 0x00
// 
module cobs_encode #(
    // Maximum number of bytes to encode.
    localparam DW = 8
) (
    input  logic clk,
    input  logic rst,
    input  logic [DW-1:0] i_data,
    input  logic i_valid,
    output logic o_ready,
    input  logic i_last,
    output logic [DW-1:0] o_data,
    output logic o_valid,
    input  logic i_ready,
    output logic o_last
);

localparam LAST_CODE = 8'hfe;

logic [DW-1:0] code = 1;
logic [DW-1:0] code_addr = 0, wr_addr = 0, wr_next = 1, rd_addr = 0, rd_data = 0, wr_data = 0;
logic bram_we = 0, bram_rd_en = 0;
logic [DW-1:0] bram [256];
logic add_code = 0, append = 0, last_r = 0;
logic busy = 0, output_en = 0;
logic valid_r = 0;
assign o_ready = !busy;
assign o_data = rd_data;
// assign o_valid = output_en;

always @(posedge clk) begin
    bram_we <= 0;
    bram_rd_en <= 0;
    add_code <= 0;
    append <= 0;
    o_last <= 0;
    busy <= 0;
    last_r <= 0;
    o_valid <= output_en;
    // o_valid <= valid_r;

    if (rst) begin
        wr_addr <= 0;
        wr_next <= 1;
        rd_addr <= 0;
        code_addr <= 0;
        code <= 1;
    end else if (i_valid & o_ready) begin
        // Start writing at addr 1. addr 0 is the length code.
        bram_we <= 1;
        last_r <= i_last;
        // Encode delimeter
        if (i_data == 0) begin
            wr_addr <= code_addr;
            wr_data <= code;
            code_addr <= wr_next;
            code <= 1;
            wr_next <= wr_next + 1;
        end else begin
            code <= code + 1;
            wr_next <= wr_next + 1;
            wr_addr <= wr_next;
            wr_data <= i_data;
        end
    end
    
    if (last_r) begin
        bram_we <= 1;
        wr_addr <= code_addr;
        wr_data <= code;
        append <= 1;
        // output_en <= 1;
    end
    // Add the code at the beginning.
    // if (add_code | last_r) begin
    //     bram_we <= 1;
    //     wr_addr <= code_addr;
    //     wr_data <= code;
    //     code_addr <= wr_next;
    //     code <= 1;
    //     append <= last_r;
    //     if (!last_r)
    //         wr_next <= wr_next + 2;
    //     else
    //         wr_next <= wr_next + 1;
    // end

    // Add zero at the end
    if (append) begin
        bram_we <= 1;
        wr_addr <= wr_next;
        wr_data <= 0;
        bram_rd_en <= 1;
        rd_addr <= 0;
        output_en <= 1;
    end
    if (output_en) begin
        bram_rd_en <= 1;
    end
    // Drive outputs
    if (o_valid & i_ready) begin
        rd_addr <= rd_addr + 1;
        if (rd_addr == wr_addr) begin
            output_en <= 0;
            o_last <= 1;
        end
    end
end

always @(posedge clk) begin
    if (bram_we)
        bram[wr_addr] <= wr_data;
    if (bram_rd_en) begin
        rd_data <= bram[rd_addr];
    end
end

endmodule
