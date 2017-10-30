
module MEM(clk, mem_addr, mem_cmd, write_data, data_out);
    
    input [15:0] write_data;
    input [8:0] mem_addr;
    wire [1:0] mread, mwrite;
    input [1:0] mem_cmd;
    input clk;
    output [15:0] data_out; 
    wire write_out;

    assign mread = 2'b00;
    assign mwrite = 2'b01;

    RAM ram1(clk,mem_addr[7:0],mem_addr[7:0],write_out,write_data,dout);
    interface_to_memory mem1(mread,mwrite,mem_cmd,mem_addr[8:8],dout,data_out,write_out);


endmodule