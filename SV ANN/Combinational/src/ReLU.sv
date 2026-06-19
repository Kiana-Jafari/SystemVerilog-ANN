module ReLU #(
    parameter int ACC_WIDTH = 32
) (

    input logic signed [ACC_WIDTH-1:0] in,
    output logic signed [ACC_WIDTH-1:0] out
);

    assign out = (in < 0) ? 0 : in;

endmodule
