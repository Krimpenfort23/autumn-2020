#include <stdio.h>
#include <string.h>
#include "globals.h"

// Max cycles simulator will execute -- to stop a runaway simulator
#define FAIL_SAFE_LIMIT  500000

struct instruction   inst_mem[MAX_LINES_OF_CODE];  	// instruction memory
struct instruction   IR;                        	// instruction register
int   data_mem[MAX_WORDS_OF_DATA];              	// data memory
int   int_regs[16];                             	// integer register file
int   PC, NPC;                                  	// PC and next PC
int   A, B;                                     	// ID register read values
int   mem_addr;                                 	// data memory address
int   Cond;                                     	// branch condition test
int   load_memory_data;                         	// data memory output
int   ALU_input1, ALU_input2, ALU_output;       	// ALU intputs and output
int   wrote_r0 = 0;                             	// register R0 written?
int   code_length;                              	// lines of code in inst mem
int   cycle;                                    	// simulation cycle count
int   inst_executed;                            	// number of instr executed

// forwarding conditionals
int   IF_continue = 1;					    
int   IF_stall = 0;						    
int   IF_stop = 0;						    
int   ID_continue = 0;				    
int   branch_end = 0;					    
int   EX_LW_stop = 0;					    
int   branch_LW_stop_one = 0;					
int   branch_LW_stop_two = 0;					

struct pipeline pipeline_one, pipeline_two, pipeline_three, pipeline_four;

// Onto simulating a pipelined DLX processor

/*
 * Instruction Fetch Stage
 */
void IF_stage() 
{
	/* ------------------------------ IF stage ------------------------------ */
	if (IF_continue == 1) 
    {
		/* check if instruction memory access is within bounds */
		if (PC < 0 || PC >= code_length)
        {
			printf("Exception: Fetch: out-of-bounds inst memory access at PC=%d\n", PC);
			exit(0);
		}

		if (IF_stall == 1) 
        {
			pipeline_one.valid = 0;
			pipeline_one.stall = 1;
			IF_stall = 0;
		} 
		else if (IF_stop == 1) 
        {
			PC = NPC;
			IF_stop = 0;
		}
		else 
        {
			IR = inst_mem[PC];    /* read instruction memory */
			NPC = PC + 1;         /* increment PC */
			pipeline_one.IR = IR;
			pipeline_one.NPC = NPC;
			pipeline_one.valid = 1;
		}
		
		if (NPC == code_length) 
			IF_continue = 0;
	}

	else if (IF_stop == 1) 
    {
		IF_stop = 0;
		if (PC != code_length)
			IF_continue = 1;
		if ((PC == code_length) && 
            ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)))
			IF_continue = 1;
	}
	else if (branch_end == 1)
		pipeline_one.valid = 0;
}

/*
 * Instruction Decode Stage
 */
