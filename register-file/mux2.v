module m_mux2(input[1:0] cont,input ip,output o);

	and(t1,cont[1],ip);
	and(t2,cont[0],~ip);
	or(o,t1,t2);

endmodule