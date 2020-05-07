/* This module gets the instruction from the memory
puts the data in instruction queue */
module fetch(
  input [3:0] pc,
  input iq_r,
   // it only write in intruction register if iq_r = 1
  output reg [31:0] instruction,
  output reg fetch_complete// this instructs whether fetch is complete or not

  );
  reg
  always@(posedge clk) begin

  end


endmodule

/*this module decodes and generates the control signal
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
