`timescale 1ns / 1ps
module Alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] ALUControl,
    output reg [31:0] ALUResult,  
    output zero
);
    wire [31:0] add_sub_res;
    wire [31:0] and_res;
    wire [31:0] or_res;
    wire [31:0] xor_res;
    wire [31:0] shift_res;
   
    assign zero = (ALUResult == 32'd0);
   
    ADDSUBSYSTEM u_addsub (
        .A(A),
        .B(B),
        .sub(ALUControl[0]),
        .result(add_sub_res)
    );

    // port mapping to match modules
    AND u_and (
        .A(A),
        .B(B),
        .Y(and_res)
    );

    OR u_or (
        .A(A),
        .B(B),
        .Y(or_res)
    );

    XOR u_xor (
        .A(A),
        .B(B),
        .Y(xor_res)
    );

    Shift u_shift (
        .func(ALUControl[0]),
        .x(A),
        .shift_parameter(B[4:0]),
        .y(shift_res)
    );

    always @(*) begin
        case (ALUControl)
            4'b0000: ALUResult = add_sub_res; // ADD
            4'b0001: ALUResult = add_sub_res; // SUB
            4'b0010: ALUResult = and_res;     // AND
            4'b0011: ALUResult = or_res;      // OR
            4'b0100: ALUResult = xor_res;     // XOR
            4'b0101: ALUResult = shift_res;   // SLL
            4'b0110: ALUResult = shift_res;   // SRL
            default: ALUResult = 32'd0;       // Default safety fallback
        endcase
    end
endmodule
