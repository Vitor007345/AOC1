`timescale 1ns/1ps

// ============================================================================
// Testbench do banco de registradores (8 registradores x 16 bits)
// Testbench auto-verificavel: imprime PASS/FAIL de cada checagem no console
// do ModelSim e um resumo ao final.
//
// Fases (use os rotulos "fase" na janela de ondas para marcar os prints):
//   1 - Valores iniciais (todos os registradores = 0)
//   2 - Escrita em todos os registradores (RegWrite = 1)
//   3 - Leitura simultanea de dois registradores diferentes
//   4 - Leitura dos dois ports no mesmo registrador
//   5 - RegWrite = 0 (escrita bloqueada)
//   6 - Leitura assincrona (muda endereco sem clock)
//   7 - Escrita sincrona (so atualiza na borda de subida)
//   8 - Leitura e escrita no mesmo registrador (valor antigo -> novo na borda)
//   9 - Sobrescrita de um registrador
//  10 - Valores limite (0x0000 e 0xFFFF)
// ============================================================================
module tb_bancoDeReg;

	// ---------------- parametros (iguais ao exigido na pratica) -------------
	parameter ADDR_WIDTH = 3;
	parameter REG_WIDTH  = 16;
	parameter NUM_REGS   = 1 << ADDR_WIDTH;

	// ---------------- sinais ------------------------------------------------
	reg  [ADDR_WIDTH-1:0] Read1, Read2, WriteReg;
	reg  [REG_WIDTH-1:0]  WriteData;
	reg                   RegWrite, clock;
	wire [REG_WIDTH-1:0]  Data1, Data2;

	// so para facilitar a visualizacao na onda (numero da fase atual)
	integer fase;

	// contadores de resultado
	integer erros, acertos;

	// modelo de referencia (golden model) para comparar com o DUT
	reg [REG_WIDTH-1:0] ref_mem [0:NUM_REGS-1];

	integer i;

	// ---------------- DUT ---------------------------------------------------
	bancoDeReg #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.REG_WIDTH(REG_WIDTH)
	) dut (
		.Read1(Read1),
		.Read2(Read2),
		.WriteReg(WriteReg),
		.WriteData(WriteData),
		.RegWrite(RegWrite),
		.clock(clock),
		.Data1(Data1),
		.Data2(Data2)
	);

	// ---------------- clock: periodo de 10 ns -------------------------------
	initial clock = 1'b0;
	always #5 clock = ~clock;

	// ---------------- tasks auxiliares --------------------------------------

	// compara um valor obtido com o esperado e registra PASS/FAIL
	task check;
		input [REG_WIDTH-1:0] obtido;
		input [REG_WIDTH-1:0] esperado;
		input [8*40-1:0]      msg;
		begin
			if (obtido === esperado) begin
				acertos = acertos + 1;
				$display("[%0t ns] PASS | %0s | obtido = %0d (0x%h)",
				         $time, msg, obtido, obtido);
			end else begin
				erros = erros + 1;
				$display("[%0t ns] FAIL | %0s | obtido = %0d (0x%h), esperado = %0d (0x%h)",
				         $time, msg, obtido, obtido, esperado, esperado);
			end
		end
	endtask

	// escreve em um registrador: entradas mudam na borda de descida e a escrita
	// acontece na proxima borda de subida do clock
	task escreve;
		input [ADDR_WIDTH-1:0] reg_dest;
		input [REG_WIDTH-1:0]  valor;
		begin
			@(negedge clock);
			WriteReg  = reg_dest;
			WriteData = valor;
			RegWrite  = 1'b1;
			@(posedge clock);        // borda em que a escrita ocorre
			ref_mem[reg_dest] = valor;
			@(negedge clock);
			RegWrite  = 1'b0;        // desabilita depois da escrita
		end
	endtask

	// le dois registradores e confere com o modelo de referencia
	task le_e_confere;
		input [ADDR_WIDTH-1:0] r1;
		input [ADDR_WIDTH-1:0] r2;
		begin
			Read1 = r1;
			Read2 = r2;
			#2; // tempo para a leitura assincrona propagar (sem usar clock)
			check(Data1, ref_mem[r1], "Data1 = banco[Read1]");
			check(Data2, ref_mem[r2], "Data2 = banco[Read2]");
		end
	endtask

	// ---------------- sequencia de testes -----------------------------------
	initial begin
		erros = 0; acertos = 0; fase = 0;

		// estado inicial das entradas
		Read1 = 0; Read2 = 0; WriteReg = 0; WriteData = 0; RegWrite = 0;

		// modelo de referencia inicia zerado (igual ao initial do DUT)
		for (i = 0; i < NUM_REGS; i = i + 1) ref_mem[i] = 0;

		#12;

		// ===== FASE 1: valores iniciais =====
		fase = 1;
		$display("\n--- FASE 1: valores iniciais (todos = 0) ---");
		for (i = 0; i < NUM_REGS; i = i + 2)
			le_e_confere(i[ADDR_WIDTH-1:0], i[ADDR_WIDTH-1:0] + 1'b1);

		// ===== FASE 2: escrita em todos os registradores =====
		fase = 2;
		$display("\n--- FASE 2: escrita em R0..R7 (valores distintos) ---");
		escreve(3'd0, 16'd10);
		escreve(3'd1, 16'd200);
		escreve(3'd2, 16'd3000);
		escreve(3'd3, 16'd4000);
		escreve(3'd4, 16'd5000);
		escreve(3'd5, 16'd60000);
		escreve(3'd6, 16'd12345);
		escreve(3'd7, 16'd54321);
		for (i = 0; i < NUM_REGS; i = i + 1)
			le_e_confere(i[ADDR_WIDTH-1:0], i[ADDR_WIDTH-1:0]);

		// ===== FASE 3: dois registradores diferentes ao mesmo tempo =====
		fase = 3;
		$display("\n--- FASE 3: leitura simultanea de registradores diferentes ---");
		le_e_confere(3'd0, 3'd7);
		le_e_confere(3'd3, 3'd5);
		le_e_confere(3'd6, 3'd1);

		// ===== FASE 4: os dois ports no mesmo registrador =====
		fase = 4;
		$display("\n--- FASE 4: Read1 = Read2 (mesmo registrador) ---");
		le_e_confere(3'd2, 3'd2);
		le_e_confere(3'd7, 3'd7);

		// ===== FASE 5: RegWrite = 0 nao pode escrever =====
		fase = 5;
		$display("\n--- FASE 5: RegWrite = 0 (escrita bloqueada) ---");
		@(negedge clock);
		WriteReg  = 3'd4;
		WriteData = 16'hDEAD;
		RegWrite  = 1'b0;
		Read1 = 3'd4; Read2 = 3'd4;
		repeat (3) @(posedge clock);       // varias bordas de subida
		#2;
		check(Data1, ref_mem[4], "R4 inalterado (RegWrite=0)");
		check(Data2, ref_mem[4], "R4 inalterado (RegWrite=0)");

		// ===== FASE 6: leitura assincrona =====
		fase = 6;
		$display("\n--- FASE 6: leitura assincrona (sem borda de clock) ---");
		// muda os enderecos logo depois de uma borda de subida, ficando longe da
		// proxima: a saida deve mudar imediatamente, sem esperar o clock
		@(posedge clock);
		#1;
		Read1 = 3'd1; Read2 = 3'd6;
		#1; // bem antes da proxima borda (que ocorre 4 ns depois)
		check(Data1, ref_mem[1], "Data1 muda sem clock");
		check(Data2, ref_mem[6], "Data2 muda sem clock");
		#1;
		Read1 = 3'd5; Read2 = 3'd3;
		#1;
		check(Data1, ref_mem[5], "Data1 muda sem clock");
		check(Data2, ref_mem[3], "Data2 muda sem clock");

		// ===== FASE 7: escrita sincrona =====
		fase = 7;
		$display("\n--- FASE 7: escrita sincrona (so na borda de subida) ---");
		@(negedge clock);
		Read1 = 3'd3; Read2 = 3'd3;
		WriteReg  = 3'd3;
		WriteData = 16'd777;
		RegWrite  = 1'b1;                  // habilitado, mas ainda sem borda
		#2;
		check(Data1, ref_mem[3], "R3 ainda com valor antigo");
		@(posedge clock);                  // borda de subida: escreve agora
		ref_mem[3] = 16'd777;
		#1;
		check(Data1, 16'd777, "R3 atualizado apos a borda");
		check(Data2, 16'd777, "R3 atualizado apos a borda");
		@(negedge clock);
		RegWrite = 1'b0;

		// ===== FASE 8: ler e escrever no mesmo registrador =====
		fase = 8;
		$display("\n--- FASE 8: leitura de R2 durante escrita em R2 ---");
		@(negedge clock);
		Read1 = 3'd2; Read2 = 3'd2;
		WriteReg  = 3'd2;
		WriteData = 16'd999;
		RegWrite  = 1'b1;
		#2;
		check(Data1, ref_mem[2], "antes da borda: valor antigo");
		@(posedge clock);
		ref_mem[2] = 16'd999;
		#1;
		check(Data1, 16'd999, "depois da borda: valor novo");
		@(negedge clock);
		RegWrite = 1'b0;

		// ===== FASE 9: sobrescrever registrador =====
		fase = 9;
		$display("\n--- FASE 9: sobrescrita de R5 ---");
		escreve(3'd5, 16'd1);
		escreve(3'd5, 16'd2);
		escreve(3'd5, 16'd3);
		le_e_confere(3'd5, 3'd0);
		// confere que os demais nao foram afetados
		le_e_confere(3'd1, 3'd4);
		le_e_confere(3'd6, 3'd7);

		// ===== FASE 10: valores limite =====
		fase = 10;
		$display("\n--- FASE 10: valores limite (0x0000 e 0xFFFF) ---");
		escreve(3'd0, 16'hFFFF);
		escreve(3'd7, 16'h0000);
		le_e_confere(3'd0, 3'd7);

		// ===== varredura final contra o modelo de referencia =====
		fase = 11;
		$display("\n--- VARREDURA FINAL: todos os registradores ---");
		for (i = 0; i < NUM_REGS; i = i + 2)
			le_e_confere(i[ADDR_WIDTH-1:0], i[ADDR_WIDTH-1:0] + 1'b1);

		// ---------------- resumo ----------------
		#10;
		$display("\n==================================================");
		$display(" RESUMO: %0d checagens OK, %0d falhas", acertos, erros);
		if (erros == 0) $display(" >>> TODOS OS TESTES PASSARAM <<<");
		else            $display(" >>> EXISTEM FALHAS, VERIFIQUE O LOG <<<");
		$display("==================================================\n");
		$stop;
	end

endmodule