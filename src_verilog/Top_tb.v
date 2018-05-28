module TOP_tb;
   /* parameter BITS = 'd32;
	parameter CGES = 'd13;
    logic clk, reset_n;
    logic start, fin;
    logic [$clog2(CGES) + BITS-'d1:0] result;
	logic [11:0]cges;

TOP #(BITS)U0
	(
		clk, 
        reset_n,
		cges,
		start, fin,
		result
    );

always begin #5; clk = ~clk; end 
	
longint i;
initial begin
		clk = 0; reset_n = 1; start = 0; fin = 0; cges = 0;
		#50	
		reset_n = 0;
		#50;
		start = 1;
		#100;
		for(i=0;i<3000;i=i+1)begin
		cges[((i/3)%12)] = 1;
		#10;	
		end

		fin = 1;  #50;
	$stop;
end
*/
/*
parameter INPUT = 5;
parameter BITS = 32;
logic [BITS*INPUT -'d1:0] in;
logic [BITS-'d1:0] pv_s, pv_c;

CSA_auto#(BITS, INPUT)U0(in, pv_s, pv_c);

int i,j;
initial begin
	in = 0; #10;
	for(i=0; i<20;i=i+1) begin
		for(j=0;j<INPUT;j=j+1)begin
			if(j%2)			in[BITS*j+:BITS] = {BITS{1'b1}};
			else 			in[BITS*j+:BITS] = 1;
			//in[BITS*j+:BITS] = 1;
			$display("%d",i<<j);
		end
		
		#10;
	end
	$stop;
end
*/
/*
parameter BITS = 32;
parameter INPUT = 7;
parameter CGES = 13;
parameter MAX   = 	$clog2(CGES) + BITS;
logic 					clk;
logic 					reset_n;
logic 					en;
logic   [CGES-'d1:1]    cges;
logic [MAX-'d1:0]		vs;
logic [MAX-'d1:0]		vc;

adder_tree_module #(BITS,CGES,MAX,INPUT)
		U3_CSA
    (
        clk,
        reset_n,
        en,
        cges,
        vs,
        vc
    );

int i,j;
always begin #5; clk = ~clk; end 
initial begin
	clk = 1; en = 1; reset_n = 0; cges = 0; #10;

	for(j=0;j<CGES-1;j=j+1)begin
	cges = cges << 1;
	cges = cges + 1;
	#30;
	end
	$stop;
end
*/

reg clk, reset_n;
reg s_read, s_write;
reg [3:0] s_addr;
reg [31:0] s_wdata;
wire [31:0] s_rdata;

power_emulator_ip a
   (
       clk, reset_n,
       s_read, s_write,
       s_addr,
	   s_wdata,
       s_rdata
   );

integer i,j;
always begin #5; clk = ~clk; end 

initial begin
	clk = 1; reset_n = 1; s_addr = 0; s_write = 1; #10;
	reset_n = 0; s_read = 1; #10;
	s_addr = 0; s_wdata = 1; #10;
	for(j=0;j<16 * 10;j=j+1)begin
	s_addr = j; #10;
	end
	$stop;
end
endmodule