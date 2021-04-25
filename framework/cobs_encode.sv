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

logic [DW-1:0] code = 1;
logic [DW-1:0] code_addr = 0, wr_addr = 0, rd_addr = 0, rd_data = 0, wr_data = 0;
logic bram_we = 0, bram_rd_en = 0;
logic [DW-1:0] bram [256];
logic add_code = 0, append = 0;
logic busy = 0, output_en = 0;

assign o_ready = !busy;
assign o_data = rd_data;

always @(posedge clk) begin
    bram_we <= 0;
    bram_rd_en <= 0;
    add_code <= 0;
    append <= 0;
    o_last <= 0;
    o_valid <= output_en;

    if (rst) begin
        wr_addr <= 0;
        rd_addr <= 0;
        code_addr <= 0;
        code <= 1;
        busy <= 0;
    end else if (i_valid & o_ready) begin
        // Start writing at addr 1. addr 0 is the length code.
        bram_we <= 1;
        wr_addr <= wr_addr + 1;
        wr_data <= i_data;
        code <= code + 1;
        if (i_last) begin
            busy <= 1;
            add_code <= 1;
            code_addr <= wr_addr + 2;
        end
    end
    
    // Add the code at the beginning.
    if (add_code) begin
        append <= 1;
        bram_we <= 1;
        wr_addr <= 0;
        wr_data <= code;
        // output_en <= 1;
        // bram_rd_en <= 1;
    end

    // Add zero at the end
    if (append) begin
        bram_we <= 1;
        wr_addr <= code_addr;
        wr_data <= 0;
        bram_rd_en <= 1;
        rd_addr <= 0;
        output_en <= 1;
    end

    // Drive outputs
    if (o_valid & i_ready) begin
        bram_rd_en <= 1;
        rd_addr <= rd_addr + 1;
        if (rd_addr == code) begin
            output_en <= 0;
        end
    end
end

always @(posedge clk) begin
    if (bram_we)
        bram[wr_addr] <= wr_data;
    // if (bram_rd_en)
    rd_data <= bram[rd_addr];
end

endmodule
