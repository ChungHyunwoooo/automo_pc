//v file
//`include "../src/TOP.sv"
module power_emulator_ip
   (
      input clk, reset_n,
      input s_read, s_write,
      input [2:0] s_addr,
      input [31:0] s_wdata,
      output reg [31:0] s_rdata
   );
   localparam BITS = 'd32; //user accuracy
   localparam CGES = 'd13;
   localparam MAX = $clog2(CGES) + BITS;
   reg [MAX-'d1:0] result;
   wire m_start, fin;
   reg start;
   reg [31:0] mem [0:7];

  initial begin
    mem[0] = 32'h00000000;
    mem[1] = 32'h11111111;
    mem[2] = 32'h22222222;
    mem[3] = 32'h33333333;
    mem[4] = 32'h44444444;
    mem[5] = 32'h55555555;
    mem[6] = 32'h66666666;
    mem[7] = 32'h77777777;
  end


  always@(posedge clk) begin
    if(reset_n) begin
      if(s_read && (s_addr > 'd4)) begin
        s_rdata <= mem[s_addr];  
      end
    end
  end

  always@(posedge clk) begin
  if(reset_n) begin
      if(s_write && (s_addr < 'd4)) begin
        mem[s_addr] <= s_wdata;  
      end
    end
  end
endmodule