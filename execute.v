module execute();
  integer i;// used for res1
  integer  k ;// used for res2

  always@(posedge run.clk)
    begin
     #5
     $display("--- EXECUTION1 STAGE ---  ");
      i = 0 ;
      while(i < 4)// 0 1 2
      begin
           if((run.res1_ready[i] && (!run.res1_execution_unit[0])) && (!run.res1_issued[i]))//only start execution if execution unit is free as well as res1 is ready
           begin
                // executing that entry;
                run.res1_i0 = run.res1_instructions[i];
                run.i0 = i;
                if(run.res1_opcode[i] == 4'b0000)// if subtract
                begin
                    run.res1_v0 <= #30 run.res1_sr1[i] - run.res1_sr2[i];
                    run.res1_v0_received <= #30 1'b1;
                    $display($time,"Intruction : %h , Executing",run.res1_i0);
                end

                else if(run.res1_opcode[i] == 4'b0001)// if add
                begin
                    run.res1_v0 <= #30 run.res1_sr1[i] + run.res1_sr2[i];
                    run.res1_v0_received <= #30 1'b1;
                    $display($time,"Intruction : %h , Executing",run.res1_i0);
                end
                run.res1_issued[i] = 1'b1;// this entry is issued , no need to issue that again;
                i = i + 1;
                run.res1_execution_unit[0] = 1'b1;// it became busy now

           end

           else if((run.res1_ready[i] && (!run.res1_execution_unit[1])) && (!run.res1_issued[i]))
           begin
             run.res1_i1 =run.res1_instructions[i];
             run.i1 = i;
             if(run.res1_opcode[i] == 4'b0000)// if subtract
             begin
                 run.res1_v1 <= #30 run.res1_sr1[i] - run.res1_sr2[i];
                 run.res1_v1_received <= #30 1'b1 ;
                 $display($time,"Intruction : %h , Executing",run.res1_i1);
             end
             else if(run.res1_opcode[i] == 4'b0001)// if add
             begin
                 run.res1_v1 <= #30 run.res1_sr1[i] + run.res1_sr2[i];
                 run.res1_v1_received <= #30 1'b1;
                 $display($time,"Intruction : %h , Executing",run.res1_i1);
             end
             run.res1_issued[i] = 1'b1;
             i = i + 1;
             run.res1_execution_unit[1] = 1'b1;// it became busy now
             
          end
          else
              i = i + 1;
      end
      if(run.res1_v0_received == 1'b1)
          begin
          run.res1_v0_written = 1'b1;
          $display($time,"Instruction : %h , Execution Complete",run.res1_i0);
          run.res1_v0_received = 1'b0;
          end
      if(run.res1_v1_received == 1'b1)
         begin
          run.res1_v1_written = 1'b1;
          $display($time,"Instruction : %h , Execution Complete",run.res1_i1);
          run.res1_v1_received = 1'b0;
        end
  end
    always@(posedge run.clk)
     begin
       #6
        $display("--- EXECUTION2 STAGE ---- ");
        k = 0 ;
        while(k < 4)// 0 1 2
        begin
             if((run.res2_ready[k] && (!run.res2_execution_unit)) && (!run.res2_issued[k]))//only start execution if execution unit is free as well as res1 is ready
             begin
                  // executing that entry;
                  run.i2 = k;
                  run.res2_i = run.res2_instructions[k];
                  if(run.res2_opcode[k] == 4'b0010)// if subtract
                     begin
                      run.res2_v <= #70 run.res2_sr1[k] * run.res2_sr2[k];
                      run.res2_v_received <= #70 1'b1;
                      $display($time,"Intruction : %h , Executing",run.res2_i);
                     end

                  else if(run.res2_opcode[k] == 4'b0011)// if add
                      begin
                      run.res2_v <= #70 run.res2_sr1[k] / run.res2_sr2[k];
                      run.res2_v_received <= #70 1'b1;
                      $display($time,"Intruction : %h , Executing",run.res2_i);
                      end
                  run.res2_issued[k] = 1'b1;
                  run.res2_execution_unit = 1'b1;// it became busy now
             end
             else
                 k = k + 1 ;

        end
        if(run.res2_v_received == 1'b1)
        begin
            run.res2_v_written = 1'b0;
            $display($time,"Instruction : %h , Execution Complete",run.res2_i);
            run.res2_v_received = 1'b0;
        end
      end
endmodule
