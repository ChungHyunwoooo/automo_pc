`include "../src/CSA_auto.sv"
module adder_tree_module
    #(
        parameter 				BITS  = 	'd32,
        parameter 				CGES  = 	'd1015,
        parameter 				MAX   = 	$clog2(CGES) + BITS,
        parameter 				INPUT = 	'd7 
    )
    (
        input 						clk,
        input 						reset_n,
        input 						en,
        input 	[MAX-'d1:0] 	coeff 	[CGES-'d1:0],
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
	



    logic [MAX-'d1:0] w_CSA_1 [level1_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_2 [level2_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_3 [level3_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_4 [level4_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_5 [level5_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_6 [level5_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_7 [level5_r-'d1:0];
	 logic [MAX-'d1:0] w_CSA_8 [level5_r-'d1:0];
    logic [MAX-'d1:0] w_CSA_9 [level5_r-'d1:0];
	 
    logic [MAX-'d1:0] w_reg_1 [level1_r-'d1:0];
    logic [MAX-'d1:0] w_reg_2 [level2_r-'d1:0];
    logic [MAX-'d1:0] w_reg_3 [level3_r-'d1:0];
    logic [MAX-'d1:0] w_reg_4 [level4_r-'d1:0];
    logic [MAX-'d1:0] w_reg_5 [level5_r-'d1:0];
    logic [MAX-'d1:0] w_reg_6 [level2_r-'d1:0];
    logic [MAX-'d1:0] w_reg_7 [level3_r-'d1:0];
    logic [MAX-'d1:0] w_reg_8 [level4_r-'d1:0];
    logic [MAX-'d1:0] w_reg_9 [level5_r-'d1:0];

    generate 
        if(level1_d>0) begin: parellel_level1
            for(i=0;i<level1_d;i=i+1)begin:level1
                CSA_auto #(MAX,INPUT) U1_CSA (coeff[INPUT*i+:INPUT], w_CSA_1[i],w_CSA_1[i+level1_d]);
                reg_en_BITS #(MAX) U1_REG_s (clk, reset_n, en, w_CSA_1[i], w_reg_1[i]);
                reg_en_BITS #(MAX) U1_REG_c (clk, reset_n, en, w_CSA_1[i+level1_d], w_reg_1[i+level1_d]);
            end
            for(i=0;i<(CGES%INPUT);i=i+1)begin:level1_bypass
                reg_en_BITS #(MAX) U1_REG (clk, reset_n, en, coeff[(INPUT*level1_d)+i], w_reg_1[(2*level1_d)+i]);
            end
        end
        else begin
            CSA_auto #(MAX,level1_r) U1_CSA (coeff, w_CSA_1[0],w_CSA_1[1]);
				reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_1[0], w_reg_1[0]);
            reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_1[1], w_reg_1[1]);
            assign vs = w_reg_1[0];
            assign vc = w_reg_1[1];
        end

        if(level2_d>0) begin: parellel_level2
            for(i=0;i<level2_d;i=i+1)begin:level2
                CSA_auto #(MAX,INPUT) U2_CSA (w_reg_1[INPUT*i+:INPUT], w_CSA_2[i],w_CSA_2[i+level2_d]);
                reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_2[i], w_reg_2[i]);
                reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_2[i+level2_d], w_reg_2[i+level2_d]);
            end
            for(i=0;i<level1_r-(level2_d*INPUT);i=i+1)begin:level2_bypass
                reg_en_BITS #(MAX) U2_REG (clk, reset_n, en, w_reg_1[(INPUT*level2_d)+i], w_reg_2[(2*level2_d)+i]);
            end
        end
        else if(level2_r > 2 && level1_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level2_r) U2_CSA (w_reg_1, w_CSA_2[0],w_CSA_2[1]);
            reg_en_BITS #(MAX) U2_REG_s (clk, reset_n, en, w_CSA_2[0], w_reg_2[0]);
            reg_en_BITS #(MAX) U2_REG_c (clk, reset_n, en, w_CSA_2[1], w_reg_2[1]);
            assign vs = w_reg_2[0];
            assign vc = w_reg_2[1];
        end
        else if(level2_r == 2) begin
            assign vs = w_reg_1[0];
            assign vc = w_reg_1[1];
        end

        if(level3_d>0) begin: parellel_level3
            for(i=0;i<level3_d;i=i+1)begin:level3
                CSA_auto #(MAX,INPUT) U3_CSA (w_reg_2[INPUT*i+:INPUT], w_CSA_3[i],w_CSA_3[i+level3_d]);
                reg_en_BITS #(MAX) U3_REG_s (clk, reset_n, en, w_CSA_3[i], w_reg_3[i]);
                reg_en_BITS #(MAX) U3_REG_c (clk, reset_n, en, w_CSA_3[i+level3_d], w_reg_3[i+level3_d]);
            end
            for(i=0;i<level2_r-(level3_d*INPUT);i=i+1)begin:level3_bypass
                reg_en_BITS #(MAX) U3_REG (clk, reset_n, en, w_reg_2[(INPUT*level3_d)+i], w_reg_3[(2*level3_d)+i]);
            end
        end
        else if(level3_r > 2 && level2_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level3_r) U3_CSA (w_reg_2, w_CSA_3[0],w_CSA_3[1]);
            reg_en_BITS #(MAX) U3_REG_s (clk, reset_n, en, w_CSA_3[0], w_reg_3[0]);
            reg_en_BITS #(MAX) U3_REG_c (clk, reset_n, en, w_CSA_3[1], w_reg_3[1]);
            assign vs = w_reg_3[0];
            assign vc = w_reg_3[1];
        end
        else if(level3_r == 2 && level2_d != 0) begin
            assign vs = w_reg_2[0];
            assign vc = w_reg_2[1];
        end
		  
		if(level4_d>0) begin: parellel_level4
            for(i=0;i<level4_d;i=i+1)begin:level4
                CSA_auto #(MAX,INPUT) U4_CSA (w_reg_3[INPUT*i+:INPUT], w_CSA_4[i],w_CSA_4[i+level4_d]);
                reg_en_BITS #(MAX) U4_REG_s (clk, reset_n, en, w_CSA_4[i], w_reg_4[i]);
                reg_en_BITS #(MAX) U4_REG_c (clk, reset_n, en, w_CSA_4[i+level4_d], w_reg_4[i+level4_d]);
            end
            for(i=0;i<level3_r-(level4_d*INPUT);i=i+1)begin:level4_bypass
                reg_en_BITS #(MAX) U4_REG (clk, reset_n, en, w_reg_3[(INPUT*level4_d)+i], w_reg_4[(2*level4_d)+i]);
            end
        end
        else if(level4_r > 2 && level3_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level4_r) U3_CSA (w_reg_3, w_CSA_4[0],w_CSA_4[1]);
            reg_en_BITS #(MAX) U4_REG_s (clk, reset_n, en, w_CSA_4[0], w_reg_4[0]);
            reg_en_BITS #(MAX) U4_REG_c (clk, reset_n, en, w_CSA_4[1], w_reg_4[1]);
            assign vs = w_reg_4[0];
            assign vc = w_reg_4[1];
        end
        else if(level4_r == 2 && level3_d != 0) begin
            assign vs = w_reg_3[0];
            assign vc = w_reg_3[1];
        end
       
		 if(level5_d>0) begin: parellel_level5
            for(i=0;i<level5_d;i=i+1)begin:level5
                CSA_auto #(MAX,INPUT) U5_CSA (w_reg_4[INPUT*i+:INPUT], w_CSA_5[i],w_CSA_5[i+level5_d]);
                reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_5[i], w_reg_5[i]);
                reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_5[i+level5_d], w_reg_5[i+level5_d]);
            end
            for(i=0;i<level4_r-(level5_d*INPUT);i=i+1)begin:level5_bypass
                reg_en_BITS #(MAX) U5_REG (clk, reset_n, en, w_reg_4[(INPUT*level5_d)+i], w_reg_5[(2*level5_d)+i]);
            end
        end
        else if(level5_r > 2 && level4_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level4_r) U5_CSA (w_reg_4, w_CSA_5[0],w_CSA_5[1]);
            reg_en_BITS #(MAX) U5_REG_s (clk, reset_n, en, w_CSA_5[0], w_reg_5[0]);
            reg_en_BITS #(MAX) U5_REG_c (clk, reset_n, en, w_CSA_5[1], w_reg_5[1]);
            assign vs = w_reg_5[0];
            assign vc = w_reg_5[1];
        end
        else if(level5_r == 2 && level4_d != 0) begin
            assign vs = w_reg_4[0];
            assign vc = w_reg_4[1];
        end
		  
		   if(level6_d>0) begin: parellel_level6
            for(i=0;i<level6_d;i=i+1)begin:level6
                CSA_auto #(MAX,INPUT) U5_CSA (w_reg_5[INPUT*i+:INPUT], w_CSA_6[i],w_CSA_6[i+level6_d]);
                reg_en_BITS #(MAX) U6_REG_s (clk, reset_n, en, w_CSA_6[i], w_reg_6[i]);
                reg_en_BITS #(MAX) U6_REG_c (clk, reset_n, en, w_CSA_6[i+level6_d], w_reg_4[i+level6_d]);
            end
            for(i=0;i<level5_r-(level6_d*INPUT);i=i+1)begin:level6_bypass
                reg_en_BITS #(MAX) U5_REG (clk, reset_n, en, w_reg_5[(INPUT*level6_d)+i], w_reg_6[(2*level6_d)+i]);
            end
        end
        else if(level6_r > 2 && level5_d != 0) begin //(level2_r이 input보다 작음)
            CSA_auto #(MAX,level5_r) U6_CSA (w_reg_5, w_CSA_6[0],w_CSA_6[1]);
            reg_en_BITS #(MAX) U6_REG_s (clk, reset_n, en, w_CSA_6[0], w_reg_6[0]);
            reg_en_BITS #(MAX) U6_REG_c (clk, reset_n, en, w_CSA_6[1], w_reg_6[1]);
            assign vs = w_reg_6[0];
            assign vc = w_reg_6[1];
        end
        else if(level6_r == 2 && level5_d != 0) begin
            assign vs = w_reg_5[0];
            assign vc = w_reg_5[1];
        end
		 
        
	


    
endgenerate

endmodule