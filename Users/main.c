#include "stm32f10x.h"
#include "stdio.h"
#include "systeminit.h"

typedef unsigned int OS_STK;
typedef void (*OS_TASK)(void);

typedef unsigned int OS_U32;
typedef int OS_S32;
typedef unsigned char OS_U8;
typedef char OS_S8;

/******************Task State********************/
typedef enum OS_TASK_STA
{
    TASK_READY,
    TASK_DELAY,
}OS_TASK_STA;
/************************************************/

/*****************Task Control Block*************/
typedef struct OS_TCB
{
    OS_STK *StkAddr;
    OS_U32 TimeDly;
    OS_TASK_STA State;
}OS_TCB, *OS_TCBP;
/************************************************/

/*****************Public Variable****************/
#define OS_EXCEPT_STK_SIZE  1024
#define TASK_1_STK_SIZE     128
#define TASK_2_STK_SIZE     128
#define TASK_IDLE_STK_SIZE  1024

#define OS_TICKS_PER_SECOND 1000

OS_TCBP osTcbCurPointer;
OS_TCBP osTcbHighRdyPointer;

static OS_STK osCPUExceptStk[OS_EXCEPT_STK_SIZE];
OS_STK *osCPUExceptStkBase;

static OS_TCB task1TCB;
static OS_TCB task2TCB;
static OS_TCB TCB_IDLE;
static OS_STK task1Stack[TASK_1_STK_SIZE];
static OS_STK task2Stack[TASK_2_STK_SIZE];
static OS_STK TASK_IDLE_STK[TASK_IDLE_STK_SIZE];

OS_U32 OS_TimeTick;
OS_U8  g_Prio_Cur;
OS_U8  g_Prio_HighRdy;

/***********************************************/

extern void osStart(void);          // from assemble
extern void osContextSwitch(void);  // from assemble

/*****************CRITIACL SECTION*********************/
extern OS_U32 osCPUSRSave();
extern void osCPUSRRestore(OS_U32 arg);

#define  OS_USE_CRITICAL    OS_U32 cpu_sr;
#define  OS_ENTER_CRITICAL()  {cpu_sr = osCPUSRSave();}
#define  OS_EXIT_CRITICAL()   {osCPUSRRestore(cpu_sr);}
#define  OS_PendSV_Trigger()  osContextSwitch()
/*****************************************************/

/*****************Task Table**************************/
#define OS_TASK_MAX_NUM 32
OS_TCBP OS_TCB_TABLE[OS_TASK_MAX_NUM];
/*****************************************************/

static void delay(uint32_t time);

// void taskSwitch(void)
// {
//    if(osTcbCurPointer == &task1TCB)
//    {
//        osTcbHighRdyPointer=&task2TCB;
//    }
//    else
//    {
//        osTcbHighRdyPointer=&task1TCB;
//    }
//    
//    osContextSwitch();
// }

/*****************************************************
* Function Name: osTaskSwitch
*
* Argument(s): None
*              
* Return: None
*
* Notes: Find the ready and highest task, and take it TCB pointer to 
*        osTcbHighRdyPointer, and take it priority level to g_Prio_HighRdy.
*****************************************************/
void osTaskSwitch(void)
{
    OS_S32 i;
    OS_TCBP tcb_p;
    OS_USE_CRITICAL
        
    for(i = 0; i<OS_TASK_MAX_NUM; i++)
    {
        tcb_p = OS_TCB_TABLE[i];
        if(tcb_p == NULL) 
        {
            continue;
        }
        if(tcb_p->State == TASK_READY)
        {
            break;
        }
    }
    OS_ENTER_CRITICAL();
    osTcbHighRdyPointer = tcb_p;
    g_Prio_HighRdy = i;
    OS_EXIT_CRITICAL();
}

/*****************************************************
* Function Name: osTimeDly
*
* Argument(s): OS_U32 ticks:
*              
* Return: None
*
* Notes: osTimeDly() to current task is during delay state. It passes the delay time
*        to current TCB->TimeDly member, and then call osTaskSwitch, and then trigger 
*        PendSV.
*****************************************************/
void osTimeDly(OS_U32 ticks)
{
    OS_USE_CRITICAL
    
    OS_ENTER_CRITICAL();
    osTcbCurPointer->State = TASK_DELAY;
    osTcbCurPointer->TimeDly = ticks;
    OS_EXIT_CRITICAL();
    osTaskSwitch();
    
    osContextSwitch();      // trigger PendSV interrupt
}

