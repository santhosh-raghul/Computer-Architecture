`include "mux16.v"

module m_mux32(input[31:0] cont, input[4:0]ip, output o);

	wire[1:0] t;
	m_mux16 mu(cont[31:16],ip[3:0],t[1]);
	m_mux16 md(cont[15:0],ip[3:0],t[0]);
	m_mux2 mf(t,ip[4],o);
	
endmodule