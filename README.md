This project implements a single-cycle RISC-V CPU in Verilog HDL.
The processor executes one instruction per clock cycle and demonstrates the fundamental concepts of CPU architecture, datapath, and control logic. It supports a subset of RV32I instructions including arithmetic, logic, load/store, and branch operations.

⚙️ Features

Program Counter (PC):

Initializes at address 0x1000

Increments by 4 each cycle

Supports branch/jump updates

Instruction Memory (IMEM):

Preloaded from .mem file using $readmemh

Word-aligned access (PC[31:2])

Register File:

32 registers (x0–x31)

Dual read ports, single write port

Register x0 hardwired to zero

Reset initializes registers to 0

ALU (Arithmetic Logic Unit):

Performs ADD, SUB, AND, OR, SLL (shift left logical)

Operation selected via control signals

Control Unit:

Main Decoder: Generates high-level control signals (regwrite, alusrc, memwrite, resultsrc, branch, aluop, immsrc) based on opcode

ALU Decoder: Generates specific ALU operations from funct3/funct7 and aluop

Data Memory:

Supports word-aligned loads and stores

Integrated with memwrite and resultsrc controls

🧪 Simulation

Testbenches are provided to verify:

PC incrementation and instruction fetch

Register file reads/writes

ALU operations (ADD, SUB, AND, OR, SLL)

Memory read/write

Control signals toggling per instruction

Waveform inspection (Vivado Simulator) confirmed correct datapath and control interactions.

📂 File Structure
├── pcounter.v
├── pcadder.v
├── instruction_memory.v
├── regfile.v
├── ALU.v
├── datamem.v
├── controlunit.v
├── mdecoder.v
├── aludecoder.v
├── Single_Cycle_top.v
├── instmem.mem   # Program in hex format
├── tb_Single_Cycle_top.v

▶️ Running the Simulation

Open Vivado and create a new project.

Add all Verilog source files and instmem.mem.

Add the testbench (tb_Single_Cycle_top.v).

Run Behavioral Simulation.

Observe waveforms for PC_TOP, RD_Inst, RD1_TOP, RD2_TOP, ALU_RESULT, regwrite, memwrite, etc.

🚀 Future Work

Add support for more RV32I instructions (SLT, XOR, shifts).

Implement JALR and additional branch types (BNE, BLT, BGE).


✍️ Author: Masooma Zainab
📅 Date: February 2025
Extend to a pipelined CPU with hazard handling.

Integrate with FPGA for on-board testing.
