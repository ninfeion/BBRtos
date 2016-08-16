///////////////////////////////////////////////////////////////////////////////
//
// IAR ANSI C/C++ Compiler V7.20.2.7424/W32 for ARM       15/Aug/2016  18:18:42
// Copyright 1999-2014 IAR Systems AB.
//
//    Cpu mode     =  thumb
//    Endian       =  little
//    Source file  =  C:\Ninfeion_Git\BBRtos\Users\Startup\core_cm3.c
//    Command line =  
//        C:\Ninfeion_Git\BBRtos\Users\Startup\core_cm3.c -D
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
//    List file    =  C:\Ninfeion_Git\BBRtos\Debug\List\core_cm3.s
//
///////////////////////////////////////////////////////////////////////////////

        #define SHT_PROGBITS 0x1

        PUBLIC __LDREXB
        PUBLIC __LDREXH
        PUBLIC __LDREXW
        PUBLIC __RBIT
        PUBLIC __REV16
        PUBLIC __STREXB
        PUBLIC __STREXH
        PUBLIC __STREXW
        PUBLIC __get_MSP
        PUBLIC __get_PSP
        PUBLIC __set_MSP
        PUBLIC __set_PSP


        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__get_PSP:
        mrs r0, psp
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__set_PSP:
        msr psp, r0
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__get_MSP:
        mrs r0, msp
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__set_MSP:
        msr msp, r0
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__REV16:
        rev16 r0, r0
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__RBIT:
        rbit r0, r0
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__LDREXB:
        ldrexb r0, [r0]
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__LDREXH:
        ldrexh r0, [r0]
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__LDREXW:
        ldrex r0, [r0]
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__STREXB:
        strexb r0, r0, [r1]
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__STREXH:
        strexh r0, r0, [r1]
        bx lr
        BX       LR               ;; return

        SECTION `.text`:CODE:NOROOT(2)
        THUMB
__STREXW:
        strex r0, r0, [r1]
        bx lr
        BX       LR               ;; return

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
// 94 bytes in section .text
// 
// 94 bytes of CODE memory
//
//Errors: none
//Warnings: none
