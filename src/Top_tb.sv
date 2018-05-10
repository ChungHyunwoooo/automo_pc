module TOP_tb;
    parameter BITS = 'd32;
    parameter CGES = 'd49;
    logic clk, reset_n;
    logic start, fin;
    logic [$clog2(CGES) + BITS-'d1:0] result;


		
TOP #(BITS,CGES)U0
	(
		clk, 
        reset_n,
		start, fin,
		result
    );

always begin #5; clk = ~clk; end 
	
shortint i;
initial begin

		clk = 0; reset_n = 1; start = 1; fin = 0; #10
		reset_n = 0;
		#10000;
		fin = 1;  #50;
	$finish;
	
    
end
endmodule