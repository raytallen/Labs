// cpu module 
module cpu(clk,reset,s,load,in,out,N,V,Z,w);
  input clk, reset, s, load;
  input [15:0] in;
  output [15:0] out;
  output N, V, Z, w;
  
  wire [15:0] instregout, sximm5, sximm8;  
  wire [2:0] opcode, readnum, writenum, nsel;  
  wire [1:0] ALUop, op, shift; 
  wire write, loada, loadb, loadc, loads, asel, bsel; 
  wire [1:0] vsel;  
  wire [2:0] statusout;
  wire [7:0] PC; 
  wire [15:0] mdata; 

   
  // for lab 6, PC and mdata are 0
  assign PC = 8'b00000000;               
  assign mdata = 16'b0000000000000000;
 
  assign Z = statusout[0]; // zero flag 
  assign N = statusout[1]; // negative flag 
  assign V = statusout[2]; // overflow flag 
  
  
  // instruction register 
  vDFFE #(16) instruction(clk, load, in, instregout);   
  // instruction decoder block
  instructionDecoder insDec(instregout, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op); 
  // state machine 
  stateMachine FSM(s, reset, opcode, op, clk, w, nsel, write, loada, loadb, loadc, loads, asel, bsel, vsel);
  // datapath 
  datapath DP(clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, 
                writenum, write, mdata, sximm8, sximm5, PC, statusout, out);



 endmodule

// insttruction decoder module 
module instructionDecoder(instregout, nsel, ALUop, sximm5, sximm8, shift, readnum, writenum, opcode, op); 
  input [15:0] instregout; 
  input [2:0] nsel; 
  output [1:0] ALUop; 
  output [15:0] sximm5; 
  output [15:0] sximm8; 
  output [1:0] shift; 
  output [2:0] readnum, writenum;  
  output [2:0] opcode; 
  output [1:0] op; 

  wire [2:0] Rn, Rd, Rm, R; 
  wire [4:0] imm5; 
  wire [7:0] imm8; 

  assign opcode = instregout[15:13];  		//assign value vased off figure in lab manual
  assign op = instregout[12:11]; 
  assign ALUop = instregout[12:11]; 
  assign imm5 = instregout[4:0];  
  assign imm8 = instregout[7:0]; 
  assign shift = instregout[4:3]; 
  assign Rn = instregout[10:8]; 
  assign Rd = instregout[7:5]; 
  assign Rm = instregout[2:0]; 

  // multiplexer selects one of Rn, Rd, or Rm 
  MUX3 #(3) Rmux(Rm, Rd, Rn, nsel, R); 
  assign readnum = R; // readnum is output of multiplexer
  assign writenum = R; // writenum is output of multiplexer 

  //assign sximm5 = {11{imm5[4]}, imm5[4:0]}; 
  //assign sximm8 = {8{imm5[7]}, imm5[7:0]}; 
  assign sximm5 = {imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4],imm5[4:0]};
  assign sximm8 = {imm8[7],imm8[7],imm8[7],imm8[7],imm8[7],imm8[7],imm8[7],imm8[7],imm8[7:0]};
endmodule 

`define s1 5'b00000			//definitions used for future reference
`define s2 5'b00001
`define s3 5'b00010
`define s4 5'b00011
`define s5 5'b00100
`define s6 5'b00101
`define s7 5'b00110
`define s8 5'b00111
`define s9 5'b01000
`define s10 5'b01001
`define s11 5'b01010
`define s12 5'b01011
`define s13 5'b01100
`define s14 5'b01101

//States added Lab 7
`define sIF1 5'b10000
`define sIF2 5'b10001
`define sUpdatePC 5'b10010
`define sReset 5'b10011

