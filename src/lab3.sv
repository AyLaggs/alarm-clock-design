module lab3
	(
			input logic clk, 
			input logic rst, 
			input logic SW0,
			input logic SW1,
			input logic SW2,
			input logic SW4,
			input logic KEY0, 
			input logic KEY2,
			input logic KEY3,
			output logic LED7,
			output logic LED9,                                                
			output logic [6:0] HEX0, 
			output logic [6:0] HEX1,
			output logic [6:0] HEX2, 
			output logic [6:0] HEX3	);
			
			
logic [27-1:0] S1; // output of million counter

logic [3:0] S2; // output of ones [-,-,-,x]
logic [3:0] S3; // output of tens [-,-,x,-]
logic [3:0] S4; // output of hundreds [-,x,-,-]
logic [3:0] S5; // output of thousands [x,-,-,-]
logic [5-1:0] SA; // for hour calculation

logic [3:0] A2; // FOR ALARM output of ones [-,-,-,x]
logic [3:0] A3; // FOR ALARM output of tens [-,-,x,-]
logic [3:0] A4; // FOR ALARM output of hundreds [-,x,-,-]
logic [3:0] A5; // FOR ALARM output of thousands [x,-,-,-]
logic [5-1:0] AA; // ALARM for hour calculation

logic [3:0] B2; // FOR ALARM output of ones [-,-,-,x]
logic [3:0] B3; // FOR ALARM output of tens [-,-,x,-]
logic [3:0] B4; // FOR ALARM output of hundreds [-,x,-,-]
logic [3:0] B5; // FOR ALARM output of thousands [x,-,-,-]

logic [5-1:0] A2_r; // FOR ALARM output of ones [-,-,-,x]
logic [5-1:0] A3_r; // FOR ALARM output of tens [-,-,x,-]
logic [5-1:0] A4_r; // FOR ALARM output of hundreds [-,x,-,-]
logic [5-1:0] A5_r; // FOR ALARM output of thousands [x,-,-,-]

logic [3:0] H2; // HEX DISPLAY output of ones [-,-,-,x]
logic [3:0] H3; // HEX DISPLAY output of tens [-,-,x,-]
logic [3:0] H4; // HEX DISPLAY output of hundreds [-,x,-,-]
logic [3:0] H5; // HEX DISPLAY output of thousands [x,-,-,-]

logic T1; // 120x speed
logic TC1; // are we changing time or is it changing on its own (specifically for ones)
logic TC2; // for tens
logic TC3; // for hundreds

logic L1; // ALARM are we changing time or is it changing on its own (specifically for ones)
logic L2; // ALARM for tens
logic L3; // ALARM for hundreds

logic new_clk; // clock based on the speed
logic tens_clk; // tens counts when ones is 9
logic hour_clk; // hunds counts when 59

logic tens_clk_AL;

logic AL; // isAlarm?
logic LD; // LED7 Condition
logic AL_old; // 

lab_counter #(100000000) one_meg (.inc(1'b1), 
											 .dec(1'b0), 
											 .clk, 
											 .rst(1'b1), 
											 .cnt(S1));

assign T1 = (((S1 == 27'd0) || (S1 == 27'd24000000) || (S1 == 27'd49000000) || (S1 == 27'd74000000)) ? 1'b1 : 1'b0); //half second speed
											 
assign new_clk = SW4 ? T1 : ((S1 == 27'd0) || (S1 == 27'd49000000));	
	
// Normal Time :

assign TC1 = (SW1 && !SW2) ? ( !(KEY2) && new_clk ) : (new_clk);	
	
lab_counter #(10) ones (.dec(1'b0), 
								.inc( TC1 ), 
								.clk(clk), 
								.rst(SW0), 
								.cnt(S2));

assign TC2 = (SW1 && !SW2) ? ( !(KEY2) && tens_clk && new_clk ) : ( tens_clk && new_clk ); //depend on key or run on its own	

assign tens_clk = (S2 == 4'd9); // if ones is 9, clock tens

lab_counter #(6) tens ( .dec(1'b0), 
								.inc( TC2 ), 
								.clk(clk), 
								.rst(SW0), 
								.cnt(S3));

assign TC3 = (SW1 && !SW2) ? ( !(KEY3) && new_clk ) : ( new_clk && hour_clk && tens_clk );	

assign hour_clk = ((S3 == 3'd5) && (S2 == 4'd9)); // if ones is 9 and tens is 5, clock hour

lab_counter #(24) hour (.dec( 1'b0 ), 
								.inc( TC3 ), 
								.clk(clk), 
								.rst(SW0), 
								.cnt(SA));

assign S4 = SA % 10; //Calculations
assign S5 = ( (SA - S4) / 10 );

// End of Normal Time

// Alarm stuff:

assign L1 = ( !(KEY2) && new_clk ); // depends on key

lab_counter #(10) ones_AL (.dec(1'b0), 
									.inc( L1 ), 
									.clk(clk), 
									.rst(SW0), 
									.cnt(A2));

assign tens_clk_AL = (A2 == 4'd9); // if ones is 9, clock tens
									

assign L2 = ( !(KEY2) && tens_clk_AL && new_clk ); // depends on key

lab_counter #(6) tens_AL ( .dec(1'b0), 
									.inc( L2 ), 
									.clk(clk), 
									.rst(SW0), 
									.cnt(A3));

assign L3 = ( !(KEY3) && new_clk ); // depends on key

lab_counter #(24) hour_AL (.dec( 1'b0 ), 
									.inc( L3 ), 
									.clk(clk), 
									.rst(SW0), 
									.cnt(AA));

assign A4 = AA % 10; //Calculations
assign A5 = ( (AA - A4) / 10 );

assign B2 = !(KEY0) ? '0 : A2;
assign B3 = !(KEY0) ? '0 : A3;
assign B4 = !(KEY0) ? '0 : A4;
assign B5 = !(KEY0) ? '0 : A5;

// End of Alarm Stuff

// Switch between Alarm and Normal:

always_comb begin
	unique case (SW2 && !SW1)
		1'b1 : H2 = B2;
		default : H2 = S2;
	endcase
end

always_comb begin
	unique case (SW2 && !SW1)
		1'b1 : H3 = B3;
		default : H3 = S3;
	endcase
end
		
always_comb begin
	unique case (SW2 && !SW1)
		1'b1 : H4 = B4;
		default : H4 = S4;
	endcase
end
		
always_comb begin
	unique case (SW2 && !SW1)
		1'b1 : H5 = B5;
		default : H5 = S5;
	endcase
end
		
// End of switch
		
// HEX Displays:

lab1_b hex_ones(H2, HEX0);
lab1_b hex_tens(H3, HEX1);
lab1_b hex_hunds(H4, HEX2);
lab1_b hex_thsns(H5, HEX3);

// End of HEX Displays

assign AL_old = ( ( B2 == S2 ) && ( B3 == S3 ) && ( B4 == S4 ) && ( B5 == S5 ) );

assign LED9 = ( (S1 < 25000000) || (S1 > 50000000 && S1 < 75000000) ); // clocks every tick-tock

dflip #(1) ff1 ( .d(AL_old), .clk(clk), .rst(SW0), .en(!(KEY0) || (AL_old)), .q(AL));

assign LED7 = AL ? LED9 : '0;	
							  
endmodule
