module regfile (
  input  [4:0] A1,   // Address for first source register (rs1)
  input  [4:0] A2,   // Address for second source register (rs2)
  input  [4:0] A3,   // Address for destination register (rd)
  input        WE3,  // Write enable for register file
  input  [31:0] WD3, // Write data
  input         rst, // Reset signal (active low assumed here)
  input         clk, // Clock
  output [31:0] RD1, // Data output for first source register
  output [31:0] RD2  // Data output for second source register
);

  // Create register file storage (32 registers of 32 bits each)
  reg [31:0] REG [0:31];
  integer i;
  // Read logic: Return 0 if A1 or A2 is register x0.
  assign RD1 = (A1 == 0) ? 32'h00000000 : REG[A1];
  assign RD2 = (A2 == 0) ? 32'h00000000 : REG[A2];

  // ? Write logic (fixed)
  always @(posedge clk or posedge rst) begin
    if (rst) begin
      for (i = 0; i < 32; i = i + 1) begin
        REG[i] <= 32'b0;
      end
    end else if (WE3 && (A3 != 0)) begin
      REG[A3] <= WD3;
    end
  end

  // ? Initialize registers with proper values

 
    //REG[9] = 32'h00002004;  // ? Ensure x9 is initialized
    //REG[6] = 32'h00000009;  // ? Some valid values
//REG[7] = 32'h0000000C;  // ? Ensure A2 has valid value
    //REG[1] = 32'h00000001;  // ? Initialize x1 to avoid RD2 being 0
  //end

endmodule