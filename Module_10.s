; ==============================================================================
; File: Mod10_UART.s
; Description: Module 10 - UART Summary Report Generator 
; ==============================================================================
    AREA    |.text|, CODE, READONLY
    EXPORT  Generate_Report
    IMPORT  Total_Bill
    IMPORT  Patient_Base_Addr
    IMPORT  Room_Cost
    IMPORT  Medicine_Bill
    IMPORT  Current_Bill

    ; ITM Stimulus Port 0 (For Debug Printf Viewer)
ITM_Port0   EQU 0xE0000000

    ; Buffer for Integer to ASCII
    AREA    UART_Data, DATA, READWRITE
Ascii_Buf   SPACE 12

    AREA    |.text|, CODE, READONLY

Generate_Report
    PUSH    {R4, LR}        ; Aligned PUSH for AAPCS compliance
    
    ; 1. Send "ID: "
    MOV     R0, #'I'
    BL      UART_Tx
    MOV     R0, #'D'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    
    ; 2. Send Patient ID (From Sorted List - Top Patient)
    LDR     R1, =Patient_Base_Addr
    LDR     R0, [R1]        ; Load ID
    BL      Print_Int
    
    ; 2a. Print Treatment Code DEBUG
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'C'
    BL      UART_Tx
    MOV     R0, #'o'
    BL      UART_Tx
    MOV     R0, #'d'
    BL      UART_Tx
    MOV     R0, #'e'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Patient_Base_Addr
    LDRB    R0, [R1, #12]   ; Read Treatment Code directly
    BL      Print_Int
    
    ; 2a. Print Age (Offset +8)
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'A'
    BL      UART_Tx
    MOV     R0, #'g'
    BL      UART_Tx
    MOV     R0, #'e'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Patient_Base_Addr
    LDRB    R0, [R1, #8]    ; Load Age (Byte)
    BL      Print_Int
    
    ; 2b. Print Ward (Offset +10)
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'W'
    BL      UART_Tx
    MOV     R0, #'a'
    BL      UART_Tx
    MOV     R0, #'r'
    BL      UART_Tx
    MOV     R0, #'d'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Patient_Base_Addr
    LDRH    R0, [R1, #10]   ; Load Ward (Halfword)
    BL      Print_Int

    ; 2c. Print Treatment Cost
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'T'
    BL      UART_Tx
    MOV     R0, #'r'
    BL      UART_Tx
    MOV     R0, #'e'
    BL      UART_Tx
    MOV     R0, #'a'
    BL      UART_Tx
    MOV     R0, #'t'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Current_Bill
    LDR     R0, [R1]
    BL      Print_Int

    ; 2d. Print Room Cost
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'R'
    BL      UART_Tx
    MOV     R0, #'o'
    BL      UART_Tx
    MOV     R0, #'o'
    BL      UART_Tx
    MOV     R0, #'m'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Room_Cost
    LDR     R0, [R1]
    BL      Print_Int

    ; 2e. Print Meds Cost
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    MOV     R0, #'M'
    BL      UART_Tx
    MOV     R0, #'e'
    BL      UART_Tx
    MOV     R0, #'d'
    BL      UART_Tx
    MOV     R0, #'s'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    LDR     R1, =Medicine_Bill
    LDR     R0, [R1]
    BL      Print_Int
    
    ; 3. Send Newline
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    
    ; 4. Send "Bill: "
    MOV     R0, #'B'
    BL      UART_Tx
    MOV     R0, #'i'
    BL      UART_Tx
    MOV     R0, #'l'
    BL      UART_Tx
    MOV     R0, #'l'
    BL      UART_Tx
    MOV     R0, #':'
    BL      UART_Tx
    MOV     R0, #' '
    BL      UART_Tx
    
    ; 5. Send Bill
    LDR     R1, =Total_Bill
    LDR     R0, [R1]        ; Load Total
    BL      Print_Int

    ; 6. Send Final Newline (Check Formatting)
    MOV     R0, #0x0D       ; \r
    BL      UART_Tx
    MOV     R0, #0x0A       ; \n
    BL      UART_Tx
    
    POP     {R4, PC}

; --- Helper: Send Char to ITM (Target -> Debug Viewer) ---
UART_Tx
    PUSH    {R1, R2}
    LDR     R1, =ITM_Port0  ; Load ITM Stimulus Port 0 address
    
   
    STRB    R0, [R1]        ; Write character to ITM Port 0
    
    POP     {R1, R2}
    BX      LR

; --- Helper: Print Integer (Itoa) ---
Print_Int
    PUSH    {R4-R9, LR}
    LDR     R4, =Ascii_Buf
    ADD     R4, R4, #10     ; Start at end
    MOV     R5, #0
    STRB    R5, [R4]        ; Null terminator
    
    MOV     R6, #10         ; Divisor
    MOV     R7, R0          ; Value to convert
    
Convert_Loop
    UDIV    R8, R7, R6      ; R8 = Val / 10 (Supported on M4)
    MUL     R9, R8, R6
    SUB     R9, R7, R9      ; Remainder calculation
    ADD     R9, R9, #'0'    ; Convert to ASCII character
    
    SUB     R4, R4, #1
    STRB    R9, [R4]        ; Store character in buffer
    
    MOV     R7, R8
    CMP     R7, #0          ; Check if more digits remain
    BNE     Convert_Loop
    
    ; Print String
    MOV     R0, R4          ; Point to start of string
Print_Str_Loop
    LDRB    R1, [R0], #1    ; Load and increment pointer
    CMP     R1, #0          ; Check for null terminator
    BEQ     End_Print
    PUSH    {R0}
    MOV     R0, R1
    BL      UART_Tx         ; Send character via UART helper
    POP     {R0}
    B       Print_Str_Loop
    
End_Print
    POP     {R4-R9, PC}
    END