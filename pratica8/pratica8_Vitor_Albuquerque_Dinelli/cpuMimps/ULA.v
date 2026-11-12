module ULA #(
	parameter N = 32
)(
	input [N-1:0] a, b,
	input [2:0] ALUop,
	output [N-1:0] result,
	output overflow, zero
);
	wire [N-1:0] b_mux, sum_result, slt_result, and_result, or_result;
	wire cin, cout;
	
	assign cin = ALUop[2]; //codigo da adiçao começa com 0 (010) e o da subatraçao começa com 1 (110)
	assign b_mux = b ^ {N{cin}}; //inverte b se cin for 1
	
	parameterAdder #(.N(N)) soma_inst (
		.a(a),
		.b(b_mux),
		.cin(cin),
		.s(sum_result),
		.cout(cout)
	);
	
	//se o sinais e a e b forem iguais, , mas o sinal do resultado for diferente deles deu overfloww
	assign overflow = (a[N-1] ~^ b_mux[N-1]) & (sum_result[N-1] ^ a[N-1]);
	
	//como o codigo do slt tbm começa com 1, uma subtraçao sera realizada e da pra reutilizar ela pra calcular o slt, se o sinal da subtraçao for negativo o A e menor q B
	//xor com overflow pois se der overflow na subatraçao o sinal do resultado inverte, e como o xor e um inversor, se tiver overflow inverte
	assign slt_result = {{N-1{1'b0}},(sum_result[N-1] ^ overflow)};
	
	assign and_result = a & b;
	assign or_result = a | b;
	
	
	//mux (fiz o mapa k e deu isso ai)
	wire is_and  = ~ALUop[1] & ~ALUop[0]; 
   wire is_or   = ~ALUop[1] &  ALUop[0]; 
   wire is_math =  ALUop[1] & ~ALUop[0]; 
   wire is_slt  =  ALUop[1] &  ALUop[0];
	
	assign result = ( and_result    & {N{is_and}}  ) | 
                    ( or_result     & {N{is_or}}   ) | 
                    ( sum_result & {N{is_math}} ) | 
                    ( slt_result    & {N{is_slt}}  );
	
	assign zero = ~|result;
	
	

endmodule