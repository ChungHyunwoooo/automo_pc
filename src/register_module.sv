module register_module
    #(
        parameter BITS = 'd32,
        parameter NUM = 'd7
    )
    (
        input                   clk,
        input                   reset_n,
        input [NUM-'d1:0]       en,
        input [BITS-'d1:0]      d [NUM-'d1:0],
		output [BITS-'d1:0]     q [NUM-'d1:0] 
    );
    generate begin: U_reg
        for(i=0;i<NUM;i=i+'d1) begin: reg_gen
                reg_en_BITS #(BITS) 
                U0_reg (
                    clk, 
                    reset_n, 
                    en[i], 
                    coeff, 
                    r_coeff[i]
                );
            end
        end
    endgenerate
endmodule

module reg_en_BITS
	#(
		parameter BITS = 'd4
	)
	(
		input clk, reset_n, en
		input [BITS-'d1:0] d,
		output [BITS-'d1:0] q
	);
		
    always @(posedge clk) begin
		if(reset_n == 1)
			q <= {(BITS){1'b0}};
		else if(en == 1)
			q <= d;
	end	
	
endmodule