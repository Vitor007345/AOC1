module extensorSinal #(
	parameter initialSize = 16,
	parameter finalSize = 32
)(
	input [initialSize-1:0]N,
	output [finalSize-1:0]S
);
	assign S = {{(finalSize - initialSize){N[initialSize - 1]}}, N};

endmodule