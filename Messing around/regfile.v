module register8_file_16bit(data_in, writenum, write_in, readnum, clk, data_out);
    input [15:0] data_in;
    input [2:0] writenum, readnum;
    input write_in;
    input clk;

    output [15:0] data_out;

    wire [7:0] reg_select, write, mux_select;
    wire [15:0] reg_out [7:0];
    
    decoder #(3,8) writehotcode(writenum, reg_select);
    decoder #(3,8) readhotcode(readnum, mux_select);

    assign write = write_in ? reg_select : 8'b00000000;

    vDFFE #(16) reg0(clk, write[0], data_in[15:0], reg_out[0]);
    vDFFE #(16) reg1(clk, write[1], data_in[15:0], reg_out[1]);
    vDFFE #(16) reg2(clk, write[2], data_in[15:0], reg_out[2]);
    vDFFE #(16) reg3(clk, write[3], data_in[15:0], reg_out[3]);
    vDFFE #(16) reg4(clk, write[4], data_in[15:0], reg_out[4]);
    vDFFE #(16) reg5(clk, write[5], data_in[15:0], reg_out[5]);
    vDFFE #(16) reg6(clk, write[6], data_in[15:0], reg_out[6]);
    vDFFE #(16) reg7(clk, write[7], data_in[15:0], reg_out[7]);

    multiplexer8 #(16) outmux(reg_out[7], reg_out[6], reg_out[5], reg_out[4], reg_out[3], reg_out[2], reg_out[1], reg_out[0], mux_select, data_out);
endmodule