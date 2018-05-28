//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : prestep_module
//  File Name       : prestep_module.sv
//  Language        : SystemVerilog
//  Author          : Hyunwoo Chung (HC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Last Updated    : 2018. 04. 29
//----------------------------------------------------------------------------------------------------------------------------

`ifndef REG__MODULE
`define REG__MODULE
`include "../src/register_module.sv"
`endif

`include "../src/multi_andgate.sv"
`include "../src/sign_extend.sv"

module prestep_module
    #(
        parameter BITS = 'd32,
        parameter CGES = 'd49,
        parameter MAX  = $clog2(CGES) + BITS
    )   
    (   
        input logic clk, reset_n,
        input logic [CGES-'d1:1] cges,
        output logic [MAX-'d1:0] coeff [CGES-'d1:0]

    );

    
endmodule