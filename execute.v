module sum;
  reg pc;
  reg clk;
  top l();
  integer j ;
  integer i ;
  initial begin
    clk = 0;

    #20 $finish;
  end
  always
   #5 clk = ~clk;
endmodule
