`default_nettype none
// Direct Digital Synthesis. Tunable, arbitrary waveform generator.
module dds #(
    // LUT file. The table should contain one full period of the signal.
    parameter WFM_FILE = "",
    // Number of entries in the waveform table.
    parameter DEPTH = 1024,
    // Tuning word width.
    parameter TW = 8,
    // Output width
    parameter OW = 24,
    // Phase accumulator width. Must satisfy equation: 2**PW >= DEPTH. Add an extra bit when using a half-wave table. Add an extra 2 bits when using quarter-wave.
    parameter PW = 12,
    // Parameter, type of table being used. Options are: "FULL", "HALF", and "QUARTER"
    // The data in the waveform table must match this selection.
    parameter TABLE_TYPE = "QUARTER",
    // Choose between "HIGH_PERFORMANCE" or "LOW_LATENCY"
    parameter RAM_PERFORMANCE = "HIGH_PERFORMANCE"
) (
    input logic clk,
    input wire rst,
    input wire ce,
    output reg valid,
    input wire [TW-1:0] tuning_word,
    output reg [OW-1:0] ampl,
    input wire [PW-1:0] start_phase,
    // Waveform bram write port.
    input wire wfm_wea,
    input wire [$clog2(DEPTH)-1:0] wfm_waddr,
    input wire [OW-1:0] wfm_din
);
// Table address width
localparam AW = $clog2(DEPTH);
localparam PAD = PW-TW;
localparam RAM_LAT = (RAM_PERFORMANCE == "LOW_LATENCY") ? 2 : 3;
// ---------- Memories ----------
// Table stored in BRAM. Using vivado language template to infer.
reg [OW-1:0] wfm_table [0:DEPTH-1];
reg [OW-1:0] wfm_data = {OW{1'b0}};
wire [OW-1:0] wfm_out;

// ---------- Logic ----------
reg wfm_rd_en = 1'b0;
logic [AW-1:0] wfm_raddr;
reg [PW-1:0] phase_acc = {PW{1'b0}};
logic phase_valid = 1'b0;
logic addr_valid = 1'b0;
logic ram_valid = 1'b0;

// Assign read address based on wavetable format.
// Should this be pipelined? It will cost one cycle of latency.
genvar negate_index;
generate
    if (TABLE_TYPE == "FULL") begin: full_wave_table
        // No need for any pipelining address modification when using full wave table.
        assign wfm_raddr = phase_acc[PW-1:PW-AW];
        assign ampl = wfm_out;
        assign wfm_rd_en = phase_valid;
        assign valid = ram_valid;
    end else if (TABLE_TYPE == "HALF") begin: half_wave_table
        reg [RAM_LAT-1:0] negate = {RAM_LAT{1'b0}};
        always @(posedge clk) begin
            wfm_rd_en <= phase_valid;
            valid <= ram_valid;
            if (phase_valid) begin
                negate <= {negate[RAM_LAT-2:0], phase_acc[PW-1]};
                // Negative phase of wave.
                if (phase_acc[PW-1]) begin
                    wfm_raddr <= {AW{1'b1}} - phase_acc[PW-2:PW-AW-1];
                // Positive phase.
                end else begin
                    wfm_raddr <= phase_acc[PW-2:PW-AW-1];
                end
            end
            if (ram_valid) begin
                if (negate[RAM_LAT-1])
                    ampl <= -wfm_out;
                else
                    ampl <= wfm_out;
            end
        end
    end else if (TABLE_TYPE == "QUARTER") begin: quarter_wave_table
        reg [RAM_LAT-1:0] negate = {RAM_LAT{1'b0}};
        always @(posedge clk) begin
            wfm_rd_en <= phase_valid;
            valid <= ram_valid;
            if (phase_valid) begin
                negate <= {negate[RAM_LAT-2:0], phase_acc[PW-1]};
                wfm_raddr <= phase_acc[PW-2] ? ~phase_acc[PW-3:PW-AW-2] : phase_acc[PW-3:PW-AW-2];
            end
            if (ram_valid) begin
                if (negate[RAM_LAT-1])
                    ampl <= -wfm_out;
                else
                    ampl <= wfm_out;
            end
        end
    end

endgenerate

// ---------- Initialization ----------
// Waveform table can be initialized at power on for static tables.
generate
    /* verilator lint_off WIDTH */
    if (WFM_FILE != "") begin: use_init_file
        initial
            $readmemh(WFM_FILE, wfm_table, 0, DEPTH-1);
    end else begin: init_bram_to_zero
        integer ram_index;
        initial
            for (ram_index = 0; ram_index < DEPTH; ram_index = ram_index + 1)
                wfm_table[ram_index] = {OW{1'b0}};
    end
    /* verilator lint_on WIDTH */
endgenerate

always @(posedge clk) begin
    phase_valid <= ce;
end
// Handle ce/valid signals based on ram performance.
generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin
        assign wfm_out = wfm_data;

        always @(posedge clk) begin
            ram_valid <= wfm_rd_en;
        end
    end else begin
        reg [OW-1:0] wfm_oreg = {OW{1'b0}};
        reg wfm_oreg_rd_en;

        always @(posedge clk)
            if (rst)
                wfm_oreg <= {OW{1'b0}};
            else if (wfm_oreg_rd_en)
                wfm_oreg <= wfm_data;
            
        assign wfm_out = wfm_oreg;

        always @(posedge clk) begin
            wfm_oreg_rd_en <= wfm_rd_en;
            ram_valid <= wfm_oreg_rd_en;
        end
    end
endgenerate
// ---------- Waveform Table ----------
// Waveform tables can be updated at run-time.
always @(posedge clk) begin
    if (wfm_wea)
        wfm_table[wfm_waddr] <= wfm_din;
    if (wfm_rd_en)
        wfm_data <= wfm_table[wfm_raddr];
end

// Phase accumulator
always @(posedge clk) begin
    if (rst)
        phase_acc <= start_phase;
    else if (ce)
        phase_acc <= phase_acc + {{PW-TW{1'b0}},tuning_word};
end

endmodule
