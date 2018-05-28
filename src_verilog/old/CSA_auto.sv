`include "../src/CSA_block.sv"

module CSA_auto
	#(
		parameter MAX = 'd7,
		parameter INPUT = 'd7
	)
	(
		input logic [MAX*INPUT -'d1:0] in,
		output logic [MAX-'d1:0] pv_s, pv_c
	);
	
	generate begin
		case(INPUT)
		'd2: begin
			assign pv_s = in[0];
			assign pv_c = in[1];
		end
		'd3: tree_3_2 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd4: tree_4_2 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd5: tree_5_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd6: tree_6_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		'd7: tree_7_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		default: tree_7_3 #(MAX) U0_CSA(in, pv_s, pv_c);
		endcase
	end endgenerate
	
	
	
endmodule