module coefficient_register
    #(
        parameter BITS = 'd32,
        parameter NUM = 'd7
    )
    (
        input                   clk,
        input                   reset_n,
		output [BITS-'d1:0]     q [NUM-'d1:0] 
    );
    logic [BITS-'d1:0] coeff [NUM-'d1:0];
    initial begin
        $readmemb("C:/Users/resio/Desktop/18ver/init.mem", coeff);
    end
	 assign q = coeff;
    
endmodule

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
		  q<={BITS{1'bz}};
	end	
	
endmodule