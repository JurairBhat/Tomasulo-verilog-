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
          //Add and subtract 3 cycles
          //Multiply 5 cycles
          //Divide 5 cycles
          //load and store 4 cycles
// Let us assume we have 3 functional units 2 for add and subract; and 1 for divide and Multiply
module run;

//Initializing memory
reg [15:0]instruction_memory[0:15];//


//Initializing register File
//register_file[0]=R0 and so on--------
reg [7:0]reg_file[0:15];// we have 16 register each 1 byte in size;
reg reg_valid[0:15];
reg [2:0]reg_rename[0:15];  // renaming corresponding to ROB // this is poiner to ROB



//Instruction Queue
reg [15:0]instruction_queue[0:3];
reg iq_f;// if instruction_queue_full = 1 else 0;
integer instruction_queue_no_of_enteries ;
reg [1:0]instruction_queue_tail;// this points to the next empty location in instruction_queue
reg [1:0]instruction_queue_head;// this points to first address which is ready for decoding;



// ROB
  //(opcode des_name value v_des commit)
  // ROB size is = 8
reg [3:0]rob_opcode_feild[0:7];//ROB isntruction feild
reg [3:0]rob_dest_reg_feild[0:7];// ROB destination register feild
reg [7:0]rob_dest_reg_value[0:7];//destination register value
reg v_des[0:7];// 0 = unvalid ,1 = valid ; Ready to retire once it = 1
reg commit[0:7];// indicates whether the particular entry has committed or not.
reg [2:0]head;// ROB head
reg [2:0]tail;// ROB tail// this points to first empty location
reg rob_full; // this is 1 when ROB is full and 0 when it has space;
reg [15:0]rob_instruction_feild[0:7];
integer rob_no_of_enteries;


// Reservation station for add and sub = res1
       // Size of res = 4 instruction;
integer res1_no_of_enteries;
reg [15:0] res1_instructions[0:3];
reg res1_free_entry[0:3];// gives us the list of free enteries; 1 = free ,0 = busy
reg [3:0]res1_opcode[0:3];

reg res1_sr1_refrence[0:3]; // This indicates whether value to be taken  from register file or refrence;1 = register file . 0 = refrence
reg [7:0]res1_sr1[0:3];//This stores refrence either value
reg [2:0]res1_sr1_ref_value[0:3];//This stores pointer to R
reg res1_sr2_refrence[0:3]; // This indicates whether value to be taken  from register file or refrence;1 = register file . 0 = refrence
reg [7:0]res1_sr2[0:3];//This stores refrence either to ROB or values;
reg [2:0]res1_sr2_ref_value[0:3];

reg [2:0]res1_dest[0:3];// This stores refrence to ROB
reg res1_ready[0:3];// this indicates whic enrty is ready to  executed
reg res1_issued[0:3];// this indicates whether the entry is issued to execution stage or not;
//Reservation station for mul and divide
    // Size of res2 = 4 instruction;

integer res2_no_of_enteries;
reg [15:0]res2_instructions[0:3];
reg res2_free_entry[0:3];// gives us the list of free enteries; 1 = free ,0 = busy
reg [3:0]res2_opcode[0:3];

reg res2_sr1_refrence[0:3]; // This indicates whether value to be taken  from register file or refrence;1 = register file . 0 = refrence to ROB
reg [7:0]res2_sr1[0:3];//This stores refrence either to ROB or value;
reg [2:0]res2_sr1_ref_value[0:3];

reg res2_sr2_refrence[0:3]; // This indicates whether value to be taken  from register file or refrence;1 = refrence register file . 0 = refrence ROB
reg [7:0]res2_sr2[0:3];//This stores refrence either to ROB or value;
reg [2:0]res2_sr2_ref_value[0:3];// this stores ROB pointer

reg [2:0]res2_dest[0:3];// This stores refrence to ROB
reg res2_ready[0:3];// this indicates which entry is ready to  executed
reg res2_issued[0:3];// this indicates whether the entry is issued to execution stage or not;
// LSQ
//
//Excecution
reg res1_execution_unit[0:1]; // this indicates whether res1 exe. units are busy or free. 1 = busy , 0 = free
reg res2_execution_unit; // this indicates whether res2 exe. units are busy or free.
reg[7:0] res1_v0; reg res1_v0_received;integer i0;reg res1_v0_written;// this stores which entry of reservation station rs1 was being used.
reg[7:0] res1_v1; reg res1_v1_received;integer i1;reg res1_v1_written;// this stores which entry of reservation station rs1 was being used.
reg[7:0] res2_v;  reg res2_v_received;integer i2;reg res2_v_written;// this stores which entry of reservation station rs2 was being used.

reg [15:0]res1_i0;// store instruction of f1 ;
reg [15:0]res1_i1;// store instruction f2;
reg [15:0]res2_i;// store instruction f3;
//
reg clk;
reg [3:0]pc ;
//
issue i();
integer m ;
integer n ;
integer p;
initial begin
  clk = 1'b0;
  pc = 4'b0000;

  //Initializing instruction_queue
  iq_f = 1'b0;
  instruction_queue_head = 2'b00;
  instruction_queue_tail = 2'b00;
  instruction_queue_no_of_enteries = 0;

 // Initializing ROB
  head = 3'b000;
  tail = 3'b000;
  rob_no_of_enteries = 0;
  m = 0;
  while(m < 8) begin
    commit[m] = 1'b0 ; // this while loops just initializes commit array to 0;
    v_des[m] = 1'b0;
    reg_valid[2*m+1] = 1'b1;
    reg_file[2*m+1] = 8'h02;
    reg_file[2*m] = 8'h02;
    reg_valid[2*m] = 1'b1;
     m = m + 1;
  end
  // Initializing reservation station
  res1_no_of_enteries = 0;
  res2_no_of_enteries = 0;
  n = 0 ;
  while(n < 4)begin
    res1_free_entry[n] = 1'b1;
    res2_free_entry[n] = 1'b1;
    res1_sr1_refrence[n] = 1'b0;
    res1_sr2_refrence[n] = 1'b0;
    res2_sr1_refrence[n] = 1'b0;
    res2_sr2_refrence[n] = 1'b0;
    res1_ready[n] = 1'b0;
    res2_ready[n] = 1'b0;
    res1_issued[n] = 1'b0;
    res2_issued[n] = 1'b0;
    n = n + 1;
  end
  // execution_unit
   res1_execution_unit[0] = 1'b0;//free
   res1_execution_unit[1] = 1'b0;// free
   res2_execution_unit = 1'b0;
   res1_v0_received = 1'b0;
   res1_v1_received = 1'b0;
   res2_v_received = 1'b0;

   res1_v0_written = 1'b0;
   res1_v1_written = 1'b0;
   res2_v_written = 1'b0;
  $readmemh("instruction_memory.dat",instruction_memory);
end
always begin
   #10 clk =~clk ;
end

initial #400 $finish ;
endmodule
