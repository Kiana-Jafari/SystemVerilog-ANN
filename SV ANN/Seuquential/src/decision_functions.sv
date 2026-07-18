package decision_functions;

    function automatic logic [47:0] ReLU(
        
        input logic signed [47:0] in
    );

        return (in < 0) ? 0 : in;
    
    endfunction

    function automatic logic Argmax(
        
        input logic signed [47:0] o0,
        input logic signed [47:0] o1
    );

        return (o0 >= o1) ? 0 : 1;

    endfunction

endpackage
