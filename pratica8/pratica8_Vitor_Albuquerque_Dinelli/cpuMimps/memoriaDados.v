module memoriaDados #(
	parameter ADDR_SIZE = 6, //2 elevado a 6, da 64 bytes
	parameter DATA_BYTES = 2, //2 bytes sao 16 bits
	parameter FILE_NAME = ""
)(
	input [ADDR_SIZE-1:0] address,
	input memWrite, memRead, clock,
	input [(DATA_BYTES<<3)-1:0] writeData, //<<3 e a msm coisa q *8
	output [(DATA_BYTES<<3)-1:0] readData
	
);

	reg [7:0] memory [0:(1<<ADDR_SIZE)-1]; //faz 2 elevado ao tamanho do endereço
	
	//Memória temporária para carregar os dados do arquivo
   reg [(DATA_BYTES<<3)-1:0] temp_ram [0:((1<<ADDR_SIZE)/DATA_BYTES)-1];
	
	integer i;
	always @(posedge clock) begin
		if(memWrite) begin
			for(i = 0; i < DATA_BYTES; i = i + 1)begin //salva byte por byte oq esta no writeData na memoria
				memory[address + i] <= writeData[(i<<3) +: 8]; 
			end
		end
	end
	
	genvar j;
	generate
		for(j = 0; j < DATA_BYTES; j = j + 1) begin : loop_leitura
			assign readData[(j<<3) +: 8] = memRead ? memory[address + j] : 8'b0;
      end
   endgenerate
	
	integer k, c, b;
	// Inicialização da memória
   initial begin
		
      // Inicializa toda a memória com zero
      for(k = 0; k < (1<<ADDR_SIZE); k = k + 1)
			memory[k] = 8'b0;
		if(FILE_NAME != "") begin
			// Inicializa a memória temporária com zero
			for(k = 0; k < ((1<<ADDR_SIZE)/DATA_BYTES); k = k + 1)
				temp_ram[k] = 0;

			// Lê os dados do arquivo
			$readmemb(FILE_NAME, temp_ram);

			// Transfere os dados para a memória principal
			for(c = 0; c < ((1<<ADDR_SIZE)/DATA_BYTES); c = c + 1) begin
				for(b = 0; b < DATA_BYTES; b = b + 1) begin
					memory[(c * DATA_BYTES) + b] = temp_ram[c][(b<<3) +: 8];
				 end
			end
		end

    end
	
	
endmodule
