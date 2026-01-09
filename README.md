# CSE-2106-Assignment
SmartCare-32: ARM-Based Healthcare Monitoring & Billing System

🏥 Project Overview

SmartCare-32 is an integrated embedded firmware solution developed for the DU Medical Center. Built entirely in ARM Assembly (Cortex-M), the system modernizes patient care by automating vital sign monitoring, emergency alert generation, medication scheduling, and complex financial billing.The project demonstrates low-level systems programming, focusing on manual memory management, pointer arithmetic, and hardware interfacing via UART.

🚀 Key Features

1. Patient Record Management
-Structured Initialization: Allocates 28-byte structures in RAM (starting at 0x20000000) for patient data including ID, Age, Ward, and Treatment codes.
-Triage Sorting: Implements a Descending Bubble Sort algorithm to prioritize patients based on their Alert_Count, ensuring critical cases are handled first.

2. Real-Time Vital Monitoring
   -Rolling Buffers: Maintains a history of the last 10 readings for Heart Rate (HR), Blood Pressure (BP), and Oxygen ($O_2$).
   -Circular Logic: Uses modulo-style index wrapping to manage memory efficiently.
   -Threshold Detection: Automatically triggers alerts for:
       -HR > 120 BPM
       -O_2 < 92%5.Systolic
       -BP > 160 or < 90 mmHg6.

3. Automated Billing Engine
   -Treatment LUT: Maps treatment codes to costs using a high-speed Lookup Table.

   -Discount Logic: Calculates room rent with a 5% discount for stays exceeding 10 days using fixed-point integer     math.

   -Medicine Aggregator: Iteratively traverses a linked list of prescribed medicines to calculate total               pharmaceutical costs.

   -Overflow Protection: Employs BVS (Branch if Overflow Set) instructions to ensure financial calculations stay within valid 32-bit bounds.

4. Safety & Communication
   -Anomaly Detection: Identifies "Stuck Sensors" (repeated values) and monitors for memory overflows near the        RAM boundary.

   -UART Reporting: Converts internal binary data to ASCII strings for transmission to a serial terminal, providing a real-time summary of patient status.

🛠️ Technical Specifications

Architecture: ARMv7-M (Cortex-M4).
Language: 100% ARM Assembly.
IDE: Keil uVision 5.
Memory Map: Base address 0x20000000 for patient structures.

📂 Project Structure
File Name,Component,Technical Responsibilities
Main.s: Execution Core

"Orchestrates the main monitoring loop, simulating sensor inputs and synchronizing module execution."

Data.s: Memory Map

"Defines RAM blocks for patient structures, vital buffers, alert logs, and system state variables."

Module_01_init.s: ,Patient Init

"Initializes 28-byte patient records at 0x20000000 with ID, Age, Ward, and Rate data."

Module_02.s: Acquisition

"Implements rolling buffers for HR, BP, and O2​ using LSL-based offset calculation and wrap-around logic."

Module_03.s: Thresholds

"Compares real-time vitals against safety limits and logs 16-byte alert records on violation."

Module_04.s: Scheduler

"Computes the next medicine due time using Last_Admin + Interval logic."
Module_05.s: Treatment
"Uses a Lookup Table (LUT) to map treatment codes (0–3) to their respective costs."

Module_06.s: Room Rent

"Calculates rent (Rate×Days) and applies a 5% discount for long stays using integer division."

Module_07.s:

"Meds Bill,Iteratively traverses a linked list to calculate Price \times Quantity \times Days for all prescribed medications."

Module_08.s: Aggregator

"Sums all bill components and uses ADDS with BVS to detect and handle arithmetic overflows."

Module_09.s: Triage Sort

"Executes a Descending Bubble Sort to prioritize patients based on the frequency of their alerts."
Module_10.s: UART Driver

"Converts integers to ASCII and transmits a patient summary via the UART Data Register."

Module_11.s:Safety Check

"Implements Anomaly Detection for stuck sensors and monitors for RAM boundary violations."

Visualizing the Patient Structure (28 Bytes)

Each patient record is carefully aligned in memory to ensure efficient 32-bit access by the ARM processor:

Offsets 0-3: Patient ID (Word)
Offset 8: Age (Byte)
Offset 10: Ward Number (Halfword)
Offset 12: Treatment Code (Byte)
Offset 16: Daily Room Rate (Word)
Offset 20: Medicine List Pointer (Word)
Offset 24: Alert Count (Word/Used for Triage)

🖥️ How to Run
1. Open Keil uVision 5.
2. Create a new project targeting an ARM Cortex-M4 processor.
3. Add all .s files from this repository to the project.
4. Build the project (F7) and enter Debug Mode (Ctrl+F5).
5. Open the Serial Window (UART #1) and Memory Window (0x20000000) to observe system behavior.
