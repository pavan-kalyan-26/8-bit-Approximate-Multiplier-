`timescale 1ns / 1ps

//------------------------------
// Half Adder
//------------------------------
module HA (
    input  a, b,
    output sum, carry
);
    assign sum   = a ^ b;
    assign carry = a & b;
endmodule

//------------------------------
// Full Adder (exact)
//------------------------------
module FA (
    input  a, b, cin,
    output sum, carry
);
    assign sum   = a ^ b ^ cin;
    assign carry = (a & b) | (b & cin) | (a & cin);
endmodule

//------------------------------
// Exact 4:2 compressor
// (for reference / MSB region)
//------------------------------
module EC (
    input  [4:1] x,
    input        cin,
    output       sum, carry, cout
);
    wire s1, c1;
    wire sum_t, carry_t;

    assign s1     = x[1] ^ x[2] ^ x[3];
    assign c1     = (x[1] & x[2]) | (x[2] & x[3]) | (x[1] & x[3]);

    assign sum_t   = s1 ^ x[4] ^ cin;
    assign carry_t = (s1 & x[4]) | (x[4] & cin) | (s1 & cin);

    assign sum   = sum_t;   // same column
    assign carry = c1;      // same column
    assign cout  = carry_t; // next column
endmodule

//------------------------------
// ACMLC - "soft" approximate 4:2
// (no constant 1s; behaves close to exact)
//------------------------------
module ACMLC (
    input  [4:1] x,
    input        cin,
    output       sum, carry
);
    // First, behave like an exact 4:2 without Cout
    wire s1, c1;

    assign s1   = x[1] ^ x[2] ^ x[3];
    assign c1   = (x[1] & x[2]) | (x[2] & x[3]) | (x[1] & x[3]);

    // Approximation: ignore cin in sum and only lightly use it in carry
    assign sum   = s1 ^ x[4];                // ignore cin here → approximation
    assign carry = c1 | (x[4] & s1) | cin;   // simplified carry

    // NOTE: when all x=0 and cin=0 → sum=0, carry=0 (no bias)
endmodule

//------------------------------
// CAC - another approximate 4:2
// used near boundary of approx/exact region
//------------------------------
module CAC (
    input  [4:1] x,
    input        cin,
    output       sum, carry
);
    // Approximated majority behaviour
    wire parity;
    assign parity = x[1] ^ x[2] ^ x[3] ^ x[4] ^ cin;

    // Keep sum as parity (like adder)
    assign sum = parity;

    // Carry is a relaxed majority of inputs
    assign carry = (x[1] & x[2]) |
                   (x[3] & x[4]) |
                   (cin & (x[1] | x[2] | x[3] | x[4]));

    // Again: if all inputs 0 → sum=0, carry=0
endmodule
//------------------------------
// Approximate 8-bit Multiplier
//------------------------------
module approx_mult_8bit (
    input  [7:0] a,
    input  [7:0] b,
    output [15:0] product
);
    // Partial products
    wire pp[7:0][7:0];
    genvar i, j;
    generate
        for (i = 0; i < 8; i = i + 1) begin : ROW
            for (j = 0; j < 8; j = j + 1) begin : COL
                assign pp[i][j] = a[i] & b[j];
            end
        end
    endgenerate

    // ACMLC/CAC outputs
    wire s4, c4;
    wire s5, c5;
    wire s6, c6;
    wire s7, c7;
    wire s8, c8;

    // Column 4  (i+j = 4): (0,4),(1,3),(2,2),(3,1)
    ACMLC ac4 (
        .x   ({pp[0][4], pp[1][3], pp[2][2], pp[3][1]}),
        .cin (1'b0),
        .sum (s4),
        .carry (c4)
    );

    // Column 5: (0,5),(1,4),(2,3),(3,2)
    ACMLC ac5 (
        .x   ({pp[0][5], pp[1][4], pp[2][3], pp[3][2]}),
        .cin (1'b0),
        .sum (s5),
        .carry (c5)
    );

    // Column 6: (0,6),(1,5),(2,4),(3,3)
    ACMLC ac6 (
        .x   ({pp[0][6], pp[1][5], pp[2][4], pp[3][3]}),
        .cin (1'b0),
        .sum (s6),
        .carry (c6)
    );

    // Column 7: (0,7),(1,6),(2,5),(3,4)
    ACMLC ac7 (
        .x   ({pp[0][7], pp[1][6], pp[2][5], pp[3][4]}),
        .cin (1'b0),
        .sum (s7),
        .carry (c7)
    );

    // Column 8: (1,7),(2,6),(3,5),(4,4)  -> CAC
    CAC ca8 (
        .x   ({pp[1][7], pp[2][6], pp[3][5], pp[4][4]}),
        .cin (1'b0),
        .sum (s8),
        .carry (c8)
    );

    // Now accumulate everything into a 16-bit sum
    reg [15:0] tmp;
    integer r, c_idx;

    always @* begin
        tmp = 16'd0;

        // add ACMLC/CAC sums and carries to their bit positions
        if (s4) tmp = tmp + (16'd1 << 4);
        if (c4) tmp = tmp + (16'd1 << 5);

        if (s5) tmp = tmp + (16'd1 << 5);
        if (c5) tmp = tmp + (16'd1 << 6);

        if (s6) tmp = tmp + (16'd1 << 6);
        if (c6) tmp = tmp + (16'd1 << 7);

        if (s7) tmp = tmp + (16'd1 << 7);
        if (c7) tmp = tmp + (16'd1 << 8);

        if (s8) tmp = tmp + (16'd1 << 8);
        if (c8) tmp = tmp + (16'd1 << 9);

        // Add remaining partial products EXACTLY, but only for columns >= 4
        for (r = 0; r < 8; r = r + 1) begin
            for (c_idx = 0; c_idx < 8; c_idx = c_idx + 1) begin
                if ((r + c_idx) >= 4) begin
                    // Skip the ones already used in ACMLC/CAC (to avoid double counting)
                    if (!(
                         (r==0 && c_idx==4) || (r==1 && c_idx==3) || (r==2 && c_idx==2) || (r==3 && c_idx==1) || // col4
                         (r==0 && c_idx==5) || (r==1 && c_idx==4) || (r==2 && c_idx==3) || (r==3 && c_idx==2) || // col5
                         (r==0 && c_idx==6) || (r==1 && c_idx==5) || (r==2 && c_idx==4) || (r==3 && c_idx==3) || // col6
                         (r==0 && c_idx==7) || (r==1 && c_idx==6) || (r==2 && c_idx==5) || (r==3 && c_idx==4) || // col7
                         (r==1 && c_idx==7) || (r==2 && c_idx==6) || (r==3 && c_idx==5) || (r==4 && c_idx==4)    // col8
                        )) begin
                        if (pp[r][c_idx])
                            tmp = tmp + (16'd1 << (r + c_idx));
                    end
                end
            end
        end
    end

    // Final product: LSBs are constant 0110 (truncation),
    // upper bits come from tmp.
    assign product[3:0]   = 4'b0110;
    assign product[15:4]  = tmp[15:4];

endmodule

