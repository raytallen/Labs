module lab7_top_tb();
  reg [3:0] KEY;
  reg [9:0] SW;
  wire [9:0] LEDR; 
  wire [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  reg CLOCK_50;

  lab7_top DUT(KEY,SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,CLOCK_50);

  
  initial begin 
    KEY[0] = 1; #5; 
     forever begin // rising edge of the clock every 5 ps 
        KEY[0] = 0; #5; 
        KEY[0] = 1; #5; 
     end 
  end  

  initial begin
    KEY[1] = 1; #5;
    KEY[1] = 0; #5;
    KEY[1] = 1; #5;
    KEY[2] = 1; #5;
    KEY[2] = 0; #30;
    KEY[2] = 0; #5;
  end

endmodule