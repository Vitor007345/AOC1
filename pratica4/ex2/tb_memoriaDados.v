`timescale 1ns/1ns
module tb_memoriaDados;

    localparam ADDR_SIZE = 6;
    localparam DATA_BYTES = 2;
    localparam BITS = DATA_BYTES << 3; //16 bits

    //sinais do Testbench
    reg [ADDR_SIZE-1:0] address;
    reg memWrite;
    reg memRead;
    reg clock;
    reg [BITS-1:0] writeData;
    wire [BITS-1:0] readData;

    //instanciação da Memória de Dados (DUT)
    memoriaDados #(
        .ADDR_SIZE(ADDR_SIZE),
        .DATA_BYTES(DATA_BYTES)
    ) DUT (
        .address(address),
        .memWrite(memWrite),
        .memRead(memRead),
        .clock(clock),
        .writeData(writeData),
        .readData(readData)
    );

    //geração do Clock (Borda de subida a cada 10 unidades de tempo)
    always #5 clock = ~clock;

    initial begin
        //1 inicialização dos sinais
        clock = 0;
        address = 0;
        memWrite = 0;
        memRead = 0;
        writeData = 0;
        
        #10;

        //2 Teste de Leitura Desabilitada
        // Esperado: readData = 16'h0000
        address = 6'd0;
        memRead = 1'b0;
        #10;

        //3 escrita no Endereço 0 (Ocupa os bytes 0 e 1)
        memWrite = 1'b1;
        memRead = 1'b0;
        writeData = 16'hAABB; //hexadecimal pq e mais facil de achar erros pelas ondas
        address = 6'd0;
        #10; //espera o clock subir e gravar
        memWrite = 1'b0;

        //4 leitura do Endereço 0
        // Esperado: readData = 16'hAABB
        memRead = 1'b1;
        address = 6'd0;
        #10;

        //5 escrita no Endereço 2 (Ocupa os bytes 2 e 3)
        memWrite = 1'b1;
        memRead = 1'b0;
        writeData = 16'hCCDD;
        address = 6'd2;
        #10;
        memWrite = 1'b0;

        //6 leitura do Endereço 2
        //esperado: readData = 16'hCCDD
        memRead = 1'b1;
        address = 6'd2;
        #10;

        //7 sobrescrita no Endereço 0
        memWrite = 1'b1;
        memRead = 1'b0;
        writeData = 16'h1234;
        address = 6'd0;
        #10;
        memWrite = 1'b0;

        //8 Confirmação da Sobrescrita
        //esperado: readData = 16'h1234
        memRead = 1'b1;
        address = 6'd0;
        #10;

        $stop; //Pausa o Questa e termina a analise de ondas
    end

endmodule