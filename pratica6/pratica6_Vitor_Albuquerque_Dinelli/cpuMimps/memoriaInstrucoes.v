module memoriaInstrucoes #(
	parameter ADDR_SIZE = 8
)(
	input [ADDR_SIZE-1:0] address,
	input clock,
	output [31:0] instruction,
	output ready
);

	reg [1:0] step = 2'b00;      //0 e 1: carregando as 2 instruçoes | 2: pronto
	assign ready = step[1];

	always @(posedge clock) begin
		if (!ready) step <= step + 1'b1;
	end

	reg [ADDR_SIZE-1:0] addrLoad;
	reg [31:0] dataLoad;
	always @* begin
		case (step)
			2'd0:    begin addrLoad = 0; dataLoad = 32'h20080005; end //addi $t0,$zero,5
			2'd1:    begin addrLoad = 4; dataLoad = 32'h01084820; end //add  $t1,$t0,$t0
			default: begin addrLoad = 0; dataLoad = 32'h0;        end
		endcase
	end

	memoriaDados #(.ADDR_SIZE(ADDR_SIZE), .DATA_BYTES(4)) mem (
		.address(ready ? address : addrLoad),
		.memWrite(~ready),
		.memRead(1'b1),
		.clock(clock),
		.writeData(dataLoad),
		.readData(instruction)
	);

endmodule