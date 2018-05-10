module temp_target_IP
    #(
        parameter CGES = 'd7
    )
    (
        input clk, reset_n,
        output logic [CGES-'d2:0] cges
    );
    integer seed;
    always @(posedge clk) begin
     //$srandom(seed);
    
		if(reset_n == 1)
			cges <= {CGES-1{1'b1}};
	end	
    
endmodule

