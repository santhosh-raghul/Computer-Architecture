`include "../modules/adder-subtractor.v"
`include "../modules/multiplier.v"

module m_fp_multiplier(
	input [31:0] a,b,
	output [31:0] final_product
);

	wire w_sign,w_NaN,w_zero,w_shift;
	wire [47:0]w_prod;
	wire [7:0]w_exp_intermediate,w_exp_final;

	xor(w_sign,a[31],b[31]);
	multiplier_24bit mult({1'b1,a[22:0]},{1'b1,b[22:0]},w_prod);
	assign w_shift=w_prod[47];

	adder_8bit get_exp_intermediate(a[30:23],b[30:23],w_shift,w_exp_intermediate); // 1 will be added through cin if shift is required 
	adder_8bit get_exp_final(w_exp_intermediate,8'b10000000,1'b1,w_exp_final); // 2nd input is 1's complement of 127

	assign w_NaN=(&a[30:23] | &b[30:23]);
	assign w_zero=~(|a[30:23] & |b[30:23]);

	m_select_output final(w_sign,w_exp_final,w_prod[46:23],w_NaN,w_zero,w_shift,final_product);

endmodule

module m_mux(
	input i0,i1,s,
	output o
);

	assign o = (i0 & ~s) | (i1 & s);

endmodule

module m_select_output(sign,exp,mantissa,nan,zero,shift,final_product);

	input sign,nan,zero,shift;
	input [7:0]exp;
	input [23:0]mantissa;
	output [31:0]final_product;

	wire [22:0]w_mantissa_normalised;
	wire [7:0]w_nan_or_zero_exp;
	wire w_nan_or_zero;

	assign w_nan_or_zero=nan|zero;
	m_mux check_nan_or_zero_sign(sign,1'b0,w_nan_or_zero,final_product[31]);

	genvar i;
	generate
		for(i=22;i>=0;i=i-1)
		begin
			m_mux normalise(mantissa[i],mantissa[i+1],shift,w_mantissa_normalised[i]);
			m_mux check_nan_or_zero_mantissa(w_mantissa_normalised[i],1'b0,w_nan_or_zero,final_product[i]);
		end
		for(i=30;i>=23;i=i-1)
		begin
			m_mux find_nan_or_zero_exp(1'b1,1'b0,zero,w_nan_or_zero_exp[i-23]);
			m_mux check_nan_or_zero_exp(exp[i-23],w_nan_or_zero_exp[i-23],w_nan_or_zero,final_product[i]);
		end
	endgenerate

endmodule