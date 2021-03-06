`default_nettype none

//! This is a **wavedrom example**
//! {signal: [
//! { name: "clk",  wave: "p.............."},
//! { name: "rst",  wave: "1.0............"},
//! { name: "q",    wave: "0....1..0..1..0"}
//! ]}
module blinky(
    input wire clk,
    input wire rst,
    output reg q
);

parameter clk_div = 0;  //! clock divider

reg [$clog2(clk_div)-1:0] count;

always @(posedge clk) begin
    if (rst) begin
        count <= 0;
        q <= 0;
    end else begin
        count <= count + 1;
        if (count == clk_div - 1) begin
            q <= !q;
            count <= 0;
        end
    end
end
endmodule
