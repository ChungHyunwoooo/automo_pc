module fulladder(
        input   a, b, ci, 
        output  s, co
    );
    wire c1, c2, sm;
    
    halfadder U0_ha(a, b, sm, c1);
    halfadder U1_ha(sm, ci, s, c2);
    assign co = c1|c2;
/*
    assign s = a ^ b ^ ci;
    assign co = (a & b) | (a & ci) | (b & ci);
*/  
endmodule
