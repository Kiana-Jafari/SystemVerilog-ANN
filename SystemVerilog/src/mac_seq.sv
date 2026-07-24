// a simple simulation of a sequential MAC (multiply accumulator) gate used in neural networks
module mac_seq(
    input logic clk,
    input logic reset,
    input logic signed [3:0] X,
    input logic signed [3:0] w,
    output logic signed [16:0] acc
);

// sequential register (memory)

always_ff @(posedge clk) begin : MAC
    
    if (reset)
        acc <= 0;
    else
        acc <= acc + (X * w);

end

endmodule