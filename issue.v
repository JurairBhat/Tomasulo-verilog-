module issue();
   fetch f();
   decode d();
   execute e();
   write_back wb();
   commit c();
endmodule

/* This module gets the instruction from the memory
puts the data in instruction queue */
module fetch();
//reg [3:0]previous_pc,current_pc;// this will account for stall  condition
always@(posedge run.clk)
begin
  #8
  $display("--- FETCH STAGE ---  ",);
  if(!run.iq_f)
    begin// it only write in intruc      vguhgution queue if iq_f = 0;
       run.instruction_queue[run.instruction_queue_tail] = run.instruction_memory[run.pc];
       $display("Fetched : %h ",run.instruction_queue[run.instruction_queue_tail]);
       run.instruction_queue_no_of_enteries = run.instruction_queue_no_of_enteries + 1;
       run.instruction_queue_tail =  run.instruction_queue_tail + 2'b01;
       if(run.instruction_queue_no_of_enteries == 4)//4 = length of instruction_queue
              run.iq_f = 1'b1; // instruction_queue_is_full --> dont allow write for further instructions
       run.pc = run.pc + 4'b0001;// next instruction to be fetched;
    end
 else
  $display(" Stall , IQ : Full , Next PC = %b  :  ",run.pc);
end
endmodule

/*this module decodes the signal, add the entry to the ROB,
/and the sends the istruction to appropriate  reservation station */
module decode();

