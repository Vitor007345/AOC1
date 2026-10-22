// ============================================================
// Top level da Pratica 7 - DE10-Lite (MAX 10)
// Caminho de dados completo (controle principal + controle da ULA)
//
// ENTRADAS
//   KEY[0]    = clock manual (1 clique = 1 instrucao, com debounce)
//   KEY[1]    = reset (volta o PC para 0)
//   SW[3:0]   = o que aparece nos displays (tabela abaixo)
//
// DISPLAYS (SW[3:0])
//    0 : PC (decimal)
//    1 : opcode  = instrucao [31:26] (decimal)
//    2 : rs | rt | rd (HEX5-4 | HEX3-2 | HEX1-0, decimal)
//    3 : funct   = instrucao [5:0] (decimal)
//    4 : imediato com sinal estendido (decimal com sinal)
//    5 : Data1  (Read data 1 do banco) (decimal com sinal)
//    6 : Data2  (Read data 2 do banco) (decimal com sinal)
//    7 : ALUb   (2o operando da ULA, depois do mux ALUSrc) (decimal com sinal)
//    8 : ALUResult = valor que sera gravado no banco (decimal com sinal)
//    9 : WriteReg = numero do registrador destino (depois do mux RegDst)
//   10 : controle da ULA: HEX4 = ALUOp (2 bits) | HEX2-0 = operacao (3 bits, binario)
//        010=add 110=sub 000=and 001=or 111=slt
//   11-15 : displays apagados
//
// LEDs
//   LEDR[0] = RegDst      LEDR[4] = MemRead
//   LEDR[1] = ALUSrc      LEDR[5] = MemWrite
//   LEDR[2] = MemtoReg    LEDR[6] = Branch
//   LEDR[3] = RegWrite    LEDR[7] = ALUResult == 0
//   LEDR[8] = valor nao cabe no display (|valor| > 99999)
//   LEDR[9] = clock manual (acende enquanto o botao esta apertado)
// ============================================================

