
module interface_to_memory(mread,mwrite,mem_cmd,mem_addr,data_in,data_out,write_out);

    input [15:0] data_in;
    input mem_addr;
    input [1:0] mread, mwrite,mem_cmd;
    output [15:0] data_out;
    output write_out;
    wire msel,isread_out,tridriver,iswrite_out;

    EqComp #(1) msel1(1'b0,mem_addr,msel);
    EqComp #(2) isread1(mread,mem_cmd,isread_out);
    EqComp #(2) iswrite1(mwrite,mem_cmd,iswrite_out);

    assign tridriver = msel & isread_out;

    // TRI STATE DRIVER
    assign data_out = tridriver ? data_in : 'bzzzzzzzzzzzzzzzz;

    assign write_out = iswrite_out & msel;

endmodule

/* EQUALITY COMPARATOR
    Compares 2 k-bit signals for equality */
module EqComp(a, b, eq);
    parameter k = 8;
    input [k-1:0] a, b;
    output eq;
    assign eq = (a==b);
endmodule

