// a simple simulation of a sequential MAC (multiply accumulator) gate used in neural networks
module mac_seq(
    input logic clk,
    input logic reset,
    input logic signed [3:0] X,
    input logic signed [3:0] w,
    output logic signed [7:0] acc
);

// combinational multiplier-term

logic signed [7:0] product;
assign product = X * w;

// sequential register (memory)

always_ff @(posedge clk) begin : MAC
    
    if (reset)
        acc <= 0;
    else
        acc <= acc + product;

end

endmodule