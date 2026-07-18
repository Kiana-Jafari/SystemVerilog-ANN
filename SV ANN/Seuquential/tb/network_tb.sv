module network_tb;

    localparam int N_INPUTS  = 2;
    localparam int N_NEURONS = 4;
    localparam int N_OUTPUTS = 2;
    localparam int DATA_WIDTH = 16;
    localparam int ACC_WIDTH = 48;
    localparam int N_SAMPLES = 57;

    logic signed [DATA_WIDTH-1:0] X_test [N_INPUTS][N_SAMPLES];

    initial begin : Test_Samples
        X_test[0] = '{
            579, -2336, -205, 307, 1130, -611, 134, -1273, -2158,
            -867, -300, 4330, 246, 579, -122, -700, -600, -122,
            196, -1335, -261, -105, -333, -183, 791, -1079, -1385,
            2527, -322, 68, -750, -2375, 435, -3051, -1546, -856,
            -1223, -2408, -1713, -1279, -734, -2464, -1340, -761,
            -2325, -1307, 1125, -2303, -1674, -1930, 1765, -1557,
            -1168, -1357, -2191, -639, 980
            };
            
        X_test[1] = '{
            -1200, -2437, -1452, 432, -1479, -405, 3751, -2736, -1088,
            -2018, -1398, -1448, 296, -696, -2193, 634, -1192, -1968,
            -1782, -2150, 1401, -2061, -3054, -2974, -495, -1805, -1491,
            -3209, 494, -2263, -1002, 564, -2274, -3794, -1464, -1212,
            1138, -3361, -1646, -1041, -1041, -1534, 21, -2154, -2487,
            -2693, 1184, -1367, -1506, -1685, -863, -297, 1173, -2608,
            1014, -3144, -1584
            };
    end

    // Inputs

    logic signed [DATA_WIDTH-1:0] x[N_INPUTS];

    logic signed [DATA_WIDTH-1:0] w1[N_NEURONS][N_INPUTS];
    logic signed [DATA_WIDTH-1:0] b1[N_NEURONS];

    logic signed [DATA_WIDTH-1:0] w2[N_OUTPUTS][N_NEURONS];
    logic signed [DATA_WIDTH-1:0] b2[N_OUTPUTS];

    // Outputs

    logic signed [ACC_WIDTH-1:0] z2[N_OUTPUTS];
    logic pred_class;
    logic done;

    logic clk;
    logic reset;
    logic start;

    // DUT

    network dut(
        .clk(clk),
        .reset(reset),
        .start(start),

        .x(x),

        .w1(w1),
        .b1(b1),

        .w2(w2),
        .b2(b2),

        .z2(z2),
        .pred_class(pred_class),
        .done(done)
    );

    always #5 clk = ~clk;

    // Test

    initial begin

        clk = 0;
        reset = 1;
        start = 0;

        #20;

        reset = 0;
        
        // Hidden layer

        w1[0][0] = 16'sd216;
        w1[0][1] = 16'sd186;

        w1[1][0] = 16'sd3599;
        w1[1][1] = 16'sd6119;

        w1[2][0] = 16'sd172;
        w1[2][1] = 16'sd159;

        w1[3][0] = 16'sd3478;
        w1[3][1] = 16'sd6001;

        b1[0] = -16'sd205;
        b1[1] =  16'sd3833;
        b1[2] = -16'sd205;
        b1[3] =  16'sd3700;

        // Output layer

        w2[0][0] = -16'sd141;
        w2[0][1] =  16'sd5831;
        w2[0][2] = -16'sd218;
        w2[0][3] =  16'sd6009;

        w2[1][0] =  16'sd77;
        w2[1][1] = -16'sd5843;
        w2[1][2] =  16'sd179;
        w2[1][3] = -16'sd5967;

        b2[0] = -16'sd4937;
        b2[1] =  16'sd4937;

        for (int i = 0; i < N_SAMPLES; i++) begin
            
            x[0] = X_test[0][i];
            x[1] = X_test[1][i];

            // start inference
            @(posedge clk);
            start <= 1;

            @(posedge clk);
            start <= 0;

            // wait until computation finishes
            @(posedge done);

            $display("Sample %0d:", i);
            $display("x = [%0d, %0d]", x[0], x[1]);
            $display("h = %p", dut.h);
            $display("z2 = %p", z2);
            $display("pred_class = %0d\n", pred_class);

        end

        $finish;
    end

    // Waveform dump

    initial begin
        $dumpfile("network.vcd");
        $dumpvars(0, network_tb);
    end

endmodule
