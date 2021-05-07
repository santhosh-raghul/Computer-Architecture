`include "logic.v"
module top;

reg [2:0]sel;
reg [31:0] a, b;
wire [31:0] out;

logic_u u1(a,b,sel,out);

initial
begin
#0 sel=3'b000;b=32'b0000000000000000;a=32'b1111111111111111;
#5 sel=3'b001;//a=32'b0000000000000000;b=32'b1111111111111111;
#5 sel=3'b010;
#5 sel=3'b011;
#5 sel=3'b100;
#5 sel=3'b101;
#5 sel=3'b110;
#5 sel=3'b111;

end

initial $monitor($time,"\tsel=%b a=%5b b=%5b out=%5b ",sel,a,b,out);
endmodule