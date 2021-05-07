`include "32rdcla.v"
module rdcla32_tb;
    reg [31:0] a, b;
    reg cin,clk;
    wire [31:0] sum;
    wire cout;

    initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

    rdcla rdcla0(sum, cout, a, b, cin, clk);
    initial begin
		cin=1'b0;
        a = 32'd25;
        b = 32'd76;
    #100 $finish();
    end
    initial 
        $monitor($time,"A = %d, B = %d,cin= %b, Sum = %b, cout = %b", a, b,cin, sum, cout);
endmodule