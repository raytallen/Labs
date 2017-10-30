module prog_count(load_pc, reset_pc, PC_out);

    input load_pc, reset_pc;
    output [8:0] PC_out;
    wire [8:0] next_pc, adder_out;

    assign adder_out = PC_out + 1;

    multiplexer2 pcmux(adder_out, 9'b000000000, reset_pc, next_pc);

    vDFF #(9) prog_counter(load_pc, next_pc, PC_out);

endmodule

/* BINARY MULTIPLEXER */
module multiplexer2 (a1, a0, s, b);
    parameter k = 16;
    input [k-1:0] a0, a1; //inputs
    input s; //binary select
    output reg [k-1:0] b;

    always @(*) begin
      case(s)
        1'b0: b = a0;
        1'b1: b = a1;
        default: b = {k{1'bx}};
      endcase
    end
endmodule