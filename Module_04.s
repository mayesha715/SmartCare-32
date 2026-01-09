; ==============================================================================
; File: Mod4_Scheduler.s
; Description: Module 4 - Medicine Administration Scheduler
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Check_Medicine_Schedule
    IMPORT  Current_Time

    ; Dummy Medicine Data for Demo
    ; Interval = 4 hours, Last_Admin = 5
Med_Interval    EQU 4
Last_Admin      EQU 5

Check_Medicine_Schedule
    PUSH    {LR}
    
    ; Calculate Next Due: Last + Interval
    MOV     R1, #Last_Admin
    ADD     R2, R1, #Med_Interval   ; Next Due = 9
    
    ; Load Current Time
    LDR     R0, =Current_Time
    LDR     R3, [R0]
    
    ; Compare
    CMP     R3, R2
    BLT     Not_Due
    
    ; Logic: If Due, normally set a flag. 
    ; For this assignment, we just ensure the check happens.
    
Not_Due
    POP     {PC}
    END