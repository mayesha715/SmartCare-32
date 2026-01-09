; ==============================================================================
; File: Mod3_Alerts.s
; Description: Module 3 - Vital Threshold Alert Module
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Check_Alerts
    IMPORT  Alert_Count
    IMPORT  Alert_Buffer

    ; Thresholds
HR_MAX      EQU 120
O2_MIN      EQU 92
SBP_MAX     EQU 160
SBP_MIN     EQU 90

Check_Alerts
    PUSH    {R4, LR}
    
    ; --- Check Heart Rate ---
    CMP     R0, #HR_MAX
    BLE     Check_O2
    MOV     R3, #1          ; Type 1 = HR High
    MOV     R12, R0         ; Save Value
    BL      Log_Alert
    
Check_O2
    ; --- Check Oxygen ---
    CMP     R2, #O2_MIN
    BGE     Check_BP
    MOV     R3, #2          ; Type 2 = O2 Low
    MOV     R12, R2
    BL      Log_Alert

Check_BP
    ; --- Check BP ---
    CMP     R1, #SBP_MAX
    BGT     BP_Fail
    CMP     R1, #SBP_MIN
    BLT     BP_Fail
    B       End_Alerts

BP_Fail
    MOV     R3, #3          ; Type 3 = BP Warning
    MOV     R12, R1
    BL      Log_Alert

End_Alerts
    POP     {R4, PC}

; Helper: Log Alert to Memory
Log_Alert
    PUSH    {R1, R5, R6, LR}
    LDR     R5, =Alert_Count
    LDRH    R6, [R5]        ; Load Alert Count
    
    ; Calculate Address: Buffer_Base + (Count * 16)
    LDR     R4, =Alert_Buffer
    MOV     R1, #16
    MUL     R1, R6, R1
    ADD     R4, R4, R1      ; Entry Address
    
    STR     R3, [R4, #0]    ; Store Type
    STR     R12, [R4, #4]   ; Store Value
    LDR     R1, =0x9999     ; Dummy Timestamp
    STR     R1, [R4, #8]
    
    ADD     R6, R6, #1      ; Increment Count
    STRH    R6, [R5]
    POP     {R1, R5, R6, PC}
    END