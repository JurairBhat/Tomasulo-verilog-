module commit();// update the register file and write the values back
  always @(posedge run.clk)
  begin
    $display(($time-10)/20 ," cycle ");
    $display("--- COMMITT STAGE---  ",);
      if((run.v_des[run.head] == 1'b1) && (run.commit[run.head] == 1'b0))// start committing
      begin
          $display("Instruction : %h , Committed", run.rob_instruction_feild[run.head]);
          if(run.reg_rename[run.rob_dest_reg_feild[run.head]] == run.head)
            begin
              // update register file;
                        run.reg_file[run.rob_dest_reg_feild[run.head]]  = run.rob_dest_reg_value[run.head];
            end
            run.commit[run.head] = 1'b1;
            run.v_des[run.head] = 1'b0;
            run.head = run.head + 2'b01;
            run.rob_no_of_enteries = run.rob_no_of_enteries - 1;
      end

      else
      begin
       if(run.rob_no_of_enteries == 0)
         $display("Rob : Empty");
      else
        $display(" Instruction : %h , Waiting for Values " , run.rob_instruction_feild[run.head]);
      end
  end
endmodule
