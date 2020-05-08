// This the driver module
// We assume we have 16 bit ISA.
// Every entry in data memory is 1 byte ; Hence we perform  1 byte operation;
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
reg [15:0]instruction_memory [0:15];//


//Initializing register File
//register_file[0]=R0 and so on--------
reg [7:0]register_file[0:15]// we have 16 register each 1 byte in size;


// This is instruction Queue
reg [15:0]isntruction_queue[0:3];
reg iq_f;
reg [1:0]instruction_queue_ptr;// this points to the next entry in instruction_queue

// ROB
  // opcode des v_des commit
  // ROB size is = 8
reg [3:0]rob_opcode_feild[0:7];//ROB isntruction feild
reg [3:0]rob_dest_reg_feild[0:7]// ROB destination register feild
reg [7:0]rob_dest_reg_value[0:3]//destination register value
reg v_des[0:7];// 0 = unvalid ,1 = valid ; Ready to retire once it = 1
reg commit[0:7];// indicates whether the particular entry has committed or not

reg [2:0]head;// ROB head
reg [2:0]tail;// ROB tail// this points to first empty location
reg rob_space; // this is 0 when ROB is full and 1 when it has entry;

// Reservation station for add and sub = res1
       // Size of res = 4 instruction;
reg [3:0]res1_opcode[0:3];

reg [3:0]res1_sr1[0:3]; // sr1 regiter
reg [7:0]res1_sr1_value[0:3];// sr1 value
reg res1_v1[0:3];// sr1 valid or not

reg [3:0]res1_sr2[0:3]; // sr2 regiter
reg [7:0]res1_sr2_value[0:3];// sr2 value
reg res1_v2[0:3];// sr2 valid or not

reg  [3:0]res1_dest[0:3]; // dest regiter corresponding to ROB;
reg [7:0]res1_dest_value[0:3];// dest value
reg res1_v3[0:3]// dest value valid or not

//Reservation station for mul
    // Size of res_mul = 2 instruction;
reg [3:0]res2_opcode[0:1];

reg [3:0]res2_sr1[0:1]; // sr1 regiter
reg [7:0]res2_sr1_value[0:1];// sr1 value
reg res2_v1[0:1];// sr1 valid or not

reg [3:0]res2_sr2[0:1]; // sr2 regiter
reg [7:0]res2_sr2_value[0:1];// sr2 value
reg res2_v2[0:3];// sr2 valid or not

reg  [3:0]res2_dest[0:1]; // dest regiter corresponding to ROB;
reg [7:0]res2_dest_value[0:1];// dest value
reg res2_v3[0:1]// dest value valid or not

//Reservation Station for divide
    // Size of divide = 2 instruction;
reg [3:0]res3_opcode[0:1];

reg [3:0]res3_sr1[0:1]; // sr1 regiter
reg [7:0]res3_sr1_value[0:1];// sr1 value
reg res3_v1[0:1];// sr1 valid or not

reg [3:0]res3_sr2[0:1]; // sr2 regiter
reg [7:0]res3_sr2_value[0:1];// sr2 value
reg res3_v2[0:1];// sr2 valid or not

reg  [3:0]res3_dest[0:1]; // dest regiter corresponding to ROB;
reg [7:0]res3_dest_value[0:1];// dest value
reg res3_v3[0:1]// dest value valid or not

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
