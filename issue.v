/* This module gets the instruction from the memory
puts the data in instruction queue */
module fetch(
            input [3:0] pc

  );
  reg
always@(posedge clk)
begin
  if(run.main.iq_f)
    begin// it only write in intruction queue if iq_f = 1;
       run.main.instruction_queue[run.main.instruction_queue_ptr] = run.main.instruction_memory[pc];
       run.main.instruction_queue_ptr =  run.main.instruction_queue_ptr + 1'b1;
       if(run.main.instruction_queue_ptr == 4)//4 = length of instruction_queue
              run.main.iq_r = 0; // instruction_queue_is_full --> dont allow write for further instructionss
    end
 else
  $display("Instruction Queue is full ,PC = %b instruction waiting",pc);
end
endmodule

/*this module decodes the signal  and add the entry to the ROB;
/and the sends the istruction to appropriate  reservation station */
module decode(
  input [31:0] instruction,
  
  output control_signal// assuming 2 functional units for every operation
  );
endmodule
// this implements tomasulos renaming policy
module rename(
  input [31:0] instruction,
// This will rename the regiters are per ROB
// Assume ROB has 32  rows
// Assume register file
  );
endmodule
/* this module puts the fetched instruction into reservation station
if reservation station has vacancy */
module issue( input [7:0] mem_address ,
              output reg [31:0]instruction[10:0],
  )

  )
