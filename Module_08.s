; ==============================================================================
; File: Mod8_Aggregator.s
; Description: Module 8 - Patient Bill Aggregator & Financial Reset
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Aggregate_Bill
    EXPORT  Clear_Billing            ; Critical for Main.s access
    
    IMPORT  Current_Bill             
    IMPORT  Room_Cost                
    IMPORT  Medicine_Bill            
    IMPORT  Total_Bill               
    IMPORT  Error_Status             

Aggregate_Bill
    PUSH    {R4, LR}
    ; Load all components
    LDR     R0, =Current_Bill
    LDR     R1, [R0]
    LDR     R0, =Room_Cost
    LDR     R2, [R0]
    LDR     R0, =Medicine_Bill
    LDR     R3, [R0]
    
    MOV     R4, #0
    
    ; Add Treatment + Room (Set Flags)
    ADDS    R4, R1, R2               ; Updates status flags
    BVS     Overflow_Err             ; Branch if Overflow Set
    
    ; Add Medicine (Set Flags)
    ADDS    R4, R4, R3
    BVS     Overflow_Err
    
    ; Store Valid Total
    LDR     R0, =Total_Bill
    STR     R4, [R0]
    B       End_Agg
    
Overflow_Err
    ; Set Error Flag 2
    LDR     R0, =Error_Status
    MOV     R1, #2                   ; Code 2 = Billing Overflow
    STRB    R1, [R0]
    
    ; Cap Bill at MAX_INT (0x7FFFFFFF)
    LDR     R0, =Total_Bill
    MVN     R1, #0
    LSR     R1, R1, #1      
    STR     R1, [R0]

End_Agg
    POP     {R4, PC}

; --- New Housekeeping Subroutine ---
Clear_Billing
    PUSH    {R0, R1, LR}             ; Protect registers from modification
    MOV     R1, #0                   ; The reset value
    
    LDR     R0, =Total_Bill
    STR     R1, [R0]
    LDR     R0, =Current_Bill
    STR     R1, [R0]
    LDR     R0, =Room_Cost
    STR     R1, [R0]
    LDR     R0, =Medicine_Bill
    STR     R1, [R0]
    
    POP     {R0, R1, PC}             ; Return to caller
    END