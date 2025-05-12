module lab_counter
  #(
    parameter int m=13,  // Maximum
    parameter int b=$clog2(m)  // Bitwidth
    )
   (
    input  logic         inc,
    input  logic         dec,

    input  logic         clk,
    input  logic         rst,

    output logic [b-1:0] cnt
    );

logic [b-1:0] next;
logic C1;
logic C2;
logic I1;
logic I2;
logic D1;
logic D2;

dflip #(b) ff1 ( .d(next), .clk(clk), .rst(rst), .en(1'b1), .q(cnt));

assign C1 = (inc && !dec);
assign C2 = (dec && !inc);

assign I1 = (C1 && cnt != (m-1));
assign I2 = (C1 && cnt == (m-1));

assign D1 = (C2 && cnt != 'd0);
assign D2 = (C2 && cnt == 'd0);

always_comb begin
        unique case (1'b1)
                I1 : next = cnt + 1'd1;
                D1 : next = cnt - 1'd1;
                I2 : next = 'd0;
                D2 : next = (m-1);
                default     : next = cnt;
        endcase
end


endmodule