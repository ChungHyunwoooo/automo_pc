
`ifndef PARALLEL_PREFIX_ADDER_CELL
`define PARALLEL_PREFIX_ADDER_CELL
`include "../src/parallel_prefix_adder_cell.sv"
`endif
// Support bitwidth: 1~128 bits
module parallel_prefix_adder_Ladner_Fisher_adder
    #(
        parameter BITS='d4
    )
    (
        input   logic [BITS-'d1:'d0] a,
        input   logic [BITS-'d1:'d0] b,
        input   logic ci,
        output  logic [BITS-'d1:'d0] s,
        output  logic co
    );

    localparam LOGIC_DEPTH = $clog2(BITS);

    logic [BITS-'d1:'d0] c_a; // Alive carry-in
    logic [BITS-'d1:'d0] c_k; // Kill (stop) carry-in
    logic [BITS-'d1:'d0] c_p; // Propagate carry-in
    logic [BITS-'d1:'d0] c_g; // Generate carry-out 

    assign c_a = a | b; 
    //assign c_k = ~(c_a); 
    assign c_p = a ^ b;
    assign c_g = a & b;


    genvar j;
    genvar i;

    generate
        assign s[0] = c_p[0] ^ ci;
        logic [BITS-1:0] lv1_g;
        logic [BITS-1:0] lv1_a;
        logic [BITS-1:0] lv2_g;
        logic [BITS-1:0] lv2_a;    
        logic [BITS-1:0] lv3_g;
        logic [BITS-1:0] lv3_a;    
        logic [BITS-1:0] lv4_g;
        logic [BITS-1:0] lv4_a;    
        logic [BITS-1:0] lv5_g;
        logic [BITS-1:0] lv5_a;
        logic [BITS-1:0] lv6_g;
        logic [BITS-1:0] lv6_a;
        logic [BITS-1:0] lv7_g;
        logic [BITS-1:0] lv7_a;

        // Carry out
        if(BITS==1)begin
            cell_g
                u_cell_g(
                    .gl(c_g),
                    .al(c_a),
                    .gr(ci),
                    .go(co)
                );
        end // end of if

        // Level 1
        if(LOGIC_DEPTH>=1)begin:LV1
            for(i=0;i<BITS;i=i+'d1)begin:LV11
                if(i==0)begin:LV111
                    cell_g
                        u_cell_g(
                        .gl(c_g[i]),
                        .al(c_a[i]),
                        .gr(ci),
                        .go(lv1_g[i])
                    );
                end // enf of if
                else if(i%2==0)begin
                    cell_ga
                        u_cell_g(
                        .gl(c_g[i]),
                        .al(c_a[i]),
                        .gr(c_g[i-1]),
                        .ar(c_a[i-1]),
                        .go(lv1_g[i]),
                        .ao(lv1_a[i])
                    );
                end // end of else if
                else begin // Wiring
                    assign lv1_g[i] = c_g[i];
                    assign lv1_a[i] = c_a[i];
                end
            end // enf of for
            
            // Sum of Level 1
            if(BITS>1)  assign s[1] = c_p[1] ^ lv1_g[0];
        
            // Carry out of Level 1
            if(BITS==2)begin
                cell_g
                    u_cell_g(
                        .gl(lv1_g[1]),
                        .al(lv1_a[1]),
                        .gr(lv1_g[0]),
                        .go(co)
                    );
            end
        end // end of if

        // Level 2
        if(LOGIC_DEPTH>=2)begin:LV2
            for(i=1;i<BITS;i=i+'d4)begin:LV21
                for(j=0;j<2;j=j+1)begin:LV211
                    if(i+j<BITS)begin
                        if(i==1)begin
                            cell_g
                                u_cell_g(
                                .gl(lv1_g[i+j]),
                                .al(lv1_a[i+j]),
                                .gr(lv1_g[i-1]),
                                .go(lv2_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv1_g[i+j]),
                                .al(lv1_a[i+j]),
                                .gr(lv1_g[i-1]),
                                .ar(lv1_a[i-1]),
                                .go(lv2_g[i+j]),
                                .ao(lv2_a[i+j])
                            );
                        end // end of else
                    end //end of if
                end // end of for
					 
                // Wiring
                for(j=2;j<4;j=j+1)begin:LV22
                    if(i+j<BITS)begin
                        assign lv2_g[i+j] = lv1_g[i+j];
                        assign lv2_a[i+j] = lv1_a[i+j];
                    end
                end
            end // end of for

            // Sum of Level 2
            for(i=2;i<4;i=i+1)begin:LV23
                if(BITS>i) assign s[i] = c_p[i] ^ lv2_g[i-1];
            end // end of for

            // Carry out of Level 2
            if(BITS==3)begin
                assign co = lv2_g[BITS-1];
            end          
            else if(BITS==4)begin
                cell_g
                    u_cell_g(
                        .gl(lv2_g[BITS-1]),
                        .al(lv2_a[BITS-1]),
                        .gr(lv2_g[BITS-2]),
                        .go(co)
                    );
            end
        end // end of if


        // Level 3
        if(LOGIC_DEPTH>=3)begin:LV3
            for(i=3;i<BITS;i=i+'d8)begin:LV31
                for(j=0;j<4;j=j+1)begin:LV311
                    if(i+j<BITS)begin
                        if(i==3)begin
                            cell_g
                                u_cell_g(
                                .gl(lv2_g[i+j]),
                                .al(lv2_a[i+j]),
                                .gr(lv2_g[i-1]),
                                .go(lv3_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv2_g[i+j]),
                                .al(lv2_a[i+j]),
                                .gr(lv2_g[i-1]),
                                .ar(lv2_a[i-1]),
                                .go(lv3_g[i+j]),
                                .ao(lv3_a[i+j])
                            );
                        end // end of else
                    end // end of for
                end // end of if

                // Wiring
                for(j=4;j<8;j=j+1)begin:LV32
                    if(i+j<BITS)begin
                        assign lv3_g[i+j] = lv2_g[i+j];
                        assign lv3_a[i+j] = lv2_a[i+j];
                    end
                end
            end // end of for

            // Sum of Level 3
            for(i=4;i<8;i=i+1)begin:LV33
                if(BITS>i) assign s[i] = c_p[i] ^ lv3_g[i-1];
            end // end of for

             // Carry out of Level 3
            if(BITS<8)begin
                assign co = lv3_g[BITS-1];
            end          
            else if(BITS==8)begin
                cell_g
                    u_cell_g(
                        .gl(lv3_g[BITS-1]),
                        .al(lv3_a[BITS-1]),
                        .gr(lv3_g[BITS-2]),
                        .go(co)
                    );
            end
        end // end of if
        
        // Level 4
        if(LOGIC_DEPTH>=4)begin:LV4
            for(i=7;i<BITS;i=i+'d16)begin:LV41
                for(j=0;j<8;j=j+1)begin:LV411
                    if(i+j<BITS)begin
                        if(i==7)begin
                            cell_g
                                u_cell_g(
                                .gl(lv3_g[i+j]),
                                .al(lv3_a[i+j]),
                                .gr(lv3_g[i-1]),
                                .go(lv4_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv3_g[i+j]),
                                .al(lv3_a[i+j]),
                                .gr(lv3_g[i-1]),
                                .ar(lv3_a[i-1]),
                                .go(lv4_g[i+j]),
                                .ao(lv4_a[i+j])
                            );
                        end // end of else
                    end // end of for
                end // end of if
                
                // Wiring
                for(j=8;j<16;j=j+1)begin:LV42
                    if(i+j<BITS)begin
                        assign lv4_g[i+j] = lv3_g[i+j];
                        assign lv4_a[i+j] = lv3_a[i+j];
                    end
                end
            end // end of for

            // Sum of Level 4
            for(i=8;i<16;i=i+1)begin:LV43
                if(BITS>i) assign s[i] = c_p[i] ^ lv4_g[i-1];
            end // end of for

             // Carry out of Level 4
            if(BITS<16)begin
                assign co = lv4_g[BITS-1];
            end          
            else if(BITS==16)begin
                cell_g
                    u_cell_g(
                        .gl(lv4_g[BITS-1]),
                        .al(lv4_a[BITS-1]),
                        .gr(lv4_g[BITS-2]),
                        .go(co)
                    );
            end
        end // end of if        

        // Level 5
        if(LOGIC_DEPTH>=5)begin:LV5
            for(i=15;i<BITS;i=i+'d32)begin:LV51
                for(j=0;j<16;j=j+1)begin:LV511
                    if(i+j<BITS)begin
                        if(i==15)begin
                            cell_g
                                u_cell_g(
                                .gl(lv4_g[i+j]),
                                .al(lv4_a[i+j]),
                                .gr(lv4_g[i-1]),
                                .go(lv5_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv4_g[i+j]),
                                .al(lv4_a[i+j]),
                                .gr(lv4_g[i-1]),
                                .ar(lv4_a[i-1]),
                                .go(lv5_g[i+j]),
                                .ao(lv5_a[i+j])
                            );
                        end // end of else
                    end // end of for
                end // end of if

                // Wiring
                for(j=16;j<32;j=j+1)begin:LV52
                    if(i+j<BITS)begin
                        assign lv5_g[i+j] = lv4_g[i+j];
                        assign lv5_a[i+j] = lv4_a[i+j];
                    end // end of if
                end // end of for
            end // end of for

            // Sum of Level 5
            for(i=16;i<32;i=i+1)begin:LV53
                if(BITS>i) assign s[i] = c_p[i] ^ lv5_g[i-1];
            end // end of for
        
            // Carry out of Level 5
            if(BITS<32)begin
                assign co = lv5_g[BITS-1];
            end          
            else if(BITS==32)begin
                cell_g
                    u_cell_g(
                        .gl(lv5_g[BITS-1]),
                        .al(lv5_a[BITS-1]),
                        .gr(lv5_g[BITS-2]),
                        .go(co)
                    );
            end
        
        end // end of if

        // Level 6
        if(LOGIC_DEPTH>=6)begin:LV6
            for(i=31;i<BITS;i=i+'d64)begin:LV61
                for(j=0;j<32;j=j+1)begin:LV611
                    if(i+j<BITS)begin
                        if(i==31)begin
                            cell_g
                                u_cell_g(
                                .gl(lv5_g[i+j]),
                                .al(lv5_a[i+j]),
                                .gr(lv5_g[i-1]),
                                .go(lv6_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv5_g[i+j]),
                                .al(lv5_a[i+j]),
                                .gr(lv5_g[i-1]),
                                .ar(lv5_a[i-1]),
                                .go(lv6_g[i+j]),
                                .ao(lv6_a[i+j])
                            );
                        end // end of else
                    end // end of for
                end // end of if

                // Wiring
                for(j=32;j<64;j=j+1)begin:LV62
                    if(i+j<BITS)begin
                        assign lv6_g[i+j] = lv5_g[i+j];
                        assign lv6_a[i+j] = lv5_a[i+j];
                    end // end of if
                end // end of for
            end // end of for

            // Sum of Level 6
            for(i=32;i<64;i=i+1)begin:LV53
                if(BITS>i) assign s[i] = c_p[i] ^ lv6_g[i-1];
            end // end of for
        
            // Carry out of Level 6
            if(BITS<64)begin
                assign co = lv6_g[BITS-1];
            end          
            else if(BITS==64)begin
                cell_g
                    u_cell_g(
                        .gl(lv6_g[BITS-1]),
                        .al(lv6_a[BITS-1]),
                        .gr(lv6_g[BITS-2]),
                        .go(co)
                    );
            end
        end // end of if

        // Level 7
        if(LOGIC_DEPTH>=7)begin:LV7
            for(i=63;i<BITS;i=i+'d128)begin:LV71
                for(j=0;j<64;j=j+1)begin:LV711
                    if(i+j<BITS)begin
                        if(i==63)begin
                            cell_g
                                u_cell_g(
                                .gl(lv6_g[i+j]),
                                .al(lv6_a[i+j]),
                                .gr(lv6_g[i-1]),
                                .go(lv7_g[i+j])
                            );                   
                        end // end of if
                        else begin
                            cell_ga
                                u_cell_g(
                                .gl(lv6_g[i+j]),
                                .al(lv6_a[i+j]),
                                .gr(lv6_g[i-1]),
                                .ar(lv6_a[i-1]),
                                .go(lv7_g[i+j]),
                                .ao(lv7_a[i+j])
                            );
                        end // end of else
                    end // end of for
                end // end of if

                // Wiring
                for(j=64;j<128;j=j+1)begin:LV72
                    if(i+j<BITS)begin
                        assign lv7_g[i+j] = lv6_g[i+j];
                        assign lv7_a[i+j] = lv6_a[i+j];
                    end // end of if
                end // end of for
            end // end of for

            // Sum of Level 7
            for(i=64;i<128;i=i+1)begin:LV73
                if(BITS>i) assign s[i] = c_p[i] ^ lv7_g[i-1];
            end // end of for
        
            // Carry out of Level 7
            if(BITS<128)begin
                assign co = lv7_g[BITS-1];
            end          
            else if(BITS==128)begin
                cell_g
                    u_cell_g(
                        .gl(lv7_g[BITS-1]),
                        .al(lv7_a[BITS-1]),
                        .gr(lv7_g[BITS-2]),
                        .go(co)
                    );
            end
        end // end of if         
    endgenerate

endmodule
