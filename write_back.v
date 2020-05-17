module write_back();
integer i;// for res1 1st
integer k;// for res1 2nd
integer j;

always @(posedge run.clk)
   begin

    #2
    $display("WRITE BACK STAGE : \n",);
    if(run.res1_v0_written == 1'b1)// if value is received
    begin

        $display("        Instruction : %h , Written Back\n",run.res1_i0);
        // update all places where that value is being used
        // first ROB value
         run.rob_dest_reg_value[run.res1_dest[run.i0]] = run.res1_v0 ;
         //run.commit[run.res1_dest[run.i0]] = 1'b0;
         run.v_des[run.res1_dest[run.i0]] = 1'b1;// ready to retire;
         // make that entry free in res1 free;
         run.res1_free_entry[run.i0] = 1'b1;
         run.res1_no_of_enteries = run.res1_no_of_enteries - 1;

         //make execution unit free
         run.res1_execution_unit[0] = 1'b0; // execution unit is free
         run.res1_v0_written = 1'b0 ;

         // update value to all places where ever this value is needed;
         // check in reservation station where ever the value is needed update that
         i = 0 ;
         while(i < 4)
         begin
           // update sr1 in rs1;
           if(!run.res1_sr1_refrence[i] &&  (run.res1_sr1_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
           begin

             //$display("Sr1 getting update");
             run.res1_sr1[i] = run.res1_v0;
             run.res1_sr1_refrence[i] = 1'b1;
            end
           // update sr2 in rs1;
            if(!run.res1_sr2_refrence[i] &&  (run.res1_sr2_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
            begin
             //$display("Sr2 getting update");
             run.res1_sr2[i] = run.res1_v0;
             run.res1_sr2_refrence[i] = 1'b1;
            end
          // check if both sources are ready so that it is ready to get issued
            if(run.res1_sr1_refrence[i] && run.res1_sr2_refrence[i])
            begin
             run.res1_ready[i] = 1'b1;
             //$display("%h , Made Ready",run.res1_instructions[i]);
            end


            // update sr1 in rs2;
            if(!run.res2_sr1_refrence[i] &&  (run.res2_sr1_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
            begin

              //$display("Sr1 getting update");
              run.res2_sr1[i] = run.res1_v0;
              run.res2_sr1_refrence[i] = 1'b1;
             end
            // update sr2 in rs2;
             if(!run.res2_sr2_refrence[i] &&  (run.res2_sr2_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
             begin
              //$display("Sr2 getting update");
              run.res2_sr2[i] = run.res1_v0;
              run.res2_sr2_refrence[i] = 1'b1;
             end
           // check if both sources are ready so that it is ready to get issued
             if(run.res2_sr1_refrence[i] && run.res2_sr2_refrence[i])
             begin
              run.res2_ready[i] = 1'b1;
              //$display("%h , Made Ready",run.res1_instructions[i]);
             end
            //
           i = i + 1 ;
          end
      end
  end

always @(posedge run.clk)
    begin
      #3
      if(run.res1_v1_written == 1'b1)// if value is received
      begin
           $display("        Instruction : %h , Written Back\n",run.res1_i1);
          // update all places where that value is being used
          // first ROB value
           run.rob_dest_reg_value[run.res1_dest[run.i1]] = run.res1_v1 ;
           run.commit[run.res1_dest[run.i1]] = 1'b0;
           run.v_des[run.res1_dest[run.i1]] = 1'b1;// ready to retire;
           // make that entry free in res1 free;
           run.res1_free_entry[run.i1] = 1'b1;
           run.res1_no_of_enteries = run.res1_no_of_enteries - 1;

           //make execution unit free
           run.res1_execution_unit[0] = 1'b0; // execution unit is free
           run.res1_v1_written = 1'b0 ;

           // update value to all places where ever this value is needed;
           // check in reservation station where ever the value is needed update that
           k = 0 ;
           while(k < 4)
           begin
             // update sr1 in rs1
             if(!run.res1_sr1_refrence[k] &&  (run.res1_sr1_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
             begin
               run.res1_sr1[k] = run.res1_v1;
               run.res1_sr1_refrence[k] = 1'b1;
             end
             // update sr2 in rs2
             if(!run.res1_sr2_refrence[k] &&  (run.res1_sr2_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
             begin
               run.res1_sr2[k] = run.res1_v1;
               run.res1_sr2_refrence[k] = 1'b1;
             end
            // check if both sources are ready so that it is ready to get issued
            if(run.res1_sr1_refrence[k] && run.res1_sr2_refrence[k])
                   run.res1_ready[k] = 1'b1;


            // update sr1 in rs2
            if(!run.res2_sr1_refrence[k] &&  (run.res2_sr1_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
                begin
                   run.res2_sr1[k] = run.res1_v1;
                   run.res2_sr1_refrence[k] = 1'b1;
                 end
            // update sr2
              if(!run.res2_sr2_refrence[k] &&  (run.res2_sr2_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
                   begin
                     run.res2_sr2[k] = run.res1_v1;
                     run.res2_sr2_refrence[k] = 1'b1;
                   end
               // check if both sources are ready so that it is ready to get issued
             if(run.res2_sr1_refrence[k] && run.res2_sr2_refrence[k])
                  run.res2_ready[k] = 1'b1;

            k = k + 1;
           end

      end
    end

    always @(posedge run.clk)
      begin
        #4
        if(run.res2_v_written == 1'b1)// if value is received
        begin
             $display("        Instruction : %h , Written Back\n",run.res2_i);
            // update all places where that value is being used
            // update ROB value
            run.commit[run.res2_dest[run.i2]] = 1'b0;
            run.v_des[run.res2_dest[run.i2]] = 1'b1;// ready to retire;
            run.rob_dest_reg_value[run.res2_dest[run.i2]] = run.res2_v ;

             // make that entry free in res1 free;
             run.res2_free_entry[run.i2] = 1'b1;
             run.res2_no_of_enteries = run.res2_no_of_enteries - 1;

             //make execution unit free
             run.res2_execution_unit = 1'b0; // execution unit is free
             run.res2_v_written = 1'b0 ;

             // update value to all places where ever this value is needed;
             // check in reservation station where ever the value is needed update that
             j = 0 ;
             while(j < 4)
             begin
               // update sr1 in rs2
               if(!run.res2_sr1_refrence[j] &&  (run.res2_sr1_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
               begin
                 run.res2_sr1[j] = run.res2_v;
                 run.res2_sr1_refrence[j] = 1'b1;
               end
               // update sr2 in rs2
               if(!run.res2_sr2_refrence[j] &&  (run.res2_sr2_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
               begin
                 run.res2_sr2[j] = run.res2_v;
                 run.res2_sr2_refrence[j] = 1'b1;
               end
              // check if both sources are ready so that it is ready to get issued
              if(run.res2_sr1_refrence[j] && run.res2_sr2_refrence[j])
                     run.res2_ready[j] = 1'b1;

              // update sr1 in rs1
              if(!run.res1_sr1_refrence[j] &&  (run.res1_sr1_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
                  begin
                    run.res1_sr1[j] = run.res2_v;
                    run.res1_sr1_refrence[j] = 1'b1;
                  end
                // update sr2 in rs1
              if(!run.res1_sr2_refrence[j] &&  (run.res1_sr2_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
                  begin
                    run.res1_sr2[j] = run.res2_v;
                    run.res1_sr2_refrence[j] = 1'b1;
                  end
              // check if both sources are ready so that it is ready to get issued
              if(run.res1_sr1_refrence[j] && run.res1_sr2_refrence[j])
                           run.res1_ready[j] = 1'b1;
              j = j + 1;
             end

        end
      end
endmodule
