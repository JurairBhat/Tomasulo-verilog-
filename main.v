module main(
  input [3:0] pc
  );
reg [3:0]b;
issue i([3:0]pc , );
execute e();
write_back wb();
commit c();
endmodule

// module add(input [3:0]a);
// endmodule
