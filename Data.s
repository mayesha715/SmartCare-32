
    AREA    DATA, DATA, READWRITE
    ALIGN

    EXPORT  Patient_Base_Addr
    EXPORT  Patient_Count
    EXPORT  Vital_Index
    EXPORT  HR_Buffer
    EXPORT  BP_Buffer
    EXPORT  O2_Buffer
    EXPORT  Alert_Buffer
    EXPORT  Alert_Count
    EXPORT  Total_Bill
    EXPORT  Current_Bill
    EXPORT  Room_Cost
    EXPORT  Medicine_Bill
    EXPORT  Current_Time
    EXPORT  Error_Status
    EXPORT  Medicine_List_Data  ; The actual data for the medicine list
    
    ; --- Patient Memory ---
    ; Allocating space for 3 patients (28 bytes each) to demonstrate sorting.
    ; Struct: [ID(4), Name(4), Age(1)|Pad(1)|Ward(2), Code(1)|Pad(3), Rate(4), MedPtr(4), AlertCount(4)]
Patient_Base_Addr SPACE   84          
Patient_Count   DCD     3           

    ; --- Module 2: Vital Buffers ---
Vital_Index     DCW     0           ; Current Index (0-9)
HR_Buffer       SPACE   40          ; 10 entries * 4 bytes
BP_Buffer       SPACE   40
O2_Buffer       SPACE   40

    ; --- Module 3: Alerts ---
Alert_Buffer    SPACE   256         ; Space for 16-byte alert records
Alert_Count     DCW     0           

    ; --- Billing Accumulators ---
Total_Bill      DCD     0
Current_Bill    DCD     0           ; For Treatment (Mod 5)
Room_Cost       DCD     0           ; For Room (Mod 6)
Medicine_Bill   DCD     0    
; For Meds (Mod 7)

; --- System State ---
Current_Time    DCD     10          
Error_Status    DCB     0           ; This is only 1 byte!

    ALIGN                           ; <--- CRITICAL: Ensures the next DCD is on a 4-byte boundary

    ; --- Static Data for Module 7 (Medicine List) ---
Medicine_List_Data
    DCD     10, 3, 5                
    DCD     50, 2, 1                
    DCD     0, 0, 0              

    END