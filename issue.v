/* This module gets the instruction from the memory
puts the data in instruction queue */

module fetch(

  );
//reg [3:0]previous_pc,current_pc;// this will account for stall  condition

always@(posedge clk)
begin
  if(run.main.iq_f)
    begin// it only write in intruction queue if iq_f = 1;
       run.main.instruction_queue[run.main.instruction_queue_tail] = run.main.instruction_memory[pc];
       run.main.instruction_queue_tail =  (run.main.instruction_queue_tail + 2'b01);
       if(run.main.instruction_queue_tail == run.main.instruction_queue_head))//4 = length of instruction_queue
              run.main.iq_f = 0; // instruction_queue_is_full --> dont allow write for further instructions
       run.main.pc = run.main.pc + 4'b0001;// next instruction to be fetched;
    end
 else
  $display("Instruction Queue is full ,PC = %b instruction waiting",pc);
end
endmodule

/*this module decodes the signal, add the entry to the ROB,
/and the sends the istruction to appropriate  reservation station */
module decode(
  // assuming 2 functional units for every operation
  );
integer no_of_free_enteries_res1;
integer no_of_free_enteries_res2;
always @(posedge clk) begin
      if((run.main.instruction_queue_tail != run.main.instruction_queue_head) and  run.main.rob_space)//ensures instruction queue is not empty
         begin
              case(run.main.instruction_queue[run.main.instruction_queue_head])
                      4'b0000,4'b0001 :
                      begin
                            // check which entry is free and put it in that entry
                          if(run.main.res1_free_entry)
                                     begin
                                       run.main.rob_opcode_feild[run.main.tail] = run.main.instruction_queue[run.main.instruction_queue_head][15:12];// last 4 bits are opcode
                                       run.main.dest_reg_feild[run.main.tail] = run.main.instruction_queue[run.main.instruction_queue_head][11:8];// destination register
                                       run.main.v_des[run.main.tail] = 0;// making valid bit 0;
                                           integer i = 0;
                                           integer k ;
                                           i

                                           while(i < 4)
                                                 begin
                                                   if(run.main.res1_free_entry[i] == 1'b1)begin
                                                   k = i ;
                                                   run.main.res1_free_entry[k] = 0;
                                                   run.main.no_of_free_enteries_res1 = run.main.no_of_free_enteries_res1 - 1;
                                                   i = 4 ;end
                                                   else
                                                    i = i+1;
                                                  end

                                           run.main.res1_opcode[k] == run.main.instruction_queue[run.main.instruction_queue_head][15:12]

                                           run.main.reg_file[run.main.instruction_queue[run.main.instruction_queue_head][11:8]] = run.main.rob_dest_reg_value[run.main.tail];
                                           run.main.reg_valid[run.main.instruction_queue[run.main.instruction_queue_head][11:8]] = 0;
                                           // filling sr1
                                           run.main.res1_sr1_value[k] = run.main.reg_file[run.main.instruction_queue_head][7:4]];
                                           if(run.main.reg_valid[run.main.instruction_queue_head][7:4])// if valid
                                                 run.main.res1_v1[k] = 1; // valid value

                                           else
                                                run.main.res1_v1[k] = 0; // Not Valid

                                          run.main.res1_sr2_value[k] = run.main.reg_file[run.main.instruction_queue_head][3:0]];
                                          if(run.main.reg_valid[run.main.instruction_queue_head][3:0])// if valid
                                              run.main.res1_v2[k] = 1; // valid value
                                          else
                                              run.main.res1_v2[k] = 0; // Not Valid
                                        // incrementing the tail in ROB
                                          run.main.tail = run.main.tail + 2'b01;
                                          if(run.main.head == run.main.tail)//4 = length of instruction_queue
                                                 rob_space = 0;

                                      end
                                else
                                  $display("Reservation Station 1 is Full");
                            end
                         4'b0010 , 4'b0011 :
                             begin
                               if(run.main.no_of_free_enteries_res2)
                                          begin
                                            run.main.rob_opcode_feild[run.main.tail] = run.main.instruction_queue[run.main.instruction_queue_head][15:12];// last 4 bits are opcode
                                            run.main.dest_reg_feild[run.main.tail] = run.main.instruction_queue[run.main.instruction_queue_head][11:8];// destination register
                                            run.main.v_des[run.main.tail] = 0;// making valid bit 0;
                                                integer i = 0;
                                                integer k ;
                                                while(i < 4)
                                                      begin
                                                        if(run.main.res2_free_entry[i] == 1'b1)begin
                                                        k = i ;
                                                        run.main.res1_free_entry[k] = 0;
                                                        run.main.no_of_free_enteries_res2 = run.main.no_of_free_enteries_res2 - 1;
                                                        i = 4 ;end
                                                        else
                                                         i = i+1;
                                                       end
                                                run.main.res2_opcode[k] == run.main.instruction_queue[run.main.instruction_queue_head][15:12]

                                                run.main.reg_file[run.main.instruction_queue[run.main.instruction_queue_head][11:8]] = run.main.rob_dest_reg_value[run.main.tail];
                                                run.main.reg_valid[run.main.instruction_queue[run.main.instruction_queue_head][11:8]] = 0;
                                                // filling sr1
                                                run.main.res2_sr1_value[k] = run.main.reg_file[run.main.instruction_queue_head][7:4]];
                                                if(run.main.reg_valid[run.main.instruction_queue_head][7:4])// if valid
                                                      run.main.res2_v1[k] = 1; // valid value

                                                else
                                                     run.main.res2_v1[k] = 0; // Not Valid

                                               run.main.res2_sr2_value[k] = run.main.reg_file[run.main.instruction_queue_head][3:0]];
                                               if(run.main.reg_valid[run.main.instruction_queue_head][3:0])// if valid
                                                     run.main.res2_v2[k] = 1; // valid value
                                               else
                                                     run.main.res2_v2[k] = 0; // Not Valid
                                              run.main.tail = run.main.tail + 3'b001;
                                              if(run.main.head == run.main.tail)// ROB is full stop further fetching of instructions
                                                     rob_space = 0;
                                          end
                              else
                                  $display("Reservation Station 2 is Full");
                          end




                                          // Filling the entry in R
                     //run.main.rob_dest_reg_value = 8'bx;
                    // putting the values in reservation station;

               else
            $display("ROB is Full or Instruction _ queue is empty")

// putting the values in reservation station;
end
endmodule
// this implements tomasulos renaming policy

/* this module puts the fetched instruction into reservation station
if reservation station has vacancy */
module issue( input [7:0] mem_address ,
              output reg [31:0]instruction[10:0],
  )

  )
