
//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : CPA_module
//  File Name       : CPA_module.sv
//  Language        : SystemVerilog
//  Author          : Hyunwoo Chung (HC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Last Updated    : 2018. 04. 29
//----------------------------------------------------------------------------------------------------------------------------

module CPA_module
    #(
        parameter BITS = 'd32
    )
    (
        input logic     [BITS-'d1:0] a,
        input logic     [BITS-'d1:0] b,
        output logic    [BITS-'d1:0] pv_prime
    );

//CPA module option
//SRC_INC_RCA - RCA
//SRC_INC_CLA - CLA
//SRC_INC_PPA_KS - Kogge - Stone adder
//SRC_INC_PPA_LF - Lander - Fisher adder
//Default - operation +

//수정필요: CLA, co - 여부



`ifdef  SRC_INC_RCA
    `include "../src/CPA/rca_nbits.sv"
    rca_nbits
    #(MAX) U_CPA (
        .a(a),
        .b(b),
        .ci(1'b0), 
        .s(pv_prime), 
        .co(1'b0);
    )


`elseif SRC_INC_CLA
    assign result = a + b;

`elseif SRC_INC_PPA_KS
    `include "../src/CPA/parallel_prefix_adder_Kogge_Stone_adder.sv"
    parallel_prefix_adder_Kogge_Stone_adder
    #(MAX) U_CPA (
         .a(a),
         .b(b), 
         .ci(1'b0), 
         .s(pv_prime), 
         .co(1'b0);
         );	
	
`elseif SRC_INC_PPA_LF
    `include "../src/CPA/parallel_prefix_adder_Ladner_Fisher_adder.sv"
    parallel_prefix_adder_Ladner_Fisher_adder
    #(MAX) U_CPA (
         .a(a),
         .b(b), 
         .ci(1'b0), 
         .s(pv_prime), 
         .co(1'b0);
         );	

`else
    //default option
    assign result = a + b;
`endef




endmodule


