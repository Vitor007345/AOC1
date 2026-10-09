module decodificador(A, B, C, D, sA, sB, sC, sD, sE, sF, sG);
	input A, B, C, D;
	output sA, sB, sC, sD, sE, sF, sG;
	
	assign sA = (~A & ~B & ~C & D) | (B & ~C & ~D);
	assign sB = (B & C & ~D) | (B & ~C & D);
	assign sC = (~B & C & ~D);
	assign sD = (B & C & D) | (B & ~C & ~D) | (~A & ~B & ~C & D);
	assign sE = (D) | (~A & B & ~C);
	assign sF = (C & D) | (~A & ~B & C) | (~A & ~B & D);
	assign sG = (B & C & D) | (~A & ~B & ~C);
	
endmodule