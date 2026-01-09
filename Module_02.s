; ==============================================================================
; File: Mod2_Acquisition.s
; Description: Module 2 - Vital Sign Data Acquisition (Rolling Buffer)
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Acquire_Vitals
    IMPORT  Vital_Index
    IMPORT  HR_Buffer
    IMPORT  BP_Buffer
    IMPORT  O2_Buffer

Acquire_Vitals
    PUSH    {R0-R6, LR}
    
    ; Load Buffer Index
    LDR     R4, =Vital_Index
    LDRH    R5, [R4]        ; R5 = Current Index (0-9)
    LSL     R6, R5, #2      ; R6 = Offset (Index * 4)
    
    ; Store Heart Rate
    LDR     R3, =HR_Buffer
    STR     R0, [R3, R6]
    
    ; Store Blood Pressure
    LDR     R3, =BP_Buffer
    STR     R1, [R3, R6]
    
    ; Store Oxygen
    LDR     R3, =O2_Buffer
    STR     R2, [R3, R6]
    
    ; Increment and Wrap Index
    ADD     R5, R5, #1
    CMP     R5, #10
    MOVEQ   R5, #0          ; Reset to 0 if 10
    STRH    R5, [R4]        ; Save Index
    
    POP     {R0-R6, PC}
    END