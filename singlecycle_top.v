module Single_Cycle_top (
  input clk, rst,
  
  // Interconnection wires
  input [31:0] PC_TOP, RD_Inst, RD1_TOP, IMM_EXT_TOP, ALU_RESULT, MEM_READ_DATA, PCPlus4,
  input [2:0] ALUCONT_TOP,
  input regwrite, memwrite, alusrc, resultsrc,
  
  // Write-back data multiplexer: selects memory data if resultsrc is high, otherwise ALU result.
  output [31:0] WriteData,
   output [1:0] immsrc,     // Connect immsrc as an output
  output branch,           // Connect branch as an output
  output [31:0] RD2_TOP);
  
  wire Zo, N, V, C;
  assign WriteData = (resultsrc) ? MEM_READ_DATA : ALU_RESULT;
  
  // Program Counter: updated every cycle (or on branch)
  pcounter PCounter(
      .clk(clk),
      .rst(rst),
      .next_pc(PCPlus4),
      .outpc(PC_TOP)
  );
  
  // PC Adder: computes PC + 4 for sequential instruction fetch
  pcadder PCAdder (
      .a(PC_TOP),
      .b(32'd4),
      .c(PCPlus4)
  );
  
  // Instruction Memory: fetch instruction using the PC
  instruction_memory im (
     // .rst(rst),
      .A(PC_TOP),
      .RD(RD_Inst)
  );
  
  // Register File: 
  // - A1 is connected to bits 19-15 (rs1) from the instruction.
  // - A3 is connected to bits 11-7 (rd) so that, for a load instruction, the read data is written to the destination register.
  regfile RFile(
    .clk(clk),
    .rst(rst),
    .WE3(regwrite),       // Write enable from the control unit.
    .WD3(WriteData),      // Write-back data: from memory (for load) or ALU.
    .A1(RD_Inst[19:15]),  // ? rs1 address from instruction.
    .A2(RD_Inst[24:20]),  // ? rs2 address from instruction (Fix applied here)
    .A3(RD_Inst[11:7]),   // ? Destination register (rd) address.
    .RD1(RD1_TOP),
    .RD2(RD2_TOP) // You may want to connect RD2 to another signal if needed
);

  
  // Sign Extension: produces a 32-bit immediate value from the instruction.
  sign_extend SExtend(
    .instr(RD_Inst),    // ? Correct input connection
    .imm_ext(IMM_EXT_TOP) // ? Correct output port name
);

  
  // ALU: computes the effective memory address (e.g. base address + immediate)
  ALU alu ( 
      .A(RD1_TOP),         // Base address from register file.
      .B(IMM_EXT_TOP),     // Sign-extended immediate (offset).
      .CS(ALUCONT_TOP),    // Control signal from the control unit.
      .Result(ALU_RESULT),
      .Zo(Zo),
      .N(N),
      .V(V),
      .C(C)
  );
  
  // Control Unit: generates control signals based on the opcode and function fields.
  // Here we connect OP to bits [6:0], funct3 to bits [14:12], and funct7 to bits [31:25].
  controlunit CU(
      .OP(RD_Inst[6:0]),          // Opcode from the instruction.
      .funct3(RD_Inst[14:12]),      // funct3 field.
     .funct7(RD_Inst[31:25]),      // funct7 field.
     //.funct7(RD_Inst[30]),
      .alucontrol(ALUCONT_TOP),     // ALU control signal.
      .regwrite(regwrite),         // Register file write enable.
      .immsrc(immsrc),                  // Immediate source (if used).
      .alusrc(alusrc),             // ALU source selection.
      .memwrite(memwrite),         // Data memory write enable.
      .resultsrc(resultsrc),       // Selects memory data for write-back (load) or ALU result (R-type).
      .branch(branch)                  // Branch control signal.
  );
  
  // Data Memory: 
  // Uses the ALU result as the address to read (or write) data.
  datamem DM (
      .A(ALU_RESULT),      // Memory address computed by ALU.
      .WD(WriteData),               // Write data (not used for a load instruction).
      .WE(memwrite),       // Write enable (should be 0 for a load).
      .clk(clk),
      .rst(rst),
      .RD(MEM_READ_DATA)   // Data read from memory.
  );
  
endmodule