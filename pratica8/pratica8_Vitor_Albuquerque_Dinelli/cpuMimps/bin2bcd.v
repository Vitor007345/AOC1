// ============================================================
// Binario (17 bits) -> BCD (5 digitos), algoritmo double dabble
// ============================================================
module bin2bcd(
	input  [16:0] bin,
	output [19:0] bcd
);
	reg [36:0] sh;       // [36:17] = 5 digitos BCD | [16:0] = binario
	integer i;
 
	always @* begin
		sh = 37'd0;
		sh[16:0] = bin;
		for (i = 0; i < 17; i = i + 1) begin
			if (sh[20:17] >= 5) sh[20:17] = sh[20:17] + 4'd3;
			if (sh[24:21] >= 5) sh[24:21] = sh[24:21] + 4'd3;
			if (sh[28:25] >= 5) sh[28:25] = sh[28:25] + 4'd3;
			if (sh[32:29] >= 5) sh[32:29] = sh[32:29] + 4'd3;
			if (sh[36:33] >= 5) sh[36:33] = sh[36:33] + 4'd3;
			sh = sh << 1;
		end
	end
 
	assign bcd = sh[36:17];
endmodule
 
