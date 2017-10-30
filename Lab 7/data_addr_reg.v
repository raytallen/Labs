module data_addr_reg(clk, load_addr, datapath_out, data_addr_out)

    input [8:0] datapath_out;
    input load_addr, clk;
    output [8:0] data_addr_out;


    register #(9) data_addr_reg1(clk, load_addr, datapath_out, data_addr_out);

endmodule


   module register(clk, load, in, out) ;
    parameter n = 16;  // width
    input clk, load ;
    input  [n-1:0] in ;
    output [n-1:0] out ;
    reg    [n-1:0] out ;
    wire   [n-1:0] next_out ;

    assign next_out = load ? in : out;

    always @(posedge clk)
      out = next_out;  
endmodule