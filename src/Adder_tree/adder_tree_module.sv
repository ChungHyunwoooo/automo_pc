`include "../Adder_tree/CSA_auto.sv"
module adder_tree_module
    #(
        parameter BITS  = 'd32,
        parameter CGES  = 'd49,
        parameter MAX   = $clog2(CGES) + BITS,
        parameter INPUT = 'd7 
    )
    (
        input clk,
        input reset_n,
        input en,
        input [MAX-'d1:0] coeff [CGES-'d1:0],
        output [MAX-'d1:0]vs,
        output [MAX-'d1:0]vc
    );

    //adder block
    genvar i;
    localparam level1_d = CGES/INPUT;
	localparam level1_r = (2*level1_d)+(CGES%INPUT);
	localparam level2_d = level1_r/INPUT;
	localparam level2_r = (level1_r==1)? 1 : level2_d+(level1_r%INPUT);
	localparam level3_d = level2_r/INPUT;
	localparam level3_r = (level2_r==1)? 1 : level3_d+(level2_r%INPUT);
	localparam level4_d = level3_r/INPUT;
	localparam level4_r = (level3_r==1)? 1 : level4_d+(level3_r%INPUT);
	localparam level5_d = level4_r/INPUT;
	localparam level5_r = (level4_r==1)? 1 : level5_d+(level4_r%INPUT);

    logic [(2*level1_d)-'d1:0] w_CSA_1;
    logic [(2*level2_d)-'d1:0] w_CSA_2;
    logic [(2*level3_d)-'d1:0] w_CSA_3;
    logic [(2*level4_d)-'d1:0] w_CSA_4;
    logic [(2*level5_d)-'d1:0] w_CSA_5;

    
    logic [level1_r-'d1:0] w_reg_1;
    

    generate begin
        if(level1_d>=1) begin: parellel_level1
            for(i=0;i<level1_d;i++)begin:level1
                CSA_auto #(MAX,INPUT) U1_CSA (coeff[INPUT*i+:INPUT], w_CSA_1[i],w_CSA_1[i+level1_d]);
                reg_en_BITS #(MAX) U1_REG_s (clk, reset_n, en, w_CSA_1[i], w_reg_1[i]);
                reg_en_BITS #(MAX) U1_REG_c (clk, reset_n, en, w_CSA_1[i+level1_d], w_reg_1[i+level1_d]);
            end
            for(i=0;i<(CGES%INPUT);i++)begin:level1__
                reg_en_BITS #(MAX) U1_REG_c (clk, reset_n, en, coeff[(2*level1_d)+i], w_reg_1[(2*level1_d)+i]);
            end
        end
        else begin
            if(level1_r>2) begin
				CSA_auto #(MAX, level1_r) U2_CSA (coeff[level1_r:0], w_CSA_1[0],w_CSA_1[1]);
				reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_1[0], w_reg_1[0]);
                reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_1[1], w_reg_1[1]);
                assign vs = w_reg_1[0];
                assign vc = w_reg_1[1];
			end
			else if(level1_r == 2) begin
                reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, coeff[0], w_reg_1[0]);
                reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, coeff[1], w_reg_1[1]);
				assign vs = w_reg_1[0];
                assign vc = w_reg_1[1];
			end
            
        end

        
	


    end
endgenerate

endmodule