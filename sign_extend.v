module sign_extend (
  input [31:0] instr,
  output reg [31:0] imm_ext
);
  always @(*) begin
    case (instr[6:0])
      7'b0010011: imm_ext = {{20{instr[31]}}, instr[31:20]}; // I-type (ADDI, LW)
      7'b0000011: imm_ext = {{20{instr[31]}}, instr[31:20]}; // Load (LW)
      7'b0100011: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]}; // Store (SW)
      default:    imm_ext = 32'b0;
    endcase
  end
endmodule