module tb_ULA;

    // Entradas do módulo viram 'reg' no testbench
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] ALUop;

    // Saídas viram 'wire'
    wire [31:0] result;
    wire overflow;
    wire zero;

    // Instanciação da tua ULA parametrizada (Device Under Test)
    ULA #(.N(32)) DUT (
        .a(a),
        .b(b),
        .ALUop(ALUop),
        .result(result),
        .overflow(overflow),
        .zero(zero)
    );

    initial begin
        // Ponto de partida limpo
        a = 0; b = 0; ALUop = 0;
        #10;

        // 1. Teste de SOMA normal (ADD = 010)
        // Esperado: result = 25, zero = 0, overflow = 0
        a = 32'd15; b = 32'd10; ALUop = 3'b010;
        #20; 

        // 2. Teste de SUBTRAÇÃO (SUB = 110)
        // Esperado: result = 15, zero = 0, overflow = 0
        a = 32'd25; b = 32'd10; ALUop = 3'b110;
        #20;

        // 3. Teste da FLAG ZERO (SUB = 110 com números iguais)
        // Esperado: result = 0, zero = 1
        a = 32'd42; b = 32'd42; ALUop = 3'b110;
        #20;

        // 4. Teste do SLT VERDADEIRO (SLT = 111) (10 é menor que 20?)
        // Esperado: result = 1
        a = 32'd10; b = 32'd20; ALUop = 3'b111;
        #20;

        // 5. Teste do SLT FALSO (SLT = 111) (20 é menor que 10?)
        // Esperado: result = 0
        a = 32'd20; b = 32'd10; ALUop = 3'b111;
        #20;

        // 6. Teste de OVERFLOW na SOMA
        // 32'h7FFFFFFF é o maior número positivo (+2147483647). Se somarmos 1, estoura para negativo.
        // Esperado: result = 80000000 (negativo), overflow = 1
        a = 32'h7FFFFFFF; b = 32'd1; ALUop = 3'b010;
        #20;

        // 7. Teste de AND Lógico (AND = 000)
        // Esperado: result = 00FF0000
        a = 32'hFFFF0000; b = 32'h00FF0F0F; ALUop = 3'b000;
        #20;

        // 8. Teste de OR Lógico (OR = 001)
        // Esperado: result = FFFFFFFF
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; ALUop = 3'b001;
        #20;

        $stop; // Interrompe a simulação no Questa para poderes ver as ondas
    end

endmodule