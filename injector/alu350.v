// ALU.v

module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    // add your code here:

    wire [31:0] nil;
    assign nil = 0;

    // control signals
    wire ctrl_sub;
    wire [3:0] leading_bits, inv_leading_bits;
    assign leading_bits = ctrl_ALUopcode[4:1];
    not invert_leading_bits [3:0] (inv_leading_bits, leading_bits);
    and set_ctrl_sub(ctrl_sub, inv_leading_bits[3:0], ctrl_ALUopcode[0]);

    // NOT
    wire [31:0] inverted_B;
    not B_inverter [31:0] (inverted_B, data_operandB);

    // B selector
    wire [31:0] selected_B;
    assign selected_B = ctrl_sub ? inverted_B : data_operandB;

    // AND + OR
    wire [31:0] p, g;
    and gen [31:0] (g, data_operandA, selected_B);
    or prop [31:0] (p, data_operandA, selected_B);

    // Adder
    wire [31:0] s;
    wire cout;

    adder addermod (
        .A(data_operandA),
        .B(selected_B),
        .Cin(ctrl_sub), 
        .p(p),
        .g(g),
        .S(s),
        .Cout(cout)
    );

    // Shift logical left
    wire [31:0] sll;

    logical_left_shift shift_ll(sll, data_operandA, ctrl_shiftamt);

    // Shift arithmetic right
    wire [31:0] sra;

    arithmetic_right_shift shift_ar (
        .Out(sra), 
        .A(data_operandA), 
        .shamt(ctrl_shiftamt)
    );

    // Outputs

    overflow_checker check_overflow(overflow, data_operandA[31], data_operandB[31], s[31], ctrl_sub);
    less_than_checker check_less_than(isLessThan, data_operandA[31], data_operandB[31], s[31]);
    equal_checker check_equal(isNotEqual, s);
   

    mux_8 opcode_selector(data_result, ctrl_ALUopcode[2:0], s, s, g, p, sll, sra, s, s);
endmodule

module overflow_checker(Out, A, B, S, sub);
    input A, B, S, sub;

    output Out;

    wire add_overflow, sub_overflow;

    wire not_a, not_b, not_s;
    not a_inv(not_a, A);
    not b_inv(not_b, B);
    not s_inv(not_s, S);

    wire a0, a1, a_o;
    and add_pos(a0, A, B, not_s);
    and add_neg(a1, not_a, not_b, S);
    or add_o(a_o, a0, a1);

    wire s0, s1, s_o;
    and sub_neg(s0, A, not_b, not_s);
    and sub_pos(s1, not_a, B, S);
    or sub_o(s_o, s0, s1);

    assign Out = sub ? s_o : a_o;
endmodule

module less_than_checker(Out, A, B, S);
    input A, B, S;

    output Out;

    wire not_a, not_b, not_s;
    not a_inv(not_a, A);
    not b_inv(not_b, B);
    not s_inv(not_s, S);


    wire c0, c1, c2;
    and case0(c0, not_a, not_b, S);
    and case1(c1, A, B, S);
    and case2(c2, A, not_b);

    or lt(Out, c0, c1, c2);


endmodule

module equal_checker(Out, S);

    input [31:0] S;

    output Out;

    wire w1, w2, w3, w4;

    or g1(w1, S[31], S[30], S[29], S[28], S[27], S[26], S[25], S[24]);
    or g2(w2, S[23], S[22], S[21], S[20], S[19], S[18], S[17], S[16]);
    or g3(w3, S[15], S[14], S[13], S[12], S[11], S[10], S[9], S[8]);
    or g4(w4, S[7], S[6], S[5], S[4], S[3], S[2], S[1], S[0]);
    or eq(Out, w1, w2, w3, w4);

endmodule


// adder.v

/*
 * 32 bit bit carry select adder
 */
