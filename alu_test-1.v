`timescale 1ns / 1ps

module alu_test();

    // inputs
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] ALUControl;

    // outputs
    wire [31:0] ALUResult;
    wire zero;

    // instantiate the ALU
    Alu uut (
        .A(A),
        .B(B),
        .ALUControl(ALUControl),
        .ALUResult(ALUResult),
        .zero(zero)
    );

    initial begin

        // test ADD (15 + 10 = 25)
        ALUControl = 4'b0000;
        A = 32'd15; B = 32'd10; 
        #20;
        
        // test SUB & Zero (20 - 20 = 0, Zero should be 1)
        ALUControl = 4'b0001;
        A = 32'd20; B = 32'd20; 
        #20;
        
        // test SUB with negative result (10 - 25 = -15)
        ALUControl = 4'b0001;
        A = 32'd10; B = 32'd25; 
        #20;
        
        // testing AND
        ALUControl = 4'b0010;
        A = 32'h0000FFFF; B = 32'hFFFF0000; // result should be 0
        #20;
        
        // testing OR
        ALUControl = 4'b0011;
        A = 32'h0F0F0F0F; B = 32'hF0F0F0F0; // result should be FFFFFFFF
        #20;
        
        // testing XOR
        ALUControl = 4'b0100;
        A = 32'hAAAAAAAA; B = 32'h55555555; // result should be FFFFFFFF
        #20;
        
        // test SLL (1 shifted left by 4 = 16)
        ALUControl = 4'b0101;
        A = 32'd1; B = 32'd4; 
        #20;
        
        // test SRL (16 shifted right by 2 = 4)
        ALUControl = 4'b0110;
        A = 32'd16; B = 32'd2; 
        #20;

        $finish; //end
    end

endmodule
