module mux #(
	parameter N = 5
)(
	input [N-1:0]zero, um,
	input valor,
	output [N-1:0]s
);

assign s = valor? um:zero;

endmodule