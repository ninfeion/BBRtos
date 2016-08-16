///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       15/Aug/2016  18:18:42
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  
//        C:\Ninfeion_Git\BBRtos\Users\Stm32f10x_StdDrivers\Lib\src\misc.c
//    Command line =  
//        C:\Ninfeion_Git\BBRtos\Users\Stm32f10x_StdDrivers\Lib\src\misc.c -D
//        USE_STDPERIPH_DRIVER -lb C:\Ninfeion_Git\BBRtos\Debug\List\ -o
//        C:\Ninfeion_Git\BBRtos\Debug\Obj\ --no_cse --no_unroll --no_inline
//        --no_code_motion --no_tbaa --no_clustering --no_scheduling --debug
//        --endian=little --cpu=Cortex-M3 -e --fpu=None --dlib_config "C:\Extra
//        Software\IAR Systems\Embedded Workbench
//        7.0\arm\INC\c\DLib_Config_Normal.h" -I
//        C:\Ninfeion_Git\BBRtos\..\BBRtos\Users\Startup\ -I
//        C:\Ninfeion_Git\BBRtos\..\BBRtos\Users\Stm32f10x_StdDrivers\Lib\inc\
//        -I C:\Ninfeion_Git\BBRtos\..\BBRtos\ -Ol -I "C:\Extra Software\IAR
//        Systems\Embedded Workbench 7.0\arm\CMSIS\Include\"
//    List file    =  C:\Ninfeion_Git\BBRtos\Debug\List\misc.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        PUBLIC NVIC_Init
        PUBLIC NVIC_PriorityGroupConfig
        PUBLIC NVIC_SetVectorTable
        PUBLIC NVIC_SystemLPConfig
        PUBLIC SysTick_CLKSourceConfig


        SECTION `.text`:CODE:NOROOT(1)
        THUMB
NVIC_PriorityGroupConfig:
        LDR.N    R1,??DataTable4  ;; 0x5fa0000
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable4_1  ;; 0xe000ed0c
        STR      R0,[R1, #+0]
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
NVIC_Init:
        PUSH     {R4}
        MOVS     R1,#+0
        MOVS     R2,#+0
        MOVS     R3,#+15
        LDRB     R4,[R0, #+3]
        CMP      R4,#+0
        BEQ.N    ??NVIC_Init_0
        LDR.N    R1,??DataTable4_1  ;; 0xe000ed0c
        LDR      R1,[R1, #+0]
        ANDS     R1,R1,#0x700
        RSBS     R1,R1,#+1792
        LSRS     R1,R1,#+8
        RSBS     R2,R1,#+4
        LSRS     R3,R3,R1
        LDRB     R1,[R0, #+1]
        LSLS     R1,R1,R2
        LDRB     R2,[R0, #+2]
        ANDS     R2,R3,R2
        ORRS     R1,R2,R1
        LSLS     R1,R1,#+4
        LDR.N    R2,??DataTable4_2  ;; 0xe000e400
        LDRB     R3,[R0, #+0]
        STRB     R1,[R3, R2]
        MOVS     R1,#+1
        LDRB     R2,[R0, #+0]
        ANDS     R2,R2,#0x1F
        LSLS     R1,R1,R2
        LDR.N    R2,??DataTable4_3  ;; 0xe000e100
        LDRB     R0,[R0, #+0]
        ASRS     R0,R0,#+5
        STR      R1,[R2, R0, LSL #+2]
        B.N      ??NVIC_Init_1
??NVIC_Init_0:
        MOVS     R1,#+1
        LDRB     R2,[R0, #+0]
        ANDS     R2,R2,#0x1F
        LSLS     R1,R1,R2
        LDR.N    R2,??DataTable4_4  ;; 0xe000e180
        LDRB     R0,[R0, #+0]
        ASRS     R0,R0,#+5
        STR      R1,[R2, R0, LSL #+2]
??NVIC_Init_1:
        POP      {R4}
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
NVIC_SetVectorTable:
        LDR.N    R2,??DataTable4_5  ;; 0x1fffff80
        ANDS     R1,R2,R1
        ORRS     R0,R1,R0
        LDR.N    R1,??DataTable4_6  ;; 0xe000ed08
        STR      R0,[R1, #+0]
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
NVIC_SystemLPConfig:
        UXTB     R1,R1            ;; ZeroExt  R1,R1,#+24,#+24
        CMP      R1,#+0
        BEQ.N    ??NVIC_SystemLPConfig_0
        LDR.N    R1,??DataTable4_7  ;; 0xe000ed10
        LDR      R1,[R1, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        ORRS     R0,R0,R1
        LDR.N    R1,??DataTable4_7  ;; 0xe000ed10
        STR      R0,[R1, #+0]
        B.N      ??NVIC_SystemLPConfig_1
??NVIC_SystemLPConfig_0:
        LDR.N    R1,??DataTable4_7  ;; 0xe000ed10
        LDR      R1,[R1, #+0]
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        BICS     R0,R1,R0
        LDR.N    R1,??DataTable4_7  ;; 0xe000ed10
        STR      R0,[R1, #+0]
??NVIC_SystemLPConfig_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
SysTick_CLKSourceConfig:
        CMP      R0,#+4
        BNE.N    ??SysTick_CLKSourceConfig_0
        LDR.N    R0,??DataTable4_8  ;; 0xe000e010
        LDR      R0,[R0, #+0]
        ORRS     R0,R0,#0x4
        LDR.N    R1,??DataTable4_8  ;; 0xe000e010
        STR      R0,[R1, #+0]
        B.N      ??SysTick_CLKSourceConfig_1
??SysTick_CLKSourceConfig_0:
        LDR.N    R0,??DataTable4_8  ;; 0xe000e010
        LDR      R0,[R0, #+0]
        BICS     R0,R0,#0x4
        LDR.N    R1,??DataTable4_8  ;; 0xe000e010
        STR      R0,[R1, #+0]
??SysTick_CLKSourceConfig_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4:
        DC32     0x5fa0000

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_1:
        DC32     0xe000ed0c

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_2:
        DC32     0xe000e400

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_3:
        DC32     0xe000e100

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_4:
        DC32     0xe000e180

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_5:
        DC32     0x1fffff80

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_6:
        DC32     0xe000ed08

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_7:
        DC32     0xe000ed10

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable4_8:
        DC32     0xe000e010

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
// 224 bytes in section .text
// 
// 224 bytes of CODE memory
//
//Errors: none
//Warnings: none
