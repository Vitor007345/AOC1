module somador(A, B, Cin, S, Cout);

	input A, B, Cin;
	output S, Cout;
	
	assign S = A ^ B ^ Cin;
	assign Cout = (A & Cin) | (B & Cin) | (A & B);

endmodule