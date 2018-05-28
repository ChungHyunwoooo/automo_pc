module temp_target_IP
    #(
        parameter CGES = 'd13
    )
    (
        input clk, reset_n,
        output reg [CGES-'d2:0] cges
    );
    
    reg [CGES-'d2:0] counter = {CGES-2{1'b0}};
    always @(posedge clk) begin
     //$srandom(seed);
      
	    cges <= {counter};
        if(counter == {CGES-2{1'b1}})
        counter <= 'd0;
        else begin
       	counter <= counter + 1'd1;
		end
	end	
    
endmodule

