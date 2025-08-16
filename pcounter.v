`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2025 09:11:09 PM
// Design Name: 
// Module Name: pc
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2025 04:45:51 PM
// Design Name: 
// Module Name: pcounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pcounter (
    input clk,
    input rst,
    input [31:0] next_pc,
    output reg [31:0] outpc // Declare as reg since it is assigned in an always block
);



always @(posedge clk or posedge rst) begin
    if (rst)
    begin
        outpc <= 32'h1000;  // Initialize PC to 0x1000 on reset
     end 
     else  
     outpc <= next_pc; // Increment PC by 4 on each clock cycle

end

endmodule

