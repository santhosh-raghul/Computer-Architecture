module left_shift(in,shift,out);

	input [24:0]in;
	input [4:0]shift;
	output [24:0]out;

	wire [24:0]stage1,stage2,stage3,stage4;
	genvar i;

	// stage 1
	mux stage_1_0(1'b0,in[0],shift[0],stage1[0]);
	generate
		for(i=1;i<25;i=i+1)
			mux stage_1(in[i-1],in[i],shift[0],stage1[i]);
	endgenerate

	// stage 2
	mux stage_2_0(1'b0,stage1[0],shift[1],stage2[0]);
	mux stage_2_1(1'b0,stage1[1],shift[1],stage2[1]);
	generate
		for(i=2;i<25;i=i+1)
			mux stage_2(stage1[i-2],stage1[i],shift[1],stage2[i]);
	endgenerate

	// stage 3
	generate
		for(i=0;i<4;i=i+1)
			mux stage_3(1'b0,stage2[i],shift[2],stage3[i]);
	endgenerate
	generate
		for(i=4;i<25;i=i+1)
			mux stage_3(stage2[i-4],stage2[i],shift[2],stage3[i]);
	endgenerate

	// stage 4
	generate
		for(i=0;i<8;i=i+1)
			mux stage_4(1'b0,stage3[i],shift[3],stage4[i]);
	endgenerate
	generate
		for(i=8;i<25;i=i+1)
			mux stage_4(stage3[i-8],stage3[i],shift[3],stage4[i]);
	endgenerate

	// stage 5
	generate
		for(i=0;i<16;i=i+1)
			mux stage_5(1'b0,stage4[i],shift[4],out[i]);
	endgenerate
	generate
		for(i=16;i<25;i=i+1)
			mux stage_5(stage4[i-16],stage4[i],shift[4],out[i]);
	endgenerate

endmodule

module right_shift(in,shift,out);

	input [23:0]in;
	input [4:0]shift;
	output [23:0]out;

	wire [23:0]stage1,stage2,stage3,stage4;
	genvar i;

	// stage 1
	generate
		for(i=0;i<23;i=i+1)
			mux stage_1(in[i+1],in[i],shift[0],stage1[i]);
	endgenerate
	mux stage_1_24(1'b0,in[23],shift[0],stage1[23]);

	// stage 2
	generate
		for(i=0;i<22;i=i+1)
			mux stage_2(stage1[i+2],stage1[i],shift[1],stage2[i]);
	endgenerate
	mux stage_2_1(1'b0,stage1[22],shift[1],stage2[22]);
	mux stage_2_0(1'b0,stage1[23],shift[1],stage2[23]);

	// stage 3
	generate
		for(i=0;i<20;i=i+1)
			mux stage_3(stage2[i+4],stage2[i],shift[2],stage3[i]);
	endgenerate
	generate
		for(i=20;i<24;i=i+1)
			mux stage_3(1'b0,stage2[i],shift[2],stage3[i]);
	endgenerate

	// stage 4
	generate
		for(i=0;i<16;i=i+1)
			mux stage_4(stage3[i+8],stage3[i],shift[3],stage4[i]);
	endgenerate
	generate
		for(i=16;i<24;i=i+1)
			mux stage_4(1'b0,stage3[i],shift[3],stage4[i]);
	endgenerate

	// stage 5
	generate
		for(i=0;i<8;i=i+1)
			mux stage_5(stage4[i+16],stage4[i],shift[4],out[i]);
	endgenerate
	generate
		for(i=8;i<24;i=i+1)
			mux stage_5(1'b0,stage4[i],shift[4],out[i]);
	endgenerate

endmodule

module mux(i1,i0,s,o);

	input i0,i1,s;
	output o;

	assign o = (i1 & s) | (i0 & ~s);

endmodule