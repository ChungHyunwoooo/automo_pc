module TOP_tb;
    parameter BITS = 'd32;
    parameter CGES = 'd50;
    logic clk, reset_n;
    logic start, fin;
    logic [$clog2(CGES) + BITS-'d1:0] result;
	logic [10:0]true;

		
TOP #(BITS,CGES)U0
	(
		clk, 
        reset_n,
		start, fin,
		result
    );

always begin #5; clk = ~clk; end 
	
longint i;
initial begin
		clk = 0; reset_n = 1; start = 1; fin = 0; true = 0;
		#10

		reset_n = 0;
		for(i=0;i<3000;i=i+1)begin
		#10;	
		end

		fin = 1;  #50;
	$stop;
end
endmodule