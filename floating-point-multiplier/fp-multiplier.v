`include "../modules/adder-subtractor.v"
`include "../modules/multiplier.v"

module fp_multiplier(
	input [31:0] a,b,
	output [31:0] out
);

	wire sign,NaN,zero,shift;
	wire [47:0]prod;
	wire [7:0]exp_intermediate,exp_final;

	xor(sign,a[31],b[31]);
	multiplier_24bit mult({1'b1,a[22:0]},{1'b1,b[22:0]},prod);
	assign shift=prod[47];

	adder_8bit get_exp_intermediate(a[30:23],b[30:23],shift,exp_intermediate);
	adder_8bit get_exp_final(exp_intermediate,8'b10000000,1'b1,exp_final); // 2nd input is 1's complement of 127

	assign NaN=(&a[30:23] | &b[30:23]);
	assign zero=~(|a[30:23] & |b[30:23]);

	select_output final(sign,exp_final,prod[46:23],NaN,zero,shift,out);

endmodule

module mux(
	input i0,i1,s,
	output o
);

	assign o = (i0 & ~s) | (i1 & s);

endmodule

module select_output(sign,exp,mantissa,nan,zero,shift,final_product);

	input sign,nan,zero,shift;
	input [7:0]exp;
	input [23:0]mantissa;
	output [31:0]final_product;

	wire [22:0]mantissa_normalised;
	wire [7:0]nan_or_zero_exp;
	wire nan_or_zero;

	assign nan_or_zero=nan|zero;
	mux check_nan_or_zero_sign(sign,1'b0,nan_or_zero,final_product[31]);

	genvar i;
	generate
		for(i=22;i>=0;i=i-1)
		begin
			mux normalise(mantissa[i],mantissa[i+1],shift,mantissa_normalised[i]);
			mux check_nan_or_zero_mantissa(mantissa_normalised[i],1'b0,nan_or_zero,final_product[i]);
		end
		for(i=30;i>=23;i=i-1)
		begin
			mux find_nan_or_zero_exp(1'b1,1'b0,zero,nan_or_zero_exp[i-23]);
			mux check_nan_or_zero_exp(exp[i-23],nan_or_zero_exp[i-23],nan_or_zero,final_product[i]);
		end
	endgenerate

endmodule