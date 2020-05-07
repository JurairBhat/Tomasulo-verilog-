//
//
//
//
//
// module topLevel(output [1:0] Output);
//   reg[1:0] PC;
//
//   sum s1();
//
//   assign Output = PC;
//
//   initial
//   $monitor($time,"PC - %b", PC);
// endmodule
//
// module sum();
//   initial begin
//   topLevel.PC = 2'b11 ;
//   topLevel.PC = #10 2'b10 ;
// end
// endmodule
//
// Output -
