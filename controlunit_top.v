`timescale 1ns / 1ps
module controlunit (
    input  [6:0] OP, 
    input  [6:0] funct7,
    input  [2:0] funct3,
    output       alusrc, memwrite, resultsrc, branch, regwrite,
    output [1:0] immsrc,
    output [2:0] alucontrol
);

    wire [1:0] aluop;

    // Main decoder
    mdecoder mdec (
        .op(OP),
        .regwrite(regwrite),
        .immsrc(immsrc),
        .alusrc(alusrc),
        .aluop(aluop),
        .memwrite(memwrite),
        .resultsrc(resultsrc),
        .branch(branch)
    );

    // ALU decoder
    aludecoder adec (
        .aluop(aluop),
        .funct3(funct3),
        .funct7(funct7),
        .alucontrol(alucontrol)
    );

endmodule
