module m_tristate(
	input clk,
	input [31:0]in,
	input en,
	output reg [31:0]out
);

	always @(posedge clk)
		out = en ? in : 32'bz;

endmodule