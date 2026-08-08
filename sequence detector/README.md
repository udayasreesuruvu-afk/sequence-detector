# 1011 Sequence Detector using Verilog

## Overview

This project implements a **1011 Sequence Detector** using Verilog HDL.

The design uses a **Finite State Machine (FSM)** to detect the binary sequence:

```text
1011
```

The detector is implemented as a **Mealy FSM**, meaning that the detection output depends on both the current state and the current input.

The design supports **overlapping sequence detection**.

## Features

* 1011 sequence detector
* Mealy FSM implementation
* Overlapping sequence detection
* Verilog HDL
* Asynchronous active-high reset
* Verilog testbench
* Simulation output
* VCD waveform generation
* Icarus Verilog compatible
* GTKWave compatible
* Makefile included

## Project Structure

```text
sequence-detector-1011/
├── rtl/
│   └── sequence_detector.v
├── tb/
│   └── tb_sequence_detector.v
├── simulation/
│   └── simulation_output.txt
├── README.md
└── Makefile
```

## Objective

The objective of this project is to design a sequential circuit that detects the binary sequence:

```text
1011
```

Whenever the four consecutive input bits are `1011`, the `detected` output becomes `1`.

## Sequence Detection

For the input:

```text
1011
```

the output is:

```text
0001
```

The final `1` indicates that the sequence has been detected.

Example:

```text
Input:     1 0 1 1
Output:    0 0 0 1
                    ↑
                 Detected
```

## FSM States

The FSM contains four main states.

| State | Meaning          |
| ----- | ---------------- |
| `S0`  | No matching bits |
| `S1`  | Detected `1`     |
| `S2`  | Detected `10`    |
| `S3`  | Detected `101`   |

When the FSM is in `S3` and receives another `1`, the complete sequence `1011` has been detected.

## State Transition Table

| Current State | Input | Next State | Detected |
| ------------- | ----: | ---------- | -------: |
| S0            |     0 | S0         |        0 |
| S0            |     1 | S1         |        0 |
| S1            |     0 | S2         |        0 |
| S1            |     1 | S1         |        0 |
| S2            |     0 | S0         |        0 |
| S2            |     1 | S3         |        0 |
| S3            |     0 | S2         |        0 |
| S3            |     1 | S1         |        1 |

## FSM Diagram

```text
                    1
              ┌─────────────┐
              │             │
              ▼             │
          ┌──────┐  0   ┌──────┐
      ┌──►│  S0  │─────►│  S1  │
      │   └──────┘      └──────┘
      │      ▲             │
      │      │             │ 0
      │      │             ▼
      │      │          ┌──────┐
      │      └──────────│  S2  │
      │                 └──────┘
      │                    │
      │                    │ 1
      │                    ▼
      │                 ┌──────┐
      │                 │  S3  │
      │                 └──────┘
      │                    │
      │                    │ 1 / DETECT=1
      │                    ▼
      └────────────────── S1
```

## Working Principle

The detector examines one input bit on every rising edge of the clock.

### State S0

No part of the sequence has been detected.

```text
Input = 1 → S1
Input = 0 → S0
```

### State S1

The first `1` of the sequence has been detected.

```text
Input = 0 → S2
Input = 1 → S1
```

### State S2

The sequence `10` has been detected.

```text
Input = 1 → S3
Input = 0 → S0
```

### State S3

The sequence `101` has been detected.

If the next input is `1`:

```text
101 + 1 = 1011
```

Therefore:

```text
detected = 1
```

The FSM then returns to `S1` so that overlapping sequences can be detected.

## Overlapping Detection

This project supports overlapping detection.

For example:

```text
Input:

1011011
```

contains two occurrences of:

```text
1011
```

Therefore the detector produces two detection pulses.

```text
Input:     1 0 1 1 0 1 1
           └────┘
           1011

                 └────┘
                 1011
```

## Inputs

| Signal    | Width | Description       |
| --------- | ----: | ----------------- |
| `clk`     |     1 | Clock             |
| `reset`   |     1 | Active-high reset |
| `data_in` |     1 | Serial input data |

## Output

| Signal     | Width | Description                       |
| ---------- | ----: | --------------------------------- |
| `detected` |     1 | Goes high when `1011` is detected |

## Reset

When:

```text
reset = 1
```

the FSM returns to:

```text
S0
```

and:

```text
detected = 0
```

## Testbench

The testbench is located at:

```text
tb/tb_sequence_detector.v
```

The testbench:

1. Generates a 10 ns clock.
2. Applies reset.
3. Sends the sequence `1011`.
4. Sends an overlapping test sequence.
5. Monitors the detection output.
6. Generates a VCD waveform.
7. Terminates the simulation.

## Simulation

### Compile

```bash
iverilog -o sequence_detector_sim rtl/sequence_detector.v tb/tb_sequence_detector.v
```

### Run

```bash
vvp sequence_detector_sim
```

### View waveform

```bash
gtkwave sequence_detector.vcd
```

## Expected Simulation Result

For:

```text
Input = 1011
```

the detector output becomes:

```text
Detected = 1
```

For:

```text
Input = 1011011
```

the sequence `1011` is detected twice.

## Simulation Output

Example:

```text
==============================================
        1011 SEQUENCE DETECTOR TEST
==============================================
Time    Reset   Input   Detected
----------------------------------------------
0       1       0       0
12000   0       0       0
15000   0       1       0
25000   0       0       0
35000   0       1       0
45000   0       1       1
55000   0       1       0
65000   0       0       0
75000   0       1       0
85000   0       1       1
95000   0       0       0
105000  0       1       0
115000  0       1       1
125000  0       1       0
----------------------------------------------
Simulation completed successfully.
```

## Waveform

The testbench generates:

```text
sequence_detector.vcd
```

Open the waveform using:

```bash
gtkwave sequence_detector.vcd
```

Recommended signals:

```text
clk
reset
data_in
detected
```

The waveform should show a one-clock detection pulse whenever `1011` is received.

## Applications

Sequence detectors are used in:

* Serial communication
* Digital communication systems
* Protocol detection
* Pattern recognition
* Control systems
* Data-stream monitoring
* Error detection
* Digital signal processing

## Advantages

* Simple FSM implementation
* Supports overlapping sequences
* Easy to modify for other patterns
* Suitable for FPGA implementation
* Low hardware complexity

## Modifying the Sequence

The same FSM concept can be used to detect other patterns such as:

```text
1101
1001
1110
1010
```

The states and transitions need to be modified according to the desired sequence.

## Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Git/GitHub

## Result

The 1011 sequence detector was successfully designed using a Mealy finite-state machine.

The simulation verifies that:

```text
1011 → detected = 1
```

and that overlapping sequences can also be detected.

**Result: PASS**

## Author

```text
Name: Your Name
Department: Your Department
College: Your College
```

## License

This project is intended for educational and academic purposes.
