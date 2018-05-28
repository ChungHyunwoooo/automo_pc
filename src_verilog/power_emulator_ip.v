`define SRC_INC_PPA_KS
module power_emulator_ip
   (
      input clk, reset_n,
      input s_read, s_write,
      input [1:0] s_addr,
      input [31:0] s_wdata,
      output reg [31:0] s_rdata
   );
   localparam BITS = 'd32; //user accuracy
   localparam CGES = 'd13;
   localparam MAX = $clog2(CGES) + BITS;
   wire [MAX-'d1:0] result;
   wire start, fin;
	wire [31:0]result_cpa;
   reg [31:0] mem [0:15];
	reg [31:0] temp = 32'hffFFFFFF;
  wire [MAX-'d1:0] vs;
   wire [MAX-'d1:0] vc;
   //최종 목표 모듈
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
      mem[0] = 32'd0;
      mem[1] = 32'd1;
      mem[2] = 32'd2;
    end
   
     // Register File Read
   always @(posedge clk) begin
		if(reset_n) 
      // READ
      if(s_read == 1) begin
        s_rdata <= mem[s_addr];
      end
      
      // WRITE
      if(s_write == 1) begin
		    mem[s_addr] <= s_wdata;
      end
      //mem[2] <= 32'hFFFFFFFF;
      //mem[3] <= 32'h11111111;
      
      //최종 목표
      mem[1] <= result[31:0];
      mem[2] <= {28'd0, result[35:32]};
   end
    assign start = mem[0][0];
    assign fin   = mem[0][1];
  
endmodule