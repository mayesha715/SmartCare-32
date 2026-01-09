; ==============================================================================
; File: Mod9_Sort.s
; Description: Module 9 - Sorting Patients by Criticality (Alert Count)
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Sort_Patients
    IMPORT  Patient_Base_Addr
    IMPORT  Patient_Count

STRUCT_SIZE EQU 28          ; 24 bytes data + 4 bytes Alert Count

Sort_Patients
    PUSH    {R4-R11, LR}
    
    LDR     R0, =Patient_Base_Addr
    LDR     R1, =Patient_Count
    LDR     R1, [R1]
    SUB     R1, R1, #1      ; R1 = Outer Loop Counter (N-1)
    
Outer_Loop
    CMP     R1, #0
    BLE     End_Sort
    
    MOV     R2, #0          ; R2 = Inner Loop Counter
    MOV     R3, R0          ; R3 = Current Struct Pointer
    
Inner_Loop
    CMP     R2, R1
    BGE     Next_Outer
    
    ADD     R4, R3, #STRUCT_SIZE    ; R4 = Next Struct Pointer
    
    ; Compare Alert Counts (Offset 24)
    LDR     R5, [R3, #24]   ; Alerts of A
    LDR     R6, [R4, #24]   ; Alerts of B
    
    ; Sort Descending (We want Higher Alerts at Lower Address)
    CMP     R5, R6
    BGE     No_Swap         ; If A >= B, order is correct
    
    ; --- SWAP BLOCK (28 Bytes) ---
    MOV     R7, #0          ; Swap Byte Counter
Swap_Bytes
    CMP     R7, #STRUCT_SIZE
    BGE     No_Swap
    
    LDRB    R8, [R3, R7]    ; Load Byte A
    LDRB    R9, [R4, R7]    ; Load Byte B
    
    STRB    R9, [R3, R7]    ; Store B in A
    STRB    R8, [R4, R7]    ; Store A in B
    
    ADD     R7, R7, #1
    B       Swap_Bytes
    
No_Swap
    ADD     R2, R2, #1
    ADD     R3, R3, #STRUCT_SIZE
    B       Inner_Loop
    
Next_Outer
    SUB     R1, R1, #1
    B       Outer_Loop
    
End_Sort
    POP     {R4-R11, PC}
    END