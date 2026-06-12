# 8-bit Approximate Multiplier using Verilog

## Overview

This project implements an 8-bit Approximate Multiplier in Verilog using ACMLC and CAC compressor techniques. The objective is to reduce hardware resource utilization and power consumption while maintaining acceptable computational accuracy.

Approximate multipliers are widely used in error-tolerant applications such as image processing, machine learning, and multimedia systems, where small computational errors can be tolerated in exchange for improved hardware efficiency.

---

## Features

* 8-bit multiplication architecture
* Approximate computing approach using ACMLC and CAC compressors
* Verilog RTL implementation
* FPGA synthesis and implementation using Xilinx Vivado
* Functional verification using a Verilog testbench
* Hardware resource and power analysis

---

## Tools Used

* Verilog HDL
* Xilinx Vivado
* FPGA Synthesis and Implementation Flow

---

## Project Structure

```text
8-bit-Approximate-Multiplier/
│
├── rtl/
│   ├── approximate_multiplier.v
│
├── tb/
│   └── approximate_multiplier_tb.v
│
├── reports/
│   ├── APPROX_utilization_synth.pdf
│   ├── EXACT_utilization_synth.pdf
│   ├── approx_power_report.pdf
│   └── exact_power_report.pdf
│
├── images/
│   ├── waveform.png
│
└── README.md
```

---

## Verification Methodology

* Developed a Verilog testbench to verify functionality.
* Tested the multiplier across all 65,536 input combinations.
* Analyzed simulation waveforms for functional validation.
* Evaluated approximation accuracy using error metrics.

---

## Performance Metrics

| Metric                    | Value  |
| ------------------------- | ------ |
| Mean Absolute Error (MAE) | 84.55  |
| Mean Relative Error (MRE) | 1.086% |
| LUT Reduction             | ~12%   |
| Register Reduction        | ~25%   |

---

## Resource Utilization Comparison

| Resource   | Exact Multiplier | Approximate Multiplier |
| ---------- | ---------------- | ---------------------- |
| Slice LUTs | 82               | 72                     |
| Registers  | 16               | 12                     |

The approximate multiplier achieves reduced hardware utilization compared to the exact multiplier implementation.

---

## Power Analysis

Power consumption was analyzed using Vivado power reports for both exact and approximate multiplier implementations.

The approximate architecture demonstrates improved hardware efficiency while maintaining acceptable computational accuracy.

---

## Results

The proposed approximate multiplier successfully reduces FPGA resource utilization and hardware complexity while maintaining controlled accuracy degradation.

The design demonstrates the effectiveness of approximate computing techniques for applications where minor computational errors can be tolerated in exchange for area and power savings.

---