module Top_cpu(
	input        MAX10_CLK1_50,
	input  [1:0] KEY,
	input  [9:0] SW,
	output [9:0] LEDR,
	output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);

	// ---------------- clock manual e reset ----------------
	wire clk_cpu;
	debounce db (
		.clk(MAX10_CLK1_50),
		.noisy(~KEY[0]),     // KEY e ativo em 0
		.clean(clk_cpu)
	);

	wire reset = ~KEY[1];

	// ---------------- processador ----------------
	wire [31:0] PCatual, instruction, Data1, Data2, ALUb, signEx, ALUResult;
	wire [4:0]  WriteReg;
	wire [2:0]  ALUop3;
	wire [1:0]  ALUOp;
	wire        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;

	cpuMimps cpu (
		.clock(clk_cpu),
		.reset(reset),
		.PCatual(PCatual),
		.instruction(instruction),
		.Data1(Data1),
		.Data2(Data2),
		.ALUb(ALUb),
		.signEx(signEx),
		.ALUResult(ALUResult),
		.WriteReg(WriteReg),
		.ALUop3(ALUop3),
		.RegDst(RegDst),
		.ALUSrc(ALUSrc),
		.MemtoReg(MemtoReg),
		.RegWrite(RegWrite),
		.MemRead(MemRead),
		.MemWrite(MemWrite),
		.Branch(Branch),
		.ALUOp(ALUOp)
	);

	// ---------------- escolha do valor mostrado ----------------
	wire [3:0] sel = SW[3:0];

	reg [31:0] val;
	reg        is_signed;
	reg        is_dec;       // 1 = mostra val em decimal (5 digitos)
	always @* begin
		val       = 32'd0;
		is_signed = 1'b0;
		is_dec    = 1'b1;
		case (sel)
			4'd0:  val = PCatual;
			4'd1:  val = {26'd0, instruction[31:26]};     // opcode
			4'd3:  val = {26'd0, instruction[5:0]};       // funct
			4'd4:  begin val = signEx;    is_signed = 1'b1; end
			4'd5:  begin val = Data1;     is_signed = 1'b1; end
			4'd6:  begin val = Data2;     is_signed = 1'b1; end
			4'd7:  begin val = ALUb;      is_signed = 1'b1; end
			4'd8:  begin val = ALUResult; is_signed = 1'b1; end
			4'd9:  val = {27'd0, WriteReg};
			default: is_dec = 1'b0;                       // 2, 10..15
		endcase
	end

	// modulo + sinal (para mostrar numeros negativos)
	wire        neg   = is_dec & is_signed & val[31];
	wire [31:0] mag   = neg ? (~val + 32'd1) : val;
	wire        sat   = is_dec & (mag > 32'd99999);
	wire [16:0] mag17 = sat ? 17'd99999 : mag[16:0];

	wire [19:0] bcd;
	bin2bcd conv (.bin(mag17), .bcd(bcd));   // 5 digitos decimais

	// campos da instrucao (visao 2)
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];

	// ---------------- monta os 6 digitos ----------------
	reg [23:0] n;        // 6 nibbles: HEX0 = n[3:0] ... HEX5 = n[23:20]
	reg [5:0]  blank;    // 1 = apaga o digito
	reg        minus;    // 1 = mostra "-" no HEX5

	always @* begin
		n     = 24'd0;
		blank = 6'b111111;
		minus = 1'b0;
		if (is_dec) begin                          // decimal
			n[19:0] = bcd;
			blank   = 6'b100000;                   // so HEX5 apagado (ou "-")
			minus   = neg;
		end
		else if (sel == 4'd2) begin                // rs | rt | rd
			n[23:20] = rs / 10;  n[19:16] = rs % 10;
			n[15:12] = rt / 10;  n[11:8]  = rt % 10;
			n[7:4]   = rd / 10;  n[3:0]   = rd % 10;
			blank    = 6'b000000;
		end
		else if (sel == 4'd10) begin               // ALUOp | operacao da ULA
			n[19:16] = {2'b00, ALUOp};             // HEX4
			n[2:0]   = ALUop3;                     // HEX2..HEX0 em binario
			n[7:4]   = {3'b000, ALUop3[1]};
			n[3:0]   = {3'b000, ALUop3[0]};
			n[11:8]  = {3'b000, ALUop3[2]};
			blank    = 6'b101000;                  // apaga HEX5 e HEX3
		end
	end

	// ---------------- decodificadores de 7 segmentos ----------------
	wire [41:0] seg;
	genvar g;
	generate
		for (g = 0; g < 6; g = g + 1) begin : dec
			decodificador d (
				.A(n[4*g+3]), .B(n[4*g+2]), .C(n[4*g+1]), .D(n[4*g]),
				.sA(seg[7*g+0]), .sB(seg[7*g+1]), .sC(seg[7*g+2]), .sD(seg[7*g+3]),
				.sE(seg[7*g+4]), .sF(seg[7*g+5]), .sG(seg[7*g+6])
			);
		end
	endgenerate

	// bit 7 = ponto decimal (apagado)
	assign HEX0 = {1'b1, blank[0] ? 7'h7F : seg[6:0]};
	assign HEX1 = {1'b1, blank[1] ? 7'h7F : seg[13:7]};
	assign HEX2 = {1'b1, blank[2] ? 7'h7F : seg[20:14]};
	assign HEX3 = {1'b1, blank[3] ? 7'h7F : seg[27:21]};
	assign HEX4 = {1'b1, blank[4] ? 7'h7F : seg[34:28]};
	assign HEX5 = {1'b1, minus    ? 7'b0111111 :      // so o segmento g aceso
	                     blank[5] ? 7'h7F : seg[41:35]};

	// ---------------- LEDs ----------------
	assign LEDR = {clk_cpu, sat, (ALUResult == 32'd0), Branch, MemWrite, MemRead,
	               RegWrite, MemtoReg, ALUSrc, RegDst};

endmodule