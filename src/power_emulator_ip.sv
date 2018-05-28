`include "../src/TOP.sv"
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
   logic [MAX-'d1:0] result;
   logic start, fin;
   logic [31:0] mem [0:3];
   
   TOP #(BITS,CGES)
      U1_TOP
      (
         clk,
         reset_n,
         start,
         fin,
         result
      );
   
   // Register File Read
   always @(posedge clk) begin
   
      // READ
      if(s_read == 1 && (s_addr == 2 || s_addr == 3)) begin
         s_rdata <= mem[s_addr];
      end
      
      // WRITE
      if(s_write == 1 && (s_addr == 0 || s_addr == 1)) begin
			mem[s_addr] <= s_wdata;
      end
      mem[2] <= 32'hFFFFFFFF;
      mem[3] <= 32'h11111111;
      /*
      mem[2] <= result[31:0];
      mem[3] <= {28'd0, result[35:32]};
      start <= mem[0][0];
      fin   <= mem[0][1];
      */
      
      
   end
   
endmodule