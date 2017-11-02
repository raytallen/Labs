/* Testbench for the 8 wide, 16 bit register

*/

module register8_file_16bit_tb();
    reg [15:0] data_in;
    reg [2:0] writenum, readnum;
    reg write, clk;
    wire [15:0] data_out;
    reg CLOCK_50;

    register8_file_16bit DUT(data_in, writenum, write, readnum, CLOCK_50, data_out);

    //Set's the clock
    initial begin
		CLOCK_50 = 0; #2;
		forever begin
			CLOCK_50 = 1; #2;
			CLOCK_50 = 0; #2;
		end
	end

    initial begin
        //Stores the value 1 into reg1
        data_in = 16'b0000000000000001; #5;
        writenum = 3'b001; #5;
        write = 1; #5; write = 0; #5;
        //Reads the value from reg1, expecting the value stored into reg1
        readnum = 3'b001; #5;

        //Stores the value data_in value into reg7
        data_in = 16'b1111111111111111; #5;
        writenum = 3'b111; #5;
        write = 1; #5; write = 0; #5;
        //Reads the value from reg7, expecting the value stored into reg7
        readnum = 3'b111; #5;

        //reads the value from reg1, expecting the value stored into reg1
        readnum = 3'b001; #5;
    end
endmodule