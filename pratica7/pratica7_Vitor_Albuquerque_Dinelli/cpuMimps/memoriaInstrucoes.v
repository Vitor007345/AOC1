module memoriaInstrucoes #(
   parameter ADDR_SIZE = 8, //2 elevado a 8, da 256 bytes
	parameter DATA_BYTES = 4, //4 bytes sao 32 bits
	parameter FILE_NAME = "instrucoes.txt"
)(
	input [ADDR_SIZE-1:0] address,
	output [(DATA_BYTES<<3)-1:0] readData //<<3 e a msm coisa q *8
	
);

	reg [7:0] memory [0:(1<<ADDR_SIZE)-1]; //faz 2 elevado ao tamanho do endereço
		
	genvar i;
	generate
		for(i = 0; i < DATA_BYTES; i = i + 1) begin : loop_leitura
			assign readData[(i<<3) +: 8] = memory[address + i];
      end
   endgenerate
	
	reg [(DATA_BYTES<<3)-1:0] temp_rom [0:((1<<ADDR_SIZE)/DATA_BYTES)-1]; //cria vetor temporario pra ler instruçoes do arquivo
	integer k, j, b;
	initial begin
		for (k = 0; k < (1<<ADDR_SIZE); k = k + 1) memory[k] = 8'b0; //inicia memoria com 0
		
		for (k = 0; k < ((1<<ADDR_SIZE)/DATA_BYTES); k = k + 1) temp_rom[k] = 0; //posicoes sem instrucao viram 0 em vez de X na simulaçao
		
		$readmemb(FILE_NAME, temp_rom); //le as instruçoes
		
		//salva na memoria as instruçoes
		for (j = 0; j < ((1<<ADDR_SIZE)/DATA_BYTES); j = j + 1) begin
            for (b = 0; b < DATA_BYTES; b = b + 1) begin
                memory[(j * DATA_BYTES) + b] = temp_rom[j][(b<<3) +: 8];
            end
        end
		
		
	end
endmodule