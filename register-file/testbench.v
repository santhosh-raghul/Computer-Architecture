`include "register-file.v"

module top;

reg [4:0]addr1,addr2,in_addr;
wire [31:0]out1,out2;
reg [31:0]in_data;
reg write_enable,read_enable,reset,clk;
integer j;

register_file regs (clk,read_enable,addr1,addr2,out1,out2,write_enable,in_addr,in_data,reset);

always #5 clk = ~clk;

initial begin

	clk = 0;
	reset=1'b0;

	read_enable = 1'b1;
	addr1 = 5'd0;
	addr2 = 5'd2;
	#20 $display("initial\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	write_enable = 1'b1;
	in_addr = 5'd2;
	in_data = 32'd2222;
	#20 $display("write 2222 at 2 with write_enable high\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	write_enable = 1'b0;
	in_addr = 5'd0;
	in_data = 32'd1234;
	#20 $display("try to write 1234 at 0 with write enable low\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);
	write_enable = 1'b1;
	#20 $display("write enable high\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	in_addr = 5'd2;
	in_data = 32'd5678;
	#20 $display("write 5678 at 2 with write enable high\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	write_enable = 1'b0;
	read_enable = 1'b0;
	#20 $display("read enable low\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	read_enable = 1'b1;
	#20 $display("read enable high\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);
	
	reset=1'b1;
	#20 $display("reset high\n[%d ]: %d\t[%d ]: %d",addr1,out1,addr2,out2);

	$finish;

end

endmodule