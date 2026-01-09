; ==============================================================================
; File: Mod6_Room.s
; Description: Module 6 - Daily Room Rent (with 5% discount logic)
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Compute_Room_Rent
    IMPORT  Patient_Base_Addr
    IMPORT  Room_Cost

Compute_Room_Rent
    PUSH    {LR}
    ; 1. Load Rate
    LDR     R0, =Patient_Base_Addr
    LDR     R1, [R0, #16]       ; Rate (Offset 16)
    
    ; 2. Define Stay Duration (Test Case: 12 Days)
    MOV     R2, #12             
    
    ; 3. Basic Calculation
    MUL     R3, R1, R2          ; Cost = Rate * Days
    
    ; 4. Check Discount (Days > 10)
    CMP     R2, #10
    BLE     Save_Rent
    
    ; 5. Apply 5% Discount: (Cost * 95) / 100
    MOV     R4, #95
    MUL     R3, R3, R4
    MOV     R4, #100
    UDIV    R3, R3, R4          ; Integer Division
    
Save_Rent
    LDR     R0, =Room_Cost
    STR     R3, [R0]
    
    POP     {PC}
    END