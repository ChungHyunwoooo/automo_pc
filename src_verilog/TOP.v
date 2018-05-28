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
	localparam MAX  = 4 + 32 ;
	//localparam MAX  = 35;
	localparam INPUT = 'd7;
	
	wire wen;
	
	wire [MAX-'d1:0] vs;
	wire [MAX-'d1:0] vc;
	
	wire [CGES-'d2:0] cges;
	wire [MAX-'d1:0] cpa_result;
	
	 adder_tree_module #(BITS,CGES,MAX,INPUT)
		U1_CSA
    (
        clk,
        reset_n,
        wen,
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
		wen, 
		cpa_result, 
		result
	); 
	 	
	
	m_control #(CGES)
	U0_main_control
	(
		clk,  
		reset_n,
		start, fin,
		wen
	);
	
	
	temp_target_IP 	#(CGES)
	U0_targetIP
	(
		clk, 
		reset_n,
      	cges
	);
	
	
	
endmodule