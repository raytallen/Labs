module mem_mapped_io_LED(clk,write_data,mem_addr,mem_cmd,LED)

    input clk;
    input [7:0] write_data;
    input [8:0] mem_addr;
    input [1:0] mem_cmd;
    output [7:0] LED;
    wire correct_addr, correct_cmd, tridriver;

//  assign mread = 2'b00;
//  assign mwrite = 2'b01;

    EqComp #(9) correct_mem_addr(0'h100, mem_addr, correct_addr);
    EqComp #(2) correct_mem_cmd(2'b01, mem_cmd, correct_cmd);

    assign load_LED = correct_addr & correct_cmd;

    register #(8) (clk, load_LED, write_data, LED);

endmodule 