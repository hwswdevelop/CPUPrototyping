module regfile( reset, clk, sel_out1, sel_out2, sel_in, wr, reg_out1, reg_out2, reg_in );
    input wire reset;
    input wire clk;
    input wire [5:0]  sel_out1;
    input wire [5:0]  sel_out2;
    input wire [5:0]  sel_in;
    input wire wr;
    output reg [15:0] reg_out1;
    output reg [15:0] reg_out2;
    input wire [15:0]  reg_in;
    reg [15:0]registers[5:0];

endmodule