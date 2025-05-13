module lab1_b( input logic [3:0] a, output logic [6:0] zout);

always_comb begin
	unique case (a)
	4'b0000 : zout = 7'b1000000;
	4'b0001 : zout = 7'b1111001;
	4'b0010 : zout = 7'b0100100;
	4'b0011 : zout = 7'b0110000;
	4'b0100 : zout = 7'b0011001;
	4'b0101 : zout = 7'b0010010;
	4'b0110 : zout = 7'b0000010;
	4'b0111 : zout = 7'b1111000;
	4'b1000 : zout = 7'b0000000;
	4'b1001 : zout = 7'b0010000;
	4'b1010 : zout = 7'b0001000;
	4'b1011 : zout = 7'b0000011;
	4'b1100 : zout = 7'b1000110;
	4'b1101 : zout = 7'b0100001;
	4'b1110 : zout = 7'b0000110;
	4'b1111 : zout = 7'b0001110;
	endcase
end

endmodule