# RISC-V Processor Design Repository

---

## 1. Project Overview

This repository contains the Verilog HDL source code, testbenches, and structural designs for a comprehensive RISC-V processor project. The repository includes implementations for RISC-V single-cycle and multicycle processors, as well as a microprogrammed multicycle architecture. 

The primary objective of this project is to build a functional processor from the ground up, starting from foundational digital logic design and progressing to complex, integrated execution engines. The project bridges Instruction Set Architecture (ISA) semantics with datapath and control concepts, transitioning from fundamental hardware design to advanced pipelined execution.

---

## 2. Core Objectives

*   **Verilog Proficiency:** To implement hardware functions using structural, dataflow, and behavioral (RTL) Verilog modeling styles[cite: 1].
*   **Sequential Logic & Timing:** To understand how hardware stores state over time using clocks, resets, and registers, while clearly distinguishing between blocking and non-blocking assignments[cite: 2].
*   **ISA & Assembly:** To understand the processor from both a programmer's and hardware designer's perspective by writing RISC-V assembly programs and manually encoding/decoding 32-bit machine code[cite: 3].
*   **Datapath Design:** To design a structural, timing-aware 32-bit Arithmetic Logic Unit (ALU) that calculates critical paths using canonical delay annotations[cite: 4].
*   **System Integration:** To integrate discrete components—such as a register file, memory banks, and immediate generators—into functional single-cycle and pipelined CPU architectures[cite: 5, 6, 7].

---

## 3. Project Tasks and Milestones

### Phase 1: Combinational Logic and Hierarchical Design
*   Implement hardware functions using structural (gate-level), dataflow (Boolean equations), and behavioral Verilog modeling styles[cite: 1].
*   Understand hierarchical designs by building reusable modules, culminating in the construction of a 4-bit ripple-carry adder and a 4-bit adder-subtractor using two's complement logic[cite: 1].
*   Develop verification discipline by using testbenches to simulate and observe signal waveforms[cite: 1].

### Phase 2: Sequential Logic and Finite State Machines (FSM)
*   Design sequential state-holding logic, including D flip-flops with synchronous and asynchronous active-low resets[cite: 2].
*   Structurally compose components to build an 8-bit register and a simple 8-bit up-counter[cite: 2].
*   Implement a shift register using behavioral modeling to observe the subtle behavioral differences between blocking (`=`) and non-blocking (`<=`) assignments[cite: 2].
*   Design an FSM-controlled system for a sequential adder/subtractor, utilizing states such as RUN_WAIT, RUN_RESULT_READY, and HALTED[cite: 2].

### Phase 3: Assembly Programming and Instruction Encoding
*   Write non-trivial RISC-V assembly programs that utilize register-level arithmetic, immediate generation, and PC-relative control flow (branches and jumps)[cite: 3].
*   Relate instruction fields to hardware behavior by manually encoding assembly into machine code and decoding 32-bit hexadecimal machine code back into assembly[cite: 3].
*   Verify decode reasoning by predicting PC updates and register writes, then stepping through execution instruction-by-instruction[cite: 3].

### Phase 4: Structural, Timing-Aware ALU Design
*   Design a 32-bit structural ALU composed of submodules including an adder/subtractor, logic unit, and logical shifter[cite: 4].
*   Implement timing awareness by annotating combinational submodules with explicit delays to model abstract, technology-independent logic depth[cite: 4].
*   Support deep reasoning about two's complement arithmetic, specifically differentiating between signed (SLT) and unsigned (SLTU) interpretation using shared arithmetic hardware[cite: 4].

### Phase 5: Register File and Execution Machinery
*   Build a structural 32-bit register file from discrete registers, strictly enforcing the rule that register `x0` is hardwired to zero[cite: 5].
*   Design a 5-to-32 write-enable decoder and integrate read/write paths with annotated propagation delays[cite: 5].
*   Generate combinational ALU control signals based on hierarchical RISC-V instruction fields (`funct3` and `funct7`), culminating in the end-to-end execution trace of a single R-type instruction[cite: 5].

### Phase 6: Single-Cycle CPU Integration
*   Develop an Immediate Generator capable of extracting and sign-extending immediate values for I-type, S-type, and B-type instructions[cite: 6].
*   Implement a banked memory system utilizing four 8-bit memory banks to support word-aligned, 32-bit asynchronous reads and synchronous writes[cite: 6].
*   Integrate the Immediate Generator, PC Incrementer, Banked Memory, Register File, and a behavioral Control Unit to form a fully functional single-cycle processor[cite: 6].
*   Extend the CPU to support control flow instructions like `beq`, `bne`, and `jal` by introducing branch comparators and PC-update logic[cite: 7].

### Phase 7: Pipelined Execution and Hazard Analysis
*   Transition the single-cycle architecture into a pipelined CPU by adding state registers between instruction stages: IF/ID, ID/EX, EX/MEM, and MEM/WB[cite: 7].
*   Perform hazard analysis on the new pipelined datapath[cite: 7].
*   Mitigate execution hazards and structural issues by modifying assembly programs to include software-level delays (NOPs) without altering the underlying hardware design[cite: 7].
