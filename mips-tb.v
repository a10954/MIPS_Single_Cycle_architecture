module MIPS_TB ();

   reg clk;
   reg reset;

   MIPS  myMIPS(clk, reset);

   always	#100	clk = ~clk;

   initial 
     begin
	clk = 0;
	reset = 1;
	#400;
	reset = 0;

	
	#10000;
	$finish;
     end

endmodule
