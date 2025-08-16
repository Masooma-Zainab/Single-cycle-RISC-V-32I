`timescale 1ns / 1ps
module mdecoder (
    input [6:0] op,
    input zero,                 // ALU zero flag
    output reg regwrite,        // Register write enable
    output reg memwrite,        // Memory write enable
    output reg resultsrc,       // Result source (0=ALU, 1=MEM)
    output reg alusrc,          // ALU source (0=reg, 1=imm)
    output reg [1:0] immsrc,    // Immediate source selector
    output reg [1:0] aluop,     // ALU operation control
    output reg branch,
    output reg pcsrc            // PC source (0=PC+4, 1=branch target)
);

    

    always @(*) begin
        // Default values
        regwrite  = 0;
        memwrite  = 0;
        resultsrc = 0;
        alusrc    = 0;
        immsrc    = 2'b00;
        aluop     = 2'b00;
        branch    = 0;
        pcsrc     = 0;

        case (op)
            7'b0110011: begin // R-type (add, sub, and, or)
                regwrite = 1;
                alusrc   = 0;
                aluop    = 2'b10;
            end
            7'b0010011: begin // I-type (addi, andi, ori)
                regwrite = 1;
                alusrc   = 1;
                aluop    = 2'b10;
                immsrc   = 2'b00; // I-type immediate
            end
            7'b0000011: begin // LW
                regwrite  = 1;
                alusrc    = 1;
                resultsrc = 1; // select memory data
                aluop     = 2'b00; // force ADD
                immsrc    = 2'b00; // I-type
            end
            7'b0100011: begin // SW
                memwrite = 1;
                alusrc   = 1;
                aluop    = 2'b00; // force ADD
                immsrc   = 2'b01; // S-type
            end
            7'b1100011: begin // Branch (BEQ/BNE)
                branch  = 1;
                alusrc  = 0;
                aluop   = 2'b01; // force SUB
                immsrc  = 2'b10; // B-type
                // Only BEQ supported here:
                pcsrc   = branch & zero;
            end
            7'b1101111: begin // JAL
                regwrite = 1;
                immsrc   = 2'b11; // J-type
                pcsrc    = 1;     // always take jump
            end
            default: begin
                // keep defaults
            end
        endcase
    end

endmodule
