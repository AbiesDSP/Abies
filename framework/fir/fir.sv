// Fir using a single multiply and bram for sample/coef storage.
`default_nettype none

module fir #(
    parameter N_TAPS = 21,
    parameter IDW = $clog2(21), // $clog2(N_TAPS)
    localparam MAX_ADDR = N_TAPS - 1,
    parameter TW = 16,
    parameter DW = 16,
    localparam PW = TW + DW,
    localparam OW = TW + DW + IDW,
    parameter COEF_FILE = ""
) (
    input logic clk,
    input logic rst,
    input logic ce,
    output logic busy,
    output logic valid,
    input logic [DW-1:0] samp_i,
    output logic [DW-1:0] scaled_o,
    output logic [OW-1:0] samp_o
);

// Coefficient memory
logic [TW-1:0] coef_ram [0:N_TAPS-1];
logic [IDW-1:0] coef_rd_addr;
logic signed [TW-1:0] tap;

// Sample memory
logic [DW-1:0] samp_ram [0:N_TAPS-1];
logic [IDW-1:0] samp_rd_addr, samp_wr_addr;
logic signed [DW-1:0] samp;

logic bram_read_en;
logic last_addr;

// Control signals
logic [IDW-1:0] count;
logic count_en;
logic signed [PW-1:0] product;
logic signed [OW-1:0] accum;
logic signed [OW-1:0] accum_out; // Shift?
logic accum_en;
logic accum_rst;

// Populate coefficients from memory file.
generate
    /* verilator lint_off WIDTH */
    if (COEF_FILE != "") begin: use_init_file
        initial
            $readmemh(COEF_FILE, coef_ram);
    end else begin: init_ram_to_zero
        integer ram_index;
        initial
            for (ram_index = 0; ram_index < N_TAPS; ram_index = ram_index + 1)
                coef_ram[ram_index] = {TW{1'b0}};
    end
    /* verilator lint_on WIDTH */
endgenerate

// Initialize ram to 0.
integer ii;
initial begin
    for (ii=0; ii<N_TAPS; ii=ii+1)
        samp_ram[ii] = 0;
end

// Truncate?
assign scaled_o = accum_out[OW-1:TW+IDW];
assign samp_o = accum_out;

// Accumuklator valid signal pipeline
logic [2:0] av;
logic last_tap;

logic [2:0] in_pipe;
assign last_tap = coef_rd_addr == MAX_ADDR;

assign accum_rst = in_pipe[2];

// Output valid logic.
always @(posedge clk) begin
    valid <= 0;
    if (av[2]) begin
        valid <= 1;
        accum_out <= accum;
    end
end

always @(posedge clk) begin
    if (rst) begin
        samp_rd_addr <= 0;
        coef_rd_addr <= 0;
        bram_read_en <= 0;
        accum_en <= 0;
        av <= 0;
        in_pipe <= 0;
    end else begin
        av <= {av[1:0], last_tap};
        in_pipe <= {in_pipe[1:0], ce};

        if (av[2] && in_pipe != 0)
            accum_en <= 0;
        if (ce) begin
            samp_rd_addr <= samp_wr_addr;
            coef_rd_addr <= 0;
            bram_read_en <= 1;
        end else begin
            if (in_pipe[2]) begin
                accum_en <= 1;
            end
            if (last_tap) begin
                bram_read_en <= 0;
            end
            if (bram_read_en) begin
                samp_rd_addr <= samp_rd_addr - 1;
                if (samp_rd_addr == 0)
                    samp_rd_addr <= MAX_ADDR;
                coef_rd_addr <= coef_rd_addr + 1;
            end
        end
    end
end

// Tap coefficient BRAM.
initial tap = 0;
always @(posedge clk) begin
    tap <= coef_ram[coef_rd_addr];
end

// Write on incoming ce. Increment write address as a sort of 'circular buffer'
// Need to set a 'busy' signal or something.
initial samp_wr_addr = 0;
always @(posedge clk) begin
    if (ce) begin
        samp_wr_addr <= samp_wr_addr + 1;
        if (samp_wr_addr == MAX_ADDR) begin
            samp_wr_addr <= 0;
        end
    end
end

// Sample BRAM.
initial samp = 0;
always @(posedge clk) begin
    if (ce) begin
        samp_ram[samp_wr_addr] <= samp_i;
    end
    samp <= samp_ram[samp_rd_addr];
end

// Multiplier
always @(posedge clk)
    product <= tap * samp;

// Accumulator
always @(posedge clk)
    if (accum_rst) begin
        /* verilator lint_off WIDTH */
        accum <= product;
    end else begin
        if (accum_en) begin
            accum <= accum + product;
        end
        /* verilator lint_on WIDTH */ 
    end

endmodule
