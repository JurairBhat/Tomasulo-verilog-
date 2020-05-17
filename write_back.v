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
         run.v_des[run.res1_dest[run.i0]] = 1'b1;// ready to retire;
         $display("        ROB\n");
         $display("        1.Index : %h",run.res1_dest[run.i0]);
         $display("        2.Rd : %h", run.rob_dest_reg_feild[run.res1_dest[run.i0]]);
         $display("        3.Value : %h",run.res1_v0);
         $display("        4.Ready to Retire : %h",run.v_des[run.res1_dest[run.i0]]);
         $display("        5.Committed : %h\n",run.commit[run.res1_dest[run.i0]]);

         // make that entry free in res1 free;
         run.res1_free_entry[run.i0] = 1'b1;
         run.res1_no_of_enteries = run.res1_no_of_enteries - 1;
         $display("        Reservation Station 1\n");
         $display("        Index : %h",run.i0);
         $display("        Free : %h\n",run.res1_free_entry[run.i0]);
         //make execution unit free
         run.res1_execution_unit[0] = 1'b0; // execution unit is free
         run.res1_v0_written = 1'b0 ;

         // update value to all places where ever this value is needed;
         // check in reservation station where ever the value is needed update that
         $display("         Updates\n");
         i = 0 ;
         while(i < 4)
         begin
           // update sr1 in rs1;
           if(!run.res1_sr1_refrence[i] &&  (run.res1_sr1_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
           begin

             //$display("Sr1 getting update");
             $display("        RS : 1");
             run.res1_sr1[i] = run.res1_v0;
             $display("        Index : %d",i);
             $display("        Rs1 : %h\n",run.res1_sr1[i]);
             run.res1_sr1_refrence[i] = 1'b1;
            end
           // update sr2 in rs1;
            if(!run.res1_sr2_refrence[i] &&  (run.res1_sr2_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
            begin
             //$display("Sr2 getting update");
             $display("        RS : 1 ");
             run.res1_sr2[i] = run.res1_v0;
             $display("        Index : %d",i);
             $display("        Rs2 : %h\n",run.res1_sr2[i]);
             run.res1_sr2_refrence[i] = 1'b1;
            end
          // check if both sources are ready so that it is ready to get issued
            if(run.res1_sr1_refrence[i] && run.res1_sr2_refrence[i])
            begin
             $display("        RS : 1");
             run.res1_ready[i] = 1'b1;
             $display("        Index : %d",i);
             $display("        Ready : %h\n",run.res1_ready[i]);
             //$display("%h , Made Ready",run.res1_instructions[i]);
            end


            // update sr1 in rs2
            if(!run.res2_sr1_refrence[i] &&  (run.res2_sr1_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
            begin

              //$display("Sr1 getting update");
              run.res2_sr1[i] = run.res1_v0;
              run.res2_sr1_refrence[i] = 1'b1;
              $display("        RS : 2");
              $display("        Index : %d",i);
              $display("        Rs1 : %h\n",run.res2_sr1[i]);
             end
            // update sr2 in rs2;
             if(!run.res2_sr2_refrence[i] &&  (run.res2_sr2_ref_value[i] == run.res1_dest[run.i0]))// value to supposed to be taken from ROB
             begin
              //$display("Sr2 getting update");
              run.res2_sr2[i] = run.res1_v0;
              run.res2_sr2_refrence[i] = 1'b1;
              $display("        RS : 2");
              $display("        Index : %d",i);
              $display("        Rs2 : %h\n",run.res2_sr2[i]);
             end
           // check if both sources are ready so that it is ready to get issued
             if(run.res2_sr1_refrence[i] && run.res2_sr2_refrence[i])
             begin
              run.res2_ready[i] = 1'b1;
              $display("        RS : 2");
              $display("        Index : %d",i);
              $display("        Ready : %h\n",run.res2_ready[i]);
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
           //run.commit[run.res1_dest[run.i1]] = 1'b0
           run.v_des[run.res1_dest[run.i1]] = 1'b1;// ready to retire;
           $display("        ROB\n");
           $display("        1.Index : %h",run.res1_dest[run.i1]);
           $display("        2.Rd : %h", run.rob_dest_reg_feild[run.res1_dest[run.i1]]);
           $display("        3.Value : %h",run.res1_v1);
           $display("        4.Ready to Retire : %h",run.v_des[run.res1_dest[run.i1]]);
           $display("        5.Committed : %h\n",run.commit[run.res1_dest[run.i1]]);

           // make that entry free in res1 free;
           run.res1_free_entry[run.i1] = 1'b1;
           run.res1_no_of_enteries = run.res1_no_of_enteries - 1;

           //make execution unit free
           run.res1_execution_unit[0] = 1'b0; // execution unit is free
           run.res1_v1_written = 1'b0 ;

           // update value to all places where ever this value is needed;
           // check in reservation station where ever the value is needed update that
           $display("        Reservation Station 1\n");
           $display("        Index : %h",run.i1);
           $display("        Free : %h\n",run.res1_free_entry[run.i1]);

           $display("        Updates\n");
           k = 0 ;
           while(k < 4)
           begin
             // update sr1 in rs1
             if(!run.res1_sr1_refrence[k] &&  (run.res1_sr1_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
             begin
               run.res1_sr1[k] = run.res1_v1;
               run.res1_sr1_refrence[k] = 1'b1;
               $display("        RS : 1");
               $display("        Index : %d",k);
               $display("        Rs1 : %h\n",run.res1_sr1[k]);
             end
             // update sr2 in rs1
             if(!run.res1_sr2_refrence[k] &&  (run.res1_sr2_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
             begin
               run.res1_sr2[k] = run.res1_v1;
               run.res1_sr2_refrence[k] = 1'b1;
               $display("        RS : 1");
               $display("        Index : %d",k);
               $display("        Rs2 : %h\n",run.res1_sr2[k]);
             end
            // check if both sources are ready so that it is ready to get issued
            if(run.res1_sr1_refrence[k] && run.res1_sr2_refrence[k])
            begin
                   run.res1_ready[k] = 1'b1;
                   $display("        RS : 1");
                   $display("        Index : %d",k);
                   $display("        Ready : %h\n",run.res1_ready[k]);
            end

            // update sr1 in rs2
            if(!run.res2_sr1_refrence[k] &&  (run.res2_sr1_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
                begin
                   run.res2_sr1[k] = run.res1_v1;
                   run.res2_sr1_refrence[k] = 1'b1;
                   $display("        RS : 2");
                   $display("        Index : %d",k);
                   $display("        Rs1 : %h\n",run.res2_sr1[k]);
                 end
            // update sr2
              if(!run.res2_sr2_refrence[k] &&  (run.res2_sr2_ref_value[k] == run.res1_dest[run.i1]))// value to supposed to be taken from ROB
                   begin
                     run.res2_sr2[k] = run.res1_v1;
                     run.res2_sr2_refrence[k] = 1'b1;
                     $display("        RS : 2");
                     $display("        Index : %d",k);
                     $display("        Rs2 : %h\n",run.res2_sr2[k]);
                   end
               // check if both sources are ready so that it is ready to get issued
             if(run.res2_sr1_refrence[k] && run.res2_sr2_refrence[k])
             begin
                  run.res2_ready[k] = 1'b1;
                  $display("        RS : 2");
                  $display("        Index : %d",k);
                  $display("        Ready : %h\n",run.res2_ready[k]);

             end

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
            $display("        ROB\n");
            $display("        1.Index : %h",run.res2_dest[run.i2]);
            $display("        2.Rd : %h", run.rob_dest_reg_feild[run.res2_dest[run.i2]]);
            $display("        3.Value : %h",run.res2_v);
            $display("        4.Ready to Retire : %h",run.v_des[run.res2_dest[run.i2]]);
            $display("        5.Committed : %h\n",run.commit[run.res2_dest[run.i2]]);

             // make that entry free in res1 free;
             run.res2_free_entry[run.i2] = 1'b1;
             run.res2_no_of_enteries = run.res2_no_of_enteries - 1;

             //make execution unit free
             run.res2_execution_unit = 1'b0; // execution unit is free
             run.res2_v_written = 1'b0 ;

             // update value to all places where ever this value is needed;
             // check in reservation station where ever the value is needed update that
             $display("        Reservation Station 2\n");
             $display("        Index : %h",run.i2);
             $display("        Free : %h\n",run.res2_free_entry[run.i2]);

             $display("        Updates\n");
             j = 0 ;
             while(j < 4)
             begin
               // update sr1 in rs2
               if(!run.res2_sr1_refrence[j] &&  (run.res2_sr1_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
               begin
                 run.res2_sr1[j] = run.res2_v;
                 run.res2_sr1_refrence[j] = 1'b1;
                 $display("        RS :  2");
                 $display("        Index : %d",j);
                 $display("        Rs1 : %h\n",run.res2_sr1[j]);
               end
               // update sr2 in rs2
               if(!run.res2_sr2_refrence[j] &&  (run.res2_sr2_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
               begin
                 run.res2_sr2[j] = run.res2_v;
                 run.res2_sr2_refrence[j] = 1'b1;
                 $display("        RS :  2");
                 $display("        Index : %d",j);
                 $display("        Rs2 : %h\n",run.res2_sr2[j]);
               end
              // check if both sources are ready so that it is ready to get issued
              if(run.res2_sr1_refrence[j] && run.res2_sr2_refrence[j])
              begin
                     run.res2_ready[j] = 1'b1;
                     $display("        RS : 2");
                     $display("        Index : %d",j);
                     $display("        Ready : %h\n",run.res2_ready[j]);
              end
              // update sr1 in rs1
              if(!run.res1_sr1_refrence[j] &&  (run.res1_sr1_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
                  begin
                    run.res1_sr1[j] = run.res2_v;
                    run.res1_sr1_refrence[j] = 1'b1;
                    $display("        RS :  1");
                    $display("        Index : %d",j);
                    $display("        Rs1 : %h\n",run.res1_sr1[j]);
                  end
                // update sr2 in rs1
              if(!run.res1_sr2_refrence[j] &&  (run.res1_sr2_ref_value[j] == run.res2_dest[run.i2]))// value to supposed to be taken from ROB
                  begin
                    run.res1_sr2[j] = run.res2_v;
                    run.res1_sr2_refrence[j] = 1'b1;
                    $display("        RS :  2");
                    $display("        Index : %d",j);
                    $display("        Rs2 : %h\n",run.res1_sr2[j]);
                  end
              // check if both sources are ready so that it is ready to get issued
              if(run.res1_sr1_refrence[j] && run.res1_sr2_refrence[j])
              begin
                           run.res1_ready[j] = 1'b1;
                           $display("        RS : 1");
                           $display("        Index : %d",j);
                           $display("        Ready : %h\n",run.res1_ready[j]);

              end
              j = j + 1;
             end

        end
      end
endmodule
