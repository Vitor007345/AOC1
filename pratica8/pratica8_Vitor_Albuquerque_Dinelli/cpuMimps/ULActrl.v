//so copiei as portas q tava no slides caminhos de dados do processador
module ULActrl(
	input [5:0]funct,
	input [1:0]ALUOp,
	output [2:0]operation
);
	assign operation[2] = ALUOp[0] | (ALUOp[1] & funct[1]);
	assign operation[1] = ~ALUOp[1] | ~funct[2];
	assign operation[0] = ALUOp[1] & (funct[3] | funct[0]);
endmodule