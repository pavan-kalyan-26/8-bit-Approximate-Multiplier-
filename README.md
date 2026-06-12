# 8-bit-Approximate-Multiplier-
# 8-bit Approximate Multiplier using Verilog

## Overview

This project presents the design and FPGA implementation of an 8-bit approximate multiplier using ACMLC and CAC compressor techniques. Approximate computing is widely used in error-tolerant applications such as image processing, machine learning, and multimedia systems, where reduced power consumption and hardware complexity are prioritized over exact computation.

## Objective

The objective of this project is to design a hardware-efficient multiplier that achieves reductions in area and power consumption while maintaining acceptable computational accuracy.

## Features

* 8-bit approximate multiplication
* Verilog RTL implementation
* ACMLC and CAC compressor-based architecture
* FPGA synthesis and implementation using Xilinx Vivado
* Functional verification through simulation

## Tools Used

* Verilog HDL
* Xilinx Vivado
* FPGA Implementation Flow

## Verification Methodology

* Developed a Verilog testbench for functional verification.
* Exhaustively tested all 65,536 input combinations.
* Analyzed simulation waveforms to validate functionality.
* Evaluated approximation accuracy using error metrics.

## Performance Results

| Metric                    | Value  |
| ------------------------- | ------ |
| Mean Absolute Error (MAE) | 84.55  |
| Mean Relative Error (MRE) | 1.086% |
| LUT Reduction             | ~12%   |
| Dynamic Power Reduction   | ~10%   |

## Repository Structure

* `rtl/` – Verilog source files
* `tb/` – Testbench files
* `reports/` – Synthesis and utilization reports
* `images/` – Waveforms and implementation screenshots

## Conclusion

The proposed approximate multiplier successfully reduces FPGA resource utilization and dynamic power consumption while maintaining controlled computational accuracy, demonstrating its suitability for error-tolerant digital applications.
