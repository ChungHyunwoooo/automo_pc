//v file
//`include "../src/TOP.sv"
module power_emulator_ip
   (
      clk, reset_n,
      s_read, s_write,
      s_addr,
      s_wdata,
      s_rdata
   );
	
	input clk, reset_n;
	input s_read, s_write;
	input [1:0] s_addr;
	input [31:0] s_wdata;
	output reg [31:0] s_rdata;
	
   localparam BITS = 'd32; //user accuracy
   localparam CGES = 'd13;
   localparam MAX = $clog2(CGES) + BITS;
	
	
	wire [3+BITS:0] result;
	//wire start, fin;
	reg start, fin;
	reg [31:0] mem [0:3];
	
	
	
	TOP #(BITS,CGES)
      U1_TOP
      (
         clk,
         reset_n,
         start,
         fin,
         result
      );
	
	
	
	initial begin
		mem[0] = 32'h00000000;
		mem[1] = 32'h00112233;
		mem[2] = 32'h00000000;
		mem[3] = 32'h00000000;
	end
	
	
	//assign	start = mem[0][0];
	//assign	fin = mem[0][1];
	
  
	//Read
	always@(posedge clk) begin
		if(reset_n) begin
			if(s_read) begin
				s_rdata <= mem[s_addr];  
			end
		end
	end
	
	
	//Write
	always@(posedge clk) begin
		if(reset_n) begin
			if(s_write) begin
				mem[s_addr] <= s_wdata;  
			end
		end
		
		if(BITS > 'd28) begin
			mem[2] <= result[3+BITS:32];
			mem[3] <= result[31:0];
		end
		else begin
			mem[2] <= result[3+BITS:0];
		end
		
		
		start <= mem[0][0];
		fin <= mem[0][1];
	end
	
endmodule
