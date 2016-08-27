
NVIC_INT_CTRL   EQU     0xE000ED04      ; Interrupt control state register.
NVIC_SYSPRI14   EQU     0xE000ED22      ; System priority register (priority 14).
NVIC_PENDSV_PRI EQU           0xFF      ; PendSV priority value (lowest).
NVIC_PENDSVSET  EQU     0x10000000      ; Value to trigger PendSV exception.

    RSEG SCHE:CODE:NOROOT(2)            ; RSEG : begins a section
    THUMB                               ; THUMB: interpret subsequent instructions as Thumb mode 
    
    ; import external symbol
    EXTERN osCPUExceptStkBase
    
    EXTERN osTcbCurPointer
    EXTERN osTcbHighRdyPointer
    
    ; export symbols to other modules (32-bit)
    PUBLIC osStart
    PUBLIC osContextSwitch
    
    PUBLIC PendSV_Handler
    PUBLIC osCPUSRSave
    PUBLIC osCPUSRRestore
    
osContextSwitch
    LDR     R0, =NVIC_INT_CTRL
    LDR     R1, =NVIC_PENDSVSET
    STR     R1, [R0]            ; triggrt the PendSV
    BX      LR
    
osStart
    LDR     R0, =NVIC_SYSPRI14
    LDR     R1, =NVIC_PENDSV_PRI
    STRB    R1, [R0]            ; set PendSV priority to the lowest
    
    MOVS    R0, #0
    MSR     PSP,R0              ; set PSP to 0
    
    LDR     R0, =osCPUExceptStkBase
    LDR     R1, [R0]
    MSR     MSP, R1             ; initialize the MSP 
    
    LDR     R0, =NVIC_INT_CTRL  
    LDR     R1, =NVIC_PENDSVSET
    STR     R1, [R0]            ; trigger the PendSV exception
    
    CPSIE   I                   ; enable interrupt in process level
    
osStartHang
    B       osStartHang         ; will not get here normally
    
PendSV_Handler
    ; save last process         ; PUSH 8 registers automatically, address order is(increase):
                                ; 1.xPSR 2.PC 3.R14(LR) 4.R12 5.R3 6.R2 7.R1 8.R0
                                
    ; when entry interrupt, LR trans to EXEC_RETURN
    CPSID   I                   ; disable all inturrpt
    MRS     R0, PSP             ; get the new PSP stack top pointer
    CBZ     R0, osCPUPendSVHandlerNoSave
    
    SUBS    R0, R0, #0x20       ; PUSH R4-R11
    STM     R0, {R4-R11}        
    
    LDR     R1, =osTcbCurPointer; osTcbCurPointer -> type is pointer
    LDR     R1, [R1]
    STR     R0, [R1]            ; PUSH SP
    
osCPUPendSVHandlerNoSave    
    ; switch into next process
    LDR     R0, =osTcbCurPointer
    LDR     R1, =osTcbHighRdyPointer      
    LDR     R2, [R1]            ; [R1]->R2  
    STR     R2, [R0]            ; R2->[R0]; new SP which will be switched into.
    
    LDR     R0, [R2]            ; get new SP.
    
    LDM     R0, {R4-R11}
    ADDS    R0, R0, #0x20
    
    MSR     PSP, R0
    ORR     LR, LR, #0x04        ; ensure EXEC_RETURN bit[32:2] is 1.
  
    CPSIE   I 
    BX      LR                   ; BX <reg> -> interrupt return.
    ; interrupt return, POP 8 registers automatically.
            
osCPUSRSave
    MRS     R0, PRIMASK
    CPSID   I
    BX      LR
    
osCPUSRRestore
    MSR     PRIMASK, R0          ; R0 is passing in argument.
    BX      LR

    END
