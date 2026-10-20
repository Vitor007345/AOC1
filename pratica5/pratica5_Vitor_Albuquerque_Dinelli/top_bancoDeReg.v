module top_bancoDeReg(
	input [9:0] SW,
	input MAX10_CLK1_50,
	output [0:6]HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);
	//entrada do banco de reg
	wire [1:0] Read1, Read2, WriteReg;
	wire [2:0] WriteData;
	wire RegWrite;
	
	assign Read1 = SW[9:8];
	assign Read2 = SW[7:6];
	assign WriteReg = SW[5:4];
	assign WriteData =  SW[3:1];
	assign RegWrite = SW[0];
	
	//saídas do banco
	wire [2:0] Data1, Data2;
	
	//escrever na tela os endereço dos regs usados
	decodificador decod0(1'b0, 1'b0, Read1[1], Read1[0], HEX5[0], HEX5[1], HEX5[2], HEX5[3], HEX5[4], HEX5[5], HEX5[6]);
	decodificador decod1(1'b0, 1'b0, Read2[1], Read2[0], HEX4[0], HEX4[1], HEX4[2], HEX4[3], HEX4[4], HEX4[5], HEX4[6]);
	decodificador decod2(1'b0, 1'b0, WriteReg[1], WriteReg[0], HEX3[0], HEX3[1], HEX3[2], HEX3[3], HEX3[4], HEX3[5], HEX3[6]);
	
	//escrever na tela o valor a ser salvo
	decodificador decod3(1'b0, WriteData[2], WriteData[1], WriteData[0], HEX2[0], HEX2[1], HEX2[2], HEX2[3], HEX2[4], HEX2[5], HEX2[6]);
	
	bancoDeReg #(
		.ADDR_WIDTH(2),
		.REG_WIDTH(3)
	) banco0 (
		.Read1(Read1),
		.Read2(Read2),
		.WriteReg(WriteReg),
		.WriteData(WriteData),
		.RegWrite(RegWrite),
		.clock(MAX10_CLK1_50),
		.Data1(Data1),
		.Data2(Data2)
	
	);
	
	//escrever na tela o valor dos registradores
	decodificador decod4(1'b0, Data1[2], Data1[1], Data1[0], HEX1[0], HEX1[1], HEX1[2], HEX1[3], HEX1[4], HEX1[5], HEX1[6]);
	decodificador decod5(1'b0, Data2[2], Data2[1], Data2[0], HEX0[0], HEX0[1], HEX0[2], HEX0[3], HEX0[4], HEX0[5], HEX0[6]);
	


endmodule