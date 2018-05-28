module multi_andgate
	#(
		parameter BITS = 'd32
	)
	(
		input [BITS-'d1:0] coeff,
		input cges,
		output logic [BITS-'d1:0] coeff_and
	);
	
	genvar i;
	
	generate
		for(i=0;i<BITS;i=i+'d1) begin: coeff_andgate
			assign coeff_and[i] = coeff[i] & cges;
		end
	endgenerate
endmodule