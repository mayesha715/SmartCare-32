; ==============================================================================
; File: Mod1_Init.s
; Description: Module 1 - Patient Record Initialization
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Init_Patient_Record
    IMPORT  Patient_Base_Addr
    IMPORT  Medicine_List_Data

Init_Patient_Record
    PUSH    {LR}
    LDR     R0, =Patient_Base_Addr
    
    ; --- Patient 1 Setup (High Criticality for Sorting Test) ---
    LDR     R1, =0x11111111      ; ID
    STR     R1, [R0, #0]
    MOV     R1, #25              ; Age
    STRB    R1, [R0, #8]
    MOV     R1, #101             ; Ward
    STRH    R1, [R0, #10]
    MOV     R1, #2               ; Treatment Code
    STRB    R1, [R0, #12]
    LDR     R1, =2000            ; Daily Rate
    STR     R1, [R0, #16]
    LDR     R1, =Medicine_List_Data ; Pointer to Med List
    STR     R1, [R0, #20]
    MOV     R1, #2               ; Alert Count (Low)
    STR     R1, [R0, #24]
    
   ; --- Patient 2 Setup (Higher Alert Count) ---
    ADD     R0, R0, #28          ; Move to Patient 2 (Base + 28)
    LDR     R1, =0x22222222      ; ID
    STR     R1, [R0, #0]         ;
    MOV     R1, #50              ; Age
    STRB    R1, [R0, #8]         ;
    MOV     R1, #102             ; Ward
    STRH    R1, [R0, #10]        ;
    MOV     R1, #1               ; Treatment Code
    STRB    R1, [R0, #12]        ;
    LDR     R1, =1500            ; Daily Rate
    STR     R1, [R0, #16]        ;
    LDR     R1, =Medicine_List_Data ; Pointer to Med List
    STR     R1, [R0, #20]        ;
    MOV     R1, #1             ; Alert Count (High)
    STR     R1, [R0, #24]        ;

    ; --- Patient 3 Setup (Moderate Criticality) ---
    ADD     R0, R0, #28          ; Move to Patient 3 (Base + 56)
    LDR     R1, =0x33333333      ; ID
    STR     R1, [R0, #0]         ;
    MOV     R1, #40              ; Age
    STRB    R1, [R0, #8]         ;
    MOV     R1, #103             ; Ward
    STRH    R1, [R0, #10]        ;
    MOV     R1, #3               ; Treatment Code
    STRB    R1, [R0, #12]        ;
    LDR     R1, =3000            ; Daily Rate
    STR     R1, [R0, #16]        ;
    LDR     R1, =Medicine_List_Data ; Pointer to Med List
    STR     R1, [R0, #20]        ;
    MOV     R1, #5               ; Alert Count (Medium)
    STR     R1, [R0, #24]        ;
    
    POP     {PC}
    END