`include "../src/adder_tree_module.sv"
`include "../src/CPA_module.sv"
`include "../src/m_control.sv"
`include "../src/temp_target_IP.sv"

//CPA module option
//SRC_INC_RCA - RCA
//SRC_INC_CLA - CLA
//SRC_INC_PPA_KS - Kogge - Stone adder
//SRC_INC_PPA_LF - Lander - Fisher adder
//Default - operation +

`define SRC_INC_PPA_LF

module TOP
	#(
		parameter BITS = 'd32, //user accuracy
		parameter CGES = 'd13
	)
	(
		input clk, reset_n,
		//input [CGES-'d2:0] cges,
		input start, fin,
		//output [$clog2(CGES) + BITS-'d1:0] result
		output [3+BITS:0] result
	);
	//localparam CGES = 'd13;
	localparam MAX  = $clog2(CGES) + BITS ;
	//localparam MAX  = 35;
	localparam INPUT = 'd7;
	
	logic cal;
	
	logic [MAX-'d1:0] vs;
	logic [MAX-'d1:0] vc;
	
	logic [CGES-'d2:0] cges;
	logic [MAX-'d1:0] cpa_result;
	
	 adder_tree_module #(BITS,CGES,MAX,INPUT)
		U1_CSA
    (
        clk,
        reset_n,
        cal,
        cges,
        vs,
        vc
    );
	 
	 CPA_module #(MAX)
	 U2_CPA
    (
        vs,
		vc, 
		cpa_result
    );
	reg_en_BITS #(MAX) 
	U3_REG_CPA 
	(
		clk, 
		reset_n, 
		cal, 
		cpa_result, 
		result
	); 
	 	
	
	m_control #(CGES)
	U0_main_control
	(
		clk,  
		reset_n,
		start, fin,
		cal
	);
	
	
	temp_target_IP#(CGES)
	U0_targetIP
	(
		clk, 
		reset_n,
      cges
	);
	
	
	
endmodule