void ID_stage() 
{
	/* ------------------------------ ID stage ------------------------------ */
	if (pipeline_one.valid == 1) 
    {
        // all the forwarding cases
		if (((pipeline_two.IR.op == ADDI) || (pipeline_two.IR.op == SUBI)) && 
            ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
            (pipeline_two.IR.rt == pipeline_one.IR.rs))
        {
			IF_stop = 1;
			IF_continue = 0;
			pipeline_one.stop = 1;
			pipeline_two.stall = 1;
			pipeline_two.valid = 0;
		}
		else if (((pipeline_two.IR.op == ADD) || (pipeline_two.IR.op == SUB)) &&
		        ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
                (pipeline_two.IR.rd == pipeline_one.IR.rs))
        {
			IF_stop = 1;
			IF_continue = 0;
			pipeline_one.stop = 1;
			pipeline_three.stall = 1;
			pipeline_three.valid = 0;
		}
		else if (((pipeline_three.IR.op == ADDI) || (pipeline_three.IR.op == SUBI)) &&
		        ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
                (pipeline_three.IR.rt == pipeline_one.IR.rs))
        {
			A = pipeline_three.ALU_output;
			ID_continue = 1;
		}
		else if (((pipeline_three.IR.op == ADD) || (pipeline_three.IR.op == SUB)) &&
		        ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
                (pipeline_three.IR.rd == pipeline_one.IR.rs))
        {
			A = pipeline_three.ALU_output;
			ID_continue = 1;
		}
		else if (((pipeline_four.IR.op == ADDI) || (pipeline_four.IR.op == SUBI)) &&
		        ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
                (pipeline_four.IR.rt == pipeline_one.IR.rs))
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		else if (((pipeline_four.IR.op == ADD) || (pipeline_four.IR.op == SUB)) &&
		        ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) && 
                (pipeline_four.IR.rd == pipeline_one.IR.rs))
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		else if (((pipeline_four.IR.op == ADDI) || (pipeline_four.IR.op == SUBI)) &&
		        ((pipeline_one.IR.op == ADDI) || (pipeline_one.IR.op == SUBI)) && 
                (pipeline_four.IR.rt == pipeline_one.IR.rs))
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		else if (((pipeline_four.IR.op == ADD) || (pipeline_four.IR.op == SUB)) &&
		        ((pipeline_one.IR.op == ADDI) || (pipeline_one.IR.op == SUBI)) && 
                (pipeline_four.IR.rd == pipeline_one.IR.rs))
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		
		if (((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) &&
		    (pipeline_two.IR.op == LW) && 
            (pipeline_two.IR.rt == pipeline_one.IR.rs) && 
            (branch_LW_stop_one == 0))
        {
			IF_stop = 1;
			IF_continue = 0;
			pipeline_one.stop = 1;
			pipeline_two.stall = 1;
			pipeline_two.valid = 0;
			branch_LW_stop_one = 1;
		}
		else if (((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ)) &&
		        (pipeline_three.IR.op == LW) && 
                (pipeline_three.IR.rt == pipeline_one.IR.rs) && 
                (branch_LW_stop_two == 0))
        {
			IF_stop = 1;
			IF_continue = 0;
			pipeline_one.stop = 1;
			pipeline_two.stall = 1;
			pipeline_two.valid = 0;
			branch_LW_stop_two = 1;
		}

        // more forwarding cases
		if ((pipeline_one.IR.op == LW) && 
            ((pipeline_three.IR.op == ADD) || (pipeline_three.IR.op == SUB)) &&
		    (pipeline_one.IR.rs == pipeline_three.IR.rd)) 
        {
			A = pipeline_three.ALU_output;
			ID_continue = 1;
		}
		else if ((pipeline_one.IR.op == LW) && ((pipeline_three.IR.op == ADDI) || (pipeline_three.IR.op == SUBI)) &&
		(pipeline_one.IR.rs == pipeline_three.IR.rt)) {
			A = pipeline_three.ALU_output;
			ID_continue = 1;
		}
		else if ((pipeline_one.IR.op == LW) && 
                ((pipeline_four.IR.op == ADD) || (pipeline_four.IR.op == SUB)) &&
		        (pipeline_one.IR.rs == pipeline_four.IR.rd)) 
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		else if ((pipeline_one.IR.op == LW) && 
                ((pipeline_four.IR.op == ADDI) || (pipeline_four.IR.op == SUBI)) &&
		        (pipeline_one.IR.rs == pipeline_four.IR.rt)) 
        {
			A = pipeline_four.ALU_output;
			ID_continue = 1;
		}
		
		if (ID_continue == 0)
			A = int_regs[pipeline_one.IR.rs]; /* read registers */	
		
		ID_continue = 0;
		B = int_regs[pipeline_one.IR.rt];

		/* 
         * Calculate branch condition codes
		 * and change PC if condition is 1 
         */
		if (pipeline_one.IR.op == BEQZ)
			Cond = (A == 0);                    /* condition is 1 if A is 0 (beqz) */
		else if (pipeline_one.IR.op == BNEZ)
			Cond = (A != 0);                    /* condition is 1 if A is not 0 (bnez) */
		else if (pipeline_one.IR.op == J)
			Cond = 1;                           /* condition is alway 1 for jump instructions */
		else
			Cond = 0;                           /* condition is 0 for all other instructions */

		// if there's a jump meant to happen and the stage isn't being held
		if ((Cond == 1) && 
            (pipeline_one.stop == 0)) 
        {             
			NPC = NPC + pipeline_one.IR.imm;	/* change NPC if condition is 1 */
			PC = NPC;
			IF_stall = 1;
		}

		//  if the stage isnt being held, allow the ex stage to run
		if (pipeline_one.stop == 0)
			pipeline_two.valid = 1;
		
		// set up the EX stage
		pipeline_two.IR = pipeline_one.IR;
		pipeline_two.A = A;
		pipeline_two.B = B;
		
		if ((IF_continue == 0) && 
            (NPC == code_length) && 
            ((pipeline_one.IR.op != BEQZ) &&
		    (pipeline_one.IR.op != BNEZ) && 
            (pipeline_one.IR.op != J)))
			pipeline_one.valid = 0;
		
		if ((PC == code_length) && 
            (Cond == 0) && 
            (IF_stop == 0) &&
		    ((pipeline_one.IR.op == BEQZ) || (pipeline_one.IR.op == BNEZ))) 
        {
			IF_continue = 0;
			branch_end = 1;
		}
	}
	else if (pipeline_one.stall == 1) 
    {
		pipeline_one.valid = 1;
		pipeline_one.stall = 0;
		pipeline_two.valid = 0;
		pipeline_two.stall = 1;
	}

	if (pipeline_one.stop == 1) 
    {
		pipeline_one.stop = 0;
		pipeline_one.valid = 1;
	}
}

