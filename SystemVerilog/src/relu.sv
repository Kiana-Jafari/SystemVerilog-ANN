// a simple ReLU gate which is going to be used as the hidden layer's activation function
module relu(
    input logic signed [15:0] in,
    output logic signed [15:0] out
);

assign out = (in < 0) ? 0 : in;

endmodule