module MIPS(clk, reset);

   input clk;
   input reset;

   // instruction and PC related wires
   wire [31:0] instruction;
   wire [31:0] PCplus4;
   wire [31:0] PC;
   
   // decoder related wires
   wire [5:0]  op, func;
   wire [4:0]  rs, rt, rd, shft;
   wire [15:0] imm16;
   wire [25:0] target;
   
   // control related wires
   wire        regWrite, regDst;
   wire        memRead, memWrite, memToReg;
   wire        extCntrl, ALUSrc;
   wire [3:0]  ALUCntrl;
   wire        branch, jump;

   // ALU related wires
   wire [31:0] A, B, ALUout;
   wire        zero;

   // register file related wires
   wire [31:0] regData2;
   wire [4:0]  regDstAddr;

   // immediate related wires
   wire [31:0] immExtended;


    wire [31:0] PCfinal;

    wire [31:0] dataMemOut;
    wire [31:0] dataToReg;
    
    
    wire [31:0] ImmExtShift;
    wire [31:0] addedBranch;
    
    wire branchTest;
    assign branchTest = (branch & zero & !regDst) + (branch & !zero & regDst);
    
    wire [31:0] branchFinal;
    wire [31:0] jumpFinal;
    
    wire [31:0] jumpAddrShifted;
    wire [31:0] jumpAddr;
    wire [31:0] target32;
    assign target32 = target;
    assign jumpAddr = {PCplus4[31:28],jumpAddrShifted[27:0]};
   
   //////////////////////////////////////////////
   

   // instantiation of instruction memory
   IMEM  imem
     (
      .instruction_out(instruction),
      .address_in(PC)
      );


   // instantiation of register file
   REG_FILE reg_file
     (
      .clk(clk),
      .data1_out(A),
      .data2_out(regData2),
      .readAddr1_in(rs),
      .readAddr2_in(rt),
      .writeAddr_in(regDstAddr),
      .writeData_in(dataToReg), //ALUout
      .writeCntrl_in(regWrite)
      );

   // instantiation of PC register
   PC_REG pc_reg
     (
      .clk(clk),
      .reset(reset),
      .PC_out(PC),
      .PC_in(PCfinal)
      );

   // instantiation of the decoder
   MIPS_DECODE	mips_decode
     (
      .instruction_in(instruction), 
      .op_out(op), 
      .func_out(func), 
      .rs_out(rs), 
      .rt_out(rt), 
      .rd_out(rd), 
      .shft_out(shft), 
      .imm16_out(imm16), 
      .target_out(target)
      );

   // instantiation of the control unit
   MIPS_CONTROL mips_control
     (
      .op_in(op),
      .func_in(func),
      .branch_out(branch), 
      .regWrite_out(regWrite), 
      .regDst_out(regDst), 
      .extCntrl_out(extCntrl), 
      .ALUSrc_out(ALUSrc), 
      .ALUCntrl_out(ALUCntrl), 
      .memWrite_out(memWrite),
      .memRead_out(memRead),
      .memToReg_out(memToReg), 
      .jump_out(jump)
      );

   // instantiation of the ALU
   MIPS_ALU mips_alu
     (
      .ALUCntrl_in(ALUCntrl), 
      .A_in(A), 
      .B_in(B), 
      .ALU_out(ALUout), 
      .zero_out(zero)
      );

   // instantiation of the sign/zero extender
   EXTEND extend
     (
      .word_out(immExtended),
      .halfWord_in(imm16),
      .extendCntrl_in(extCntrl)
      );

   // instantiation of a 32-bit adder used for computing PC+4
   ADDER32 plus4Adder
     (
      .result_out(PCplus4),
      .a_in(32'd4), 
      .b_in(PC)
      );

   // instantiation of a 32-bit MUX used for selecting between immediate and register as the second source of ALU
   MUX32_2X1 aluMux
     (
      .value_out(B),
      .value0_in(regData2), 
      .value1_in(immExtended), 
      .select_in(ALUSrc)
      );

   // instantiation of a 5-bit MUX used for selecting between RT or RD as the destination address of the operation
   MUX5_2X1 regMUX 
     (
      .value_out(regDstAddr),
      .value0_in(rt),
      .value1_in(rd),
      .select_in(regDst)
      );
      
      
      
      //MY MODS
      
  MUX32_2X1 aluOutMux
	(
		.value_out(dataToReg),
		.value0_in(ALUout),
		.value1_in(dataMemOut),
		.select_in(memToReg)
	);
      
      
   DMEM dataMem
   (
    .clk(clk),
    .data_out(dataMemOut),
    .writeCntrl_in(memWrite),
    .writeData_in(regData2),
    .readCntrl_in(memRead),
    .address_in(ALUout) 
   );   
      
      
     SHIFT2 shiftBranch
     (
     .word_out(ImmExtShift),
	   .word_in(immExtended)   
     );
    
    
    
      ADDER32 branchAdder
      (
      .result_out(addedBranch),
      .a_in(PCplus4),
      .b_in(ImmExtShift)
      );
      
      
    MUX32_2X1 branchMux
	(
		.value_out(branchFinal),
		.value0_in(PCplus4),
		.value1_in(addedBranch),
		.select_in(branchTest)
	);
      
      
    MUX32_2X1 jumpBranchMux
    (
      .value_out(PCfinal),
      .value0_in(branchFinal),
      .value1_in(jumpFinal),
      .select_in(jump)
    
    );
    
    MUX32_2X1 jumpMux
    (
      .value_out(jumpFinal),
      .value0_in(jumpAddr),
      .value1_in(A),
      .select_in(regDst)
      
      );
      
      SHIFT2 shiftJump
     (
     .word_out(jumpAddrShifted),
	   .word_in(target32)   
     );
      
      //
      
      

endmodule
