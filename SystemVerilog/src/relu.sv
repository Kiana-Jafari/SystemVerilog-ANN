// a simple ReLU gate which is going to be used as the hidden layer's activation function
module relu(
    input logic signed [7:0] in,
    output logic signed [7:0] out
);

assign out = (in < 0) ? 0 : in;

endmodule