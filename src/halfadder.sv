
//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : halfadder
//  File Name       : halfadder.sv
//  Description     : Functional Model of Half Adder
//  Language        : SystemVerilog
//  Author          : Changon Choi (CC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Email / Phone   : ccw0604@gmail.com or changwonchoi@kw.ac.kr / (+82)10-5012-2962
//  Last Updated    : 2017. 08. 23
//----------------------------------------------------------------------------------------------------------------------------

module halfadder(
        input   logic a, b, 
        output  logic s, co
    );	
    
	assign s    = a ^ b;
	assign co   = a & b;	
endmodule
