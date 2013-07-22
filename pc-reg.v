module PC_REG
  (
   clk,
   reset, 
   PC_in, 
   PC_out
   );

   parameter pc_delay = 1;  
 
   output [31:0] PC_out;				
   reg [31:0] 	 PC_out;
   reg [31:0] 	 next_PC;
   
   input [31:0]  PC_in;	
   input 	 clk;
   input 	 reset;

   always@(posedge clk or posedge reset)
     begin
	if (~reset)
	  PC_out = PC_in;
	else
	  PC_out = 32'h00400000;
     end
      
endmodule // PC_REG














