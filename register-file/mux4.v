`include "mux2.v"

module m_mux4(input[3:0] cont,input[1:0] ip,output o);

	wire[1:0] t;
	m_mux2 mu(cont[3:2],ip[0],t[1]);
	m_mux2 md(cont[1:0],ip[0],t[0]);
	m_mux2 mf(t,ip[1],o);

endmodule