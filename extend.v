module EXTEND
  (
   word_out,
   halfWord_in, 
   extendCntrl_in
   );
   
   parameter     ext_delay = 3;  

   output [31:0] word_out;				
   reg [31:0] 	 word_out, temp;
   
   input [15:0]  halfWord_in ;	
   input 	 extendCntrl_in;
   
   always @*
     begin
	#ext_delay;
	if (extendCntrl_in & (halfWord_in[15])) 
	  word_out = {16'hffff, halfWord_in};
	else
	  word_out = {16'b0, halfWord_in};
     end
   
endmodule














