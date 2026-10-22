`timescale 1ns/1ps

// ============================================================================
// Testbench autoverificável do cpuMimps - Prática 7 (item II.a)
//
// Programa em instrucoes.txt:
//   0 : addi $9,  $18, 10
//   4 : sub  $9,  $18, $17
//   8 : and  $8,  $9,  $18
//   12: or   $10, $9,  $17
//   16: slt  $8,  $18, $17
//
// Para cada instrução o TB confere, no meio do ciclo (negedge, tudo estável):
//   PC, instrução, sinais de controle, ALUOp, operação da ULA, WriteReg,
//   Data1, Data2, entrada B da ULA e resultado da ULA;
// e logo depois da borda de subida:
//   valor gravado no banco de registradores e novo PC.
// Roda 4 cenários com valores diferentes de $18 e $17 (positivos, negativos,
// overflow na subtração e iguais).
//
// OBS: o arquivo instrucoes.txt precisa estar no diretório de trabalho do
// simulador (no ModelSim: a pasta onde está o .mpf / "simulation/modelsim").
// ============================================================================
module tb_cpuMimps;

    reg clock = 1'b0;
    reg reset = 1'b1;

    wire [31:0] PCatual, instruction, Data1, Data2, ALUb, signEx, ALUResult;
    wire [4:0]  WriteReg;
    wire [2:0]  ALUop3;
    wire        RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch;
    wire [1:0]  ALUOp;

    cpuMimps dut (
        .clock(clock), .reset(reset),
        .PCatual(PCatual), .instruction(instruction),
        .Data1(Data1), .Data2(Data2), .ALUb(ALUb),
        .signEx(signEx), .ALUResult(ALUResult),
        .WriteReg(WriteReg), .ALUop3(ALUop3),
        .RegDst(RegDst), .ALUSrc(ALUSrc), .MemtoReg(MemtoReg),
        .RegWrite(RegWrite), .MemRead(MemRead), .MemWrite(MemWrite),
        .Branch(Branch), .ALUOp(ALUOp)
    );

    always #5 clock = ~clock;   // periodo de 10 ns

    // ------------------------------------------------------------------
    // Valores esperados (preenchidos a cada cenário)
    // ------------------------------------------------------------------
    reg [31:0] exp_instr [0:4];
    reg [4:0]  exp_wr    [0:4];
    reg        exp_regdst[0:4];
    reg        exp_alusrc[0:4];
    reg [1:0]  exp_aluop [0:4];
    reg [2:0]  exp_op3   [0:4];
    reg [31:0] exp_d1    [0:4];
    reg [31:0] exp_d2    [0:4];
    reg [31:0] exp_alub  [0:4];
    reg [31:0] exp_res   [0:4];

    integer erros = 0;
    integer checks = 0;
    integer i;

    task check;
        input [8*14-1:0] nome;
        input [31:0] obtido;
        input [31:0] esperado;
        begin
            checks = checks + 1;
            if (obtido !== esperado) begin
                erros = erros + 1;
                $display("    [ERRO] %0s: obtido=%h (%0d) esperado=%h (%0d)",
                         nome, obtido, $signed(obtido), esperado, $signed(esperado));
            end
        end
    endtask

    // ------------------------------------------------------------------
    // Monta a tabela de esperados a partir dos valores iniciais de $18 e $17
    // ------------------------------------------------------------------
    task monta_esperados;
        input [31:0] a;   // $18
        input [31:0] b;   // $17
        reg   [31:0] r9;
        begin
            r9 = a - b;   // valor de $9 depois do sub

            // 0: addi $9,$18,10  (Data2 le $9 = rt, que vale 0 aqui; a ULA usa o imediato)
            exp_instr[0]=32'b00100010010010010000000000001010; exp_wr[0]=5'd9;
            exp_regdst[0]=0; exp_alusrc[0]=1; exp_aluop[0]=2'b00; exp_op3[0]=3'b010;
            exp_d1[0]=a;  exp_d2[0]=32'd0; exp_alub[0]=32'd10; exp_res[0]=a + 32'd10;

            // 1: sub $9,$18,$17
            exp_instr[1]=32'b00000010010100010100100000100010; exp_wr[1]=5'd9;
            exp_regdst[1]=1; exp_alusrc[1]=0; exp_aluop[1]=2'b10; exp_op3[1]=3'b110;
            exp_d1[1]=a;  exp_d2[1]=b;  exp_alub[1]=b;      exp_res[1]=r9;

            // 2: and $8,$9,$18
            exp_instr[2]=32'b00000001001100100100000000100100; exp_wr[2]=5'd8;
            exp_regdst[2]=1; exp_alusrc[2]=0; exp_aluop[2]=2'b10; exp_op3[2]=3'b000;
            exp_d1[2]=r9; exp_d2[2]=a;  exp_alub[2]=a;      exp_res[2]=r9 & a;

            // 3: or $10,$9,$17
            exp_instr[3]=32'b00000001001100010101000000100101; exp_wr[3]=5'd10;
            exp_regdst[3]=1; exp_alusrc[3]=0; exp_aluop[3]=2'b10; exp_op3[3]=3'b001;
            exp_d1[3]=r9; exp_d2[3]=b;  exp_alub[3]=b;      exp_res[3]=r9 | b;

            // 4: slt $8,$18,$17
            exp_instr[4]=32'b00000010010100010100000000101010; exp_wr[4]=5'd8;
            exp_regdst[4]=1; exp_alusrc[4]=0; exp_aluop[4]=2'b10; exp_op3[4]=3'b111;
            exp_d1[4]=a;  exp_d2[4]=b;  exp_alub[4]=b;
            exp_res[4]=($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
        end
    endtask

    // ------------------------------------------------------------------
    // Executa o programa inteiro para um par de valores iniciais
    // ------------------------------------------------------------------
    task roda_cenario;
        input [31:0] a;   // valor inicial de $18
        input [31:0] b;   // valor inicial de $17
        begin
            $display("\n=================================================================");
            $display(" CENARIO: $18 = %0d (%h)   $17 = %0d (%h)", $signed(a), a, $signed(b), b);
            $display("=================================================================");
            monta_esperados(a, b);

            // Reset (assincrono) -> PC = 0. O RegWrite e travado pelo reset na
            // CPU, entao nada e gravado durante o reset. Os registradores sao
            // (re)inicializados no ultimo negedge, junto com a saida do reset.
            reset = 1'b1;
            @(negedge clock);
            @(negedge clock);
            dut.bancoReg.banco[8]  = 32'd0;
            dut.bancoReg.banco[9]  = 32'd0;
            dut.bancoReg.banco[10] = 32'd0;
            dut.bancoReg.banco[17] = b;
            dut.bancoReg.banco[18] = a;
            reset = 1'b0;

            for (i = 0; i < 5; i = i + 1) begin
                #1; // deixa a logica combinacional estabilizar (meio do ciclo)

                $display("--- Instrucao %0d | PC=%0d | instr=%b", i, PCatual, instruction);
                $display("    RegDst=%b ALUSrc=%b MemtoReg=%b RegWrite=%b MemRead=%b MemWrite=%b Branch=%b ALUOp=%b ULAop=%b",
                         RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp, ALUop3);
                $display("    WriteReg=$%0d Data1=%0d Data2=%0d ALUb=%0d ULA=%0d",
                         WriteReg, $signed(Data1), $signed(Data2), $signed(ALUb), $signed(ALUResult));

                check("PC",          PCatual,     i*4);
                check("instrucao",   instruction, exp_instr[i]);
                check("RegDst",      RegDst,      exp_regdst[i]);
                check("ALUSrc",      ALUSrc,      exp_alusrc[i]);
                check("RegWrite",    RegWrite,    1'b1);
                check("MemtoReg",    MemtoReg,    1'b0);
                check("MemRead",     MemRead,     1'b0);
                check("MemWrite",    MemWrite,    1'b0);
                check("Branch",      Branch,      1'b0);
                check("ALUOp",       ALUOp,       exp_aluop[i]);
                check("ULA control", ALUop3,      exp_op3[i]);
                check("WriteReg",    WriteReg,    exp_wr[i]);
                check("Data1",       Data1,       exp_d1[i]);
                check("Data2",       Data2,       exp_d2[i]);
                check("ALUb",        ALUb,        exp_alub[i]);
                check("ALUResult",   ALUResult,   exp_res[i]);

                @(posedge clock);
                #1; // depois da borda: registrador gravado e PC atualizado
                check("banco[dest]", dut.bancoReg.banco[exp_wr[i]], exp_res[i]);
                check("PC+4",        PCatual, (i+1)*4);
                $display("    -> apos a borda: $%0d = %0d | PC = %0d",
                         exp_wr[i], $signed(dut.bancoReg.banco[exp_wr[i]]), PCatual);

                @(negedge clock);
            end

            // Estado final dos registradores
            check("final $8  slt", dut.bancoReg.banco[8],  exp_res[4]);
            check("final $9  sub", dut.bancoReg.banco[9],  exp_res[1]);
            check("final $10 or",  dut.bancoReg.banco[10], exp_res[3]);
            check("final $17",     dut.bancoReg.banco[17], b);
            check("final $18",     dut.bancoReg.banco[18], a);
            check("final $0",      dut.bancoReg.banco[0],  32'd0);
        end
    endtask

    // ------------------------------------------------------------------
    initial begin
        $dumpfile("tb_cpuMimps.vcd");
        $dumpvars(0, tb_cpuMimps);

        #1;
        $display("Valores carregados de registradores.txt: $17=%0d  $18=%0d",
                 $signed(dut.bancoReg.banco[17]), $signed(dut.bancoReg.banco[18]));

        roda_cenario(32'd25,         32'd7);        // caso comum, slt = 0
        roda_cenario(-32'sd5,        32'd3);        // negativo, slt = 1
        roda_cenario(32'h80000000,   32'd1);        // overflow na subtracao, slt = 1
        roda_cenario(32'd7,          32'd7);        // iguais, sub = 0

        $display("\n=================================================================");
        if (erros == 0)
            $display(" RESULTADO: PASSOU - %0d verificacoes, 0 erros", checks);
        else
            $display(" RESULTADO: FALHOU - %0d erros em %0d verificacoes", erros, checks);
        $display("=================================================================");
        $finish;
    end

    // Watchdog
    initial begin
        #20000;
        $display("TIMEOUT");
        $finish;
    end

endmodule