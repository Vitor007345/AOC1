`timescale 1ns/1ps

// Testbench da pratica 8 - lw / sw
// Programa (instrucoes.txt):
//   0 : addi $8, $zero, 4    # R[8]  <= 4
//   4 : lw   $9, 0($5)       # R[9]  <= M[24] = 6
//   8 : sub  $9, $9, $8      # R[9]  <= 6 - 4 = 2
//   12: sw   $9, 4($5)       # M[28] <= 2
//   16: lw   $10, 4($5)      # R[10] <= M[28] = 2
module tb_cpuMimps;

	reg clock;
	reg reset;

	wire [31:0] PCatual, instruction, Data1, Data2, ALUb, signEx, ALUResult, writeDataRegs;
	wire [4:0]  WriteReg;
	wire [2:0]  ALUop3;
	wire        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
	wire [1:0]  ALUOp;

	cpuMimps dut (
		.clock(clock),
		.reset(reset),
		.PCatual(PCatual),
		.instruction(instruction),
		.Data1(Data1),
		.Data2(Data2),
		.ALUb(ALUb),
		.signEx(signEx),
		.ALUResult(ALUResult),
		.writeDataRegs(writeDataRegs),
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

	// clock de 10 ns
	initial clock = 1'b0;
	always #5 clock = ~clock;

	// reset: ativo no inicio, solta antes da primeira borda util
	initial begin
		reset = 1'b1;
		#12;
		reset = 1'b0;
		// 5 instrucoes + folga
		#100;
		$display("Fim da simulacao.");
		$stop;
	end

	// log no meio do ciclo (sinais ja estabilizados)
	always @(negedge clock) begin
		if (!reset)
			$display("t=%0t | PC=%0d | instr=%h | Data1=%0d Data2=%0d | ALUb=%0d ALUResult=%0d | WriteReg=%0d writeDataRegs=%0d | RegW=%b MemR=%b MemW=%b MemtoReg=%b",
				$time, PCatual, instruction, Data1, Data2, ALUb, ALUResult, WriteReg, writeDataRegs,
				RegWrite, MemRead, MemWrite, MemtoReg);
	end

	// verificacoes simples (PASS/FAIL) por instrucao
	always @(negedge clock) begin
		if (!reset) begin
			case (PCatual)
				32'd0: // addi $8,$zero,4
					if (ALUResult !== 32'd4 || writeDataRegs !== 32'd4 || WriteReg !== 5'd8)
						$display("  FAIL addi (PC=0)"); else $display("  PASS addi (PC=0): R[8] <= 4");
				32'd4: // lw $9,0($5)
					if (ALUResult !== 32'd24 || writeDataRegs !== 32'd6 || WriteReg !== 5'd9)
						$display("  FAIL lw (PC=4)"); else $display("  PASS lw (PC=4): R[9] <= M[24] = 6");
				32'd8: // sub $9,$9,$8
					if (ALUResult !== 32'd2 || writeDataRegs !== 32'd2 || WriteReg !== 5'd9)
						$display("  FAIL sub (PC=8)"); else $display("  PASS sub (PC=8): R[9] <= 2");
				32'd12: // sw $9,4($5)
					if (ALUResult !== 32'd28 || Data2 !== 32'd2 || MemWrite !== 1'b1)
						$display("  FAIL sw (PC=12)"); else $display("  PASS sw (PC=12): M[28] <= 2");
				32'd16: // lw $10,4($5)
					if (ALUResult !== 32'd28 || writeDataRegs !== 32'd2 || WriteReg !== 5'd10)
						$display("  FAIL lw (PC=16)"); else $display("  PASS lw (PC=16): R[10] <= M[28] = 2");
				default: ;
			endcase
		end
	end

endmodule