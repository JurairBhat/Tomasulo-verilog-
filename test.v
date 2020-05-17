module y;
    wire [7:0]y1;
    reg  [7:0]a1;
    reg  [7:0]a2;
    mul c(a1,a2,y1);
initial
begin
  #10 a1 = 8'h02; a2 = 8'h02;
 $display("y = %h",y1);
end
endmodule

module mul(input [7:0]x1, input [7:0]x2, output [7:0]y);
assign y = x1*x2;
endmodule
