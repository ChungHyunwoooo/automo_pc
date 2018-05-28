module reg_en_BITS
	#(
		parameter BITS = 'd4
	)
	(
		input clk, 
		input reset_n, 
		input en,
		input logic [BITS-'d1:0] d,
		output logic [BITS-'d1:0] q
	);
		
    always @(posedge clk) begin
		if(reset_n == 1)
			q <= {BITS{1'b0}};
		else if(en == 1)
			q <= d;
		else
		  q<={BITS{1'b0}};
		  
	end	
	
endmodule