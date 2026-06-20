module network #(
    parameter int N_INPUTS = 2,
                N_NEURONS = 4,
                N_OUTPUTS = 2,
                DATA_WIDTH = 16,
                ACC1_WIDTH = 32,
                ACC2_WIDTH = 48
) (
    
    input logic signed [DATA_WIDTH-1:0] x[N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] w1[N_NEURONS][N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] b1[N_NEURONS],
    
    input logic signed [DATA_WIDTH-1:0] w2[N_OUTPUTS][N_NEURONS],
    input logic signed [DATA_WIDTH-1:0] b2[N_OUTPUTS],

    output logic signed [ACC2_WIDTH-1:0] z2[N_OUTPUTS],
    output logic pred_class
);

    // initialize the layers' helper signals
    logic signed [ACC1_WIDTH-1:0] z1[N_NEURONS];
    logic signed [ACC1_WIDTH-1:0] h[N_NEURONS];

    // build the first hidden layer
    dense_layer #(
        .N_INPUTS(N_INPUTS),
        .N_NEURONS(N_NEURONS),
        .INPUT_WIDTH(DATA_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .ACC_WIDTH(ACC1_WIDTH)
        ) hidden_layer(
            .x(x),
            .w(w1),
            .b(b1),
            .z(z1)
        );

    // pass the scaled signals to ReLU
    generate
        
        for (genvar i = 0; i < N_NEURONS; i++) begin : ReLU_Activation

            ReLU #(
                .ACC_WIDTH(ACC1_WIDTH)
                ) activate(
                    .in(z1[i]),
                    .out(h[i])
            );

        end

    endgenerate

    // build the output layer using the previous layer's activations and return the logits
    dense_layer #(
        .N_INPUTS(N_NEURONS), 
        .N_NEURONS(N_OUTPUTS), 
        .INPUT_WIDTH(ACC1_WIDTH), 
        .DATA_WIDTH(DATA_WIDTH), 
        .ACC_WIDTH(ACC2_WIDTH)
        ) output_layer(
            .x(h),
            .w(w2),
            .b(b2),
            .z(z2)
    );

    // predict the class by returning the maximum logit 
    Argmax #(
        .ACC_WIDTH(ACC2_WIDTH)
        ) predict(
            .o0(z2[0]),
            .o1(z2[1]),
            .pred(pred_class)
    );

endmodule
