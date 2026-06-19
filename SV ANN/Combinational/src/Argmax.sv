module Argmax #(
    parameter int ACC_WIDTH = 48
) (

    input logic signed [ACC_WIDTH-1:0] o0,
    input logic signed [ACC_WIDTH-1:0] o1,
    output logic pred
);

    assign pred = (o0 >= o1) ? 0 : 1;

endmodule
