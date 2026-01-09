; ==============================================================================
; File: Mod5_Treatment.s
; Description: Module 5 - Treatment Cost Computation
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Compute_Treatment_Cost
    IMPORT  Patient_Base_Addr
    IMPORT  Current_Bill

Compute_Treatment_Cost
    PUSH    {LR}
    LDR     R0, =Patient_Base_Addr
    LDRB    R1, [R0, #12]       ; Load Treatment Code as BYTE (Offset 12)
    
    ; Boundary Guard
    CMP     R1, #3
    MOVGT   R1, #0              ; Default to 0 if invalid
    
    ; Lookup using conditional branches
    CMP     R1, #0
    BEQ     Treat_0
    CMP     R1, #1
    BEQ     Treat_1
    CMP     R1, #2
    BEQ     Treat_2
    
    ; Default/Code 3
    LDR     R3, =2000
    B       Store_Treat
    
Treat_0
    LDR     R3, =100
    B       Store_Treat
    
Treat_1
    LDR     R3, =500
    B       Store_Treat
    
Treat_2
    LDR     R3, =1500
    B       Store_Treat

Store_Treat
    ; Store
    LDR     R4, =Current_Bill
    STR     R3, [R4]
    
    POP     {PC}
    END