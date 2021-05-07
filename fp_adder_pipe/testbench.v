`include "adder.v"
// r_ register
// m for module
module top();

reg [31:0]r_a, r_b,r_s;
reg r_cin,clk;
wire [31:0]sum;
initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

fpadd m_gh(r_a,r_b,sum,clk);

initial
begin
	// // test 1
	//r_a=32'b01010101010101010101010101010101;//0x55555555
	//r_b=32'b01010101001010101010101010101010;//0x552AAAAA
	// // test 2
	// #5r_a=32'b01010101010101010101010101010101;//0x55555555
	// r_b=32'b01010101010101010101010101010101;//0x55555555
	// // test 3
	r_a=32'b11010101011111111101010101010100;//0xd57fd554
	r_b=32'b01010100111111111111111010101110;//0x54fffeae
	// // test 4 infinity
	// #5r_a=32'b01111111111000000000000000000001;
	// r_b=32'b01111111111000000000000000000001;
	// // test 5 proper zero
	// #5r_a=32'b01000011111110100000000000000000;
    // r_b=32'b11000011111110100000000000000000;
	//zero approx; no support for denormalised numbers
	//r_a=32'b10000000111110100000000000000000;
	//r_b=32'b00000000100000000000000000000000;
	#30 $finish();
end

initial begin
	//$monitor("%t\na = %b, 0x%h, b = %b, 0x%h,\nSum = %b, 0x%h",$time,r_a,r_a,r_b,r_b,sum,sum);
	$monitor("%ta = %b, b = %b,Sum = %b",$time,r_a,r_b,sum);

	end
endmodule