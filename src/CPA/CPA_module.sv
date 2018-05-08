//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : CPA_module
//  File Name       : CPA_module.sv
//  Language        : SystemVerilog
//  Author          : Hyunwoo Chung (HC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Last Updated    : 2018. 04. 29
//----------------------------------------------------------------------------------------------------------------------------
//CPA module option
//SRC_INC_RCA - RCA
//SRC_INC_CLA - CLA
//SRC_INC_PPA_KS - Kogge - Stone adder
//SRC_INC_PPA_LF - Lander - Fisher adder
//Default - operation +

`define SRC_INC_PPA_LF //option

`ifdef  SRC_INC_RCA
	`include "../CPA/rca_nbits.sv"
`elsif  SRC_INC_PPA_KS
	`include "../CPA/parallel_prefix_adder_Kogge_Stone_adder.sv"
`elsif SRC_INC_PPA_LF
	`include "../CPA/parallel_prefix_adder_Ladner_Fisher_adder.sv"
`endif
module CPA_module
    #(
        parameter BITS = 'd32
    )
    (
        input logic     [BITS-'d1:0] a,
        input logic     [BITS-'d1:0] b,
        output logic    [BITS-'d1:0] pv_prime
    );


`ifdef  SRC_INC_RCA
    
    rca_nbits
    #(BITS) U_CPA (
        .a(a),
        .b(b),
        .ci(1'b0), 
        .s(pv_prime), 
        .co(1'b0)
    );

`elsif SRC_INC_CLA
    assign pv_prime = a + b;


`elsif SRC_INC_PPA_KS
    
    parallel_prefix_adder_Kogge_Stone_adder
    #(BITS) U_CPA (
         .a(a),
         .b(b), 
         .ci(1'b0), 
         .s(pv_prime), 
         .co(1'b0)
         );	
	
`elsif SRC_INC_PPA_LF
    
    parallel_prefix_adder_Ladner_Fisher_adder
    #(BITS) U_CPA (.a(a), .b(b), .ci(1'b0), .s(pv_prime), .co(1'b0));	

`else
    //default option
    assign result = a + b;
`endif
endmodule


