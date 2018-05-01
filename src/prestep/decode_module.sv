module decode_module
	#(
		parameter CGES = 'd7
	)
	(
		input wen,
		input [$clog2(CGES)-'d1:0] addr,
		output logic [CGES-'d1:0] d_wen
	);
	
	always@(addr, wen) begin
		if(wen) begin
			d_wen = 1'b1 <<addr;
		end
		else begin
			d_wen = {(CGES){1'd0}};
		end
	end
endmodule