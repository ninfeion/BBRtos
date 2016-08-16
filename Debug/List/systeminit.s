///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       15/Aug/2016  18:18:44
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  C:\Ninfeion_Git\BBRtos\Users\systeminit.c
//    Command line =  
//        C:\Ninfeion_Git\BBRtos\Users\systeminit.c -D USE_STDPERIPH_DRIVER -lb
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
//    List file    =  C:\Ninfeion_Git\BBRtos\Debug\List\systeminit.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        EXTERN FLASH_PrefetchBufferCmd
        EXTERN FLASH_SetLatency
        EXTERN GPIO_Init
        EXTERN GPIO_ResetBits
        EXTERN RCC_APB2PeriphClockCmd
        EXTERN RCC_DeInit
        EXTERN RCC_GetFlagStatus
        EXTERN RCC_GetSYSCLKSource
        EXTERN RCC_HCLKConfig
        EXTERN RCC_HSEConfig
        EXTERN RCC_PCLK1Config
        EXTERN RCC_PCLK2Config
        EXTERN RCC_PLLCmd
        EXTERN RCC_PLLConfig
        EXTERN RCC_SYSCLKConfig
        EXTERN RCC_WaitForHSEStartUp

        PUBLIC ledInit
        PUBLIC sysclockInit
        PUBLIC systickInit


        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp void NVIC_SetPriority(IRQn_Type, uint32_t)
NVIC_SetPriority:
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        CMP      R0,#+0
        BPL.N    ??NVIC_SetPriority_0
        LSLS     R1,R1,#+4
        LDR.N    R2,??DataTable2  ;; 0xe000ed18
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        ANDS     R0,R0,#0xF
        ADDS     R0,R0,R2
        STRB     R1,[R0, #-4]
        B.N      ??NVIC_SetPriority_1
??NVIC_SetPriority_0:
        LSLS     R1,R1,#+4
        LDR.N    R2,??DataTable2_1  ;; 0xe000e400
        SXTB     R0,R0            ;; SignExt  R0,R0,#+24,#+24
        STRB     R1,[R0, R2]
??NVIC_SetPriority_1:
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
// static __interwork __softfp uint32_t SysTick_Config(uint32_t)
SysTick_Config:
        PUSH     {R7,LR}
        SUBS     R1,R0,#+1
        CMP      R1,#+16777216
        BCC.N    ??SysTick_Config_0
        MOVS     R0,#+1
        B.N      ??SysTick_Config_1
??SysTick_Config_0:
        SUBS     R0,R0,#+1
        LDR.N    R1,??DataTable2_2  ;; 0xe000e014
        STR      R0,[R1, #+0]
        MOVS     R1,#+15
        MOVS     R0,#-1
        BL       NVIC_SetPriority
        MOVS     R0,#+0
        LDR.N    R1,??DataTable2_3  ;; 0xe000e018
        STR      R0,[R1, #+0]
        MOVS     R0,#+7
        LDR.N    R1,??DataTable2_4  ;; 0xe000e010
        STR      R0,[R1, #+0]
        MOVS     R0,#+0
??SysTick_Config_1:
        POP      {R1,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
sysclockInit:
        PUSH     {R7,LR}
        BL       RCC_DeInit
        MOVS     R0,#+65536
        BL       RCC_HSEConfig
        BL       RCC_WaitForHSEStartUp
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        CMP      R0,#+1
        BNE.N    ??sysclockInit_0
        MOVS     R0,#+0
        BL       RCC_HCLKConfig
        MOVS     R0,#+0
        BL       RCC_PCLK2Config
        MOV      R0,#+1024
        BL       RCC_PCLK1Config
        MOVS     R0,#+2
        BL       FLASH_SetLatency
        MOVS     R0,#+16
        BL       FLASH_PrefetchBufferCmd
        MOVS     R1,#+1835008
        MOVS     R0,#+65536
        BL       RCC_PLLConfig
        MOVS     R0,#+1
        BL       RCC_PLLCmd
??sysclockInit_1:
        MOVS     R0,#+57
        BL       RCC_GetFlagStatus
        CMP      R0,#+0
        BEQ.N    ??sysclockInit_1
        MOVS     R0,#+2
        BL       RCC_SYSCLKConfig
??sysclockInit_2:
        BL       RCC_GetSYSCLKSource
        CMP      R0,#+8
        BNE.N    ??sysclockInit_2
        MOVS     R0,#+1
        B.N      ??sysclockInit_3
??sysclockInit_0:
        MOVS     R0,#+0
??sysclockInit_3:
        POP      {R1,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
systickInit:
        PUSH     {R7,LR}
        MOVS     R0,#+72
        BL       SysTick_Config
        UXTB     R0,R0            ;; ZeroExt  R0,R0,#+24,#+24
        POP      {R1,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(1)
        THUMB
ledInit:
        PUSH     {R7,LR}
        MOVS     R1,#+1
        MOVS     R0,#+5
        BL       RCC_APB2PeriphClockCmd
        MOVS     R0,#+240
        STRH     R0,[SP, #+0]
        MOVS     R0,#+2
        STRB     R0,[SP, #+2]
        MOVS     R0,#+16
        STRB     R0,[SP, #+3]
        ADD      R1,SP,#+0
        LDR.N    R0,??DataTable2_5  ;; 0x40010800
        BL       GPIO_Init
        MOVS     R1,#+16
        LDR.N    R0,??DataTable2_5  ;; 0x40010800
        BL       GPIO_ResetBits
        MOVS     R1,#+128
        LDR.N    R0,??DataTable2_5  ;; 0x40010800
        BL       GPIO_ResetBits
        MOVS     R1,#+64
        LDR.N    R0,??DataTable2_5  ;; 0x40010800
        BL       GPIO_ResetBits
        MOVS     R1,#+32
        LDR.N    R0,??DataTable2_5  ;; 0x40010800
        BL       GPIO_ResetBits
        POP      {R0,PC}          ;; return

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2:
        DC32     0xe000ed18

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_1:
        DC32     0xe000e400

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_2:
        DC32     0xe000e014

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_3:
        DC32     0xe000e018

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_4:
        DC32     0xe000e010

        SECTION `.text`:CODE:NOROOT(2)
        SECTION_TYPE SHT_PROGBITS, 0
        DATA
??DataTable2_5:
        DC32     0x40010800

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
// 292 bytes in section .text
// 
// 292 bytes of CODE memory
//
//Errors: none
//Warnings: none