// state machine module 
module stateMachine(s, reset, opcode, op, clk, w, nsel, write, loada, loadb, loadc, loads, asel, bsel, vsel); 
  parameter n = 3; // width of nsel signal 
  input s, reset;  
  input [2:0] opcode; 
  input [1:0] op; 
  input clk; 

  output w; 
  output [n-1:0] nsel; 
  output write, loada, loadb, loadc, loads, asel, bsel;
  output [1:0] vsel; 
 
  reg [3:0] present_state, next_state; 
  reg w; 
  reg [n-1:0] nsel; 
  reg write, loada, loadb, loadc, loads, asel, bsel;
  reg [1:0] vsel; 

  always@(posedge clk) begin 
    if (reset) begin 
			present_state = `s1;  // if reset is 1, go to state 1 - Wait state 
			next_state = `s1; 
    end else begin 
		case(present_state) 
			`s1: if (s) // wait state
			next_state = `s2; // wait for s to move to decode state 
					else 
			next_state = `s1; 
			`s2: if (opcode == 3'b110) // decode state: move or ALU 
			next_state = `s10;  // Move branch	
					else if (opcode == 3'b101)
			next_state = `s3; // getA state: first state of ALU branch 
					else 
			next_state = 4'bxxxx;
			`s10: if(op == 2'b10)
			next_state = `s11; //writeReg state
					else if (op == 2'b00)
			next_state = `s12; //loadb state
			`s12: next_state = `s13; //add state (asel = 0)
			`s13: next_state = `s14; //writeReg state
			`s14: next_state = `s1; //end of mov (op == 00) branch
			`s11: next_state = `s1; //end of mov (op == 10) branch
			`s3: next_state = `s4; // getB state 
			`s4: if (op == 2'b00) 
			next_state = `s5; // add state
					else if (op == 2'b01)  
			next_state = `s6; // subtraction state 
					else if (op == 2'b10) 
			next_state = `s7; // AND state 
					else if (op == 2'b11) 
			next_state = `s8; // NOT state 
					else 
			next_state = 4'bxxxx; 
			`s5: next_state = `s9; // writeReg state: all ALU operations go to state 10 
			`s6: next_state = `s9; //unconditionally move from any calculation state to writeRegC state
			`s7: next_state = `s9; 
			`s8: next_state = `s9;  
			`s9: next_state = `s1; //after writiting calculation, moves back to wait state
			default: next_state = 4'bxxxx; 
		endcase

			present_state = next_state; 

		case (present_state) 
			`s1: begin // wait state
				w = ~s; // turn w signal to on if we are in the wait state and the start ("s") signal is off
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'b00;
			//in state one we want to reset everything just in case
			end 

			`sIF1: begin //IF1 State

			end

			`sIF2: begin //IF2 State

			end

			`s2: begin // decode state 
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
			//in state 2 we are just checking for opcode so no outputs necessary
			end

			`s10: begin // start of mov branch
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
			//start of mov branch and checks for op - no outputs	
			end 

			`s3: begin // getA state 
				w = 1'b0; 
				nsel = 3'b001;  write = 1'b0; 
				loada = 1'b1; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//we need to loada to be on to enable loadA register
			//nsel is 3'b001 to choose Rn to make readnum be the value of the register we want to read from for loadA
			end 

			`s4: begin // getB state 
				w = 1'b0; 
				nsel = 3'b100;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b1; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//need loadb to be on to enable loadB register
			//nsel is 3'b100 to select Rm to set readnum to be the value of the register we want to read from for loadB
			end 
			
			`s5: begin // add state 
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b1; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//calculation state - loads/loadc on
			end 

			`s6: begin // subtraction state 
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b1; loads = 1'b1; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//calculation state - loads/loadc on
			end

			`s7: begin // AND state 
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b1; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//calculation state - loads/loadc on
			end 

			`s8: begin // NOT state
				w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b1; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
				//calculation state - loads/loadc on	
			end 

			`s9: begin // writeReg C
							w = 1'b0; 
				nsel = 3'b010;  write = 1'b1; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'b00;
			//nsel is set to Rd to set writenum to the register value we want to set our calculated value to
			end

			`s11: begin //writeReg 
							w = 1'b0; 
				nsel = 3'b001;  write = 1'b1; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'b10;
			//set nsel to 001 so the writenum is set to Rn so immediate value inputted goes the register that we input
			end

			`s12: begin //loadB state in mov branch
							w = 1'b0; 
				nsel = 3'b100;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b1; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'bxx;
			//set nsel to 100 so writenum gets the value of Rm so loadB reads from the register indicated with Rm
			end

			`s13: begin //add state (asel = 1)
						w = 1'b0; 
				nsel = 3'b000;  write = 1'b0; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b1; loads = 1'b0; asel = 1'b1; bsel = 1'b0; vsel = 2'bxx;
			//calculation state - loada/loadc on
			//set asel to 1 so we add 0 to B so we can output B by itself
			end 

			`s14: begin //writeReg state in mov branch
							w = 1'b0; 
				nsel = 3'b010;  write = 1'b1; 
				loada = 1'b0; loadb = 1'b0; loadc = 1'b0; loads = 1'b0; asel = 1'b0; bsel = 1'b0; vsel = 2'b00;
			//nsel set to Rd so the output gets written to register indicated by Rd (write = value of Rd)
			end
			endcase 
    end 
   end
endmodule
  
