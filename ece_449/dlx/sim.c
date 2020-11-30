#include <stdio.h>
#include <string.h>
#include "globals.h"

// Max cycles simulator will execute -- to stop a runaway simulator
#define FAIL_SAFE_LIMIT  500000

struct instruction   inst_mem[MAX_LINES_OF_CODE];  // instruction memory
struct instruction   IR_IF;                        // instruction register in Fetch
struct instruction   IR_ID;                        // instruction register in Decode
struct instruction   IR_EX;                        // instruction register in Execution
struct instruction   IR_MEM;                       // instruction register in Memory
struct instruction   IR_WB;                        // instruction register in Writeback
int   data_mem[MAX_WORDS_OF_DATA];             // data memory
int   int_regs[16];                            // integer register file
int   PC,NPC;                                  // PC and next PC
int   A,B;                                     // ID register read values
int   mem_addr;                                // data memory address
int   Cond;                                    // branch condition test
int   LMD;                                     // data memory output
int   ALU_input1,ALU_input2,ALU_output;        // ALU intputs and output
int   wrote_r0=0;                              // register R0 written?
int   code_length;                             // lines of code in inst mem
int   cycle;                                   // simulation cycle count
int   inst_executed;                           // number of instr executed

/* Simulate one cycle of the DLX processor */
void IF_stage()
{
  /* ------------------------------ IF stage ------------------------------ */
  /* check if instruction memory access is within bounds */
  if (PC < 0 || PC >= code_length)
  {
    printf("Exception: out-of-bounds inst memory access at PC=%d\n",PC);
    exit(0);
  }
  
  IR_IF = inst_mem[PC];    /* read instruction memory */
  NPC = PC + 1;            /* increment PC */
}

void ID_stage() 
{
  /* ------------------------------ ID stage ------------------------------ */
  IR_ID = IR_IF;

  /* 
    check to see if IR_ID.rs or IR_ID.rt is being used in 
    IR_EX.rd. This will be the forwarding right here.    
   */

  /* if IR_ID.rs == IR_EX.rd then the ALU_output then make A = ALU_output */
  if (IR_ID.rs == IR_EX.rd)
  {
    A = ALU_output;
    B = int_regs[IR_ID.rt];
  }
  /* if IR_ID.rt == IR_EX.rd then the ALU_output then make B = ALU_output */
  else if (IR_ID.rt == IR_EX.rd) 
  {
    A = int_regs[IR_ID.rs];
    B = ALU_output;
  }
  else
  {
    A = int_regs[IR_ID.rs];
    B = int_regs[IR_ID.rt];
  }

  /* Calculate branch condition codes 
     and change PC if condition is true */
  if (IR_ID.op == BEQZ)
    Cond = (A == 0);         /* condition is true if A is 0 (beqz) */
  else if (IR_ID.op == BNEZ)
    Cond = (A != 0);         /* condition is true if A is not 0 (bnez) */
  else if (IR_ID.op == J)
    Cond = 1;                /* condition is alway true for jump instructions */
  else
    Cond = 0;                /* condition is false for all other instructions */

  if (Cond)                  /* change NPC if condition is true */
    NPC = NPC + IR_ID.imm;
}

void EX_stage() 
{
  /* ------------------------------ EX stage ------------------------------ */
  /* set ALU inputs */
  IR_EX = IR_ID;
  ALU_input1 = A;

  if (IR_EX.op == ADDI || IR_EX.op == SUBI || 
      IR_EX.op == LW   || IR_EX.op == SW )
    ALU_input2 = IR_EX.imm;
  else
    ALU_input2 = B;

  /* calculate ALU output */
  if (IR_EX.op == SUB || IR_EX.op == SUBI)
    ALU_output = ALU_input1 - ALU_input2;
  else
    ALU_output = ALU_input1 + ALU_input2;
}

void MEM_stage() 
{
  /* ------------------------------ MEM stage ----------------------------- */
  IR_MEM = IR_EX;
  mem_addr = ALU_output;

  /* check if data memory access is within bounds */
  if (IR_MEM.op == LW || IR_MEM.op == SW)
  {
    if (mem_addr < 0 || mem_addr >= MAX_WORDS_OF_DATA)
    {
      printf("Exception: out-of-bounds data memory access at PC=%d\n",PC);
      exit(0);
    }
  }

  if(IR_MEM.op == LW)               /* read memory for lw instruction */
    LMD = data_mem[mem_addr];
  else if (IR_MEM.op == SW)         /* or write to memory for sw instruction */
    data_mem[mem_addr] = B;
}

void WB_stage() 
{
  /* ------------------------------ WB stage ------------------------------ */
  /* write to register and check if output register is R0 */
  IR_WB = IR_MEM;
  if (IR_WB.op == ADD || IR_WB.op == SUB) 
  {
    int_regs[IR_WB.rd] = ALU_output;
    wrote_r0 = (IR_WB.rd == R0);
  }
  else if (IR_WB.op == ADDI || IR_WB.op == SUBI) 
  {
    int_regs[IR_WB.rt] = ALU_output;
    wrote_r0 = (IR_WB.rt == R0);
  } 
  else if (IR_WB.op == LW) 
  {
    int_regs[IR_WB.rt] = LMD;
    wrote_r0 = (IR_WB.rt == R0);
  }

  inst_executed++;

  /* if output register is R0, exit with error */
  if (wrote_r0)
  {
    printf("Exception: Attempt to overwrite R0 at PC=%d\n",PC);
    exit(0);
  }
}

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
  cycle=0;                /* simulator cycle count */
  PC=0;                   /* first instruction to execute from inst mem */
  int_regs[R0]=0;         /* register R0 is alway zero */
  inst_executed=0;


  /* Main simulator loop */
  while (PC != (code_length))
  {
    if (cycle >= 4)
      WB_stage();
    else if (cycle >= 3)
      MEM_stage();
    else if (cycle >= 2)
      EX_stage();
    else if (cycle >= 1)
      ID_stage();

    IF_stage();                
    
    PC=NPC;                    /* update PC          */
    cycle+=1;                  /* update cycle count */

    /* check if simuator is stuck in an infinite loop */
    if (cycle>FAIL_SAFE_LIMIT)
    {    
      printf("\n\n *** Runaway program? (Program halted.) ***\n\n");
      break;
    }
  }

  /* print final register values and simulator statistics */
  printf("Final register file values:\n");
  for (i = 0; i < 16; i += 4)
  {
    printf("  R%-2d: %-10d  R%-2d: %-10d",i,int_regs[i],i+1,int_regs[i+1]);
    printf("  R%-2d: %-10d  R%-2d: %-10d\n",i+2,int_regs[i+2],i+3,int_regs[i+3]);
  }
  printf("\nCycles executed: %d\n",cycle);
  printf("IPC:  %6.3f\n", (float)inst_executed/(float)cycle);
  printf("CPI:  %6.3f\n", (float)cycle/(float)inst_executed);
}
