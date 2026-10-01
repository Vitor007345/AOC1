module adder16(
	input [5:0]SW,
	output [6:0]HEX0, 
	output [6:0]HEX1,
	output [6:0]HEX2
);
	wire [15:0]a, b, s;
	wire cin, cout;
	
	assign a = SW[5:3];
	assign b = SW[2:0];
	assign cin = 1'b0;
	
	parameterAdder #(.N(16)) BLOCO0(
		.a(a),
		.b(b),
		.cin(cin),
		.s(s),
		.cout(cout)
	);
	
	decodificador BLOCO1(s[3], s[2], s[1], s[0], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);
	decodificador BLOCO2(b[3], b[2], b[1], b[0], HEX1[0], HEX1[1], HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);
	decodificador BLOCO3(a[3], a[2], a[1], a[0], HEX2[0], HEX2[1], HEX2[2], HEX2[3], HEX2[4], HEX2[5], HEX2[6]);
	

endmodule