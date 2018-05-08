
//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : fulladder
//  File Name       : fulladder.sv
//  Description     : Functional Model of Full Adder
//  Language        : SystemVerilog
//  Author          : Changon Choi (CC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Email / Phone   : ccw0604@gmail.com or changwonchoi@kw.ac.kr / (+82)10-5012-2962
//  Last Updated    : 2017. 08. 23
//----------------------------------------------------------------------------------------------------------------------------

`ifndef SRC_INC_HALFADDER
`define SRC_INC_HALFADDER
`include "../src/halfadder.sv"
`endif

module fulladder(
        input   logic a, b, ci, 
        output  logic s, co
    );
    logic c1, c2, sm;
    
    halfadder U0_ha(a, b, sm, c1);
    halfadder U1_ha(sm, ci, s, c2);
    assign co = c1|c2;
/*
    assign s = a ^ b ^ ci;
    assign co = (a & b) | (a & ci) | (b & ci);
*/  
endmodule
