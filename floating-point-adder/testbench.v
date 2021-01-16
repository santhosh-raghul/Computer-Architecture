`include "fp-adder.v"

module top;

	reg [31:0]a, b;
	wire [31:0]out;

	fp_adder FP1 (a, b, out);

	initial
	begin

		a=32'b0_10101010_10101010101010101010101;
		b=32'b0_10101010_01010101010101010101010;
		#5 $display("%b_%b_%b",out[31], out[30:23], out[22:0]);

		a=32'b01010101010101010101010101010101;
		b=32'b01010101010101010101010101010101;
		#5 $display("%b_%b_%b", out[31], out[30:23], out[22:0]);

		a=32'b11010101011111111101010101010100;
		b=32'b01010100111111111111111010101110;
		#5 $display("%b_%b_%b", out[31], out[30:23], out[22:0]);

		a=32'b1_10001100_00011000010001100011111;	//-8968.78
		b=32'b0_10001101_11001010100011111000001;	//29347.877
		#5 $display("output: %b %b %b", out[31], out[30:23], out[22:0]); //0 10001101 00111110011011000110010 -> 20379.098


		a=32'b1_10001100_00110001100101010101110;	//-9778.67
		b=32'b0_10001100_00110001100101010101110;	//9778.67
		#5 $display("output: %b %b %b", out[31], out[30:23], out[22:0]); // all 0s

		a=32'b0_10001000_00001010000011111101100;	// 532.1238
		b=32'b0_10010000_11001101110111010111011;	// 236474.92
		#5 $display("output: %b %b %b", out[31], out[30:23], out[22:0]);// 0 10010000 11001110111001111000010 -> 237007.05

	end

endmodule