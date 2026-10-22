`timescale 1ns/1ps

module tb_ULActrl;

    // Declaração de sinais (reg para entradas, wire para saídas)
    reg [5:0] funct;
    reg [1:0] ALUop;
    wire [2:0] operation;

    // Instanciação do módulo ULA Control
    ULActrl uut (
        .funct(funct),
        .ALUOp(ALUop),
        .operation(operation)
    );

    initial begin
        // Configuração para exibir as mudanças no console (Monitor)
        $monitor("Tempo = %0t ns | ALUop = %b | funct = %b | operation = %b", 
                 $time, ALUop, funct, operation);

        $display("--- Iniciando Testes do Controlador da ULA ---");

        // 1. Teste para LW / SW (ALUop = 00 -> Operação deve ser Soma/Add: 010)
        ALUop = 2'b00; funct = 6'b000000; #10;

        // 2. Teste para BEQ (ALUop = 01 -> Operação deve ser Subtração/Sub: 110)
        ALUop = 2'b01; funct = 6'b000000; #10;

        // 3. Instruções do Tipo R (ALUop = 10)
        // 3.1. ADD (funct = 32 -> 6'b100000) -> Operação: 010
        ALUop = 2'b10; funct = 6'b100000; #10;

        // 3.2. SUB (funct = 34 -> 6'b100010) -> Operação: 110
        ALUop = 2'b10; funct = 6'b100010; #10;

        // 3.3. AND (funct = 36 -> 6'b100100) -> Operação: 000
        ALUop = 2'b10; funct = 6'b100100; #10;

        // 3.4. OR (funct = 37 -> 6'b100101) -> Operação: 001
        ALUop = 2'b10; funct = 6'b100101; #10;

        // 3.5. SLT (funct = 42 -> 6'b101010) -> Operação: 111
        ALUop = 2'b10; funct = 6'b101010; #10;

        $display("--- Testes Concluídos ---");
        $finish;
    end

endmodule