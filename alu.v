`timescale 1ns / 1ps
module ALU(
  input [31:0] A, B,     // ALU Operands (Corrected B input)
  input [2:0] CS,        // ALU Control Signals
  output reg [31:0] Result, // ALU Output
  output Zo, N, V, C     // Flags: Zero, Negative, Overflow, Carry
);

  wire [31:0] a_and_b, a_or_b, not_b, SUM, slt;
  wire cout, add_sub;

  // ? Compute Basic Operations
  assign a_and_b = A & B;
  assign a_or_b  = A | B;
  assign not_b   = ~B;

  // ? Choose whether to subtract (CS[0] for sub)
  assign add_sub = CS[0];  // 0 = Add, 1 = Subtract

  // ? Fix B selection for correct ADD behavior
  wire [31:0] B_final = (add_sub) ? ~B : B;  // **NO external control logic!**

  // ? Compute Addition/Subtraction (SUM = A + B + CS[0])
  assign {cout, SUM} = A + B_final + add_sub;

  // ? Set Less-Than Flag using sign bit of SUM
  assign slt = {31'b0, SUM[31]};

  // ? Multiplexer for ALU Operations
  always @(*) begin
    case (CS)
      3'b000: Result = SUM;       // ? Addition
      3'b001: Result = SUM;       // ? Subtraction
      3'b010: Result = SUM;       // ? Used for `addi`
      3'b011: Result = a_or_b;    // OR operation
      3'b100: Result = a_and_b;   // AND operation
      3'b101: Result = slt;       // Set Less Than
      default: Result = 32'h00000000;  // Default (NOP)
    endcase
  end

  // ? Compute Flags
  assign Zo = (Result == 0);  // Zero flag
  assign N  = Result[31];     // Negative flag
  assign C  = cout & (~CS[1]); // Carry flag (only for addition)
  assign V  = (~CS[1]) & (A[31] ^ SUM[31]) & (~(A[31] ^ B_final[31] ^ add_sub)); // Overflow

endmodule
