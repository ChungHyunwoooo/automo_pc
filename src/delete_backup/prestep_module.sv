//----------------------------------------------------------------------------------------------------------------------------
//  Design Name     : prestep_module
//  File Name       : prestep_module.sv
//  Language        : SystemVerilog
//  Author          : Hyunwoo Chung (HC)
//  Organization    : Embedded System Architecture Laboratory (ESAL), The Dept. of Computer Engineering, Kwangwoon University
//  Last Updated    : 2018. 04. 29
//----------------------------------------------------------------------------------------------------------------------------

`ifndef REG_WEN_MODULE
`define REG_WEN_MODULE
`include "../src/register_module.sv"
`endif

`include "../src/decode_module.sv"
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
        input logic wen,
        input logic [$clog2(CGES)-'d1:0] addr,
        input logic [CGES-'d1:0] cges,
        input logic [BITS-'d1:0] value,
        output logic [MAX-'d1:0] coeff [CGES-'d1:0]

    );

    logic [CGES-'d1:0]  w_wen;
    logic [BITS-'d1:0]  r_coeff [CGES-'d1:0];
    logic [BITS-'d1:0]  a_coeff [CGES-'d1:0];

	genvar i;
//decoder
    decode_en #(CGES) U0_decode_en(wen, addr, w_wen); // wirte enable decode

//register
    register_module #(BITS, CGES) 
        U1_reg (
            clk, 
            reset_n, 
            w_wen, 
            value,
            r_coeff
        );
//multi-andgate
    assign a_coeff[0] = r_coeff[0];
    generate 
		for(i=1;i<CGES;i=i+'d1) begin: and_coeff
			multi_andgate #(BITS) 
            U2_multi (
                r_coeff[i], 
                cges[i], 
                a_coeff[i]
            );
		end
    endgenerate

//signextend
    generate 
        for(i=0;i<CGES;i++) begin:U3_sign_extend
            sign_extend #(BITS, MAX) 
            U3_ext(
                a_coeff[i], 
                coeff[i]
            );
        end
	endgenerate
endmodule