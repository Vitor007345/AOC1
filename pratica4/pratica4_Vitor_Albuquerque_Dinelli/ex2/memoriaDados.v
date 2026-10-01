module memoriaDados #(
	parameter ADDR_SIZE = 6, //2 elevado a 6, da 64 bytes
	parameter DATA_BYTES = 2 //2 bytes sao 16 bits
)(
	input [ADDR_SIZE-1:0] address,
	input memWrite, memRead, clock,
	input [(DATA_BYTES<<3)-1:0] writeData, //<<3 e a msm coisa q *8
	output [(DATA_BYTES<<3)-1:0] readData
	
);

	reg [7:0] memory [0:(1<<ADDR_SIZE)-1]; //faz 2 elevado ao tamanho do endereço
	
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
	
	
endmodule