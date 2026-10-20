// ============================================================
// Top level da Pratica 6 - DE10-Lite (MAX 10)
//
// ENTRADAS
//   KEY[0]    = clock manual (1 clique = 1 ciclo, com debounce)
//   KEY[1]    = reset (zera so o PC)
//   SW[0]     = RegDst
//   SW[1]     = RegWrite
//   SW[2]     = ALUSrc
//   SW[5:3]   = ALUop (010 = soma)
//   SW[8:6]   = o que aparece nos displays (tabela abaixo)
//
// DISPLAYS (SW[8:6])
//   000 : PC (decimal)
//   001 : opcode  = instrucao [31:26] (decimal)
//   010 : imediato = instrucao [15:0] (decimal com sinal)
//   011 : Data1  (readdata1) (decimal com sinal)
//   100 : Data2  (readdata2) (decimal com sinal)
//   101 : ALUb   (2o operando da ULA, depois do mux ALUSrc) (decimal com sinal)
//   110 : ALUResult (decimal com sinal)
//   111 : rs | rt | rd da instrucao (HEX5-4 | HEX3-2 | HEX1-0, decimal)
//
// LEDs
//   LEDR[0] = ready (memoria de instrucoes carregada)
//   LEDR[1] = zero  (flag da ULA)
//   LEDR[2] = valor nao cabe no display (|valor| > 99999)
//   LEDR[3] = pisca junto com clock manual do botao pra avisar q passou 1 clock
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
	wire [31:0] PCatual, instruction, Data1, Data2, ALUb, ALUResult;
	wire zero, ready;
 
	cpuMimps cpu (
		.clock(clk_cpu),
		.reset(reset),
		.RegDst(SW[0]),
		.RegWrite(SW[1]),
		.ALUSrc(SW[2]),
		.ALUop(SW[5:3]),
		.PCatual(PCatual),
		.instruction(instruction),
		.Data1(Data1),
		.Data2(Data2),
		.ALUb(ALUb),
		.ALUResult(ALUResult),
		.zero(zero),
		.ready(ready)
	);
 
	// ---------------- escolha do valor mostrado ----------------
	wire [2:0] sel = SW[8:6];
 
	wire is_dec    = (sel != 3'd7);                    // todas, menos rs|rt|rd
	wire is_signed = (sel >= 3'd2 && sel <= 3'd6);     // imediato, Data1, Data2, ALUb, ALUResult
 
	reg [31:0] val;
	always @* begin
		case (sel)
			3'd0:    val = PCatual;
			3'd1:    val = {26'd0, instruction[31:26]};                 // opcode
			3'd2:    val = {{16{instruction[15]}}, instruction[15:0]};  // imediato com sinal
			3'd3:    val = Data1;
			3'd4:    val = Data2;
			3'd5:    val = ALUb;
			3'd6:    val = ALUResult;
			default: val = 32'd0;
		endcase
	end
 
	// modulo + sinal (para mostrar numeros negativos)
	wire        neg  = is_signed & val[31];
	wire [31:0] mag  = neg ? (~val + 32'd1) : val;
	wire        sat  = is_dec & (mag > 32'd99999);
	wire [16:0] mag17 = sat ? 17'd99999 : mag[16:0];
 
	wire [19:0] bcd;
	bin2bcd conv (.bin(mag17), .bcd(bcd));   // 5 digitos decimais
 
	// campos da instrucao (visao 111)
	wire [4:0] rs = instruction[25:21];
	wire [4:0] rt = instruction[20:16];
	wire [4:0] rd = instruction[15:11];
 
	// ---------------- monta os 6 digitos ----------------
	reg [23:0] n;        // 6 nibbles: HEX0 = n[3:0] ... HEX5 = n[23:20]
	reg [5:0]  blank;    // 1 = apaga o digito
	reg        minus;    // 1 = mostra "-" no HEX5
 
	always @* begin
		n     = 24'd0;
		blank = 6'b000000;
		minus = 1'b0;
		case (sel)
			3'd0, 3'd1, 3'd2, 3'd3, 3'd4, 3'd5, 3'd6: begin   // decimal
				n[19:0] = bcd;
				blank[5] = 1'b1;
				minus    = neg;
			end
			3'd7: begin                           // rs | rt | rd em decimal
				n[23:20] = rs / 10;  n[19:16] = rs % 10;
				n[15:12] = rt / 10;  n[11:8]  = rt % 10;
				n[7:4]   = rd / 10;  n[3:0]   = rd % 10;
			end
		endcase
	end
 
	// ---------------- decodificadores de 7 segmentos ----------------
	// seu decodificador tem saida ativa em 0 (igual aos displays da DE10)
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
	assign LEDR = {6'b000000, clk_cpu, sat, zero, ready};
 
endmodule
