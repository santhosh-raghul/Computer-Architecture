module adder_subtractor (a,b,cin,sum);

	input [23:0] a,b;
	input cin;
	output reg [24:0] sum;
	reg [23:0] partial_sum,b1;

	wire [24:0] carry, p, carry_1, p_1, carry_2, p_2, carry_4, p_4, carry_8, p_8, carry_16, p_16;
	
	assign carry[0] = cin;
	assign p[0] = 0;
	
	kpg_init initializing_kpg [24:1] (a[23:0], b1[23:0], p[24:1], carry[24:1]);

	assign p_1[0] = cin;
	assign carry_1[0] = cin;
	assign p_2[1:0] = p_1[1:0];
	assign carry_2[1:0] = carry_1[1:0];
	assign p_4[3:0] = p_2[3:0];
	assign carry_4[3:0] = carry_2[3:0];
	assign p_8[7:0] = p_4[7:0];
	assign carry_8[7:0] = carry_4[7:0];
	assign p_16[15:0] = p_8[15:0];
	assign carry_16[15:0] = carry_8[15:0];

	kpg iteration_1 [24:1] (p[24:1], carry[24:1], p[23:0], carry[23:0], p_1[24:1], carry_1[24:1]);
	kpg iteration_2 [24:2] (p_1[24:2], carry_1[24:2], p_1[22:0], carry_1[22:0], p_2[24:2], carry_2[24:2]);
	kpg iteration_4 [24:4] (p_2[24:4], carry_2[24:4], p_2[20:0], carry_2[20:0], p_4[24:4], carry_4[24:4]);
	kpg iteration_8 [24:8] (p_4[24:8], carry_4[24:8], p_4[16:0], carry_4[16:0], p_8[24:8], carry_8[24:8]);
	kpg iteration_16 [24:16] (p_8[24:16], carry_8[24:16], p_8[8:0], carry_8[8:0], p_16[24:16], carry_16[24:16]);

	always @(*)
	begin
		if(cin==0)
		begin
			b1=b;
			sum[24] = carry_16[24];
		end
		else
		begin
			b1=b^24'hffffff;
			sum[24] = 1'b0;
		end
		partial_sum = a^b1;
		sum[23:0] = partial_sum[23:0]^carry_16[23:0];
	end

endmodule

module adder(a,b,cin,sum,cout);

	input [23:0] a,b;
	input cin;
	output wire [23:0] sum;
	output wire cout;
	wire [23:0] partial_sum;

	wire [24:0] carry, p, carry_1, p_1, carry_2, p_2, carry_4, p_4, carry_8, p_8, carry_16, p_16;
	
	assign carry[0] = cin;
	assign p[0] = 0;
	
	kpg_init initializing_kpg [24:1] (a[23:0], b[23:0], p[24:1], carry[24:1]);

	assign p_1[0] = cin;
	assign carry_1[0] = cin;
	assign p_2[1:0] = p_1[1:0];
	assign carry_2[1:0] = carry_1[1:0];
	assign p_4[3:0] = p_2[3:0];
	assign carry_4[3:0] = carry_2[3:0];
	assign p_8[7:0] = p_4[7:0];
	assign carry_8[7:0] = carry_4[7:0];
	assign p_16[15:0] = p_8[15:0];
	assign carry_16[15:0] = carry_8[15:0];

	kpg iteration_1 [24:1] (p[24:1], carry[24:1], p[23:0], carry[23:0], p_1[24:1], carry_1[24:1]);
	kpg iteration_2 [24:2] (p_1[24:2], carry_1[24:2], p_1[22:0], carry_1[22:0], p_2[24:2], carry_2[24:2]);
	kpg iteration_4 [24:4] (p_2[24:4], carry_2[24:4], p_2[20:0], carry_2[20:0], p_4[24:4], carry_4[24:4]);
	kpg iteration_8 [24:8] (p_4[24:8], carry_4[24:8], p_4[16:0], carry_4[16:0], p_8[24:8], carry_8[24:8]);
	kpg iteration_16 [24:16] (p_8[24:16], carry_8[24:16], p_8[8:0], carry_8[8:0], p_16[24:16], carry_16[24:16]);

	assign cout = carry_16[24];
	assign partial_sum = a^b;
	assign sum[23:0] = partial_sum[23:0]^carry_16[23:0];

endmodule

module adder_8bit (a,b,cin,sum);

	input [7:0] a,b;
	input cin;
	output [7:0] sum;
	wire [7:0] partial_sum;

	wire [8:0] carry, p, carry_1, p_1, carry_2, p_2, carry_4, p_4;
	
	assign carry[0] = cin;
	assign p[0] = 0;
	
	kpg_init initializing_kpg [8:1] (a[7:0], b[7:0], p[8:1], carry[8:1]);

	assign p_1[0] = cin;
	assign carry_1[0] = cin;
	assign p_2[1:0] = p_1[1:0];
	assign carry_2[1:0] = carry_1[1:0];
	assign p_4[3:0] = p_2[3:0];
	assign carry_4[3:0] = carry_2[3:0];

	kpg iteration_1 [8:1] (p[8:1], carry[8:1], p[7:0], carry[7:0], p_1[8:1], carry_1[8:1]);
	kpg iteration_2 [8:2] (p_1[8:2], carry_1[8:2], p_1[6:0], carry_1[6:0], p_2[8:2], carry_2[8:2]);
	kpg iteration_4 [8:4] (p_2[8:4], carry_2[8:4], p_2[4:0], carry_2[4:0], p_4[8:4], carry_4[8:4]);

	assign partial_sum = a^b;
	assign sum[7:0] = partial_sum[7:0]^carry_4[7:0];

endmodule

module kpg_init (
	input a, b,
	output reg p, carry
);
	always @*
	case ({a, b})
		2'b00: begin
			p = 1'b0; carry = 1'b0;
		end
		2'b11: begin
			p = 1'b0; carry = 1'b1;
		end
		default: begin 
			p = 1'b1; carry = 1'bx;
		end
	endcase

endmodule

module kpg (
	input current_p, current_carry, from_p, from_carry,
	output reg final_p, final_carry
);
	always @(*)
	begin
	
		if({current_p, current_carry} == 2'b00)
			{final_p, final_carry} = 2'b00;
		
		else if({current_p, current_carry} == 2'b01)
			{final_p, final_carry} = 2'b01;

		else
			{final_p, final_carry} = {from_p, from_carry};

	end

endmodule