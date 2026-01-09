; ==============================================================================
; File: Mod7_MedBill.s
; Description: Module 7 - Medicine Billing with Robust Termination
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Compute_Medicine_Bill
    IMPORT  Patient_Base_Addr
    IMPORT  Medicine_Bill

Compute_Medicine_Bill
    PUSH    {R4-R8, LR}
    
    ; 1. Get List Pointer from Patient Struct
    LDR     R0, =Patient_Base_Addr
    LDR     R1, [R0, #20]       ; Load MedList Pointer (Offset 20)
    
    MOV     R2, #0              ; Total Accumulator
    
Med_Loop
    LDR     R3, [R1]            ; Load Price
    LDR     R4, [R1, #4]        ; Load Quantity
    
    ; Check for Terminator: End only if Price OR Quantity results in 0
    ORRS    R7, R3, R4          
    BEQ     End_Med_Calc        
    
    LDR     R5, [R1, #8]        ; Load Days
    
    ; Cost = Price * Qty * Days
    MUL     R6, R3, R4          ; Price * Qty
    MUL     R6, R6, R5          ; Result * Days
    
    ADD     R2, R2, R6          ; Add to running total
    
    ADD     R1, R1, #12         ; Jump 12 bytes to next entry
    B       Med_Loop
    
End_Med_Calc
    LDR     R0, =Medicine_Bill
    STR     R2, [R0]            ; Save final tally
    
    POP     {R4-R8, PC}
    END