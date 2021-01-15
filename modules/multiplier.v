module multiplier_24bit(a,b,product);

    input [23:0] a, b;
    output [47:0] product;

    wire [48:0]level_1[23:0];
    wire [48:0]level_2[15:0];
    wire [48:0]level_3[10:0];
    wire [48:0]level_4[7:0];
    wire [48:0]level_5[5:0];
    wire [48:0]level_6[3:0];
    wire [48:0]level_7[2:0];
    wire [48:0]level_8[1:0];
    wire middle_carry;
    wire carry_out;

    genvar i,j;
    generate
        for(i=0;i<24;i=i+1)
        begin
            for(j=0;j<i;j=j+1)
                assign level_1[i][j]=0;
            for(j=i;j-i<24;j=j+1)
                assign level_1[i][j]=a[j-i]&&b[i];
            for(j=24+i;j<=48;j=j+1)
                assign level_1[i][j]=0;
        end
    endgenerate

    generate
        for(i=0;i<=21;i=i+3)
            carry_save_adder calc_level_2 (level_1[i],level_1[i+1],level_1[i+2],level_2[i*2/3],level_2[i*2/3+1]);
    endgenerate

    generate
        for(i=0;i<=12;i=i+3)
            carry_save_adder calc_level_3 (level_2[i],level_2[i+1],level_2[i+2],level_3[i*2/3],level_3[i*2/3+1]);
    endgenerate
    assign level_3[10]=level_2[15];

    generate
        for(i=0;i<=6;i=i+3)
            carry_save_adder calc_level_4 (level_3[i],level_3[i+1],level_3[i+2],level_4[i*2/3],level_4[i*2/3+1]);
    endgenerate
    assign level_4[6]=level_3[9];
    assign level_4[7]=level_3[10];

    carry_save_adder calc_level_5_0_and_1 (level_4[0],level_4[1],level_4[2],level_5[0],level_5[1]);
    carry_save_adder calc_level_5_2_and_3 (level_4[3],level_4[4],level_4[5],level_5[2],level_5[3]);
    assign level_5[4]=level_4[6];
    assign level_5[5]=level_4[7];

    carry_save_adder calc_level_6_0_and_1 (level_5[0],level_5[1],level_5[2],level_6[0],level_6[1]);
    carry_save_adder calc_level_6_2_and_3 (level_5[3],level_5[4],level_5[5],level_6[2],level_6[3]);
    
    carry_save_adder calc_level_7 (level_6[0],level_6[1],level_6[2],level_7[0],level_7[1]);
    assign level_7[2]=level_6[3];

    carry_save_adder calc_level_8 (level_7[0],level_7[1],level_7[2],level_8[0],level_8[1]);

    adder bit_0_to_23 (level_8[0][23:0],level_8[1][23:0],1'b0,product[23:0],middle_carry);
    adder bit_23_to_48 (level_8[0][47:24],level_8[1][47:24],middle_carry,product[47:24],carry_out);

endmodule


module carry_save_adder(a,b,c,sum,carry);

    input [48:0] a,b,c;
    output [48:0] sum,carry;

    full_adder add [47:0] (a[47:0],b[47:0],c[47:0],sum[47:0],carry[48:1]);
    assign sum[48]=1'b0;
    assign carry[0]=1'b0;

endmodule

module full_adder(a,b,cin,sum,cout);

    input a,b,cin;
    output sum,cout;

    wire w1,w2,w3,w4,w5;

    xor xor_0(w1,a,b);
    xor xor_1(sum,w1,cin);
    and and_0(w2,a,b);
    and and_1(w3,a,cin);
    and and_2(w4,b,cin);
    or or_0(w5,w2,w3);
    or or_1(cout,w4,w5);

endmodule