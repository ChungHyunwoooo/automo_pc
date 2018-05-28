`ifndef REG__MODULE
`define REG__MODULE
`include "../src/register_module.sv"
`endif

`include "../src/CSA_auto.sv"
`include "../src/multi_andgate.sv"
`include "../src/sign_extend.sv"

module adder_tree_module
    #(
        parameter 				BITS  = 	'd32,
        parameter 				CGES  = 	'd13,
        parameter 				MAX   = 	$clog2(CGES) + BITS,
        parameter 				INPUT = 	'd7 
    )
    (
        input 						clk,
        input 						reset_n,
        input 						en,
        input   [CGES-'d1:1]      cges,
        output [MAX-'d1:0]		vs,
        output [MAX-'d1:0]		vc
    );

    //adder block
    genvar i;
	localparam level1_d = CGES/INPUT;
	localparam level1_r = (2*level1_d)+(CGES%INPUT);
	localparam level2_d = level1_r/INPUT;
	localparam level2_r = (2*level2_d)+(level1_r%INPUT);
	localparam level3_d = level2_r/INPUT;
	localparam level3_r = (2*level3_d)+(level2_r%INPUT);
	localparam level4_d = level3_r/INPUT;
	localparam level4_r = (2*level4_d)+(level3_r%INPUT);
	localparam level5_d = level4_r/INPUT;
	localparam level5_r = (2*level5_d)+(level4_r%INPUT);
	localparam level6_d = level5_r/INPUT;
	localparam level6_r = (2*level6_d)+(level5_r%INPUT);
	localparam level7_d = level6_r/INPUT;
	localparam level7_r = (2*level7_d)+(level6_r%INPUT);
	localparam level8_d = level7_r/INPUT;
	localparam level8_r = (2*level8_d)+(level7_r%INPUT);
	localparam level9_d = level8_r/INPUT;
	localparam level9_r = (2*level9_d)+(level8_r%INPUT);
	



    logic [MAX*level1_r-'d1:0] w_CSA_1;
    logic [MAX*level2_r-'d1:0] w_CSA_2;
    logic [MAX*level3_r-'d1:0] w_CSA_3;
    logic [MAX*level4_r-'d1:0] w_CSA_4;
    logic [MAX*level5_r-'d1:0] w_CSA_5;
    logic [MAX*level5_r-'d1:0] w_CSA_6;
    logic [MAX*level5_r-'d1:0] w_CSA_7;
	logic [MAX*level5_r-'d1:0] w_CSA_8;
    logic [MAX*level5_r-'d1:0] w_CSA_9;
	 
    logic [MAX*level1_r-'d1:0] w_reg_1;
    logic [MAX*level2_r-'d1:0] w_reg_2;
    logic [MAX*level3_r-'d1:0] w_reg_3;
    logic [MAX*level4_r-'d1:0] w_reg_4;
    logic [MAX*level5_r-'d1:0] w_reg_5;
    logic [MAX*level2_r-'d1:0] w_reg_6;
    logic [MAX*level3_r-'d1:0] w_reg_7;
    logic [MAX*level4_r-'d1:0] w_reg_8;
    logic [MAX*level5_r-'d1:0] w_reg_9;
    
    logic [BITS-'d1:0] mem_coeff [CGES-'d1:0];
    logic [BITS-'d1:0]  r_coeff [CGES-'d1:0];
    logic [BITS-'d1:0]  a_coeff [CGES-'d1:0];
    logic [MAX*CGES-'d1:0] coeff;
    
    integer j, initi = 32'hFFFFFFFF;
    //register set
    initial begin
        $readmemb("C:/altera/projects/power_emulator_25/src/init.mem", mem_coeff);
        /*
        for(j=0;j<CGES;j=j+1) begin
            mem_coeff[j] <= initi;
        end
        */
    end
    

	
    
    //multi-andgate
    assign a_coeff[0] = mem_coeff[0];
    generate 
		for(i=1;i<CGES;i=i+'d1) begin: and_coeff
			multi_andgate #(BITS) 
            U2_multi (
                mem_coeff[i], 
                cges[i], 
                a_coeff[i]
            );
		end
    endgenerate

    //signextend
    generate 
        for(i=0;i<CGES;i=i+1) begin:U3_sign_extend
            sign_extend #(BITS, MAX) 
            U3_ext(
                a_coeff[i], 
                coeff[MAX*i+:MAX]
            );
        end
	endgenerate
    generate 
        if(level1_d>0) begin: parellel_level1
            for(i=0;i<level1_d;i=i+1)begin:level1
                CSA_auto #(MAX,INPUT) U1_CSA (coeff[MAX*INPUT*i+:MAX*INPUT], w_CSA_1[MAX*i+:MAX], w_CSA_1[MAX*(i+level1_d)+:MAX]);
                reg_en_BITS #(MAX) U1_REG_s (clk, reset_n, en, w_CSA_1[MAX*i+:MAX], w_reg_1[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U1_REG_c (clk, reset_n, en, w_CSA_1[MAX*(i+level1_d)+:MAX], w_reg_1[MAX*(i+level1_d)+:MAX]);
            end
            for(i=0;i<CGES-(level1_d*INPUT);i=i+1)begin:level1_bypass
                reg_en_BITS #(MAX) U1_REG (clk, reset_n, en, coeff[MAX*(INPUT*level1_d+i)+:MAX], w_reg_1[MAX*((2*level1_d)+i)+:MAX]);
            end
        end
        else begin
            CSA_auto #(MAX,level1_r) U1_CSA (coeff[MAX*level1_r-'d1:0], w_CSA_1[MAX*1-'d1:0],w_CSA_1[MAX*2-'d1:MAX]);
			reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_1[MAX*0+:MAX], w_reg_1[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_1[MAX*1+:MAX], w_reg_1[MAX*1+:MAX]);
            assign vs = w_reg_1[MAX*1-'d1:MAX*0];
            assign vc = w_reg_1[MAX*2-'d1:MAX*1];
        end

        if(level2_d>0) begin: parellel_level2
            for(i=0;i<level2_d;i=i+1)begin:level2
                CSA_auto #(MAX,INPUT) U2_CSA (w_reg_1[MAX*INPUT*i+:MAX*INPUT], w_CSA_2[MAX*i+:MAX], w_CSA_2[MAX*(i+level2_d)+:MAX]);
                reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_2[MAX*i+:MAX], w_reg_2[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_2[MAX*(i+level2_d)+:MAX], w_reg_2[MAX*(i+level2_d)+:MAX]);
            end
            for(i=0;i<level1_r-(level2_d*INPUT);i=i+1)begin:level2_bypass
                reg_en_BITS #(MAX) U2_REG (clk, reset_n, en, w_reg_1[MAX*(INPUT*level2_d+i)+:MAX], w_reg_2[MAX*((2*level2_d)+i)+:MAX]);
            end
        end
        else if(level2_r > 2 && level1_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level2_r) U2_CSA (w_reg_1[MAX*level2_r-'d1:0], w_CSA_2[MAX*1-'d1:0],w_CSA_2[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_2[MAX*0+:MAX], w_reg_2[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_2[MAX*1+:MAX], w_reg_2[MAX*1+:MAX]);
            assign vs = w_reg_2[MAX*1-'d1:MAX*0];
            assign vc = w_reg_2[MAX*2-'d1:MAX*1];
        end
        else if(level2_r == 2) begin
            assign vs = w_reg_1[MAX*1-'d1:MAX*0];
            assign vc = w_reg_1[MAX*2-'d1:MAX*1];
        end

        if(level3_d>0) begin: parellel_level3
            for(i=0;i<level3_d;i=i+1)begin:level3
                CSA_auto #(MAX,INPUT) U3_CSA (w_reg_2[MAX*INPUT*i+:MAX*INPUT], w_CSA_3[MAX*i+:MAX], w_CSA_3[MAX*(i+level3_d)+:MAX]);
                reg_en_BITS #(MAX) U3_REG_s (clk, reset_n, en, w_CSA_3[MAX*i+:MAX], w_reg_3[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U3_REG_c (clk, reset_n, en, w_CSA_3[MAX*(i+level3_d)+:MAX], w_reg_3[MAX*(i+level3_d)+:MAX]);
            end
            for(i=0;i<level2_r-(level3_d*INPUT);i=i+1)begin:level3_bypass
                reg_en_BITS #(MAX) U3_REG (clk, reset_n, en, w_reg_2[MAX*(INPUT*level3_d+i)+:MAX], w_reg_3[MAX*((2*level3_d)+i)+:MAX]);
            end
        end
        else if(level3_r > 2 && level2_d != 0) begin //(level3_r이 input보다 작음)
            CSA_auto #(MAX,level3_r) U3_CSA (w_reg_2[MAX*level3_r-'d1:0], w_CSA_3[MAX*1-'d1:0],w_CSA_3[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U3_REG_s (clk, reset_n, en, w_CSA_3[MAX*0+:MAX], w_reg_3[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U3_REG_c (clk, reset_n, en, w_CSA_3[MAX*1+:MAX], w_reg_3[MAX*1+:MAX]);
            assign vs = w_reg_3[MAX*1-'d1:MAX*0];
            assign vc = w_reg_3[MAX*2-'d1:MAX*1];
        end
        else if(level3_r == 2 && level2_d != 0) begin
            assign vs = w_reg_2[MAX*1-'d1:MAX*0];
            assign vc = w_reg_2[MAX*2-'d1:MAX*1];
        end

        if(level4_d>0) begin: parellel_level4
            for(i=0;i<level4_d;i=i+1)begin:level4
                CSA_auto #(MAX,INPUT) U4_CSA (w_reg_3[MAX*INPUT*i+:MAX*INPUT], w_CSA_4[MAX*i+:MAX], w_CSA_4[MAX*(i+level4_d)+:MAX]);
                reg_en_BITS #(MAX) U4_REG_s (clk, reset_n, en, w_CSA_4[MAX*i+:MAX], w_reg_4[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U4_REG_c (clk, reset_n, en, w_CSA_4[MAX*(i+level4_d)+:MAX], w_reg_4[MAX*(i+level4_d)+:MAX]);
            end
            for(i=0;i<level3_r-(level4_d*INPUT);i=i+1)begin:level4_bypass
                reg_en_BITS #(MAX) U4_REG (clk, reset_n, en, w_reg_3[MAX*(INPUT*level4_d+i)+:MAX], w_reg_4[MAX*((2*level4_d)+i)+:MAX]);
            end
        end
        else if(level4_r > 2 && level3_d != 0) begin //(level4_r이 input보다 작음)
            CSA_auto #(MAX,level4_r) U4_CSA (w_reg_3[MAX*level4_r-'d1:0], w_CSA_4[MAX*1-'d1:0],w_CSA_4[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U4_REG_s (clk, reset_n, en, w_CSA_4[MAX*0+:MAX], w_reg_4[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U4_REG_c (clk, reset_n, en, w_CSA_4[MAX*1+:MAX], w_reg_4[MAX*1+:MAX]);
            assign vs = w_reg_4[MAX*1-'d1:MAX*0];
            assign vc = w_reg_4[MAX*2-'d1:MAX*1];
        end
        else if(level4_r == 2 && level3_d != 0) begin
            assign vs = w_reg_3[MAX*1-'d1:MAX*0];
            assign vc = w_reg_3[MAX*2-'d1:MAX*1];
        end

        if(level5_d>0) begin: parellel_level5
            for(i=0;i<level5_d;i=i+1)begin:level5
                CSA_auto #(MAX,INPUT) U5_CSA (w_reg_4[MAX*INPUT*i+:MAX*INPUT], w_CSA_5[MAX*i+:MAX], w_CSA_5[MAX*(i+level5_d)+:MAX]);
                reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_5[MAX*i+:MAX], w_reg_5[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_5[MAX*(i+level5_d)+:MAX], w_reg_5[MAX*(i+level5_d)+:MAX]);
            end
            for(i=0;i<level4_r-(level5_d*INPUT);i=i+1)begin:level5_bypass
                reg_en_BITS #(MAX) U5_REG (clk, reset_n, en, w_reg_4[MAX*(INPUT*level5_d+i)+:MAX], w_reg_5[MAX*((2*level5_d)+i)+:MAX]);
            end
        end
        else if(level5_r > 2 && level4_d != 0) begin //(level5_r이 input보다 작음)
            CSA_auto #(MAX,level5_r) U5_CSA (w_reg_4[MAX*level5_r-'d1:0], w_CSA_5[MAX*1-'d1:0],w_CSA_5[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_5[MAX*0+:MAX], w_reg_5[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_5[MAX*1+:MAX], w_reg_5[MAX*1+:MAX]);
            assign vs = w_reg_5[MAX*1-'d1:MAX*0];
            assign vc = w_reg_5[MAX*2-'d1:MAX*1];
        end
        else if(level5_r == 2 && level4_d != 0) begin
            assign vs = w_reg_4[MAX*1-'d1:MAX*0];
            assign vc = w_reg_4[MAX*2-'d1:MAX*1];
        end

        if(level6_d>0) begin: parellel_level6
            for(i=0;i<level6_d;i=i+1)begin:level6
                CSA_auto #(MAX,INPUT) U5_CSA (w_reg_5[MAX*INPUT*i+:MAX*INPUT], w_CSA_6[MAX*i+:MAX], w_CSA_6[MAX*(i+level6_d)+:MAX]);
                reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_6[MAX*i+:MAX], w_reg_6[MAX*i+:MAX]);
                reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_6[MAX*(i+level6_d)+:MAX], w_reg_6[MAX*(i+level6_d)+:MAX]);
            end
            for(i=0;i<level5_r-(level6_d*INPUT);i=i+1)begin:level6_bypass
                reg_en_BITS #(MAX) U5_REG (clk, reset_n, en, w_reg_6[MAX*(INPUT*level6_d+i)+:MAX], w_reg_6[MAX*((2*level6_d)+i)+:MAX]);
            end
        end
        else if(level6_r > 2 && level5_d != 0) begin //(level6_r이 input보다 작음)
            CSA_auto #(MAX,level6_r) U5_CSA (w_reg_5[MAX*level6_r-'d1:0], w_CSA_6[MAX*1-'d1:0],w_CSA_6[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_6[MAX*0+:MAX], w_reg_6[MAX*0+:MAX]);
            reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_6[MAX*1+:MAX], w_reg_6[MAX*1+:MAX]);
            assign vs = w_reg_6[MAX*1-'d1:MAX*0];
            assign vc = w_reg_6[MAX*2-'d1:MAX*1];
        end
        else if(level6_r == 2 && level5_d != 0) begin
            assign vs = w_reg_5[MAX*1-'d1:MAX*0];
            assign vc = w_reg_5[MAX*2-'d1:MAX*1];
        end

        else if(level7_r > 2 && level6_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level6_r) U6_CSA (w_reg_6[MAX*level6_r-'d1:0], w_CSA_7[MAX*1-'d1:0],w_CSA_7[MAX*2-'d1:MAX]);
            reg_en_BITS #(MAX) U6_REG_s (clk, reset_n, en, w_CSA_7[MAX*1-'d1:MAX*0], w_reg_7[MAX*1-'d1:MAX*0]);
            reg_en_BITS #(MAX) U6_REG_c (clk, reset_n, en, w_CSA_7[MAX*2-'d1:MAX*1], w_reg_7[MAX*2-'d1:MAX*1]);
            assign vs = w_reg_7[MAX*1-'d1:MAX*0];
            assign vc = w_reg_7[MAX*2-'d1:MAX*1];
        end
        else if(level7_r == 2 && level6_d != 0) begin
            assign vs = w_reg_6[MAX*1-'d1:MAX*0];
            assign vc = w_reg_6[MAX*2-'d1:MAX*1];
        end
endgenerate

endmodule