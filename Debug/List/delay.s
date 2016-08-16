///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       15/Aug/2016  18:18:42
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  C:\Ninfeion_Git\BBRtos\Users\delay.c
//    Command line =  
//        C:\Ninfeion_Git\BBRtos\Users\delay.c -D USE_STDPERIPH_DRIVER -lb
//        C:\Ninfeion_Git\BBRtos\Debug\List\ -o
//        C:\Ninfeion_Git\BBRtos\Debug\Obj\ --no_cse --no_unroll --no_inline
//        --no_code_motion --no_tbaa --no_clustering --no_scheduling --debug
//        --endian=little --cpu=Cortex-M3 -e --fpu=None --dlib_config "C:\Extra
//        Software\IAR Systems\Embedded Workbench
//        7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        C:\Ninfeion_Git\BBRtos\..\BBRtos\Users\Startup\ -I
//        C:\Ninfeion_Git\BBRtos\..\BBRtos\Users\Stm32f10x_StdDrivers\Lib\inc\
//        -I C:\Ninfeion_Git\BBRtos\..\BBRtos\ -Ol -I "C:\Extra Software\IAR
//        Systems\Embedded Workbench 7.0\arm\CMSIS\Include\"
//    List file    =  C:\Ninfeion_Git\BBRtos\Debug\List\delay.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN RCC_GetClocksFreq

        PUBLIC SysTick_Handler
        PUBLIC currentTime
        PUBLIC cycleCounterInit
        PUBLIC delay_current_ms
        PUBLIC delay_current_us
        PUBLIC sysTickUptime


        SECTION `.bss`:DATA:REORDER:NOROOT(2)
usTicks:
        DS8 4

        SECTION `.bss`:DATA:REORDER:NOROOT(2)
sysTickUptime:
        DS8 4

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
cycleCounterInit:
        PUSH     {LR}
        SUB      SP,SP,#+20
        ADD      R0,SP,#+0
        BL       RCC_GetClocksFreq
        LDR      R0,[SP, #+0]
        LDR.N    R1,??DataTable2  ;; 0xf4240
        UDIV     R0,R0,R1
        LDR.N    R1,??DataTable2_1
        STR      R0,[R1, #+0]
        ADD      SP,SP,#+20
        POP      {PC}             ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
SysTick_Handler:
        LDR.N    R0,??DataTable2_2
        LDR      R0,[R0, #+0]
        ADDS     R0,R0,#+1
        LDR.N    R1,??DataTable2_2
        STR      R0,[R1, #+0]
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
currentTime:
??currentTime_0:
        LDR.N    R0,??DataTable2_2
        LDR      R0,[R0, #+0]
        LDR.N    R1,??DataTable2_3  ;; 0xe000e018
        LDR      R1,[R1, #+0]
        LDR.N    R2,??DataTable2_2
        LDR      R2,[R2, #+0]
        CMP      R0,R2
        BNE.N    ??currentTime_0
        LDR.N    R2,??DataTable2_1
        LDR      R2,[R2, #+0]
        SUBS     R1,R2,R1
        LDR.N    R2,??DataTable2_1
        LDR      R2,[R2, #+0]
        UDIV     R1,R1,R2
        ADDS     R0,R1,R0
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC32     0xf4240

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     usTicks

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     sysTickUptime

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_3:
        DC32     0xe000e018

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
delay_current_us:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
        BL       currentTime
        MOVS     R5,R0
??delay_current_us_0:
        BL       currentTime
        SUBS     R0,R0,R5
        CMP      R0,R4
        BCC.N    ??delay_current_us_0
        POP      {R0,R4,R5,PC}    ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
delay_current_ms:
        PUSH     {R3-R5,LR}
        MOVS     R4,R0
        BL       currentTime
        MOVS     R5,R0
??delay_current_ms_0:
        BL       currentTime
        SUBS     R0,R0,R5
        MOV      R1,#+1000
        MUL      R1,R1,R4
        CMP      R0,R1
        BCC.N    ??delay_current_ms_0
        POP      {R0,R4,R5,PC}    ;; return

        SECTION `.iar_vfe_header`:DATA:NOALLOC:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
        DC32 0

        SECTION __DLIB_PERTHREAD:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        SECTION __DLIB_PERTHREAD_init:DATA:REORDER:NOROOT(0)
        SECTION_TYPE SHT_PROGBITS, 0

        END
// 
//   8 bytes in section .bss
// 140 bytes in section .text
// 
// 140 bytes of CODE memory
//   8 bytes of DATA memory
//
//Errors: none
//Warnings: 1
