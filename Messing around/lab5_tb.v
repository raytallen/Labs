// testbench for lab5 datapath
module datapath_tb;

  reg [3:0] KEY;
  reg [9:0] SW;
  reg CLOCK_50;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

/*
  wire [15:0] datapath_out, datapath_in;
  wire write, vsel, loada, loadb, asel, bsel, loadc, loads;
  wire [2:0] readnum, writenum;
  wire [1:0] shift, ALUop;

*/
	lab5_top dut(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

/*
	initial begin
		KEY[0] = 0; #5;
		forever begin
			KEY[0] = 1; #5;
			KEY[0] = 0; #5;
		end
	end
*/

	initial begin
		CLOCK_50 = 0; #1;
		forever begin
			CLOCK_50 = 1; #1;
			CLOCK_50 = 0; #1;
		end
	end


// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// <<register read stage>>
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// <<execute stage>>
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// <<writeback stage>>
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]
	initial begin
//		test 1
		SW[9:0]  = 10'd0;
		KEY[0] = 1; #5;
		SW[9:0] = 10'b1000000000; #10;
//		datapath in set to 1
		SW[9:0] = 10'b1000000001; #5;
//		switch to read cycle
		SW[9:0] = 10'd0; #5;
//		write to register 0
		SW[9:0] = 10'b0000010001; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		datapath set to 5
		SW[9:0] = 10'b1000000101; #5;
//		switch to read cycle again 
		SW[9:0] = 10'd0; #5;
//		write to register 1
		SW[9:0] = 10'b0000010011; #5;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 1 to load a
		SW[9:0] = 10'b0001000000; #5;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 0 to load b
		SW[9:0] = 10'b0000100010; #5;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		execute addition then load c
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b0010000000; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		expected value of data_out is 10'b0000000110


//		lab specified case test
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b1000000111; #2;
		SW[9:0] = 10'b0000000000; #2;
//		load value 7 into register 1
		SW[9:0] = 10'b0000010011; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		load 2 into register 0
		SW[9:0] = 10'b1000000010; #2;
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b0000010001; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 1 to register b
		SW[9:0] = 10'b0001000010; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 0 to register a
		SW[9:0] = 10'b0000100000; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		execute addition with reg b shifted 1 bit left
		SW[9:0] = 10'b0010000010; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		write result to register 2
		SW[9:0] = 10'b0000000101; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		expected value of register 2 is 16


//		test case 3
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b1000001111; #2;
		SW[9:0] = 10'b0000000000; #2;
//		load value 15 into register 1
		SW[9:0] = 10'b0000010011; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		load 6 into register 0
		SW[9:0] = 10'b1000000110; #2;
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b0000010001; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 1 to register a
		SW[9:0] = 10'b0000100010; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		read register 0 to register b
		SW[9:0] = 10'b0001000000; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		execute addition with reg b shifted 1 bit left
		SW[9:0] = 10'b0010100010; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		write result to register 2
		SW[9:0] = 10'b0000000101; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		expected value of register 2 is 10'b0000000011

//		test 4
//		value in reg a & value in reg b stored to reg c
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b0011000001; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		expected value of data_out is 10'b0000000110

//		test 5
//		~value in reg b stored to reg c
		SW[9:0] = 10'b0000000000; #2;
		SW[9:0] = 10'b0011100001; #2;
		KEY[0] = 1'b0; #2;
		KEY[0] = 1'b1; #2;
//		expected value of data_out is 10'b1111111001



		end
endmodule
// control signal(s)  switch(es)
// ~~~~~~~~~~~~~~~~~  ~~~~~~~~~       
// <<register read stage>>
//           readnum  SW[3:1]
//             loada  SW[5]
//             loadb  SW[6]
// <<execute stage>>
//             shift  SW[2:1]
//              asel  SW[3]
//              bsel  SW[4]
//             ALUop  SW[6:5]
//             loadc  SW[7]
//             loads  SW[8]
// <<writeback stage>>
//             write  SW[0]      
//          writenum  SW[3:1]
//              vsel  SW[4]



