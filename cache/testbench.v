`include "cache.v"

module top ();

	reg [15:0] read_addr, write_addr;
	reg [31:0] write_data;
	reg clk;
	reg read_enable, write_enable;
	wire [31:0] read_data;
	
	cache C1 (read_addr, write_addr, write_data, read_enable, write_enable, clk, read_data);

	initial begin
		
		read_enable = 1'b1;
		read_addr = 16'b10_1110000000_1011;
		
		#10 read_enable = 1'b0;
		write_enable = 1'b1;
		write_addr = 16'b10_1110000000_1011;
		write_data = 32'h0F0F0F0F;

		#10 write_enable = 1'b0;
		read_enable = 1'b1;
		read_addr = 16'b10_1110000000_1011;
		
		#10 read_enable = 1'b0;
		read_enable = 1'b1;
		read_addr = 16'b10_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 16'b10_1110000000_1011;
		#10 read_enable = 1'b0;
		
		#10 write_enable = 1'b1;
		write_addr = 16'b11_1110000000_1011;
		write_data = 32'h0F0F0F0F;
		#10 write_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 16'b11_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 write_enable = 1'b1;
		write_addr = 17'b100_1110000000_1011;
		write_data = 32'h0F0F0F0F;
		#10 write_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 17'b110_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 read_enable = 1'b1;
		read_addr = 17'b100_1110000000_1011;
		#10 read_enable = 1'b0;

		#10 $finish;
	end

	initial begin
		clk = 0;
		forever begin
			#10 clk = ~clk;
		end
	end

endmodule
