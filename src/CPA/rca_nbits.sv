
//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : rca_nbits
//  File Name       : rca_nbits.sv
//  Description     : Functional Model of n bits Ripple Carry Adder
//  Language        : SystemVerilog
//  Author          : Changon Choi (CC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Email / Phone   : ccw0604@gmail.com or changwonchoi@kw.ac.kr / (+82)10-5012-2962
//  Last Updated    : 2017. 08. 25
//----------------------------------------------------------------------------------------------------------------------------


`ifndef SRC_INC_FULLADDER
`define SRC_INC_FULLADDER
`include "../src/fulladder.sv"
`endif

module rca_nbits
    #(
        parameter BITS = 'd32
    )
    (
        input   logic [BITS-'d1:'d0] a,
        input   logic [BITS-'d1:'d0] b,
        input   logic ci,
        output  logic [BITS-'d1:'d0] s,
`ifdef RCA_OUTPUT_CO_PREV
        output  logic co_prev,
`endif
        output  logic co
    );
    
    logic [BITS:'d0] w_c;
    
    assign w_c['d0] = ci;
`ifdef RCA_OUTPUT_CO_PREV
    assign co_prev = w_c[BITS-'d1];
`endif
    assign co = w_c[BITS];
    
    genvar gen_fa;
    generate
        for(gen_fa = 'd0; gen_fa < BITS; gen_fa = gen_fa + 'd1)begin:U_FA
            fulladder
                u_fa(
                    .a(a[gen_fa]),
                    .b(b[gen_fa]),
                    .ci(w_c[gen_fa]),
                    .s(s[gen_fa]),
                    .co(w_c[gen_fa+'d1])
                );
        end
    endgenerate
        
endmodule
