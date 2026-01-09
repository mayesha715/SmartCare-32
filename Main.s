; ==============================================================================
; File: Main.s
; Description: Main Entry Point and Execution Loop (Linker-Optimised)
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    ENTRY                           ; Mark this AREA as the global entry point
    EXPORT  main                    ; Make 'main' visible to the Keil linker
    
; --- Import All Modules ---
    ; IMPORT  Init_UART                ; Removed
    IMPORT  Init_Patient_Record      ; Mod 1
    IMPORT  Acquire_Vitals           ; Mod 2
    IMPORT  Check_Alerts             ; Mod 3
    IMPORT  Check_Medicine_Schedule  ; Mod 4
    IMPORT  Compute_Treatment_Cost   ; Mod 5
    IMPORT  Compute_Room_Rent        ; Mod 6
    IMPORT  Compute_Medicine_Bill    ; Mod 7
    IMPORT  Aggregate_Bill           ; Mod 8
    IMPORT  Clear_Billing            ; Mod 8 Helper
    IMPORT  Sort_Patients            ; Mod 9
    IMPORT  Generate_Report          ; Mod 10
    IMPORT  Check_Anomalies          ; Mod 11
    
main                                ; The specific label the linker starts from
    ; --- 1. Initialization Phase ---
    ; BL      Init_UART                ; Removed: Using ITM for Debug Viewer now
    BL      Init_Patient_Record      ; Set up structures once
    
    ; --- 2. Main Monitoring Loop ---
Loop
    ; --- Step A: Reset State ---
    BL      Clear_Billing            ; Ensure fresh billing data each cycle

    ; --- Step B: Simulate Sensor Inputs ---
    MOV     R0, #80                 ; Simulated Heart Rate
    MOV     R1, #120                ; Simulated Blood Pressure
    MOV     R2, #98                 ; Simulated Oxygen Levels
    
    ; --- Step C: Call Modules Sequentially ---
    BL      Acquire_Vitals           ; Mod 2
    BL      Check_Alerts             ; Mod 3
    BL      Sort_Patients            ; Mod 9 (Moved Up: Pivot to highest priority patient FIRST)
    BL      Check_Medicine_Schedule  ; Mod 4
    BL      Compute_Treatment_Cost   ; Mod 5
    BL      Compute_Room_Rent        ; Mod 6
    BL      Compute_Medicine_Bill    ; Mod 7
    BL      Aggregate_Bill           ; Mod 8
    BL      Check_Anomalies          ; Mod 11
    BL      Generate_Report          ; Mod 10
    
    ; --- Step D: Stop (Run Once) ---
Stop
    B       Stop                    ; Stop here so we can read the output
    
    ; B       Loop                    ; Old infinite loop (Removed)

    ALIGN                           ; Clean 4-byte boundary padding
    END                             ; End of source file