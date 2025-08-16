`timescale 1ns / 1ps
module instruction_memory (
  input  [31:0] A,   // Address input (PC)
  output [31:0] RD   // Read Data (Fetched Instruction)
);

  reg [31:0] memory [0:4095]; // Instruction memory (4K words)
  integer i;

  // Initialize instruction memory
  initial begin
    for (i = 0; i < 4096; i = i + 1)
      memory[i] = 32'h00000013; // fill with NOP by default

    $readmemh("instmem.mem", memory); // Load program
    $display("Instruction memory initialized!");
  end

  // Combinational read (ROM style)
  assign RD = memory[A[31:2]];

endmodule
