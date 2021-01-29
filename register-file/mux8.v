`include "mux4.v"

module m_mux8(input[7:0] cont,input[2:0] ip,output o);

	wire[1:0] t;
	m_mux4 mu(cont[7:4],ip[1:0],t[1]);
	m_mux4 md(cont[3:0],ip[1:0],t[0]);
	m_mux2 mf(t,ip[2],o);

endmodule