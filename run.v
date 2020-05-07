// This the driver module
// We assume we have 12 bit ISA
// operation : Load 0101, store 0100 , divide 0011 , mul 0010 , add 0001 , sub 0000
// we have eight registers r1 ------ r16 (0000 ------  10000);
// we will 4 bits instead of 3 bits to address them for future addition of registes
// Arithematic operation
//[opcode(4 bit) , rd(4 bit) ,  rs1 (4 bit) , rs2 (4 bit)]
// Load and stores
//[opcode(4 bit) , rs(4 bit) , rb(4 bit) , immediate(4 bit)]                        ]
// ROB capacity = 16 instruction , so 4 bits needed to address each entry
// Reagister Renamming table : 16 enteries
// instruction memory = 16 instructions;
// instruction queue = 4 instruction;
// data memory = 0000 ------- 1111
// latencies :
          //Add and subtract 2 cycles
          //Multiply 6 cycles
          //Divide 8 cycles
          //load and store 4 cycles

module run ;

//Initializing memory
reg [11:0]instruction_memory [0:15];//

// This is instruction Queue
reg [11:0]isntruction_queue[0:3];
reg iq_f;
reg [1:0]instruction_queue_ptr;// this points to the next entry in instruction_queue

// ROB
// ROB size is = 8
reg [3:0]rob_opcode_feild[0:7];//ROB isntruction feild
reg [3:0]destination_reg_feild[0:7]// ROB destination register feild
reg valid_value[0:7];// 0 = unvalid ,1 = valid ; Ready to retire once it = 1
reg commit[0:7];// indicates whether the particular entry has committed or not
reg [2:0]head;// ROB head
reg [2:0]tail;// ROB tail
// Reservation station
res_add_sub
res_mul_div
//
// LSQ
reg clk;
reg [3:0]pc ;

//
main m(pc , );

integer i ;
initial begin
  clk = 1'b0;

  pc = 4'b0000;
  iq_f = 1'b1;

  head = 3'b000;
  tail = 3'b000;

  i = 0;
  while(i<8) begin
    commit[i] = 0 ; // this while loops just initializes commit array to 0;
  end

  readmemh("instruction_memory",instruction_memory);
end
always #5 clk = ~clk ;

initial #160 $finish ;

endmodule
