module sign_extend
    #(
        parameter BITS = 'd32,
        parameter MAX = 'd40
    )
    (
        input signed [BITS-'d1:0] in,
        output signed [MAX-'d1:0] extend
    );


	assign extend[BITS-'d1:0] = in;
	assign extend[MAX-'d1:BITS] = {MAX-BITS{in[BITS-'d1]}};
endmodule
