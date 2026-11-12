module parameterAdder #(
	parameter N = 16
)(
	input wire [N-1:0] a,
	input wire [N-1:0] b,
	input wire cin,
	output wire [N-1:0] s,
	output wire cout
);

	wire [N:0] carry;
	assign carry[0] = cin;
	assign cout = carry[N];
	
	genvar i;
	generate 
		for(i = 0; i < N; i = i + 1) begin: gen_adder
			somador AdderInst(
				.A(a[i]),
				.B(b[i]),
				.Cin(carry[i]),
				.S(s[i]),
				.Cout(carry[i+1])
			);
		end
	endgenerate

endmodule