module IMEM
  (
   address_in, 
   instruction_out
   );

   // Delay to do a memory read or write
   parameter memory_delay = 20;  
   
   input [31:0]  address_in;
   
   output [31:0] instruction_out;
   reg [31:0] 	 instruction_out;			
   
   reg [4:0] 	 word_address;
   
   // We allocate space for 32 instructions in our model
   reg [31:0] 	 mem_array[0:31];

   // Reading the instructions from the file into the array
   initial begin
      $readmemh("program.txt", mem_array, 0, 31);
   end
   
   always @(address_in)
     begin
	#memory_delay;
	
	// word_address = (address_in - 0x00400000) / 4
	word_address= (address_in - 32'h00400000) >> 2;
	
	if ((address_in[31]) | (address_in > 32'h40007C))
	  instruction_out = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
	else
	  instruction_out = mem_array[word_address];
	
     end // always @(address_in)
   
endmodule // IMEM