/*
 * Execution Stage
 */
void EX_stage() 
{
	/* ------------------------------ EX stage ------------------------------ */
	if (pipeline_two.valid == 1) 
    {
		if ((pipeline_three.IR.op == ADD || pipeline_three.IR.op == SUB) && 
            (pipeline_three.IR.rd != 0)) 
        {
			if (pipeline_two.IR.rs == pipeline_three.IR.rd)
				pipeline_two.A = pipeline_three.ALU_output;

			if (pipeline_two.IR.rt == pipeline_three.IR.rd) 
				pipeline_two.B = pipeline_three.ALU_output;
		}
		else if ((pipeline_three.IR.op == ADDI || pipeline_three.IR.op == SUBI) &&
                (pipeline_three.IR.rd != 0)) 
        {
			if (pipeline_two.IR.rs == pipeline_three.IR.rt) 
				pipeline_two.A = pipeline_three.ALU_output;

			if	(pipeline_two.IR.rt == pipeline_three.IR.rt) 
				pipeline_two.B = pipeline_three.ALU_output;
		}
		
		if ((pipeline_three.IR.op == LW) && 
            ((pipeline_two.IR.op == ADD) || (pipeline_two.IR.op == SUB))) 
        {
			if ((pipeline_two.IR.rt == pipeline_three.IR.rt) ||
			    (pipeline_two.IR.rs == pipeline_three.IR.rt))
            {
				pipeline_three.valid = 0;
				pipeline_three.stall = 1;
				pipeline_one.valid = 0;
				pipeline_one.stop = 1;
				IF_continue = 0;
				IF_stop = 1;
				EX_LW_stop = 1;
			}
		}
		else if ((pipeline_three.IR.op == LW) && 
                ((pipeline_two.IR.op == ADDI) || (pipeline_two.IR.op == SUBI))) 
        {
			if (pipeline_two.IR.rs == pipeline_three.IR.rt)
            {
				pipeline_three.valid = 0;
				pipeline_three.stall = 1;
				pipeline_one.valid = 0;
				pipeline_one.stop = 1;
				IF_continue = 0;
				IF_stop = 1;
				EX_LW_stop = 1;
			}
		}
		else if ((pipeline_four.IR.op == LW) && 
                ((pipeline_two.IR.op == ADD) || (pipeline_two.IR.op == SUB))) 
        {
			if (pipeline_two.IR.rt == pipeline_four.IR.rt)
				pipeline_two.A = pipeline_four.load_memory_data;
			else if (pipeline_two.IR.rs == pipeline_four.IR.rt)
				pipeline_two.B = pipeline_four.load_memory_data;
		}
		else if ((pipeline_four.IR.op == LW) && 
                ((pipeline_two.IR.op == ADDI) || (pipeline_two.IR.op == SUBI))) 
        {
			if (pipeline_two.IR.rs == pipeline_four.IR.rt)
				pipeline_two.A = pipeline_four.load_memory_data;
		}		
		
		if ((pipeline_two.IR.op == SW) && 
            (pipeline_four.IR.rd != 0) && 
		    ((pipeline_four.IR.op == ADD) || (pipeline_four.IR.op == SUB))) 
        {
			if (pipeline_two.IR.rt == pipeline_four.IR.rs)
				pipeline_two.B = int_regs[pipeline_four.IR.rs];
			else if (pipeline_two.IR.rt == pipeline_four.IR.rt)
				pipeline_two.B = int_regs[pipeline_four.IR.rt];
		}
		else if ((pipeline_two.IR.op == SW) && 
                (pipeline_four.IR.rd != 0) && 
		        ((pipeline_four.IR.op == ADDI) || (pipeline_four.IR.op == SUBI))) 
        {
			if (pipeline_two.IR.rt == pipeline_four.IR.rs)
				pipeline_two.B = int_regs[pipeline_four.IR.rs];
		}
		
		// sets the ALU input from A
		ALU_input1 = pipeline_two.A;

		if (pipeline_two.IR.op == ADDI || pipeline_two.IR.op == SUBI ||
		    pipeline_two.IR.op == LW || pipeline_two.IR.op == SW )
			ALU_input2 = pipeline_two.IR.imm;
        else
			ALU_input2 = pipeline_two.B;

		if (pipeline_two.IR.op == SUB || pipeline_two.IR.op == SUBI)
			pipeline_three.ALU_output = ALU_input1 - ALU_input2;
		else
			pipeline_three.ALU_output = ALU_input1 + ALU_input2;
		
		// set up the MEM stage
		pipeline_three.IR = pipeline_two.IR;
		pipeline_three.B = pipeline_two.B;
		
		if (EX_LW_stop == 0)
			pipeline_three.valid = 1;
		
		if ((IF_continue == 0) && 
            (pipeline_one.valid == 0) &&
		    (PC == code_length) && 
            (pipeline_one.stop == 0))
			pipeline_two.valid = 0;
		
		EX_LW_stop = 0;
	}
	else if (pipeline_two.stall == 1) 
    {
		pipeline_two.valid = 1;
		pipeline_two.stall = 0;
		pipeline_three.valid = 0;
		pipeline_three.stall = 1;
	}
	
	if ((branch_LW_stop_one == 1) && 
        (pipeline_two.IR.op != LW)) 
		branch_LW_stop_one = 0;
}