module adder(
    input [31:0] A, 
    input [31:0] B, 
    input [31:0] p,
    input [31:0] g,
    input Cin,
    output [31:0] S,
    output Cout 
);

    // Speculate cin bits
    assign spec_low = 0;
    assign spec_high = 1;

    // First carry look ahead block
    wire P0, G0, P1, G1, P2, G2, P3, G3;
    carry_look_ahead_block block0(A[7:0], B[7:0], Cin, p[7:0], g[7:0], S[7:0], P0, G0);

    // Second carry look ahead block
    wire P1_low, P1_high, G0_low, G0_high;
    wire [7:0] S1_low, S1_high;
    
    carry_look_ahead_block block1_low(A[15:8], B[15:8], spec_low, p[15:8], g[15:8], S1_low, P1_low, G1_low);
    carry_look_ahead_block block1_high(A[15:8], B[15:8], spec_high, p[15:8], g[15:8], S1_high, P1_high, G1_high);
    

    // Third carry look ahead block
    wire P2_low, P2_high, G2_low, G2_high;
    wire [7:0] S2_low, S2_high;

    carry_look_ahead_block block2_low(A[23:16], B[23:16], spec_low, p[23:16], g[23:16], S2_low, P2_low, G2_low);
    carry_look_ahead_block block2_high(A[23:16], B[23:16], spec_high, p[23:16], g[23:16], S2_high, P2_high, G2_high);
    

    // Fourth carry look ahead block
    wire P3_low, P3_high, G3_low, G3_high;
    wire [7:0] S3_low, S3_high;

    carry_look_ahead_block block3_low(A[31:24], B[31:24], spec_low, p[31:24], g[31:24], S3_low, P3_low, G3_low);
    carry_look_ahead_block block3_high(A[31:24], B[31:24], spec_high, p[31:24], g[31:24], S3_high, P3_high, G3_high);
    
    /*
    * Compute carries for carry look ahead blocks
    */

    // Compute c8
    wire c8, c8w0;

    and     c8_a0(c8w0, P0, Cin);
    or      c8_o0(c8, G0, c8w0);

    // Compute c16
    wire c16, c16w0, c16w1;

    and     c16_a0(c16w0, P1, P0, Cin);
    and     c16_a1(c16w1, P1, G0);
    or      c16_o0(c16, G1, c16w0, c16w1);

    // Compute c24
    wire c24, c24w0, c24w1, c24w2;

    and     c24_a0(c24w0, P2, P1, P0, Cin);
    and     c24_a1(c24w1, P2, P1, G0);
    and     c24_a2(c24w2, P2, G1);
    or      c24_o0(c24, G2, c24w0, c24w1, c24w2);

    // Compute c32
    wire c32w0, c32w1, c32w2, c32w3;

    and     c32_a0(c32w0, P3, P2, P1, P0, Cin);
    and     c32_a1(c32w1, P3, P2, P1, G0);
    and     c32_a2(c32w2, P3, P2, G1);
    and     c32_a3(c32w3, P3, G2);
    or      c32_o0(Cout, G3, c32w0, c32w1, c32w2, c32w3);


    /*
    * Multiplexers
    */

    assign S[15:8] = c8 ? S1_high : S1_low;
    assign P1 = c8 ? P1_high : P1_low;
    assign G1 = c8 ? G1_high : G1_low;

    assign S[23:16] = c16 ? S2_high : S2_low;
    assign P2 = c16 ? P2_high : P2_low;
    assign G2 = c16 ? G2_high : G2_low;


    assign S[31:24] = c24 ? S3_high : S3_low;
    assign P3 = c24 ? P3_high : P3_low;
    assign G3 = c24 ? G3_high : G3_low;


endmodule

/*
 *  Eight bit carry look ahead adder block
 */
