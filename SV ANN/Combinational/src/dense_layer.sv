module dense_layer #(
    parameter int N_INPUTS = 2, 
                N_NEURONS = 4,
                INPUT_WIDTH = 16,
                DATA_WIDTH = 16,
                ACC_WIDTH = 32
) (
    input logic signed [INPUT_WIDTH-1:0] x[N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] w[N_NEURONS][N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] b[N_NEURONS],

    output logic signed [ACC_WIDTH-1:0] z[N_NEURONS]
);

    // instantiate the `neuron` module N times, 
    // where N is the number of neurons in the dense layer
    generate
        
        for (genvar i = 0; i < N_NEURONS; i++) begin : Neurons

            neuron #(
                .N_INPUTS(N_INPUTS),
                .INPUT_WIDTH(INPUT_WIDTH),
                .DATA_WIDTH(DATA_WIDTH),
                .ACC_WIDTH(ACC_WIDTH)
                ) inst(
                    .x(x),
                    .w(w[i]),
                    .b(b[i]),
                    .z(z[i])
                );

        end

    endgenerate
    
endmodule
