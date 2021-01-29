`include "mux32.v"
`include "tristate.v"

module register_file(
	input clk,
	input read_enable,
	input [4:0]out_addr_1,
	input [4:0]out_addr_2,
	output [31:0]out_data_1,
	output [31:0]out_data_2,
	input write_enable,
	input [4:0]in_addr,
	input [31:0]in_data,
	input reset
);

	wire [31:0]out_data_1_aux,out_data_2_aux;
	reg [31:0] register [31:0];
	genvar i;
	integer j;

	generate
		for(i=0; i<32; i=i+1)begin
			m_mux32 mux1 ({register[31][i],register[30][i],register[29][i],register[28][i],register[27][i],register[26][i],register[25][i],register[24][i],register[23][i],register[22][i],register[21][i],register[20][i],register[19][i],register[18][i],register[17][i],register[16][i],register[15][i],register[14][i],register[13][i],register[12][i],register[11][i],register[10][i],register[9][i],register[8][i],register[7][i],register[6][i],register[5][i],register[4][i],register[3][i],register[2][i],register[1][i],register[0][i]}, out_addr_1, out_data_1_aux[i]);
			m_mux32 mux2 ({register[31][i],register[30][i],register[29][i],register[28][i],register[27][i],register[26][i],register[25][i],register[24][i],register[23][i],register[22][i],register[21][i],register[20][i],register[19][i],register[18][i],register[17][i],register[16][i],register[15][i],register[14][i],register[13][i],register[12][i],register[11][i],register[10][i],register[9][i],register[8][i],register[7][i],register[6][i],register[5][i],register[4][i],register[3][i],register[2][i],register[1][i],register[0][i]}, out_addr_2, out_data_2_aux[i]);
		end
	endgenerate

	m_tristate out1 (clk,out_data_1_aux,read_enable,out_data_1);
	m_tristate out2 (clk,out_data_2_aux,read_enable,out_data_2);

	initial
		for(j=0;j<32;j=j+1)
			register[j]=32'b0;

	always @(posedge clk)
	begin
		if(write_enable)
			register[in_addr] <= in_data;
		if(reset)
			for(j=0;j<32;j=j+1)
				register[j]=32'b0;
	end

endmodule