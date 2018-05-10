module temp_target_IP
    #(
        parameter CGES = 'd7
    )
    (
        input clk, reset_n,
        output logic [CGES-'d2:0] cges
    );
    
    logic [CGES-'d2:0] counter;
    always @(posedge clk) begin
     //$srandom(seed);
        
		if(reset_n == 1)
			counter = 0;
      else begin 
			cges <= {counter};
			counter = counter + 'b1;
		end
	end	
    
endmodule

