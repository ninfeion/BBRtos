///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       15/Aug/2016  18:18:42
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  C:\Ninfeion_Git\BBRtos\Users\main.c
//    Command line =  
//        C:\Ninfeion_Git\BBRtos\Users\main.c -D USE_STDPERIPH_DRIVER -lb
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
//    List file    =  C:\Ninfeion_Git\BBRtos\Debug\List\main.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN GPIO_ResetBits
        EXTERN GPIO_SetBits
        EXTERN cycleCounterInit
        EXTERN delay_current_ms
        EXTERN ledInit
        EXTERN sysclockInit
        EXTERN systickInit

        PUBLIC ledBing
        PUBLIC main
        PUBLIC runFunction


        SECTION `.text`:CODE:NOROOT(1)
        THUMB
ledBing:
        PUSH     {R7,LR}
        MOVS     R1,#+16
        LDR.N    R0,??DataTable1  ;; 0x40010800
        BL       GPIO_SetBits
        MOV      R0,#+1000
        BL       delay_current_ms
        MOVS     R1,#+16
        LDR.N    R0,??DataTable1  ;; 0x40010800
        BL       GPIO_ResetBits
        MOV      R0,#+1000
        BL       delay_current_ms
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
runFunction:
        PUSH     {R7,LR}
        BLX      R0
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
main:
        PUSH     {R7,LR}
        BL       sysclockInit
        BL       cycleCounterInit
        BL       systickInit
        BL       ledInit
??main_0:
        LDR.N    R0,??DataTable1_1
        BL       runFunction
        B.N      ??main_0

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1:
        DC32     0x40010800

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable1_1:
        DC32     ledBing

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
// 76 bytes in section .text
// 
// 76 bytes of CODE memory
//
//Errors: none
//Warnings: 1