/*************SysTick Handler definition************/
void SysTick_Handler(void)
{
    OS_TCBP tcb_p;
    OS_S32 i;
    OS_USE_CRITICAL
        
    OS_ENTER_CRITICAL();
    ++OS_TimeTick;
    for(i=0; i<OS_TASK_MAX_NUM; i++)
    {
        tcb_p = OS_TCB_TABLE[i];
        if(tcb_p == NULL)
        {
            continue;
        }
        if(tcb_p->State == TASK_DELAY)
        {
            --tcb_p->TimeDly;
            if(tcb_p->TimeDly == 0)
            {
                tcb_p->State = TASK_READY;
            }
        }
    }
    OS_EXIT_CRITICAL();
}

/*****************************************************
* Function Name: osTaskIdle
*
* Argument(s): None
*              
* Return: None
*
* Notes: It runs when no task ready. Set this task the lowest priority.
*        WFE is instruction that set CPU sleep. When interrupt comes, CPU wake
*        and check if have ready task.
*****************************************************/
void osTaskIdle(void)
{
  while(1)
  {
    asm("WFE"); 
    osTaskSwitch();
    osContextSwitch();
  }
}

void osTaskDelete(OS_U8 prio)
{
    if(prio >= OS_TASK_MAX_NUM)
    {
        return;
    }
    OS_TCB_TABLE[prio] = 0;
}

void osTaskEnd(void)
{
    // printf("Task of Prio %d End\n", g_Prio_Cur);
    osTaskDelete(g_Prio_Cur);
    osTaskSwitch();
    osContextSwitch();
}
        
void task_1()
{
    while(1)
    {
        LedA_on;
        delay(200);
        //taskSwitch();
        LedA_off;
        delay(200);
        //taskSwitch();
    }
}

void task_2()
{
    while(1)
    {
        LedB_on;
        delay(200);
        //taskSwitch();
        LedB_off;
        delay(200);
        //taskSwitch();
    }
}

// void task_end(void)
// {
//    LedC_on;
//    while(1)
//    {
//        
//    }
// }

/*****************************************************
* Function Name: osTaskCreate
*
* Argument(s): OS_TCB* tcb:  Current stack pointer
*              OS_TASK task: Function address
*              OS_STK* stk:  Task stack address, the last address of stack array
*              OS_U8 prio: task priority                
*
* Return: None
*
* Notes: 
*****************************************************/
void osTaskCreate(OS_TCB* tcb, OS_TASK task, OS_STK* stk, OS_U8 prio)
{
    OS_USE_CRITICAL
    OS_STK* p_stk;
    if(prio >= OS_TASK_MAX_NUM)
    {
        return;
    }
    
    OS_ENTER_CRITICAL();
    
    p_stk      = stk;
    p_stk      = (OS_STK*)((OS_STK)(p_stk) & 0xFFFFFFF8u);      // Align the address to 8-byte(according to AAPCS), 
                                                                // but will not out of range of stack array. So smart way.
    
    *(--p_stk) = (OS_STK)0x01000000uL;                          // xPSR
    *(--p_stk) = (OS_STK)task;                                  // Entry Point (PC)
    *(--p_stk) = (OS_STK)osTaskEnd;                             // R14 (LR)
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
    tcb->TimeDly=0;
    tcb->State=TASK_READY;
    OS_TCB_TABLE[prio]=tcb;
    
    OS_EXIT_CRITICAL();
}
    
void osInit(void)
{
    OS_S32 i;
    osCPUExceptStkBase = &osCPUExceptStk[OS_EXCEPT_STK_SIZE-1];
    
    asm("CPSID I");
    for(i=0; i<OS_TASK_MAX_NUM; i++)
    {
        OS_TCB_TABLE[i] = 0;
    }
    OS_TimeTick = 0;
    osTaskCreate(&TCB_IDLE, osTaskIdle, &TASK_IDLE_STK[TASK_IDLE_STK_SIZE - 1], OS_TASK_MAX_NUM -1);
}

void osStartSchedule(void)
{
    osTaskSwitch();
    SystemCoreClockUpdate();
    SysTick_Config(SystemCoreClock/OS_TICKS_PER_SECOND);
    osStart();
}

int main(void* p_arg)
{
    ledInit();
    
    //osCPUExceptStkBase = osCPUExceptStk + OS_EXCEPT_STK_SIZE - 1;
    osInit();
    
    osTaskCreate(&task1TCB,task_1,&task1Stack[TASK_1_STK_SIZE-1], 0);
    osTaskCreate(&task2TCB,task_2,&task2Stack[TASK_1_STK_SIZE-1], 1);
    
    // osTcbHighRdyPointer=&task1TCB;
  
    osStartSchedule();
  
  return 0;
}

static void delay(uint32_t time)
{
	time *= 1429;//50000 -> 35.006ms
	while(time --);
}
	