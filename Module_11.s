; ==============================================================================
; File: Mod11_Anomaly.s
; Description: Module 11 - Anomaly Detection (Stuck Sensor & Corrected RAM Audit)
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Check_Anomalies
    IMPORT  Error_Status
    IMPORT  Alert_Count
    IMPORT  Alert_Buffer

; Constants
RAM_LIMIT       EQU     0x20002000  ; Absolute boundary of allocated SRAM
STUCK_THRESH    EQU     10          ; Threshold for frozen sensor detection

Check_Anomalies
    PUSH    {R4-R8, LR}
    
    ; --- Check 1: Stuck Sensor Logic ---
    ; We verify if the heart rate remains unchanged over multiple iterations.
    LDR     R4, =Internal_State
    LDR     R5, [R4]        ; Load the Last_HR from memory
    LDRB    R6, [R4, #4]    ; Load the current Stuck_Count
    
    CMP     R0, R5          ; Compare current Heart Rate (R0) with the previous one
    BNE     Reset_Stuck     ; If they differ, the sensor is functioning normally
    
    ; Values Match: Increment the frozen sensor counter
    ADD     R6, R6, #1
    STRB    R6, [R4, #4]
    CMP     R6, #STUCK_THRESH
    BLT     Check_Mem       ; Continue if under threshold
    
    ; ERROR CODE 1: Stuck Sensor Detected
    LDR     R7, =Error_Status
    MOV     R8, #1          ; Assign Error Code 1
    STRB    R8, [R7]
    B       Check_Mem
    
Reset_Stuck
    STR     R0, [R4]        ; Update Last_HR with current reading
    MOV     R6, #0          ; Reset the frozen counter
    STRB    R6, [R4, #4]
    
Check_Mem
    ; --- Check 2: RAM Overflow Audit ---
    ; We calculate the address of the next potential alert log entry.
    LDR     R4, =Alert_Count
    LDRH    R5, [R4]        ; Fetch current number of alerts logged
    MOV     R6, #16         ; Each entry is 16 bytes
    MUL     R5, R5, R6      ; R5 = Offset in bytes
    LDR     R6, =Alert_Buffer
    ADD     R6, R6, R5      ; R6 = Current write pointer address
    
    LDR     R7, =RAM_LIMIT
    CMP     R6, R7          ; Compare pointer against the hard RAM limit
    BLE     End_Anomaly     ; If pointer <= limit, system is safe
    
    ; ERROR CODE 3: RAM Overflow Detected (Corrected Logic)
    ; We use Code 3 to distinguish this from Billing Overflows (Code 2).
    LDR     R7, =Error_Status
    MOV     R8, #3          ; Assign Error Code 3
    STRB    R8, [R7]

End_Anomaly
    POP     {R4-R8, PC}     ; Restore context and return to Main

    ; --- Private State Storage ---
    AREA    Mod11_Data, DATA, READWRITE
Internal_State
    DCD     0               ; Last_HR (Stored as 32-bit Word)
    DCB     0               ; Stuck_Count (Stored as Byte)
    ALIGN                   ; Ensure 4-byte boundary for the next area
    END