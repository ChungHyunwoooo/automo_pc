module cell_g
    (
        input      gl,
        input      al,
        input      gr,
        output     go
    );
    assign go = gl | (al & gr);
endmodule

module cell_ga
    (
        input      al,
        input      gl,
        input      gr,
        input      ar,
        output     go,
        output     ao
    );
    assign go = gl | (al & gr);
    assign ao = al & ar;
endmodule