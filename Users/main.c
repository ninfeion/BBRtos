#include "stm32f10x.h"
#include "stm32f10x_gpio.h"
#include "stm32f10x_rcc.h"
#include "systeminit.h"
#include "delay.h"

// Cooperative Multitasking
uint32_t Stack[200]; 

register uint32_t OSRdyTbI          asm("r4")
register uint32_t OSTaskRunningPrio asm("r5")

#define OS_TASKS 3  // set the number of running task
struct TaskCtrBlock // task control block
{
    uint32_t OSTaskStackTop; // stack top of task saving
    uint32_t OSWaitTick;     // task delay tick
}TCB[OS_TASKS + 1];


// prevent be used by compiler
register uint32_t tempR6 asm("r6");
register uint32_t tempR7 asm("r7");
register uint32_t tempR8 asm("r8");
register uint32_t tempR9 asm("r9");
register uint32_t tempR10 asm("r10");
register uint32_t tempR11 asm("r11");
register uint32_t tempR12 asm("r12");


// creak task
void OSTaskCreate(void (*Task)(void), uint32_t *Stack, uint_32 TaskID)
{
    uint8_t i;
    *Stack-- = (uint32_t)Task;
    
    /**
    * *Stack-- = 0x00;      // R1 __zero_reg__
    * *Stack-- = 0x00;      // R0 __tmp_reg__
    * *Stack-- = 0x80;      // SREG in the task, enabled global interrupt
    *
    */
    for(i=0; i<7; i++)      // the seven register used by compiler, but this is arm, i don't know how to alter it, 
                            // i should read the arm C manual
    {
        *Stack-- = i;       // describe the function of register
    }
    
    TCB[TaskID].OSTaskStackTop = (uint32_t)Stack; // save the top of man-make stack to the array of stack 
    OSRdyTbI |= 0x01<<TaskID;   // task ready table is ready
}


// start task scheduling, from the lowest priority task
void OSStartTask()
{
    OSTaskRunningPrio = OS_TASKS;
    asm("MOV SP, TCB[OS_TASKS].OSTaskStackTop + 17;
}
        
 
// task scheduling
void OSSched(void)
{
    // PUSH according to the order of save register in interrupt, simulation of after a interrupt and the status of PUSH
    
    // avr:
    asm("PUSH __zero_reg__        \n" // R1
        "PUSH __tmp_reg__         \n" // R0
        "IN __tmp_reg__, __SREG__ \n" // saving the status register SREG 
        "PUSH __tmp_reg__         \n"
        "CLR __zero_reg__         \n" // R0 clear to zero
        "PUSH R18                 \n" // not the register which used by C compiler
        "PUSH R19                 \n"
        "PUSH R20                 \n"
        "PUSH R21                 \n"
        "PUSH R22                 \n"
        "PUSH R23                 \n"
        "PUSH R24                 \n"
        "PUSH R25                 \n"
        "PUSH R26                 \n"
        "PUSH R27                 \n"
        "PUSH R30                 \n"
        "PUSH R31                 \n"
        "PUSH R28                 \n"
        "PUSH R29                 \n");
    
    TCB[OSTaskRunningPrio].OSTaskStackTop = SP; // saving the stack bottom of running task
            
    uint32_t OSNextTaskID; // new a space in the now exist stack
    for(OSNextTaskID = 0;  // task scheduling
        OSNextTaskID < OS_TASKS && !(OSRdyTbI & (0x01 << OSNextTaskID));
        OSNextTaskID ++);
    {
        OSTaskRunningPrio = OSNextTaskID;
    }
    
    cli(); // protect the stack conversion
    SP = TCB[OSTaskRunningPrio].OSTaskStackTop;
    sei();
    
    // according to the order of POP when interrupt 
    asm("POP R29                    \n"
        "POP R28                    \n"
        "POP R31                    \n"
        "POP R30                    \n"
        "POP R27                    \n"
        "POP R26                    \n"
        "POP R25                    \n"
        "POP R24                    \n"
        "POP R23                    \n"
        "POP R22                    \n"
        "POP R21                    \n"
        "POP R20                    \n"
        "POP R19                    \n"
        "POP R18                    \n"
        "POP __tmp_reg__            \n"   // POP SERG 
        "OUT __SREG__, __temp_reg__ \n"   // SERG recovery
        "POP __tmp_reg__            \n"   // POP R0
        "POP __zero_reg__           \n"); // POP R1
    // POP finish when interrupt
}
        

void OSTimeDly(uint32_t ticks)
{
    if(ticks) // enabled when during delay
    {
        OSRdyTbI &= ~(0x01 << OSTaskRunningPrio);
        TCB[OSTaskRunningPrio].OSWaitTick = ticks;
        OSSched(); // scheduling from start
    }
}
        

// AVR
void TCN0Init(void) // time count 0 (timer 0)
{
    TCCR0 = 0;
    TCCR0 |= (1<<CS02); // 256 prescale
    TIMSK |= (1<<TOIE0); // T0 overflow interrupt enabled
    TCNT0 = 100; // Set count init number
}
        
        
SIGNAL(SIG_OCERFLOW0)
{
    uint8_t i;
    for(i=0; i<OS_TASKS; i++) // task clock
    {
        if(TCB[i].OSWaitTick)
        {
            TCB[i].OSWaitTick--;
            if(TCB[i].OSWaitTick == 0) // when task clock down count, should count by timer
            {
                OSRdyTbI |= (0x01<<i);
            }
        }
    }
    TCNT0 = 100;
}
        
        
void Task0()
{
    while(1)
    {
        
    }
}
        
        
void Task1()
{
    while(1)
    {
        
    }
}
        
        
void Task2()
{
    while(1)
    {
        
    }
}
        
    
void TaskScheduler()
{
    while(1)
    {
        OSSched(); // scheduling again and again
    }
}
        
        
// void ledBing(void)
// {
//    LedA_on;
//    delay_current_ms(1000);
//    LedA_off;
//    delay_current_ms(1000);
// }


// void runFunctionInStack(void (*pfun)(), uint32_t *pStack)
// {
//    *pStack-- = (uint32_t)pfun;
//    asm("MOV SP, r1");
// }


void main(void)
{
    // sysclockInit();
	// cycleCounterInit();
    // systickInit();
    
    // ledInit();
    // while(1)
    // {
        // runFunctionInStack(ledBing, &Stack[99]);
    // }
    TCN0Init();
    OSRdyTbI = 0;
    OSTaskRunningPrio = 0;
    OSTaskCreate(Task0, &Stack[49], 0);
    OSTaskCreate(Task1, &Stack[99], 1);
    OSTaskCreate(Task2, &Stack[149],2);
    OSTaskCreate(TaskScheduler, &Stack[199], OS_TASKS);
    OSSTartTask();
}

