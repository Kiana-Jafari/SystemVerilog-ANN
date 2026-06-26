module neuron #(
    parameter int N_INPUTS = 2,
                INPUT_WIDTH = 16,
                DATA_WIDTH = 16,
                ACC_WIDTH = 32,
                SHIFT_FACTOR = 12
) (

    input logic signed [INPUT_WIDTH-1:0] x[N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] w[N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] b,

    output logic signed [ACC_WIDTH-1:0] z
);

    always_comb begin : linear_operation
        
        z = 0;

        for (int i = 0; i < N_INPUTS; i++) begin : MAC
            
            z += (x[i] * w[i]) >>> SHIFT_FACTOR;
        
        end

        z += {{(ACC_WIDTH-DATA_WIDTH){b[DATA_WIDTH-1]}}, b};

    end
    
endmodule
