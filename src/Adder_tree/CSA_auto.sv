`include "../Adder_tree/CSA_block.sv"

module CSA_auto
	#(
		parameter MAX = 'd7,
		parameter INPUT = 'd7
	)
	(
		input logic [MAX-'d1:0] in [INPUT-'d1:0],
		output logic [MAX-'d1:0] pv_s, pv_c
	);
	
	logic [MAX-'d1:0] w_s1, w_c1;
	logic [MAX-'d1:0] w_s2, w_c2;
	
	generate begin
		case(INPUT)
		'd2: begin
			assign pv_s = in[0];
			assign pv_c = in[1];
		end
		'd3: tree_3_2 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd4: tree_4_2 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd5: tree_5_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd6: begin
			tree_3_2 #(MAX) U0_CSA(in[0+:3], w_s1, w_c1);
			tree_3_2 #(MAX) U1_CSA(in[6-:3], w_s2, w_c2);
			tree_4_2 #(MAX) U2_CSA({w_s1, w_c1, w_s2, w_c2}, pv_s, pv_c);
		end
		'd7: tree_7_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		default: tree_7_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		endcase
	end endgenerate
	
	
	
endmodule