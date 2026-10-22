`timescale 1ns/1ps
// Testbench da instrucao ADD (item I.c da pratica 7) as outras instruçoes q pede na c estao no outro testbench
//   0 : add $11, $18, $17
//   4 : add $12, $11, $18
// Usa instrucoes_add.txt (colocar na mesma pasta do instrucoes.txt)
module tb_cpuMimps_add;
    reg clock = 1'b0, reset = 1'b1;
    wire [31:0] PCatual, instruction, Data1, Data2, ALUb, signEx, ALUResult;
    wire [4:0]  WriteReg;
    wire [2:0]  ALUop3;
    wire        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0]  ALUOp;

    cpuMimps dut (.clock(clock), .reset(reset), .PCatual(PCatual), .instruction(instruction),
        .Data1(Data1), .Data2(Data2), .ALUb(ALUb), .signEx(signEx), .ALUResult(ALUResult),
        .WriteReg(WriteReg), .ALUop3(ALUop3), .RegDst(RegDst), .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg), .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .Branch(Branch), .ALUOp(ALUOp));

    defparam dut.memoriaInst.FILE_NAME = "instrucoes_add.txt"; // troca o programa

    always #5 clock = ~clock;

    integer erros = 0, i;
    reg [31:0] a, b;

    task check(input [8*12-1:0] nome, input [31:0] obt, input [31:0] esp);
        if (obt !== esp) begin erros = erros + 1;
            $display("  [ERRO] %0s obtido=%0d esperado=%0d", nome, $signed(obt), $signed(esp)); end
    endtask

    task passo(input integer n, input [31:0] instr, input [4:0] wr, input [31:0] d1, input [31:0] d2);
        begin
            #1;
            $display("--- ADD %0d | PC=%0d | instr=%b", n, PCatual, instruction);
            $display("    Data1=%0d Data2=%0d ULA=%0d WriteReg=$%0d RegDst=%b ALUSrc=%b RegWrite=%b ALUOp=%b ULAop=%b",
                     $signed(Data1), $signed(Data2), $signed(ALUResult), WriteReg, RegDst, ALUSrc, RegWrite, ALUOp, ALUop3);
            check("PC", PCatual, n*4);       check("instrucao", instruction, instr);
            check("RegDst", RegDst, 1);      check("ALUSrc", ALUSrc, 0);
            check("RegWrite", RegWrite, 1);  check("MemtoReg", MemtoReg, 0);
            check("MemRead", MemRead, 0);    check("MemWrite", MemWrite, 0);
            check("Branch", Branch, 0);      check("ALUOp", ALUOp, 2'b10);
            check("ULA control", ALUop3, 3'b010);
            check("WriteReg", WriteReg, wr);
            check("Data1", Data1, d1);       check("Data2", Data2, d2);
            check("ALUb", ALUb, d2);         check("ALUResult", ALUResult, d1 + d2);
            @(posedge clock); #1;
            check("banco[dest]", dut.bancoReg.banco[wr], d1 + d2);
            check("PC+4", PCatual, (n+1)*4);
            $display("    -> apos a borda: $%0d = %0d | PC = %0d", wr, $signed(dut.bancoReg.banco[wr]), PCatual);
            @(negedge clock);
        end
    endtask

    initial begin
        $dumpfile("tb_cpuMimps_add.vcd"); $dumpvars(0, tb_cpuMimps_add);
        a = 32'd25; b = 32'd7;
        reset = 1; @(negedge clock); @(negedge clock);
        dut.bancoReg.banco[11] = 0; dut.bancoReg.banco[12] = 0;
        dut.bancoReg.banco[17] = b;  dut.bancoReg.banco[18] = a;
        reset = 0;
        passo(0, 32'b00000010010100010101100000100000, 5'd11, a,      b);   // $11 = 25+7
        passo(1, 32'b00000001011100100110000000100000, 5'd12, a + b,  a);   // $12 = 32+25
        $display("\n RESULTADO: %0s (%0d erros)", erros == 0 ? "PASSOU" : "FALHOU", erros);
        $finish;
    end
endmodule