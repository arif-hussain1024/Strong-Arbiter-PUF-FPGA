# EEE5716 Final Project - Strong Arbiter PUF
This is the repository for EEE5716 Introduction to Hardware Security and Trust Group 8's final project. It will contain all the code for the implementation of the Strong Arbiter PUF, as well as findings/results. It includes RTL code, testbenches, scripts, constraint files, and results used to implement and evaluate a 32-bit Strong Arbiter PUF.

## Author
- Arif Hussain

## Project Overview
This project implements a **32-bit Strong Arbiter PUF** on an FPGA (RealDigital Urbana Spartan-7 XC7S50). We evaluate three standard PUF metrics:

- **Reliability** – does the same challenge always give the same response (intra-chip)? 
- **Uniqueness** – do different "chips" produce different responses (inter-chip)?  
- **Uniformity** – are responses ~50% ones and ~50% zeros?

## Repository Structure
RTL/
 
 ├── switchPUF.v
 
 ├── arbiter.v
 
 ├── arbiterPUF.v
 
 └── puf_top_urbana.v (top module in Vivado!)
 
 └──testbenches/

   
Constraints/

 └── urbana_constraints.xdc (this is the primary constraints we used, other files for other FPGAs available)
 
Scripts/

 ├── analyze_reliability.py
 
 ├── analyze_uniqueness.py
 
 ├── analyze_uniformity.py
 
 └── run_all_analyses.py    
 
data/

 ├── single_puf_data.txt    
 
 └── multi_puf_data.txt      
 
Results/

 ├── Spreadsheets and text files from analysis scripts

 Reports/ 
  - This is where the finalized report for this project will be housed.


.gitignore

LICENSE

README.md


## Build Instructions

### 1. Repository Setup

```
git clone https://github.com/arif-hussain1024/Strong-Arbiter-PUF-FPGA.git
cd Strong-Arbiter-PUF-FPGA
```
Open in VS Code, Vivado, or in the text editor/IDE of your choice.

### 2. Vivado Project Setup 
1. Open **Vivado 2024.2**
2. Create a **new RTL project**
3. Add all Verilog files from the `RTL/` directory
4. Set **puf_top_urbana.v** as the **Top Module**
5. Add `urbana_constraints.xdc` from `Constraints/` 
7. Run:
   - **Synthesis**
   - **Implementation**
   - **Generate Bitstream**
8. Program the Urbana FPGA board

The PUF response will show on `LED0`.

### 3. Testing and Collecting Results 
#### Run any testbench:
1. Open the TB in Vivado  
2. Click **Run Simulation → Run Behavioral Simulation**  
3. Capture the generated `.txt` output files (for Python scripts)

#### Python Analysis Tools

Install dependencies:
```
pip install numpy matplotlib seaborn
```

Run each metric individually:
```
python analyze_reliability.py
python analyze_uniqueness.py
python analyze_uniformity.py
```

Or run everything at once:
```
python run_all_analyses.py
```

This generates:

- Response plots  
- Text summaries  
- A full **comprehensive_report.txt**  

All inside `/Results/`.

---

# Notes & Limitations

- **Uniqueness (≈0.19)** is lower than ideal (0.50) due to:
  - No manual routing symmetry (very difficult!)
  - Only one real FPGA available for hardware variation

- **Reliability = 100%**  
  The PUF reproduced identical responses for repeated challenges.

- **Uniformity ≈ 0.48**  
  Very close to ideal 0.50.

- Additional testing such as:
  - Temperature variation  
  - Voltage variation  
  was not performed due to time constraints.

---
