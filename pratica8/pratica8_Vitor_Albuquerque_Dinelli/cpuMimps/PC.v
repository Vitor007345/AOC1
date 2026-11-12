module PC #(
	parameter ADDR_SIZE = 32,
	parameter INST_SIZE_BYTES = 4
)(
	input clock, reset,
	input [ADDR_SIZE-1:0] PCprox,
	output reg [ADDR_SIZE-1:0] PCatual
);

	always @(posedge clock or posedge reset) begin
		if(reset) begin
			PCatual <= {ADDR_SIZE{1'b0}};
		end else begin
			PCatual <= PCprox;
		end
	end



endmodule