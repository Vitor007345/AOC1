module bancoDeReg #(
	parameter ADDR_WIDTH = 3,
	parameter REG_WIDTH = 16,
	parameter INIT_FILE = ""
)
(
	input [ADDR_WIDTH-1:0] Read1, Read2, WriteReg, 
	input [REG_WIDTH-1:0] WriteData,
	input RegWrite, clock,
	output [REG_WIDTH-1:0] Data1, Data2
);
	localparam NUM_REGS = 1 << ADDR_WIDTH;
	
	reg [REG_WIDTH-1:0] banco[0:NUM_REGS -1]; //array de registradores
	
	//seta as saidas pelo valor dos regs correspondentes
	assign Data1 = banco[Read1]; //leitura assíncrona (porta 1)
	assign Data2 = banco[Read2]; //leitura assíncrona (porta 2)
	
	//escreve somente em borda de subida do clock
	always @(posedge clock) begin //escrita síncrona
		if(RegWrite) begin //se RegWrite for 1 atualiza o o valor do reg
			banco[WriteReg] <= WriteData;
		end
	end
	
	//inicializa todos  os regs
	integer i;
   integer file, scan_result;
   reg [31:0] reg_index;
   reg [REG_WIDTH-1:0] reg_val;
	initial begin
		for (i = 0; i < NUM_REGS; i = i + 1) begin
			banco[i] = 0;
		end
		
		
      if (INIT_FILE != "") begin
			$readmemh(INIT_FILE, banco);
		end

	end
	
	
endmodule