`include "fp-adder.v"

module top;

	reg [31:0]a, b;
	wire [31:0]out;

	fp_adder FP1 (a, b, out);

	initial
	begin

		a=32'b1_10001111_01110010111000100111110;	// -94946.484375
		b=32'b0_10011010_00111110010000000000111;	// 166854768.0
		#5 $display("%b_%b_%b", out[31], out[30:23], out[22:0]);


		a=32'b0_10001111_11100010010000001100101;	// 123456.7890625
		b=32'b1_10001111_11100010010000001100101;	// -123456.7890625
		#5 $display("%b_%b_%b", out[31], out[30:23], out[22:0]);


		a=32'b0_10000111_11010001001010100101110;	// 465.16546630859375
		b=32'b0_10010000_10100001011110001111111;	// 213745.984375
		#5 $display("%b_%b_%b", out[31], out[30:23], out[22:0]);

	end

endmodule