#include "stm32f10x.h"
#include "systeminit.h"

#define OS_EXCEPT_STK_SIZE  1024
#define TASK_1_STK_SIZE     1024
#define TASK_2_STK_SIZE     1024

typedef unsigned int OS_STK;
typedef void (*OS_TASK)(void);

typedef struct OS_TCB
{
    OS_STK *StkAddr;
}OS_TCB, *OS_TCBP;

OS_TCBP osTcbCurPointer;
OS_TCBP osTcbHighRdyPointer;

static OS_STK osCPUExceptStk[OS_EXCEPT_STK_SIZE];
OS_STK *osCPUExceptStkBase;

static OS_TCB task1TCB;
static OS_TCB task2TCB;
static OS_STK task1Stack[TASK_1_STK_SIZE];
static OS_STK task2Stack[TASK_2_STK_SIZE];

extern void osStart(void);
extern void osContextSwitch(void);

static void delay(uint32_t time);

void taskSwitch(void)
{
    if(osTcbCurPointer == &task1TCB)
    {
        osTcbHighRdyPointer=&task2TCB;
    }
    else
    {
        osTcbHighRdyPointer=&task1TCB;
    }
    
    osContextSwitch();
}

void task_1()
{
    while(1)
    {
        LedA_on;
        delay(200);
        taskSwitch();
        LedA_off;
        delay(200);
        taskSwitch();
    }
}

void task_2()
{
    while(1)
    {
        LedB_on;
        delay(200);
        taskSwitch();
        LedB_off;
        delay(200);
        taskSwitch();
    }
}

void task_end(void)
{
    LedC_on;
    while(1)
    {
        
    }
}

void taskCreate(OS_TCB *tcb, OS_TASK task, OS_STK *stk)
{
    OS_STK *p_stk;
    
    p_stk      = stk;
    p_stk      = (OS_STK *)((OS_STK)(p_stk) & 0xFFFFFFF8u);
    
    *(--p_stk) = (OS_STK)0x01000000uL;                          //xPSR
    *(--p_stk) = (OS_STK)task;                                  // Entry Point
    *(--p_stk) = (OS_STK)task_end;                              // R14 (LR)
    *(--p_stk) = (OS_STK)0x12121212uL;                          // R12
    *(--p_stk) = (OS_STK)0x03030303uL;                          // R3
    *(--p_stk) = (OS_STK)0x02020202uL;                          // R2
    *(--p_stk) = (OS_STK)0x01010101uL;                          // R1
    *(--p_stk) = (OS_STK)0x00000000u;                           // R0
    
    *(--p_stk) = (OS_STK)0x11111111uL;                          // R11
    *(--p_stk) = (OS_STK)0x10101010uL;                          // R10
    *(--p_stk) = (OS_STK)0x09090909uL;                          // R9
    *(--p_stk) = (OS_STK)0x08080808uL;                          // R8
    *(--p_stk) = (OS_STK)0x07070707uL;                          // R7
    *(--p_stk) = (OS_STK)0x06060606uL;                          // R6
    *(--p_stk) = (OS_STK)0x05050505uL;                          // R5
    *(--p_stk) = (OS_STK)0x04040404uL;                          // R4
    
    tcb->StkAddr=p_stk;
}
    
int main(void* p_arg)
{
    ledInit();
    
    osCPUExceptStkBase = osCPUExceptStk + OS_EXCEPT_STK_SIZE - 1;
  
    taskCreate(&task1TCB,task_1,&task1Stack[TASK_1_STK_SIZE-1]);
    taskCreate(&task2TCB,task_2,&task2Stack[TASK_1_STK_SIZE-1]);
    
    osTcbHighRdyPointer=&task1TCB;
  
    osStart();
  
  return 0;
}

static void delay(uint32_t time)
{
	time *= 1429;//50000 -> 35.006ms
	while(time --);
}
	