integer i ;
integer k ;
integer j ;
always @(posedge run.clk)
  begin
    #7
     $display( "--- DECODE STAGE --- ");
     $display("ROB HEAD : %h",run.head);
     $display("ROB TAIL : %h",run.tail);
      if((run.instruction_queue_no_of_enteries != 0) && (run.rob_no_of_enteries < 8))//ensures instruction queue is not empty and rob is not full
         begin
              case(run.instruction_queue[run.instruction_queue_head][15:12])
                      4'b0000,4'b0001 :
                      begin
                          // check which entry is free and put it in that entry

                          if(run.res1_no_of_enteries < 4)
                                    begin
                                       // updating ROB
                                       run.rob_instruction_feild[run.tail] = run.instruction_queue[run.instruction_queue_head];
                                       run.rob_opcode_feild[run.tail] = run.instruction_queue[run.instruction_queue_head][15:12];// last 4 bits are opcode
                                       run.rob_dest_reg_feild[run.tail] = run.instruction_queue[run.instruction_queue_head][11:8];// destination register
                                       run.v_des[run.tail] = 1'b0;// making valid bit 0;
                                       run.rob_no_of_enteries = run.rob_no_of_enteries + 1;
                                       run.commit[run.tail] = 1'b0;

                                       // searching for free entry in reservation station
                                       i = 0 ;
                                           while(i < 4)
                                                 begin
                                                   if(run.res1_free_entry[i] == 1'b1)begin
                                                   k = i ;
                                                   run.res1_free_entry[k] = 1'b0;
                                                   run.res1_no_of_enteries = run.res1_no_of_enteries + 1;
                                                   i = 4 ;end
                                                   else
                                                    i = i+1;
                                            end
                                           //updating reservation station
                                           run.res1_instructions[k] = run.instruction_queue[run.instruction_queue_head];
                                           run.res1_opcode[k] = run.instruction_queue[run.instruction_queue_head][15:12];// opcode
                                           run.res1_ready[k] = 1'b0;// make it initially as not ready
                                           // sr1
                                           if(!run.reg_valid[run.instruction_queue[run.instruction_queue_head][7:4]])
                                              begin
                                                  run.res1_sr1_refrence[k] = 1'b0;// take value from ROB
                                                  run.res1_sr1[k] = run.reg_rename[run.instruction_queue[run.instruction_queue_head][7:4]];// check refrence in rename register
                                              end
                                          else
                                               begin
                                                 run.res1_sr1_refrence[k] = 1'b1; // value in actual register
                                                 run.res1_sr1[k] = run.reg_file[run.instruction_queue[run.instruction_queue_head][7:4]];//  register
                                               end

                                            //sr2
                                            if(!run.reg_valid[run.instruction_queue[run.instruction_queue_head][3:0]])
                                                 begin
                                                     run.res1_sr2_refrence[k] = 1'b0; // take value from ROB // refrence to ROB
                                                     run.res1_sr2[k] = run.reg_rename[run.instruction_queue[run.instruction_queue_head][3:0]];// check refrence in rename register
                                                 end
                                            else
                                                  begin
                                                      run.res1_sr2_refrence[k] = 1'b1; //
                                                      run.res1_sr2[k] = run.reg_file[run.instruction_queue[run.instruction_queue_head][3:0]];//  register
                                                  end
                                        // register renaming for destination register and updating value
                                          run.res1_dest[k] = run.tail;// storing refrence in ROB
                                          run.reg_rename[run.instruction_queue[run.instruction_queue_head][11:8]] = run.tail;// pointer to ROB
                                        // making valid bit 0; It also symbolises that the register is renamed and the value has to be fetched from R
                                          run.reg_valid[run.instruction_queue[run.instruction_queue_head][11:8]] = 1'b0; // / making valid bit 0; It also symbolises that the register is renamed and the value has to be fetched from taken corresponding to ROB
                                          run.tail = run.tail + 2'b01;

                                         if((run.res1_sr1_refrence[k] == 1'b1 && run.res1_sr2_refrence[k] == 1'b1) && (run.res1_free_entry[k] == 1'b0)) // if both operands are available make it ready
                                             begin
                                               run.res1_ready[k] = 1'b1;
                                               //$display("This entry is ready");
                                             end
                                          else
                                             run.res1_ready[k] = 1'b0;

                                         run.res1_issued[k] = 1'b0;// since this enrty is not issued yet
                                         $display(" Decoded : %h , Location : RS1",run.instruction_queue[run.instruction_queue_head]);
                                        // incrementing head pointer in instruction_queue and dercrementing no. of enteries in instruction_queue
                                         run.instruction_queue_head = run.instruction_queue_head + 2'b01;
                                         run.instruction_queue_no_of_enteries = run.instruction_queue_no_of_enteries - 1;

                              end
                          else
                                $display("Stall , RS1 : Full");
                        end
                       4'b0010,4'b0011 :
                       begin
                           // check which entry is free and put it in that entry
                           if(run.res1_no_of_enteries < 4)
                                     begin
                                        // updating ROB
                                        run.rob_instruction_feild[run.tail] = run.instruction_queue[run.instruction_queue_head];
                                        run.rob_opcode_feild[run.tail] = run.instruction_queue[run.instruction_queue_head][15:12];// last 4 bits are opcode
                                        run.rob_dest_reg_feild[run.tail] = run.instruction_queue[run.instruction_queue_head][11:8];// destination register
                                        run.v_des[run.tail] = 1'b0;// making valid bit 0;
                                        run.rob_no_of_enteries = run.rob_no_of_enteries + 1;
                                        run.commit[run.tail] = 1'b0;
                                        // searching for free entry in reservation station

                                        i = 0 ;
                                            while(i < 4)
                                                  begin
                                                    if(run.res2_free_entry[i] == 1'b1)begin
                                                    k = i ;
                                                    run.res2_free_entry[k] = 1'b0;
                                                    run.res2_no_of_enteries = run.res2_no_of_enteries + 1;
                                                    i = 4 ;end
                                                    else
                                                     i = i+1;
                                             end
                                            //updating reservation station
                                            run.res2_instructions[k] = run.instruction_queue[run.instruction_queue_head];
                                            run.res2_opcode[k] = run.instruction_queue[run.instruction_queue_head][15:12];// opcode
                                            run.res2_ready[k] = 1'b0;// make it initially as not ready

                                            // sr1
                                            if(!run.reg_valid[run.instruction_queue[run.instruction_queue_head][7:4]])
                                               begin
                                                   run.res2_sr1_refrence[k] = 1'b0;// take value from ROB

                                                   run.res2_sr1[k] = run.reg_rename[run.instruction_queue[run.instruction_queue_head][7:4]];// check refrence in rename register
                                               end
                                           else
                                                begin
                                                  run.res2_sr1_refrence[k] = 1'b1; // value in actual register
                                                  //$display("sr1 fine");
                                                  run.res2_sr1[k] = run.reg_file[run.instruction_queue[run.instruction_queue_head][7:4]];//  register
                                                end

                                             //sr2
                                             if(!run.reg_valid[run.instruction_queue[run.instruction_queue_head][3:0]])
                                                  begin
                                                      run.res2_sr2_refrence[k] = 1'b0; // take value from ROB // refrence to ROB
                                                      run.res2_sr2[k] = run.reg_rename[run.instruction_queue[run.instruction_queue_head][3:0]];// check refrence in rename register
                                                  end
                                             else
                                                   begin
                                                       run.res2_sr2_refrence[k] = 1'b1; // value in actual register // refrence to regiseterfile;
                                                       //$display("sr2 fine");
                                                       run.res2_sr2[k] = run.reg_file[run.instruction_queue[run.instruction_queue_head][3:0]];//  register
                                                   end
                                            // register renaming and updating values
                                            run.res2_dest[k] = run.tail;
                                            run.reg_rename[run.instruction_queue[run.instruction_queue_head][11:8]] = run.tail;// pointer to ROB
                                            // making valid bit 0; It also symbolises that the register is renamed and the value has to be fetched from R
                                            run.reg_valid[run.instruction_queue[run.instruction_queue_head][11:8]] = 1'b0; // / making valid bit 0; It also symbolises that the register is renamed and the value has to be fetched from taken corresponding to ROB
                                            run.tail = run.tail + 2'b01;
                                             if((run.res2_sr1_refrence[k] == 1'b1 && run.res2_sr2_refrence[k] == 1'b1)&& (run.res2_free_entry[k] == 1'b0)) // if both operands are available make it ready
                                                  begin
                                                    run.res2_ready[k] = 1'b1;
                                                    //$display("This entry is ready");
                                                  end
                                             else
                                                  run.res2_ready[k] = 1'b0;

                                           run.res2_issued[k] = 1'b0; // since this entry is not issued yet;
                                           $display(" Decoded : %h , Location : RS2",run.instruction_queue[run.instruction_queue_head]);
                                         // incrementing head pointer in instruction_queue and dercrementing no. of enteries in instruction_queue
                                          run.instruction_queue_head = run.instruction_queue_head + 2'b01;
                                          run.instruction_queue_no_of_enteries = run.instruction_queue_no_of_enteries - 1;

                               end
                           else
                                 $display("Stall , RS2 : Full");
                         end
                          default: $display("Unvalid Opcode %h",run.instruction_queue[run.instruction_queue_head][15:12]);
                      endcase
                  end
          else
             begin
                if(run.instruction_queue_no_of_enteries == 0)
                      $display("Stall , IQ : Empty");
               else
                 $display("Stall , ROB : Full");
             end

end
endmodule
