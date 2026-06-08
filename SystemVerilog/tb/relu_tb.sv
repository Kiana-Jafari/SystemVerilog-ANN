module relu_tb;

logic signed [7:0] in;
logic signed [7:0] out;

relu dut(
    .in(in),
    .out(out)
);

initial begin

    $display(" in | out");
    $display("----------");

    in = -6;
    #10;
    $display("%0d | %0d", in, out);

    in = -1;
    #10;
    $display("%0d | %0d", in, out);

    in = 0;
    #10;
    $display("%0d | %0d", in, out);

    in = 5;
    #10;
    $display("%0d | %0d", in, out);

    in = 12;
    #10;
    $display("%0d | %0d", in, out);

    $finish;
end

endmodule