module cell_g
    (
        input   logic   gl,
        input   logic   al,
        input   logic   gr,
        output  logic   go
    );
    assign go = gl | (al & gr);
endmodule

module cell_ga
    (
        input   logic   gl,
        input   logic   al,
        input   logic   gr,
        input   logic   ar,
        output  logic   go,
        output  logic   ao
    );
    assign go = gl | (al & gr);
    assign ao = al & ar;
endmodule