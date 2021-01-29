`include "mux8.v"

module m_mux16(input[15:0] cont,input[3:0] ip,output o);

	wire[1:0] t;
	m_mux8 mu(cont[15:8],ip[2:0],t[1]);
	m_mux8 md(cont[7:0],ip[2:0],t[0]);
	m_mux2 mf(t,ip[3],o);

endmodule