// ============================================================
// Debounce do botao: so muda a saida depois de ~21 ms estavel
// ============================================================
module debounce(
	input clk, noisy,
	output reg clean
);
	initial clean = 1'b0;
	reg sync0 = 1'b0, sync1 = 1'b0;
	reg [19:0] cnt = 20'd0;
 
	always @(posedge clk) begin
		sync0 <= noisy;
		sync1 <= sync0;
		if (sync1 == clean)
			cnt <= 20'd0;
		else begin
			cnt <= cnt + 1'b1;
			if (cnt == 20'hFFFFF) clean <= sync1;
		end
	end
endmodule
