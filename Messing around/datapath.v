module datapath(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, datapath_in, status, datapath_out);
    input clk; 
    input write; //Writes to selected register
    input vsel; //Selects datapath_in or datapath_out as input to register
    input loada, loadb, loadc, loads; //Load inputs to register a, b, c, s
    input asel, bsel; //Selects for a and b multiplexers
    input [1:0] shift; //Shift input for B
    input [1:0] ALUop; //Operation selector for ALU
    input [2:0] writenum; //Selects register to write
    input [2:0] readnum; //Selects register to read, outputs immediatly to data_out
    input [15:0] datapath_in; //Output of datapath
    
    output [15:0] datapath_out;
    output status;

    //Input into register file
    wire [15:0] data_in; 

    //Output of register file
    wire [15:0] data_out; 

    //Wire from a and b registers to mux and shifter
    wire [15:0] a_regtomux, b_regtoshift;

    wire [15:0] b_shifttomux;

    //Output of a and b multiplexers
    wire[15:0] ain, bin;

    //Outputs of ALU
    wire [15:0] ALU_to_reg_c; wire ALU_to_reg_status;


    //multiplexer to register file
    multiplexer2 data_in_mux(datapath_in,datapath_out,vsel,data_in);

    //register file
    register8_file_16bit regfile(data_in, writenum, write, readnum, clk, data_out);

    //A and B registers
    vDFFE #(16) rega(clk, loada, data_out, a_regtomux);
    vDFFE #(16) regb(clk, loadb, data_out, b_regtoshift);

    //B shifter
    shifter16 shiftb(b_regtoshift, shift, b_shifttomux);

    //A and B multiplexers
    multiplexer2 #(16) muxa(16'b0, a_regtomux, asel, ain);
    multiplexer2 #(16) muxb({11'b0, datapath_in[4:0]}, b_shifttomux, bsel, bin);

    ALU ALU(ain, bin, ALUop, ALU_to_reg_c, ALU_to_reg_status);

    //ALU output reg and status reg
    vDFFE #(16) regc(clk, loadc, ALU_to_reg_c, datapath_out);
    vDFFE #(16) regstatus(clk, loads, ALU_to_reg_status, status);
endmodule

