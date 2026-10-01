module tb_ULA;

    //entradas do modulo
    reg [31:0] a;
    reg [31:0] b;
    reg [2:0] ALUop;

    //saidas
    wire [31:0] result;
    wire overflow;
    wire zero;

    //instanciaçao da ULA
    ULA #(.N(32)) DUT (
        .a(a),
        .b(b),
        .ALUop(ALUop),
        .result(result),
        .overflow(overflow),
        .zero(zero)
    );

    initial begin
        //inicia tudo com 0
        a = 0; b = 0; ALUop = 0;
        #10;

        //1 Teste de soma normal (ADD = 010)
        //esperado: result = 25, zero = 0, overflow = 0
        a = 32'd15; b = 32'd10; ALUop = 3'b010;
        #20; 

        //2 Teste de subtraçao (SUB = 110)
        //esperado: result = 15, zero = 0, overflow = 0
        a = 32'd25; b = 32'd10; ALUop = 3'b110;
        #20;

        //3 Teste da flag zero (SUB = 110 com números iguais)
        //esperado: result = 0, zero = 1
        a = 32'd42; b = 32'd42; ALUop = 3'b110;
        #20;

        //4 Teste do SLT VERDADEIRO (SLT = 111) (10 é menor que 20?)
        //esperado: result = 1
        a = 32'd10; b = 32'd20; ALUop = 3'b111;
        #20;

        //5 teste do slt falso (SLT = 111) (20 < 10?)
        //esperado: result = 0
        a = 32'd20; b = 32'd10; ALUop = 3'b111;
        #20;

        //6 Teste de overflow na soma
        //32'h7FFFFFFF é o maior número positivo (+2147483647) se soma 1, estoura para negativo.
        //esperado: result = 80000000 (negativo), overflow = 1
        a = 32'h7FFFFFFF; b = 32'd1; ALUop = 3'b010;
        #20;

        //7 teste do and (AND = 000)
        //esperado: result = 00FF0000
        a = 32'hFFFF0000; b = 32'h00FF0F0F; ALUop = 3'b000;
        #20;

        //8 teste do or (OR = 001)
        //esperado: result = FFFFFFFF
        a = 32'hF0F0F0F0; b = 32'h0F0F0F0F; ALUop = 3'b001;
        #20;

        $stop; //caba a simulaçao
    end

endmodule