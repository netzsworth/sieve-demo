# Demonstration of the Sieve of Eratosthenes Algorithm Through Multiple CPU Architectures

## 1. Document Overview

This repository contains assembly language implementations of the Sieve of Eratosthenes algorithm across five distinct CPU architectures. This document serves as the technical manual detailing the file manifest, system dependencies, and execution procedures required to assemble and run each demonstration.

## 2. Algorithm Specifications

The Sieve of Eratosthenes is an iterative mathematical algorithm designed to identify all prime numbers up to a specified integer limit. The procedure operates by establishing a memory array and systematically marking the multiples of each prime number, beginning with 2.

Because the algorithm relies predominantly on continuous memory read/write operations rather than complex arithmetic instructions, it functions as a highly effective benchmark for evaluating and comparing instruction sets, memory management, and register utilization across different hardware architectures.

---

## 3. System Requirements and File Manifest

Each architecture demonstration requires a specific emulation environment or software suite for execution. Below is the technical breakdown of the required source files and their corresponding operational targets.

| Architecture | Source File | Required Execution Environment |
| --- | --- | --- |
| **MOS 6502** (C64) | `sieve_6502(c64).asm` | CBM prg Studio |
| **Motorola 68000** | `sieve_68000.S68` | EASy68K |
| **x86-64** (AMD64) | `sieve_amd64.s` | QEMU (Bare-metal) |
| **ARMv7** | `sieve_armv7.asm` | CPUlator |
| **Intel 8086** | `sieve_emu8086.asm` | emu8086 |

---

## 4. Standard Operating Procedures

### 4.1 Executing MOS 6502 (Commodore 64)

1. Initialize the **CBM prg Studio** application.
2. Load the source file `sieve_6502(c64).asm` into the project workspace.
3. Assemble the code and initiate execution through the integrated Commodore 64 emulator.

### 4.2 Executing Motorola 68000 (m68k)

1. Launch the **EASy68K** Editor/Assembler.
2. Open the file `sieve_68000.S68`.
3. Assemble the source code to generate the executable binary.
4. Execute the resulting binary within the EASy68K simulator.

### 4.3 Executing x86-64 (AMD64)

*Note: This implementation is designed to run directly on the hardware without an operating system layer.*

1. Ensure the **QEMU** machine emulator is installed and configured on your host system.
2. Assemble the `sieve_amd64.s` file using the appropriate assembler to generate a bootable binary image.
3. Mount and boot the resulting image using QEMU to observe execution.

### 4.4 Executing ARMv7

1. Navigate to the **CPUlator** browser-based simulator.
2. Configure the target system architecture to **ARMv7**.
3. Import the contents of `sieve_armv7.asm` into the simulator's code editor.
4. Compile the source and initiate the simulation.

### 4.5 Executing Intel 8086

1. Open the **emu8086** microprocessor emulator.
2. Load the source file `sieve_emu8086.asm`.
3. Select the **Emulate** function to assemble the code and step through the execution process.
