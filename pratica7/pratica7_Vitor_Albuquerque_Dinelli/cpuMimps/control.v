//so copiei as portas q tava no slides caminhos de dados do processador e adicio nei o addi pq la n tinha
module control(
	input [5:0] Op,
	output RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch,
	output [1:0]ALUOp
);
	
	//definindo qual tipo de instruçao vai ser
	wire R_format = ~|Op;
	wire lw = Op[5] & ~Op[4] & ~Op[3] & ~Op[2] & Op[1] & Op[0];
	wire sw = Op[5] & ~Op[4] & Op[3] & ~Op[2] & Op[1] & Op[0];
	wire beq = ~Op[5] & ~Op[4] & ~Op[3] & Op[2] & ~Op[1] & ~Op[0];
	wire addi = ~Op[5] & ~Op[4] &  Op[3] & ~Op[2] & ~Op[1] & ~Op[0];
	
	//setandos os outputs
	assign RegDst = R_format;
	assign ALUSrc = lw | sw | addi;
	assign MemtoReg = lw;
	assign RegWrite = R_format | lw | addi;
	assign MemRead = lw;
	assign MemWrite = sw;
	assign Branch = beq;
	assign ALUOp[1] = R_format;
	assign ALUOp[0] = beq;
	
endmodule