/*
 * Memory Access Stage
 */
void MEM_stage() 
{
    /* ------------------------------ MEM stage ----------------------------- */
	if (pipeline_three.valid == 1) 
    {
		mem_addr = pipeline_three.ALU_output;

		/* check if data memory access is within bounds */
		if (pipeline_three.IR.op == LW || pipeline_three.IR.op == SW)
        {
			if (mem_addr < 0 || mem_addr >= MAX_WORDS_OF_DATA)
            {
				printf("Exception: Memory: out-of-bounds data memory access at PC=%d\n", PC);
				exit(0);
			}
		}

		// if the instruction is lw, get the value from the data_mem[mem_addr] location
		if(pipeline_three.IR.op == LW)          /* read memory for lw instruction */
			pipeline_four.load_memory_data = data_mem[mem_addr];
		else if (pipeline_three.IR.op == SW)    /* or write to memory for sw instruction */
			data_mem[mem_addr] = pipeline_three.B;
		
		// set up the WB stage
		pipeline_four.ALU_output = pipeline_three.ALU_output;
		pipeline_four.IR = pipeline_three.IR;
		pipeline_four.valid = 1;
		
		if ((IF_continue == 0) && 
            (pipeline_one.valid == 0) &&
			(pipeline_two.valid == 0) && 
            (PC == code_length))
			pipeline_three.valid = 0;
	}
	else if (pipeline_three.stall == 1) 
    {
		pipeline_three.valid = 1;
		pipeline_three.stall = 0;
		pipeline_four.valid = 0;
		pipeline_four.stall = 1;
	}
	
	if ((branch_LW_stop_two == 1) && 
        (pipeline_three.IR.op != LW))
		branch_LW_stop_two = 0;
}

