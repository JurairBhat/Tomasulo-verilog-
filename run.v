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
reg [7:0]reg_file[0:15]// we have 16 register each 1 byte in size;
reg reg_valid[0:15];
reg [2:0]reg_rename[0:15];  // renaming corresponding to ROB


//Instruction Queue
reg [15:0]isntruction_queue[0:3];
reg iq_f;// if instruction_queue_full = 1 else 0;
reg [1:0]instruction_queue_tail;// this points to the next empty location in instruction_queue
reg [1:0]instruction_queue_head;// this points to first address which is ready for decoding;



// ROB
  //(opcode des v_des commit)
  // ROB size is = 8
reg [3:0]rob_opcode_feild[0:7];//ROB isntruction feild
reg [3:0]rob_dest_reg_feild[0:7]// ROB destination register feild
reg [7:0]rob_dest_reg_value[0:7]//destination register value
reg v_des[0:7];// 0 = unvalid ,1 = valid ; Ready to retire once it = 1
reg commit[0:7];// indicates whether the particular entry has committed or not.
reg [2:0]head;// ROB head
reg [2:0]tail;// ROB tail// this points to first empty location
reg rob_full; // this is 1 when ROB is full and 0 when it has space;



// Reservation station for add and sub = res1
       // Size of res = 4 instruction;
reg res1_free_entry[0:3];// gives us the list of free enteries; 1 = free ,0 = busy
reg res1_full //1 = full , 0 = not full
reg [3:0]res1_opcode[0:3];
reg [7:0]res1_sr1_value[0:3];// sr1 value
reg res1_v1[0:3];// sr1 valid or not
reg [7:0]res1_sr2_value[0:3];// sr2 value
reg res1_v2[0:3];// sr2 valid or not
reg [7:0]res1_dest_value[0:3];// dest value
reg res1_v3[0:3]// dest value valid or not



//Reservation station for mul and divide
    // Size of res2 = 4 instruction;

reg [3:0]res2_opcode[0:3];
reg res2_free_entry[0:3];// gives us the list of free enteries; 1 = free ,0 = busy
reg res2_full //1 = full , 0 = not full
reg [7:0]res2_sr1_value[0:3];// sr1 value
reg res2_v1[0:3];// sr1 valid or not
reg [3:0]res2_sr2[0:3]; // sr2 regiter
reg [7:0]res2_sr2_value[0:3];// sr2 value
reg res2_v2[0:3];// sr2 valid or not
reg  [3:0]res2_dest[0:3]; // dest regiter corresponding to ROB;
reg [7:0]res2_dest_value[0:3];// dest value
reg res2_v3[0:1]// dest value valid or not


// LSQ
//
reg clk;
reg [3:0]pc ;
//
main m(pc , );

integer i ;
integer j ;
initial begin
  clk = 1'b0;

  pc = 4'b0000;

  //Initializing instruction_queue
  iq_f = 1'b0;
  instruction_queue_head = 0;
  instruction_queue_tail = 0;

 // Initializing ROB
  head = 3'b000;
  tail = 3'b000;
  rob_full = 1'b0;
  i = 0;
  while(i<8) begin
     commit[i] = 1'b0 ; // this while loops just initializes commit array to 0;
     v_des[i] = 1'b0;
     i = i + 1;
  end

  // Initializing reservation station
  j = 0 ;
  while(j<4)begin
    res1_free_entry[j] = 1'b0;
    res2_free_entry[j] = 1'b0;
    res1_v1[j] = 1'b0;
    res2_v1[j] = 1'b0;
    res1_v2[j] = 1'b0;
    res2_v2[j] = 1'b0;
    res1_v3[j] = 1'b0;
    res2_v3[j] = 1'b0;
  end
  res1_full = 0;
  res2_full = 0;


  readmemh("instruction_memory",instruction_memory);
end
always #5 clk = ~clk ;

initial #160 $finish ;

endmodule
