`include "wallace.v"
module wallace_tb;
    reg [31:0] a, b;
    reg cin,clk;
    wire [63:0] out;
    //wire cout;

    initial begin
		clk=0;
	end

	always 
		#1 clk=~clk;

    wallace wallace0( a, b, clk, out);
    initial begin
		//cin=1'b0;
        a = 32'd4073741824;
        b = 32'd4073741824;
    #25 $finish();
    end
		always@( clk)
        $display($time," A = %d, B = %d, Product = %b", a, b, out);

    // initial 
    //     $monitor($time," A = %d, B = %d, Product = %b", a, b, out);
endmodule