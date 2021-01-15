import struct, ctypes
def ieee(a):
	a=format(ctypes.c_uint.from_buffer(ctypes.c_float(a)).value, '032b')
	a=a[0]+'_'+a[1:9]+'_'+a[9:]
	return a

def writedata(a,b):
	a_ieee=ieee(a)
	b_ieee=ieee(b)
	testbench_file.write(f"\n\t\ta=32'b{a_ieee};\t// {a}\n\t\tb=32'b{b_ieee};\t// {b}\n\t\t#5 $display(\"%b_%b_%b\", out[31], out[30:23], out[22:0]);\n\n")
	c=struct.unpack('f',struct.pack('f',a*b))[0]
	output_file.write(ieee(c)+"\n")

def test_case():
	a=float(input("enter 1st number : "))
	b=float(input("enter 2nd number : "))
	a=struct.unpack('f',struct.pack('f',a))[0]
	b=struct.unpack('f',struct.pack('f',b))[0]
	writedata(a,b)

testbench_file=open("testbench.v","w")
output_file=open("expected_output.txt","w")
testbench_file.write("""`include "fp-multiplier.v"

module top;

	reg [31:0]a, b;
	wire [31:0]out;

	fp_multiplier FP1 (a, b, out);

	initial
	begin\n"""
)

print("test case 1:")
test_case()
print("test case 2:")
test_case()
print("test case 3:")
test_case()

testbench_file.write("""\tend\n\nendmodule""")
testbench_file.close()
output_file.close()