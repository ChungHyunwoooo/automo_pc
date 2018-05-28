module CPA_module
    #(
        parameter BITS = 'd40
    )
    (
        input      [BITS-'d1:0] a,
        input      [BITS-'d1:0] b,
        output     [BITS-'d1:0] pv_prime
    );


`ifdef  SRC_INC_RCA
    
    rca_nbits
    #(BITS) U_CPA (
        .a(a),
        .b(b),
        .ci(1'b0), 
        .s(pv_prime)
    );

`elsif SRC_INC_CLA
    assign pv_prime = a + b;


`elsif SRC_INC_PPA_KS
    
    parallel_prefix_adder_Kogge_Stone_adder
    #(BITS) U_CPA (
         .a(a),
         .b(b), 
         .ci(1'b0), 
         .s(pv_prime)
         );	
	
`elsif SRC_INC_PPA_LF
    
    parallel_prefix_adder_Ladner_Fisher_adder
    //#(BITS) U_CPA (.a(a), .b(b), .ci(1'b0), .s(pv_prime), .co(1'b0));	
    #(BITS) U_CPA (.a(a), .b(b), .ci(1'b0), .s(pv_prime));	

`else
    //default option
    assign pv_prime = a + b;
`endif
endmodule


