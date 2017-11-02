/* ALU
    Does arithmetic on two 16 bit input, depending on what ALUop input is
*/
module ALU(Ain, Bin, ALUop, out, status);
    input [15:0] Ain, Bin;
    input [1:0] ALUop;
    output reg [15:0] out;
    output reg status;
    /*
    If ALUop == 00, add inputs
    If ALUop == 01, subtract inputs
    If ALUop == 10, AND inputs
    If ALUop == 11, NOT b-input
    */
    always @(*) begin
        case(ALUop)
        2'b00: out = Ain[15:0] + Bin[15:0];
        2'b01: out = Ain - Bin;
        2'b10: out = Ain & Bin;
        2'b11: out = ~Bin;
        endcase

        
    end
endmodule