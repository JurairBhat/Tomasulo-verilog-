# tomasulo-verilog-

This the driver module.
We assume we have 12 bit ISA.
Operation : Load 0101, store 0100 , divide 0011 , mul 0010 , add 0001 , sub 0000.
we have eight registers r1 ------ r16 (0000 ------  10000);
we will 4 bits instead of 3 bits to address them for future addition of registes.
 Arithematic operation
[opcode(4 bit) , rd(4 bit) ,  rs1 (4 bit) , rs2 (4 bit)]
Load and stores
[opcode(4 bit) , rs(4 bit) , rb(4 bit) , immediate(4 bit)]                        ]
ROB capacity = 16 instruction , so 4 bits needed to address each entry.
Reagister Renamming table : 16 enteries
instruction memory = 16 instructions;
instruction queue = 4 instruction;
data memory = 0000 ------- 1111.
latencies :
          Add and subtract 2 cycles.
          Multiply 6 cycles.
          Divide 8 cycles.
          load and store 4 cycles.
