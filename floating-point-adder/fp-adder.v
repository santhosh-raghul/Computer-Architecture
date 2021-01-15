`include "./modules/barrel-shifter.v"
`include "./modules/adder-subtractor.v"

module fp_adder(
	input [31:0] a,b,
	output reg [31:0] out
);

	reg S1, S2, S3;
	reg [7:0] E1, E2, E3, D;
	reg [23:0] M1, M2;
	wire [24:0] M3;
	reg [4:0] norm_shift;
	wire [23:0]M2_shifted;
	wire [24:0]M3_normalised;
	integer q;

	right_shift rs(M2,D[4:0],M2_shifted);
	adder_subtractor add(M1,M2_shifted,S1^S2,M3);
	left_shift ls(M3,norm_shift,M3_normalised);

	always@(*)
	begin

		// extract values
		S1=a[31];
		S2=b[31];
		E1=a[30:23];
		E2=b[30:23];
		M1={1'b1,a[22:0]};
		M2={1'b1,b[22:0]};

		// swap X1, X2 if |X2|>|X1|
		if(E2>E1 || (E1==E2 && M2>M1))
		begin
			S1=b[31];
			S2=a[31];
			E1=b[30:23];
			E2=a[30:23];
			M1={1'b1,b[22:0]};
			M2={1'b1,a[22:0]};
		end

		// denormalize M2; add/subt will happen in module
		// E3=E1;
		S3=S1;
		D=E1-E2;
		if(D>=23)	// shift more than 23 will yield only 0
			D=8'd23;

		// normalize result
		norm_shift=0;
		while(M3[24-norm_shift]==1'b0 && norm_shift<24)
			norm_shift=norm_shift+1;
		E3<=E1+norm_shift-1;

		// chk for 0, infinty, NaN
		if(E1==8'hff || E2==8'hff)	// infinity
			out=32'b0_11111111_11111111111111111111111;
		else if(a[30:0]==0)	// one of the inputs is zero
			out=b;
		else if(b[30:0]==0)	// one of the inputs is zero
			out=a;
		else if(M3_normalised==0)	// output is zero
			out = 32'b0;
		else	// default case
			out={S3,E3,M3_normalised[23:1]};

	end

endmodule