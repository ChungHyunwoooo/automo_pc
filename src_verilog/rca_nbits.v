module rca_nbits
    #(
        parameter BITS = 'd32
    )
    (
        input    [BITS-'d1:'d0] a,
        input    [BITS-'d1:'d0] b,
        input    ci,
        output  [BITS-'d1:'d0] s,
`ifdef RCA_OUTPUT_CO_PREV
        output  co_prev,
`endif
        output  co
    );
    
    wire [BITS:'d0] w_c;
    
    assign w_c['d0] = ci;
`ifdef RCA_OUTPUT_CO_PREV
    assign co_prev = w_c[BITS-'d1];
`endif
    assign co = w_c[BITS];
    
    genvar gen_fa;
    generate
        for(gen_fa = 'd0; gen_fa < BITS; gen_fa = gen_fa + 'd1)begin:U_FA
            fulladder
                u_fa(
                    .a(a[gen_fa]),
                    .b(b[gen_fa]),
                    .ci(w_c[gen_fa]),
                    .s(s[gen_fa]),
                    .co(w_c[gen_fa+'d1])
                );
        end
    endgenerate
        
endmodule
