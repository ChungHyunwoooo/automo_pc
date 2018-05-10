`ifndef SRC_INC_FULLADDER
`define SRC_INC_FULLADDER
`include "../src/fulladder.sv"
`endif

module tree_2_2 
	#(
		parameter MAX = 'd7
	)
	(
		input logic [MAX-'d1:0] in [1:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);
	assign s = in[0];
	assign c = in[1];
endmodule

module tree_3_2
	#(
		parameter MAX = 'd7
	)
	(
		input logic [MAX-'d1:0] in [2:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);
	genvar i;
	generate
		for(i=0;i<MAX;i=i+'d1) begin:level1
			adder_3_2 U1({in[0][i], in[1][i], in[2][i]}, {s[i], c[i]});
		end	
	endgenerate
	
endmodule

module tree_4_2
	#(
		parameter MAX = 'd32
	)
	(
		input logic [MAX-'d1:0] in [3:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);

	logic [MAX-'d2:0] cout ;
	
	genvar i;
	
	generate
		for(i=0;i<MAX;i=i+'d1) begin:level1
			if(i==0) 	adder_4_2_cinout U0({in[0][i], in[1][i], in[2][i], in[3][i]}, 1'b0, s[i], c[i], cout[i]);
			else if(i == MAX-'d1)
						adder_4_2_cinout U0({in[0][i], in[1][i], in[2][i], in[3][i]}, cout[i-1], s[i], c[i]);
			else 		adder_4_2_cinout U1({in[0][i], in[1][i], in[2][i], in[3][i]}, cout[i-1], s[i], c[i], cout[i]);
		end	
	endgenerate 
	
endmodule

module tree_5_3
	#(
		parameter MAX = 'd5
	)
	(
		input logic [MAX-'d1:0] in [4:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);

	logic [2:0] lv1 [MAX-'d1:0];
	logic w_c;
	genvar i;
	generate
		for(i=0;i<MAX;i=i+'d1) begin:level1
			adder_5_3 U1(
			{in[0][i], in[1][i], in[2][i], in[3][i], in[4][i]}, lv1[i][2:0]);
		end
		////////////////////////level 2
		for(i='d3;i<MAX;i=i+'d1) begin:lv2
			if(i!= MAX-'d1) fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], c[i+1]);
			else fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], w_c);
			//w_c is not used
		end
		halfadder U2_0(lv1[0][2], lv1[1][1], s[2], c[3]);
		//halfadder U2_1(lv1[MAX-'d4][1], lv1[MAX-'d5][2], s[MAX-'d3], c[MAX-'d3]);
		assign s[1:0] = {lv1[0][1] ,lv1[0][0]};
		assign c[2:1] = {lv1[2][0], lv1[1][0]};
		assign c[0] = 1'b0;
		//assign s[MAX-'d2] = lv1[MAX-'d4][2];	
	endgenerate 
	
endmodule
module tree_6_3
	#(
		parameter MAX = 'd6
	)
	(
		input logic [MAX-'d1:0] in [5:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);
	logic [2:0] lv1 [MAX-'d1:0];
	logic w_c;
  genvar i;
	generate
		for(i=0;i<MAX;i=i+'d1) begin:level1
			adder_6_3 U1(
			{in[0][i], in[1][i], in[2][i], in[3][i], in[4][i], in[5][i]}, lv1[i][2:0]);
		end
		////////////////////////level 2
		for(i='d3;i<MAX;i=i+'d1) begin:lv2
			if(i!= MAX-'d1) fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], c[i+1]);
			else fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], w_c);
			//w_c is not used
		end
		halfadder U2_0(lv1[0][2], lv1[1][1], s[2], c[3]);
		//halfadder U2_1(lv1[MAX-'d4][1], lv1[MAX-'d5][2], s[MAX-'d3], c[MAX-'d3]);
		assign s[1:0] = {lv1[0][1] ,lv1[0][0]};
		assign c[2:1] = {lv1[2][0], lv1[1][0]};
		assign c[0] = 1'b0;
		//assign s[MAX-'d2] = lv1[MAX-'d4][2];	
	endgenerate 
	
endmodule


module tree_7_3 
	#(
		parameter MAX = 'd7
	)
	(
		input logic [MAX-'d1:0] in [6:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);
	logic [2:0] lv1 [MAX-'d1:0];
	logic w_c;
	genvar i;
	generate
		for(i=0;i<MAX;i=i+'d1) begin:level1
			adder_7_3 U1(
			{in[0][i], in[1][i], in[2][i], in[3][i], in[4][i], in[5][i], in[6][i]},
			lv1[i][2:0]);
		end
		
		////////////////////////level 2
		for(i='d3;i<MAX;i=i+'d1) begin:lv2
			if(i!= MAX-'d1) fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], c[i+1]);
			else fulladder U2(lv1[i-2][2], lv1[i-1][1], lv1[i][0], s[i], w_c);
			//w_c is not used
		end
		halfadder U2_0(lv1[0][2], lv1[1][1], s[2], c[3]);
		//halfadder U2_1(lv1[MAX-'d4][1], lv1[MAX-'d5][2], s[MAX-'d3], c[MAX-'d3]);
		assign s[1:0] = {lv1[0][1] ,lv1[0][0]};
		assign c[2:1] = {lv1[2][0], lv1[1][0]};
		//assign s[MAX-'d2] = lv1[MAX-'d4][2];
		assign c[0] = 1'b0;
	endgenerate
	
endmodule

module reg_tree_7_3
	#(
		parameter MAX = 'd7
	)
	(
		input clk, en, reset,
		input logic [MAX-'d1:0] in [6:0],
		output logic [MAX-'d1:0] s,
		output logic [MAX-'d1:0] c
	);
	logic [MAX-'d1:0] coeff[6:0];
	logic [MAX-'d1:0] w_s;
	logic [MAX-'d1:0] w_c;
	genvar i;
	generate
	  for(i=0;i<MAX;i=i+'d1) begin:level1
		  reg_en_BITS #(MAX) U2_reg (clk, en, reset, in[i], coeff[i]);
		end
	endgenerate
	tree_7_3 U0_csa(coeff,w_s,w_c);
	reg_en_BITS #(MAX) U1_reg (clk, en, reset, w_s, s);
	reg_en_BITS #(MAX) U3_reg (clk, en, reset, w_c, c);
	
endmodule

////////////////
//basic module//
///////////////

module adder_3_2
	(
		input logic [2:0]in,
		output logic [1:0] out
	);

	fulladder U0_0(in[0], in[1], in[2], out[0], out[1]);
	
endmodule
module adder_4_2_cinout
	(
		input logic [3:0] in,
		input logic cin,
		output logic s,
		output logic c,
		output logic cout
	);
	logic w_s;
	fulladder U0(in[0], in[1], in[2], w_s, cout);
	fulladder U1(in[3], w_s, cin, s, c);
	
endmodule

module adder_5_2_cinout
	(
		input logic [4:0] in,
		input logic [1:0] cin,
		output logic s,
		output logic c,
		output logic [1:0] cout
	);
	logic [1:0] w_s;
	fulladder U0(in[0], in[1], in[2], w_s[0], cout[0]);
	fulladder U1(in[3], w_s[0], cin[0], w_s[1], cout[1]);
	fulladder U2(in[4], w_s[1], cin[1], s, c);
	
endmodule

module adder_5_3
	(
		input logic [4:0] in,
		output logic [2:0] out
	);
	logic [2:0] w; 
	//w[0] U0 sum
	//w[1] U0 carry
	//w[2] U1 carry
	fulladder U0(in[0], in[1], in[2], w[0], w[1]);
	fulladder U1(in[3], in[4], w[0], out[0], w[2]);
	halfadder U2(w[1], w[2], out[1], out[2]);
	
endmodule
module adder_6_3
	(
		input logic [5:0] in,
		output logic [2:0] out
	);
	logic [3:0] w_1;
	logic w_2;
	//w_1[0] U0 sum
	//w_1[1] U0 carry
	//w_1[2] U1 carry
	fulladder U0(in[0], in[1], in[2], w_1[0], w_1[1]);
	fulladder U1(in[3], in[4], in[5], w_1[2], w_1[3]);
	halfadder U2(w_1[0],w_1[1], out[0], w_2);
	fulladder U3(w_1[1], w_1[3], w_2, out[1], out[2]);
	
endmodule

module adder_7_3
	(
		input logic [6:0]in,
		output logic [2:0] out
	);

	logic [1:0] w_s;
	logic [2:0] w_c;

`ifdef CSA_LINEAR_TREE
	fulladder U0(in[0], in[1], in[2], w_s[0], w_c[0]);
	fulladder U1(w_s[0], in[3], in[4], w_s[1], w_c[1]);
	fulladder U2(w_s[1], in[5], in[6], out[0], w_c[2]);
	fulladder U3(w_c[0], w_c[1], w_c[2], out[1], out[2]);

/*`elseif CSA_WALLACE_TREE
	fulladder U0_0(in[0], in[1], in[2], w_s[0], w_c[0]);
	fulladder U0_1(in[3], in[4], in[5], w_s[1], w_c[1]);
	fulladder U1(in[6], w_s[0], w_s[1], out[0], w_c[2]);
	fulladder U2(w_c[0], w_c[1], w_c[2], out[1], out[2]);
	*/
	`else
	fulladder U0_0(in[0], in[1], in[2], w_s[0], w_c[0]);
	fulladder U0_1(in[3], in[4], in[5], w_s[1], w_c[1]);
	fulladder U1(in[6], w_s[0], w_s[1], out[0], w_c[2]);
	fulladder U2(w_c[0], w_c[1], w_c[2], out[1], out[2]);
`endif
		
endmodule

module adder_8_4
	(
		input logic [7:0]in,
		output logic [3:0] out
	);

	logic [2:0] w_s0;
	logic w_s1;
	logic [2:0] w_c0;
	logic [1:0] w_c1;
	logic w_c2;
		
	fulladder U0_0(in[0], in[1], in[2], w_s0[0], w_c0[0]);
	fulladder U0_1(in[3], in[4], in[5], w_s0[1], w_c0[1]);
	halfadder U0_2(in[6], in[7], w_s0[2], w_c0[2]);

	fulladder U1_0(w_s0[0], w_s0[1], w_s0[2], out[0], w_c1[0]);
	fulladder U1_1(w_c0[0], w_c0[1], w_c0[2], w_s1, w_c1[1]);
	
	halfadder U2(w_c1[0], w_s1, out[1], w_c2);
	halfadder U3(w_c1[1], w_c2, out[2], out[3]);
	
endmodule


module adder_9_4
	(
		input logic [8:0]in,
		output logic [3:0] out
	);
	
	//wallace tree
	logic [2:0] w_s0;
	logic w_s1;
	logic [2:0] w_c0;
	logic [1:0] w_c1;
	logic w_c2;
		
	fulladder U0_0(in[0], in[1], in[2], w_s0[0], w_c0[0]);
	fulladder U0_1(in[3], in[4], in[5], w_s0[1], w_c0[1]);
	fulladder U0_2(in[6], in[7], in[8], w_s0[2], w_c0[2]);

	fulladder U1_0(w_s0[0], w_s0[1], w_s0[2], out[0], w_c1[0]);
	fulladder U1_1(w_c0[0], w_c0[1], w_c0[2], w_s1, w_c1[1]);
	
	halfadder U2(w_c1[0], w_s1, out[1], w_c2);
	halfadder U3(w_c1[1], w_c2, out[2], out[3]);
	
endmodule
