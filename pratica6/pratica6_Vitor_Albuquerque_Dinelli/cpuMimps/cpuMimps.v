module cpuMimps(
	input clock, reset, RegDst, RegWrite, ALUSrc,
	input [2:0] ALUop,
	output [31:0]PCatual, instruction, Data1, Data2, ALUb, ALUResult,
	output zero, ready
);

	wire [31:0] PCprox;
	wire cout;
	
	parameterAdder #(.N(32)) somadorPC(
		.a(PCatual),
		.b(32'd4),
		.cin(1'b0),
		.s(PCprox),
		.cout(cout)
	);

	PC #(
		.ADDR_SIZE(32),
		.INST_SIZE_BYTES(4)
	) pc(
		.clock(clock),
		.reset(reset | ~ready),
		.PCprox(PCprox),
		.PCatual(PCatual)
	);

	memoriaInstrucoes #(.ADDR_SIZE(8)) memoriaInst(
		.address(PCatual[7:0]),
		.clock(clock),
		.instruction(instruction),
		.ready(ready)
	);

	wire [4:0]WriteReg;
	mux #(.N(5)) mux0 (
		.zero(instruction[20:16]),
		.um(instruction[15:11]),
		.valor(RegDst),
		.s(WriteReg)
	);

	bancoDeReg #(
		.ADDR_WIDTH(5),
		.REG_WIDTH(32)
	) bancoReg(
		.Read1(instruction[25:21]),
		.Read2(instruction[20:16]),
		.WriteReg(WriteReg),
		.WriteData(ALUResult),
		.RegWrite(RegWrite & ready),
		.clock(clock),
		.Data1(Data1),
		.Data2(Data2)
	);


	wire [31:0] signEx;
	extensorSinal #(
		.initialSize(16),
		.finalSize(32)
	) signex (
		.N(instruction[15:0]),
		.S(signEx)
	);

	mux #(.N(32)) mux1 (
		.zero(Data2),
		.um(signEx),
		.valor(ALUSrc),
		.s(ALUb)
	);

	wire overflow;
	ULA #(.N(32)) alu (
		.a(Data1),
		.b(ALUb),
		.ALUop(ALUop),
		.result(ALUResult),
		.overflow(overflow),
		.zero(zero)
	);



endmodule