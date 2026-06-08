module mac_seq_tb;

logic clk;
logic reset;
logic signed [3:0] X;
logic signed [3:0] w;
logic signed [7:0] acc;

// Design Under Test (DUT)
mac_seq dut(
    .clk(clk),
    .reset(reset),
    .X(X),
    .w(w),
    .acc(acc)
);

always #5 clk = ~clk; // toggle clock every 5 ns

initial begin

    $dumpfile("mac.vcd");
    $dumpvars(0, mac_seq_tb);

    $monitor("t=%0t | clk=%0d reset=%0d X=%0d w=%0d acc=%0d",
            $time, clk, reset, X, w, acc);
    
    // initialize signals 
    clk = 0;
    reset = 1;
    X = 0;
    w = 0;

    #10; // wait timeline

    // update signals 
    reset = 0;
    X = 2;
    w = 3;

    #50;

    $finish;

end
    
endmodule