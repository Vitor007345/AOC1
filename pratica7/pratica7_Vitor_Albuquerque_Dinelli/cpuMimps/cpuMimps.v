module cpuMimps(
	input clock, reset,
	output [31:0]PCatual, instruction, Data1, Data2, ALUb, signEx, ALUResult,
	output [4:0]WriteReg,
	output [2:0]  ALUop3,
	output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
	output [1:0]  ALUOp
);
	
	//fios
	wire [31:0] PCprox, PCmais4, PCbeq;
	wire overflow, zero;
	wire [31:0] shifted_left2;
	
	//somador padrao do PC
	parameterAdder #(.N(32)) somadorPC(
		.a(PCatual),
		.b(32'd4),
		.cin(1'b0),
		.s(PCmais4),
		.cout()
	);
	
	//shift do valor pra somar no pc
	assign shifted_left2 = {signEx[29:0], 2'b00};
	
	//somador do pc pra instruçoes beq
	parameterAdder #(.N(32)) somadorPCbeq(
		.a(PCmais4),
		.b(shifted_left2),
		.cin(1'b0),
		.s(PCbeq),
		.cout()
	);
	
	//controle do PC
	assign PCprox = (Branch & zero)? PCbeq : PCmais4;
	PC #(
		.ADDR_SIZE(32),
		.INST_SIZE_BYTES(4)
	) pc(
		.clock(clock),
		.reset(reset),
		.PCprox(PCprox),
		.PCatual(PCatual)
	);
	
	//FPGA n tem 512MB(2^32 bytes) de memoria ent tive q por endereço so com 8 de tamanho sendo so 32bytes(2^8) de memoria
	memoriaInstrucoes #(
		.ADDR_SIZE(8),
		.DATA_BYTES(4),
		.FILE_NAME("instrucoes.txt")
	) memoriaInst(
		.address(PCatual[7:0]),
		.readData(instruction)
	);
	
	//bloco de controle da cpu
	control ctrl(
		.Op(instruction[31:26]),
		.RegDst(RegDst),
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);
	
	//mux do WriteReg
	assign WriteReg = RegDst? instruction[15:11]:instruction[20:16];
	
	
	//banco de registradores
	bancoDeReg #(
		.ADDR_WIDTH(5),
		.REG_WIDTH(32),
		.INIT_FILE("registradores.txt") //formato: uma linha por reg -> "numero valor" (decimal)

	) bancoReg(
		.Read1(instruction[25:21]),
		.Read2(instruction[20:16]),
		.WriteReg(WriteReg),
		.WriteData(ALUResult),
		.RegWrite(RegWrite & ~reset),
		.clock(clock),
		.Data1(Data1),
		.Data2(Data2)
	);


	//extensor de sinal
	extensorSinal #(
		.initialSize(16),
		.finalSize(32)
	) signex (
		.N(instruction[15:0]),
		.S(signEx)
	);
	
	//mux pra calcular o segundo operando da ALU
	assign ALUb = ALUSrc? signEx : Data2;

	//controle da Ula
	ULActrl aluctrl(
		.funct(instruction[5:0]),
		.ALUOp(ALUOp),
		.operation(ALUop3)
		
	);
	
	//Ula principal
	ULA #(.N(32)) alu (
		.a(Data1),
		.b(ALUb),
		.ALUop(ALUop3),
		.result(ALUResult),
		.overflow(overflow),
		.zero(zero)
	);



endmodule