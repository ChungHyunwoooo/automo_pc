`include "../src/prestep_module.sv"
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


module TOP
	#(
		parameter BITS = 'd32,
		parameter CGES = 'd49
		
	)
	(
		input CLK, reset_n,
		//input [CGES-'d1:0] cges,
		input start, fin,
		output [$clog2(CGES) + BITS-'d1:0] result
	);
	localparam MAX  = $clog2(CGES) + BITS;
	localparam INPUT = 'd7;
	
	logic wen;
	logic cal;
	logic [$clog2(CGES)-'d1:0] addr; 
	
	logic [MAX-'d1:0] vs;
	logic [MAX-'d1:0] vc;
	
	logic [MAX-'d1:0] 	coeff 	[CGES-'d1:0];
	logic [CGES-'d2:0] cges;
	
	prestep_module#(BITS,CGES,MAX)
	 U0_prestep
    (   
        .clk(CLK),
		  .reset_n(reset_n),
        .wen(wen),
        .cges(cges),
        .coeff(coeff)

    );
	 

	 adder_tree_module #(BITS,CGES,MAX,INPUT)
		U1_CSA
    (
        CLK,
        reset_n,
        cal,
        coeff,
        vs,
        vc
    );
	 
	 CPA_module #(MAX)
	 U2_CPA
    (
        vs,
		  vc, 
		  result
    );
	 
	 	
	
	m_control #(CGES)
	U3_main_control
	(
		CLK,  
		reset_n,
		start, fin,
		wen, cal,
		addr
		
	);
	temp_target_IP#(CGES)
	U4_targetIP
	(
		CLK, 
		reset_n,
      cges
	);
	
	
	
endmodule