module carry_look_ahead_block(A, B, Cin, p, g, S, P, G);
    
    input [7:0] A, B, p, g;
    input Cin;

    output [7:0] S;
    output P, G;

    wire [7:0] c;
    assign c[0] = Cin;

    /*
     * Half adder cells
     */
    xor adder_cell [7:0] (S, A, B, c);

    /*
     * Carry bit(s) logic
     */
    //c1
    wire    c1w0;
    and     c1_a(c1w0, p[0], Cin);
    or      c1_o(c[1], g[0], c1w0);
    
    //c2
    wire    c2w0, c2w1;
    and     c2_a0(c2w0, p[1], p[0], Cin);
    and     c2_a1(c2w1, p[1], g[0]);
    or      c2_o(c[2], g[1], c2w0, c2w1);

    //c3
    wire    c3w0, c3w1, c3w2;
    and     c3_a0(c3w0, p[2], p[1], p[0], Cin);
    and     c3_a1(c3w1, p[2], p[1], g[0]);
    and     c3_a2(c3w2, p[2], g[1]);
    or      c3_o(c[3], g[2], c3w0, c3w1, c3w2);

    //c4
    wire    c4w0, c4w1, c4w2, c4w3;
    and     c4_a0(c4w0, p[3], p[2], p[1], p[0], Cin);
    and     c4_a1(c4w1, p[3], p[2], p[1], g[0]);
    and     c4_a2(c4w2, p[3], p[2], g[1]);
    and     c4_a3(c4w3, p[3], g[2]);
    or      c4_o(c[4], g[3], c4w0, c4w1, c4w2, c4w3);

    //c5
    wire    c5w0, c5w1, c5w2, c5w3, c5w4;
    and     c5_a0(c5w0, p[4], p[3], p[2], p[1], p[0], Cin);
    and     c5_a1(c5w1, p[4], p[3], p[2], p[1], g[0]);
    and     c5_a2(c5w2, p[4], p[3], p[2], g[1]);
    and     c5_a3(c5w3, p[4], p[3], g[2]);
    and     c5_a4(c5w4, p[4], g[3]);
    or      c5_o(c[5], g[4], c5w0, c5w1, c5w2, c5w3, c5w4);

    //c6
    wire    c6w0, c6w1, c6w2, c6w3, c6w4, c6w5;
    and     c6_a0(c6w0, p[5], p[4], p[3], p[2], p[1], p[0], Cin);
    and     c6_a1(c6w1, p[5], p[4], p[3], p[2], p[1], g[0]);
    and     c6_a2(c6w2, p[5], p[4], p[3], p[2], g[1]);
    and     c6_a3(c6w3, p[5], p[4], p[3], g[2]);
    and     c6_a4(c6w4, p[5], p[4], g[3]);
    and     c6_a5(c6w5, p[5], g[4]);
    or      c6_o(c[6], g[5], c6w0, c6w1, c6w2, c6w3, c6w4, c6w5);

    //c7
    wire    c7w0, c7w1, c7w2, c7w3, c7w4, c7w5, c7w6;
    and     c7_a0(c7w0, p[6], p[5], p[4], p[3], p[2], p[1], p[0], Cin);
    and     c7_a1(c7w1, p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and     c7_a2(c7w2, p[6], p[5], p[4], p[3], p[2], g[1]);
    and     c7_a3(c7w3, p[6], p[5], p[4], p[3], g[2]);
    and     c7_a4(c7w4, p[6], p[5], p[4], g[3]);
    and     c7_a5(c7w5, p[6], p[5], g[4]);
    and     c7_a6(c7w6, p[6], g[5]);
    or      c7_o(c[7], g[6], c7w0, c7w1, c7w2, c7w3, c7w4, c7w5, c7w6);

    //c8 -- only used for the generate out
    wire    c8w1, c8w2, c8w3, c8w4, c8w5, c8w6, c8w7;
    and     c8_a1(c8w1, p[7], p[6], p[5], p[4], p[3], p[2], p[1], g[0]);
    and     c8_a2(c8w2, p[7], p[6], p[5], p[4], p[3], p[2], g[1]);
    and     c8_a3(c8w3, p[7], p[6], p[5], p[4], p[3], g[2]);
    and     c8_a4(c8w4, p[7], p[6], p[5], p[4], g[3]);
    and     c8_a5(c8w5, p[7], p[6], p[5], g[4]);
    and     c8_a6(c8w6, p[7], p[6], g[5]);
    and     c8_a7(c8w7, p[7], g[6]);

    /*
     * Generate & Propagate output
     */
    and prop(P, p[7], p[6], p[5], p[4], p[3], p[2], p[1], p[0]);
    or  gen(G, g[7], c8w1, c8w2, c8w3, c8w4, c8w5, c8w6, c8w7);

endmodule


// arith_right_shift.v

/*
* 32 bit arithmetic right shifter
*/
module arithmetic_right_shift(
    output [31:0] Out, 
    input [31:0] A, 
    input [4:0] shamt
);


    wire [31:0] s16, s8, s4, s2, s1, stage1, stage2, stage3, stage4;

    right_arith_shift_sixteen sixteen(s16, A);
    right_arith_shift_eight eight(s8, stage1);
    right_arith_shift_four four(s4, stage2);
    right_arith_shift_two two(s2, stage3);
    right_arith_shift_one one (
        .Out(s1), 
        .A(stage4)
    );

    mux_2 sel_16(stage1, shamt[4], A, s16);
    mux_2 sel_8(stage2, shamt[3], stage1, s8);
    mux_2 sel_4(stage3, shamt[2], stage2, s4);
    mux_2 sel_2(stage4, shamt[1], stage3, s2);
    mux_2 sel_1(Out, shamt[0], stage4, s1);
endmodule

/*
* Right shift by 1 module
*/
module right_arith_shift_one(
    output [31:0] Out, 
    input [31:0] A
);
    wire [30:0] temp = A[31:1];

    assign Out = {A[31], temp[30:0]};
endmodule

/*
* Right shift by 2 module
*/
module right_arith_shift_two(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[29:0] = A[31:2];

    assign Out[31] = A[31];
    assign Out[30] = A[31];
endmodule

/*
* Right shift by 4 module
*/
module right_arith_shift_four(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[27:0] = A[31:4];

    assign Out[31] = A[31];
    assign Out[30] = A[31];
    assign Out[29] = A[31];
    assign Out[28] = A[31];
endmodule

/*
* Right shift by 8 module
*/
module right_arith_shift_eight(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[23:0] = A[31:8];

    assign Out[31] = A[31];
    assign Out[30] = A[31];
    assign Out[29] = A[31];
    assign Out[28] = A[31];
    assign Out[27] = A[31];
    assign Out[26] = A[31];
    assign Out[25] = A[31];
    assign Out[24] = A[31];
endmodule

/*
* Right shift by 16 module
*/
module right_arith_shift_sixteen(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[15:0] = A[31:16];

    assign Out[31] = A[31];
    assign Out[30] = A[31];
    assign Out[29] = A[31];
    assign Out[28] = A[31];
    assign Out[27] = A[31];
    assign Out[26] = A[31];
    assign Out[25] = A[31];
    assign Out[24] = A[31];
    assign Out[23] = A[31];
    assign Out[22] = A[31];
    assign Out[21] = A[31];
    assign Out[20] = A[31];
    assign Out[19] = A[31];
    assign Out[18] = A[31];
    assign Out[17] = A[31];
    assign Out[16] = A[31];
endmodule


// log_left_shift.v

/*
* 32 bit logical left shifter
*/
module logical_left_shift(Out, A, shamt);
    input [31:0] A;
    input [4:0] shamt;
    
    output [31:0] Out;

    wire [31:0] s16, s8, s4, s2, s1, stage1, stage2, stage3, stage4;

    left_shift_sixteen sixteen(s16, A);
    left_shift_eight eight(s8, stage1);
    left_shift_four four(s4, stage2);
    left_shift_two two(s2, stage3);
    left_shift_one one(s1, stage4);

    mux_2 sel_16(stage1, shamt[4], A, s16);
    mux_2 sel_8(stage2, shamt[3], stage1, s8);
    mux_2 sel_4(stage3, shamt[2], stage2, s4);
    mux_2 sel_2(stage4, shamt[1], stage3, s2);
    mux_2 sel_1(Out, shamt[0], stage4, s1);
endmodule

/*
* Left shift by 1 module
*/
module left_shift_one(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[31:1] = A[30:0];
    assign Out[0] = 1'b0;
endmodule

/*
* Left shift by 2 module
*/
module left_shift_two(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[31:2] = A[29:0];
    assign Out[1:0] = 2'b0;
endmodule

/*
* Left shift by 4 module
*/
module left_shift_four(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[31:4] = A[27:0];
    assign Out[3:0] = 4'b0;
endmodule

/*
* Left shift by 8 module
*/
module left_shift_eight(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[31:8] = A[23:0];
    assign Out[7:0] = 8'b0;
endmodule

/*
* Left shift by 16 module
*/
module left_shift_sixteen(Out, A);
    input [31:0] A;

    output [31:0] Out;

    assign Out[31:16] = A[15:0];
    assign Out[15:0] = 16'b0;
endmodule

// mux.v

/*
* 2 input mux
*/
module mux_2(out, select, in0, in1);
    input select;
    input [31:0] in0, in1;
    output [31:0] out;
    assign out = select ? in1 : in0;
endmodule

/*
* 4 input mux
*/
module mux_4(out, select, in0, in1, in2, in3);
    input [1:0] select;
    input [31:0] in0, in1, in2, in3;
    output [31:0] out;
    wire [31:0] w1, w2;
    mux_2 first_top(w1, select[0], in0, in1);
    mux_2 first_bottom(w2, select[0], in2, in3);
    mux_2 second(out, select[1], w1, w2);
endmodule

/*
* 8 input mux
*/
module mux_8(out, select, in0, in1, in2, in3, in4, in5, in6, in7);
    input [2:0] select;
    input [31:0] in0, in1, in2, in3, in4, in5, in6, in7;
    output [31:0] out;
    wire [31:0] w1, w2;

    mux_4 first_top(w1, select[1:0], in0, in1, in2, in3);
    mux_4 first_bottom(w2, select[1:0], in4, in5, in6, in7);
    mux_2 second(out, select[2], w1, w2);
endmodule