/*
 * Writeback Stage
 */
void WB_stage() 
{
    /* ------------------------------ WB stage ------------------------------ */
	if (pipeline_four.valid == 1) {
		
		/* write to register and check if output register is R0 */
		if (pipeline_four.IR.op == ADD || pipeline_four.IR.op == SUB) 
        {
			int_regs[pipeline_four.IR.rd] = pipeline_four.ALU_output;
			wrote_r0 = (pipeline_four.IR.rd == R0);
		}
		else if (pipeline_four.IR.op == ADDI || pipeline_four.IR.op == SUBI) 
        {
			int_regs[pipeline_four.IR.rt] = pipeline_four.ALU_output;
			wrote_r0 = (pipeline_four.IR.rt == R0);
		}
		else if (pipeline_four.IR.op == LW) 
        {
			int_regs[pipeline_four.IR.rt] = pipeline_four.load_memory_data;
			wrote_r0 = (pipeline_four.IR.rt == R0);
		}

		// increase the number of instructions done
		inst_executed++;

		/* if output register is R0, exit with error */
		if (wrote_r0)
        {
			printf("Exception: Writeback: Attempt to overwrite R0 at PC=%d\n", PC);
			exit(0);
		}
		
		if ((IF_continue == 0) && 
            (pipeline_one.valid == 0) &&
			(pipeline_two.valid == 0) && 
            (pipeline_three.valid == 0) && 
            (PC == code_length)) 
			pipeline_four.valid = 0;
	}
	
	else if (pipeline_four.stall == 1) 
    {
	    // if this stage is stalling, allow the next iteration to run normally
		pipeline_four.valid = 1;
		pipeline_four.stall = 0;
	}
}

/* 
 * main function for pipelined processor
 */
main(int argc, char**argv)
{
	int i;

	if (argc != 2) 
    {  
        /* Check command line inputs */
		printf("Usage: sim [program]\n");
		exit(0);
	}

	/* assemble input program */
	AssembleSimpleDLX(argv[1],inst_mem,&code_length);

	/* set initial simulator values */
	cycle = 0;                /* simulator cycle count */
	PC = 0;                   /* first instruction to execute from inst mem */
	int_regs[R0] = 0;         /* register R0 is alway zero */
	inst_executed = 0;


	// Main simulator loop, ends when all the stages won't continue anymore
	while (IF_continue == 1 || pipeline_one.valid == 1 ||
		   pipeline_two.valid == 1 || pipeline_three.valid == 1 || 
           pipeline_four.valid == 1)
    {
		WB_stage();
		MEM_stage();
		EX_stage();
		ID_stage();
		IF_stage();

		PC = NPC;                    /* update PC          */
		cycle += 1;                  /* update cycle count */

		/* check if simuator is stuck in an infinite loop */
		if (cycle > FAIL_SAFE_LIMIT)
        {
			printf("\n\n *** Runaway program? (Program halted.) ***\n\n");
			break;
		}
	}


	/* print final register values and simulator statistics */
	printf("Final register file values:\n");
	for (i = 0; i < 16; i += 4)
    {
	    printf("  R%-2d: %-10d  R%-2d: %-10d", i, int_regs[i], i+1, int_regs[i+1]);
	    printf("  R%-2d: %-10d  R%-2d: %-10d\n", i+2, int_regs[i+2], i+3, int_regs[i+3]);
	}
	printf("\nCycles executed: %d\n", cycle);
	printf("Instructions executed: %d\n", inst_executed);
	printf("IPC:  %6.3f\n", (float)inst_executed/(float)cycle);
	printf("CPI:  %6.3f\n", (float)cycle/(float)inst_executed);
}
