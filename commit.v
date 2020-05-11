module topLevel(output [2:0] Output);
  reg[2'b10:2'b00] PC;

  sum s1();

  assign Output = PC;

  initial
  $monitor($time,"PC - %b", PC);
endmodule

module sum();
  initial begin

  topLevel.PC = 3'b111 ;
  topLevel.PC = #10 3'b101 ;
end
endmodule
