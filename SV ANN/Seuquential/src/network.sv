import decision_functions::*;

module network #(
    parameter int N_INPUTS = 2,
                N_NEURONS = 4,
                N_OUTPUTS = 2,
                DATA_WIDTH = 16,
                ACC_WIDTH = 48
) (
    
    input logic clk,
    input logic reset,
    input logic start,

    input logic signed [DATA_WIDTH-1:0] x[N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] w1[N_NEURONS][N_INPUTS],
    input logic signed [DATA_WIDTH-1:0] b1[N_NEURONS],

    input logic signed [DATA_WIDTH-1:0] w2[N_OUTPUTS][N_NEURONS],
    input logic signed [DATA_WIDTH-1:0] b2[N_OUTPUTS],

    output logic signed [ACC_WIDTH-1:0] z2[N_OUTPUTS],
    output logic pred_class,
    output logic done

);

    // define a new data type called `state_t` that stores the FSM states
    typedef enum logic [2:0] {

        IDLE,
        HIDDEN_MAC,
        HIDDEN_STORE,
        OUTPUT_MAC,
        OUTPUT_STORE,
        DONE

    } state_t;

    // FSM states
    state_t state;

    // declare a register that keeps track of the accumulator
    logic signed [ACC_WIDTH-1:0] acc;

    // a register that stores the activations
    logic signed [ACC_WIDTH-1:0] h[N_NEURONS];

    // counters
    logic [1:0] neuron_idx;
    logic [1:0] input_idx;

    localparam int SHIFT_FACTOR = 12; // fractional bits, must match Q-format

    always_ff @(posedge clk) begin : seq_MAC

        // reset all registers
        if (reset) begin
            
            state <= IDLE;
            neuron_idx <= 0;
            input_idx <= 0;
            acc <= 0;
            done <= 0;
            pred_class <= 0;

            for (int i = 0; i < N_NEURONS; i++) begin
                
                h[i] <= 0;

            end

            for (int i = 0; i < N_OUTPUTS; i++) begin
                
                z2[i] <= 0;

            end

        end

        else begin
            
            case(state)

                IDLE : begin

                    done <= 0;
                    
                    if (start) begin
                        
                        state <= HIDDEN_MAC;
                        neuron_idx <= 0;
                        input_idx <= 0;
                        acc <= 0;

                    end

                end

                HIDDEN_MAC : begin
                    
                    acc <= acc + ((w1[neuron_idx][input_idx] * x[input_idx]) >>> SHIFT_FACTOR);
                    
                    if (input_idx == (N_INPUTS - 1)) begin
                        
                        state <= HIDDEN_STORE;

                    end

                    else begin
                        
                        input_idx <= input_idx + 1;
                        state <= HIDDEN_MAC;

                    end

                end

                HIDDEN_STORE : begin
                    
                    h[neuron_idx] <= ReLU(acc + {{(ACC_WIDTH-DATA_WIDTH){b1[neuron_idx][DATA_WIDTH-1]}}, b1[neuron_idx]});

                    if (neuron_idx == (N_NEURONS - 1)) begin
                        
                        input_idx <= 0;
                        neuron_idx <= 0;
                        acc <= 0;
                        state <= OUTPUT_MAC;

                    end

                    else begin
                        
                        neuron_idx <= neuron_idx + 1;
                        state <= HIDDEN_MAC;
                        input_idx <= 0;
                        acc <= 0; 

                    end

                end

                OUTPUT_MAC : begin
                    
                    acc <= acc + ((w2[neuron_idx][input_idx] * h[input_idx]) >>> SHIFT_FACTOR);

                    if (input_idx == (N_NEURONS - 1)) begin
                        
                        state <= OUTPUT_STORE;

                    end

                    else begin
                        
                        input_idx <= input_idx + 1;
                        state <= OUTPUT_MAC;

                    end

                end

                OUTPUT_STORE : begin

                    z2[neuron_idx] <= acc + {{(ACC_WIDTH-DATA_WIDTH){b2[neuron_idx][DATA_WIDTH-1]}}, b2[neuron_idx]};

                    if (neuron_idx == (N_OUTPUTS - 1)) begin
                        
                        state <= DONE;

                    end

                    else begin

                        neuron_idx <= neuron_idx + 1;
                        input_idx <= 0;
                        acc <= 0;
                        state <= OUTPUT_MAC;

                    end

                end

                DONE : begin
                    
                    // prediction
                    pred_class <= Argmax(z2[0], z2[1]);                    
                    done <= 1;
                    state <= IDLE;

                end

                default : state <= IDLE;

            endcase
        end 
    end
    
endmodule
