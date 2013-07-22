

module MIPS_CONTROL
  (
   op_in,
   func_in,
   
   branch_out, 
   regWrite_out, 
   regDst_out, 
   extCntrl_out, 
   ALUSrc_out, 
   ALUCntrl_out, 
   memWrite_out,
   memRead_out,
   memToReg_out, 
   jump_out,
   
   );
   
   parameter control_delay = 6;  

   input [5:0]  op_in, func_in;
   
   output [3:0] ALUCntrl_out;
   reg [3:0] 	ALUCntrl_out;
   
   output 	branch_out, jump_out;				
   reg 		branch_out, jump_out;				
   
   output 	regWrite_out, regDst_out;
   reg 		regWrite_out, regDst_out;
   
   output 	extCntrl_out, ALUSrc_out;
   reg 		extCntrl_out, ALUSrc_out;
   
   output 	memWrite_out, memRead_out, memToReg_out;
   reg 		memWrite_out, memRead_out, memToReg_out;
   

   always@*
     begin
	#control_delay;

	casex({op_in, func_in})

	  // nop
	  {6'h0, 6'h0}: 
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b0; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0010; //pg316*
	    
	    end // case: {6'h0, 6'h0}
	  
	  // addi
 	  {6'h8, 6'hx}: // addi
	    begin
	       regDst_out   = 1'b0;
	       ALUSrc_out   = 1'b1;
	       memToReg_out = 1'b0;
	       regWrite_out = 1'b1;
	       memWrite_out = 1'b0;
	       memRead_out  = 1'b0;
	       branch_out   = 1'b0;
	       jump_out     = 1'b0;
	       extCntrl_out = 1'b1;
	       ALUCntrl_out = 4'b0010;
	    
	    end // case: {6'h8, 6'hx}
	  	  
	  {6'hf, 6'hx}: // lui
	    begin	
	       regDst_out   = 1'b0;
	       ALUSrc_out   = 1'b1;
	       memToReg_out = 1'b0;
	       regWrite_out = 1'b1;
	       memWrite_out = 1'b0;
	       memRead_out  = 1'b0;
	       branch_out   = 1'b0;
	       jump_out     = 1'b0;
	       extCntrl_out = 1'bx;
	       ALUCntrl_out = 4'b1111; 
         
	    end // case: 6'hf

	  {6'h0, 6'h20}: // add
	    begin
	       regDst_out   = 1'b1;
	       ALUSrc_out   = 1'b0;
	       memToReg_out = 1'b0;
	       regWrite_out = 1'b1;
	       memWrite_out = 1'b0;
	       memRead_out  = 1'b0;
	       branch_out   = 1'b0;
	       jump_out     = 1'b0;
	       extCntrl_out = 1'bx;
	       ALUCntrl_out = 4'b0010;
	    
	    end // case: {6'h0, 6'h20}
	  
	  
	  
	  {6'h0, 6'h22}: //sub
	    begin       
	       regDst_out   = 1'b1; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'bx; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0110; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	  
	  
	  
	  {6'h0, 6'h2a}: //slt
	    begin       
	       regDst_out   = 1'b1; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'bx; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0111; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    
	  {6'hd, 6'hx}: //ori
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b1; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0001; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'ha, 6'hx}: //slti
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b1; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0111; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h23, 6'hx}: //lw
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b1; //0 means REG and 1 means IMM
	       memToReg_out = 1'b1; //0 means NO  and 1 means YES
	       regWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b1; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0010; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h2b, 6'hx}: //sw
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b1; //0 means REG and 1 means IMM
	       memToReg_out = 1'bx; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b1; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0010; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h4, 6'hx}: //beq
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'bx; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b1; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0110; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h5, 6'hx}: //bne
	    begin       
	       regDst_out   = 1'b1; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'bx; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b1; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b1; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0110; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h2, 6'hx}: //j
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'bx; //0 means REG and 1 means IMM
	       memToReg_out = 1'bx; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'bx; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b1; //0 means NO  and 1 means YES
	       extCntrl_out = 1'bx; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'bxxxx; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h0, 6'h8}: //jr
	    begin       
	       regDst_out   = 1'b1; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'bx; //0 means REG and 1 means IMM
	       memToReg_out = 1'bx; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'bx; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b1; //0 means NO  and 1 means YES
	       extCntrl_out = 1'bx; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'bxxxx; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	    {6'h3, 6'hx}: //jal
	    begin       
	       regDst_out   = 1'b0; //0 means RT  and 1 means RD
	       ALUSrc_out   = 1'b0; //0 means REG and 1 means IMM
	       memToReg_out = 1'b0; //0 means NO  and 1 means YES
	       regWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memWrite_out = 1'b0; //0 means NO  and 1 means YES
	       memRead_out  = 1'b0; //0 means NO  and 1 means YES
	       branch_out   = 1'b0; //0 means NO  and 1 means YES
	       jump_out     = 1'b0; //0 means NO  and 1 means YES
	       extCntrl_out = 1'b0; //0 means Zero-extension and 1 means Sign-extension
	       ALUCntrl_out = 4'b0010; //Refer to table on page 316 of the book
	    
	    end // case: {6'hx, 6'hx}
	    
	  
	  ///
	  
	  default:   //anything else
	    begin		
	       regDst_out   = 1'bx;
               ALUSrc_out   = 1'bx;
               memToReg_out = 1'bx;
               regWrite_out = 1'bx;
               memWrite_out = 1'bx;
               branch_out   = 1'bx;
               jump_out     = 1'bx;
               extCntrl_out = 1'bx;
               ALUCntrl_out = 4'bxxxx;
	    end // case: default
	  
	endcase // casex({op_in, func_in})
	
	
     end // always@ *
      
endmodule // MIPS_CONTROL




























