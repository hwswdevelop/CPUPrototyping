/* 
    Simple ALU - Ariphmetical and Logical unit 
    It is based on ALU of demo computer, named Hack
    There is no any pipline, combination logic only
    Author: Evgeny Sobolev
*/

module alu( x, y, zx, nx, zy, ny, f, no, out, zr, ng );

// So system of this ALU commands are not so orthogonal. (You can find the same commands)
// So system of this ALU commands are oriented to use single reg
// So system of this ALU commands are oriented to use long latency command,
// but, it minimize logic elements are used in the arch.

// zx nx zy ny  f no    command
//  1  0  1  0  0  0    out = 0 & 0, i.e. out = 0;          (0)
//  1  1  1  1  0  0    out = ~0 & ~0, i.e out = 0xFFFF;    (not 0 ; 0xFFFF; -1)
//  0  0  1  1  0  0    out = X & (~0), i.e. out = X;       (X)
//  1  1  0  0  0  0    out = Y &(~0), i.e. out = Y;        (Y)
//  0  1  1  1  0  0    out = ~X & (~0), i.e. out = ~X;     (not X)
//  1  1  0  1  0  0    out = (~0) & ~Y, i.e out = ~Y;      (not Y)
//  0  0  0  0  0  0    out = A & Y.                        (X and Y)
//  0  1  0  1  0  1    out = ~(~X & ~Y), i.e. out = X | Y  (X or Y)
//  0  1  0  0  1  1    out = ~(~X + Y), i.e out = X - Y    (X - Y) // -1 is 0xFFFF, -2 is 0xFFFE
//  0  0  0  1  1  1    out = ~(~Y + X), i.e out = Y - X    (Y - X) // -1 is 0xFFFF, -2 is 0xFFFE
//  0  0  0  1  1  0    out = X + ~Y, i.e. out = X - Y,     (X - Y, another coding ???)
//  0  1  0  0  1  0    out = ~X + Y, i.e. out = Y - X,     (Y - X, another coding ???)

input wire [15:0]x;     // Input argument X or A
input wire [15:0]y;     // Input argument Y or B
output wire [15:0]out;  // Output of ALU
input wire zx;          // Input command zx. x1 = (zx) ? 0 : x;
input wire nx;          // Input command nx, x2 = (nx) ? (~x1) : x1;
input wire zy;          // Input command zy, y1 = (zy) ? 0: y;
input wire ny;          // Input command ny, y2 = (ny) ? (~y1): y1;
input wire f;           // Input command f, temp = (f) ? (x2 + y2) : (x2 & y2);
input wire no;          // Input command no, out = (no) ? (~temp) : temp;
output wire zr;         // Output status, out is zero
output wire ng;         // Output status, out is negative

wire [15:0] int_x;
wire [15:0] int_y;
wire [15:0] int_nx;
wire [15:0] int_ny;
wire [15:0] int_out;
wire [15:0] int_nout;
assign int_x = zx ? 16'b0 : x;
assign int_y = zy ? 16'b0 : y;
assign int_nx = nx ? ~int_x : int_x;
assign int_ny = ny ? ~int_y : int_y;
assign int_out = (f) ? ( int_nx + int_ny ) : ( int_nx & int_ny );
assign int_nout = (no) ? (~int_out) : (int_out);
assign out = int_nout;
assign zr = (&int_nout);
assign ng = int_nout[15];

endmodule
