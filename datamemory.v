`timescale 1ns / 1ps
module datamem(
  input [31:0] A, WD,  // Address and Write Data
  input clk, rst, WE,  // Clock, Reset, Write Enable
  output reg [31:0] RD // Read Data (Must be reg type since assigned inside always)
);

  // ? 32-bit Word-Aligned Memory (4096 words)
  reg [31:0] REG [0:4095];  
  integer i;

  // ? Read Logic: Reads memory unless reset is LOW
  always @(*) begin
    if (!rst)
      RD = 32'd0;  // Force read data to zero on reset
    else
      RD = REG[A[31:2]];  // Read from aligned memory address
  end

  // ? Write Logic: Stores Data on `WE == 1`
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      // ? Initialize memory with zeros, except address 0x2000 (index 2048)
      for (i = 0; i < 4096; i = i + 1) begin
        REG[i] <= 32'h00000000;
      end
      // ? Ensure address 0x2000 is initialized
      REG[2048] <= 32'hDEADBEEF;
    end 
    else if (WE) begin
      // ? Write only if not trying to overwrite protected address
      if (A[31:2] != 2048)
        REG[A[31:2]] <= WD;
    end
  end

endmodule