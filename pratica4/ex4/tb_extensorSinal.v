`timescale 1ns/1ns

module tb_extensorSinal();
	
	localparam initialSize = 16;
	localparam finalSize = 32;
	
	reg [initialSize-1:0]entrada;
	wire [finalSize-1:0]saida;
	
	extensorSinal #(
		.initialSize(initialSize),
		.finalSize(finalSize)
	) ex0 (
		.N(entrada),
		.S(saida)
	);
	
	
	initial begin
		//iniciar 0
		entrada = 0;
		#10;
		
		//testar com numero positivo
		entrada = 3450;
		#10;
		
		//testar com numero negativo
		entrada = -234;
		#10;
		
		$stop;
	end

endmodule