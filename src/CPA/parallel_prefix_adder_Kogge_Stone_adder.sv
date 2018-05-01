

`ifndef PARALLEL_PREFIX_ADDER_CELL
`define PARALLEL_PREFIX_ADDER_CELL
`include "../src/parallel_prefix_adder_cell.sv"
`endif

// Support bitwidth: 1~128 bits
module parallel_prefix_adder_Kogge_Stone_adder
    #(
        parameter BITS='d8
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
    logic [BITS-'d1:'d0] c_p; // Propagate carry-in
    logic [BITS-'d1:'d0] c_g; // Generate carry-out 

    assign c_a = a | b; 
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
        end 

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
                end 
                else begin
                    cell_ga
                        u_cell_g(
                        .gl(c_g[i]),
                        .al(c_a[i]),
                        .gr(c_g[i-1]),
                        .ar(c_a[i-1]),
                        .go(lv1_g[i]),
                        .ao(lv1_a[i])
                    );
                end
            end
            
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
        end

        // Level 2
        if(LOGIC_DEPTH>=2)begin:LV2
            for(i=1;i<BITS;i=i+'d1)begin:LV21
                if(i==1)begin
                    cell_g
                        u_cell_g(
                            .gl(lv1_g[i]),
                            .al(lv1_a[i]),
                            .gr(ci),
                            .go(lv2_g[i])
                        );   
                end
                else if(i==2)begin
                    cell_g
                        u_cell_g(
                            .gl(lv1_g[i]),
                            .al(lv1_a[i]),
                            .gr(lv1_g[i-2]),
                            .go(lv2_g[i])
                        );   
                end
                else begin
                    cell_ga
                        u_cell_ga(
                            .gl(lv1_g[i]),
                            .al(lv1_a[i]),
                            .gr(lv1_g[i-2]),
                            .ar(lv1_a[i-2]),
                            .go(lv2_g[i]),
                            .ao(lv2_a[i])
                        );
                end
            end
            
            // Wiring
            assign lv2_g[0] = lv1_g[0];

            // Sum of Level 2
            assign s[2] = c_p[2] ^ lv2_g[1];
            assign s[3] = c_p[3] ^ lv2_g[2];

            if(BITS==3) assign co = lv2_g[BITS-1];
            else if(BITS==4)begin
                cell_g
                    u_cell_g(
                        .gl(lv2_g[BITS-1]),
                        .al(lv2_a[BITS-1]),
                        .gr(lv2_g[BITS-3]),
                        .go(co)
                    );
            end
        end

        
        // Level 3
        if(LOGIC_DEPTH>=3)begin:LV3
            for(i=3;i<BITS;i=i+'d1)begin:LV31
                if(i==3)begin
                    cell_g
                        u_cell_g(
                            .gl(lv2_g[i]),
                            .al(lv2_a[i]),
                            .gr(ci),
                            .go(lv3_g[i])
                        );   
                end
                else if(i<7)begin
                    cell_g
                        u_cell_g(
                            .gl(lv2_g[i]),
                            .al(lv2_a[i]),
                            .gr(lv2_g[i-4]),
                            .go(lv3_g[i])
                        );   
                end
                else begin
                        cell_ga
                            u_cell_g(
                            .gl(lv2_g[i]),
                            .al(lv2_a[i]),
                            .gr(lv2_g[i-4]),
                            .ar(lv2_a[i-4]),
                            .go(lv3_g[i]),
                            .ao(lv3_a[i])
                        );
                end
            end    

            // Wiring of Level 3
            for(i=0;i<3;i=i+1)begin:LV32
                assign lv3_g[i] = lv2_g[i];
            end
            // Sum of Level 3
            for(i=4;i<8;i=i+1)begin:LV33
                if(BITS>i) assign s[i] = c_p[i] ^ lv3_g[i-1];
            end 
            // Carry out of Level 3
            if(BITS<8)begin
                assign co = lv3_g[BITS-1];
            end
            else if(BITS==8)begin
                cell_g
                    u_cell_g(
                        .gl(lv3_g[BITS-1]),
                        .al(lv3_a[BITS-1]),
                        .gr(lv3_g[BITS-5]),
                        .go(co)
                    );
            end
        end 

        // Level 4
        if(LOGIC_DEPTH>=4)begin:LV4
            for(i=7;i<BITS;i=i+'d1)begin:LV41
                if(i==7)begin
                    cell_g
                        u_cell_g(
                            .gl(lv3_g[i]),
                            .al(lv3_a[i]),
                            .gr(ci),
                            .go(lv4_g[i])
                        );   
                end
                else if(i<15)begin
                    cell_g
                        u_cell_g(
                            .gl(lv3_g[i]),
                            .al(lv3_a[i]),
                            .gr(lv3_g[i-8]),
                            .go(lv4_g[i])
                        );   
                end
                else begin
                        cell_ga
                            u_cell_g(
                            .gl(lv3_g[i]),
                            .al(lv3_a[i]),
                            .gr(lv3_g[i-8]),
                            .ar(lv3_a[i-8]),
                            .go(lv4_g[i]),
                            .ao(lv4_a[i])
                        );
                end
            end    

            // Wiring of Level 4
            for(i=0;i<7;i=i+1)begin:LV42
                assign lv4_g[i] = lv3_g[i];
            end
            // Sum of Level 4
            for(i=8;i<16;i=i+1)begin:LV43
                if(BITS>i) assign s[i] = c_p[i] ^ lv4_g[i-1];
            end 

            // Carry out of Level 4
            if(BITS<16)begin
                assign co = lv4_g[BITS-1];
            end
            else if(BITS==16)begin
                cell_g
                    u_cell_g(
                        .gl(lv4_g[BITS-1]),
                        .al(lv4_a[BITS-1]),
                        .gr(lv4_g[BITS-9]),
                        .go(co)
                    );
            end
        end

        // Level 5
        if(LOGIC_DEPTH>=5)begin:LV5
            for(i=15;i<BITS;i=i+'d1)begin:LV51
                if(i==15)begin
                    cell_g
                        u_cell_g(
                            .gl(lv4_g[i]),
                            .al(lv4_a[i]),
                            .gr(ci),
                            .go(lv5_g[i])
                        );   
                end
                else if(i<31)begin
                    cell_g
                        u_cell_g(
                            .gl(lv4_g[i]),
                            .al(lv4_a[i]),
                            .gr(lv4_g[i-16]),
                            .go(lv5_g[i])
                        );   
                end
                else begin
                        cell_ga
                            u_cell_g(
                            .gl(lv4_g[i]),
                            .al(lv4_a[i]),
                            .gr(lv4_g[i-16]),
                            .ar(lv4_a[i-16]),
                            .go(lv5_g[i]),
                            .ao(lv5_a[i])
                        );
                end
            end    

            // Wiring of Level 5
            for(i=0;i<15;i=i+1)begin:LV52
                assign lv5_g[i] = lv4_g[i];
            end

            // Sum of Level 5
            for(i=16;i<32;i=i+1)begin:LV53
                if(BITS>i) assign s[i] = c_p[i] ^ lv5_g[i-1];
            end 

            // Carry out of Level 5
            if(BITS<32)begin
                assign co = lv5_g[BITS-1];
            end
            else if(BITS==32)begin
                cell_g
                    u_cell_g(
                        .gl(lv5_g[BITS-1]),
                        .al(lv5_a[BITS-1]),
                        .gr(lv5_g[BITS-17]),
                        .go(co)
                    );
            end
        end

        // Level 6
        if(LOGIC_DEPTH>=6)begin:LV6
            for(i=31;i<BITS;i=i+'d1)begin:LV61
                if(i==31)begin
                    cell_g
                        u_cell_g(
                            .gl(lv5_g[i]),
                            .al(lv5_a[i]),
                            .gr(ci),
                            .go(lv6_g[i])
                        );   
                end
                else if(i<63)begin
                    cell_g
                        u_cell_g(
                            .gl(lv5_g[i]),
                            .al(lv5_a[i]),
                            .gr(lv5_g[i-32]),
                            .go(lv6_g[i])
                        );   
                end
                else begin
                        cell_ga
                            u_cell_g(
                            .gl(lv5_g[i]),
                            .al(lv5_a[i]),
                            .gr(lv5_g[i-32]),
                            .ar(lv5_a[i-32]),
                            .go(lv6_g[i]),
                            .ao(lv6_a[i])
                        );
                end
            end    

            // Wiring of Level 6
            for(i=0;i<31;i=i+1)begin:LV62
                assign lv6_g[i] = lv5_g[i];
            end

            // Sum of Level 6
            for(i=32;i<64;i=i+1)begin:LV63
                if(BITS>i) assign s[i] = c_p[i] ^ lv6_g[i-1];
            end 

            // Carry out of Level 6
            if(BITS<64)begin
                assign co = lv6_g[BITS-1];
            end
            else if(BITS==64)begin
                cell_g
                    u_cell_g(
                        .gl(lv6_g[BITS-1]),
                        .al(lv6_a[BITS-1]),
                        .gr(lv6_g[BITS-33]),
                        .go(co)
                    );
            end
        end

        // Level 7
        if(LOGIC_DEPTH>=7)begin:LV7
            for(i=63;i<BITS;i=i+'d1)begin:LV71
                if(i==63)begin
                    cell_g
                        u_cell_g(
                            .gl(lv6_g[i]),
                            .al(lv6_a[i]),
                            .gr(ci),
                            .go(lv7_g[i])
                        );   
                end
                else if(i<128)begin
                    cell_g
                        u_cell_g(
                            .gl(lv6_g[i]),
                            .al(lv6_a[i]),
                            .gr(lv6_g[i-64]),
                            .go(lv7_g[i])
                        );   
                end
                else begin
                        cell_ga
                            u_cell_g(
                            .gl(lv6_g[i]),
                            .al(lv6_a[i]),
                            .gr(lv6_g[i-64]),
                            .ar(lv6_a[i-64]),
                            .go(lv7_g[i]),
                            .ao(lv7_a[i])
                        );
                end
            end    

            // Wiring of Level 7
            for(i=0;i<63;i=i+1)begin:LV72
                assign lv7_g[i] = lv6_g[i];
            end

            // Sum of Level 7
            for(i=64;i<128;i=i+1)begin:LV73
                if(BITS>i) assign s[i] = c_p[i] ^ lv7_g[i-1];
            end 

            // Carry out of Level 7
            if(BITS<128)begin
                assign co = lv7_g[BITS-1];
            end
            else if(BITS==128)begin
                cell_g
                    u_cell_g(
                        .gl(lv7_g[BITS-1]),
                        .al(lv7_a[BITS-1]),
                        .gr(lv7_g[BITS-65]),
                        .go(co)
                    );
            end
        end
    endgenerate

endmodule
